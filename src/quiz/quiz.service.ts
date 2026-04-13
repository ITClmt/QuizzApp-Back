import { HttpService } from "@nestjs/axios";
import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from "@nestjs/common";
import he from "he";
import { firstValueFrom } from "rxjs";
import { Difficulty, Question } from "../generated/prisma/client";
import { PrismaService } from "../prisma/prisma.service";
import { ScoreService } from "../score/score.service";
import { AnswerDto } from "./dto/finish-session.dto";
import { OtdQuestion, OtdResponse } from "./interfaces/otd-question.interface";
import { SanitizedQuestion } from "./interfaces/question.interface";

@Injectable()
export class QuizService {
  private readonly logger = new Logger(QuizService.name);
  private readonly OTD_URL = "https://opentdb.com/api.php";
  private readonly QUESTIONS_PER_GAME = 2;
  private readonly GAME_DURATION_MS = 3 * 60 * 1000; // 3 minutes

  constructor(
    private readonly httpService: HttpService,
    private readonly prisma: PrismaService,
    private readonly scoreService: ScoreService,
  ) {}

  async getQuestions(
    lang: string = "en",
    difficulty?: string,
    category?: string,
  ): Promise<SanitizedQuestion[]> {
    // 1. Récupère des questions existantes en DB

    //     const where = {
    //     ...(difficulty && { difficulty }),
    //     ...(category && { category }),
    //   }

    // const totalInDb = await this.prisma.question.count();

    // const randomSkip = Math.max(
    //   0,
    //   Math.floor(Math.random() * (totalInDb - this.QUESTIONS_PER_GAME)),
    // );

    // const existing = await this.prisma.question.findMany({
    //   where,
    //   take: this.QUESTIONS_PER_GAME,
    //   skip: randomSkip,
    // });

    // let questions = existing

    // 2. Si pas assez en DB, fetch OTD

    // if (existing.length < this.QUESTIONS_PER_GAME) {
    const fetchedQuestions = await this.fetchFromOtd(
      this.QUESTIONS_PER_GAME,
      difficulty,
      category,
    );
    // questions = [...existing, ...fetchedQuestions]
    // }

    // 3. TODO: Si lang === 'fr', traduire via DeepL les questions sans questionFr

    // 4. Sanitize et retourne
    return fetchedQuestions.map((question) => this.sanitize(question, lang));
  }

  private async fetchFromOtd(
    amount: number,
    difficulty?: string,
    category?: string,
  ) {
    this.logger.log(`Fetching ${amount} questions from Open Trivia DB`);

    const { data } = await firstValueFrom(
      this.httpService.get<OtdResponse>(this.OTD_URL, {
        params: { amount, difficulty, category },
      }),
    );

    if (data.response_code !== 0) {
      this.logger.error(`OTD response code: ${data.response_code}`);
      return [];
    }

    // Sauvegarde en DB et retourne les entités créées
    const created = await Promise.all(
      data.results.map((q) => this.saveQuestion(q)),
    );

    return created.filter((q): q is NonNullable<typeof q> => q !== null);
  }

  private async saveQuestion(q: OtdQuestion) {
    // Décode les entités HTML qu'OTD renvoie encodées
    const decode = (str: string) => he.decode(str);

    const answers = [...q.incorrect_answers, q.correct_answer].map(decode);
    const shuffled = answers.sort(() => Math.random() - 0.5);
    const correctIndex = shuffled.indexOf(decode(q.correct_answer));

    // sourceId = hash de la question pour éviter les doublons
    const sourceId = Buffer.from(q.question).toString("base64").slice(0, 50);

    try {
      return await this.prisma.question.upsert({
        where: { sourceId },
        update: {},
        create: {
          sourceId,
          questionEn: decode(q.question),
          answersEn: shuffled,
          correctIndex,
          category: q.category,
          difficulty: q.difficulty,
        },
      });
    } catch (error) {
      this.logger.error(`Failed to save question: ${error.message}`);
      return null;
    }
  }

  private sanitize(question: Question, lang: string): SanitizedQuestion {
    const isfr = lang === "fr" && question.questionFr;

    return {
      id: question.id,
      questionEn: question.questionEn,
      questionFr: question.questionFr ?? null,
      answers: (isfr ? question.answersFr : question.answersEn) as string[],
      correctIndex: question.correctIndex,
      category: question.category,
      difficulty: question.difficulty,
    };
  }

  // Appelé par le GameService pour valider une réponse
  async validateAnswer(
    questionId: string,
    answerIndex: number,
    lang: string,
  ): Promise<{ isCorrect: boolean; correctAnswer: string } | null> {
    const question = await this.prisma.question.findUnique({
      where: { id: questionId },
    });

    if (!question) return null;

    const answers = (
      lang === "fr" && question.answersFr
        ? question.answersFr
        : question.answersEn
    ) as string[];

    return {
      isCorrect: question.correctIndex === answerIndex,
      correctAnswer: answers[question.correctIndex],
    };
  }

  async startSession(
    userId: string,
    lang: string,
    difficulty?: string,
    category?: string,
  ) {
    // Vérifie qu'aucune session n'est déjà en cours
    const existing = await this.prisma.soloSession.findFirst({
      where: {
        userId,
        status: "IN_PROGRESS",
        expiresAt: { gt: new Date() },
      },
    });

    if (existing) {
      throw new ConflictException("A session is already in progress");
    }

    const questions = await this.getQuestions(lang, difficulty, category);

    // Crée la session
    const session = await this.prisma.soloSession.create({
      data: {
        userId,
        lang,
        difficulty: difficulty ? (difficulty as Difficulty) : null,
        category: category ? category : null,
        expiresAt: new Date(Date.now() + (this.GAME_DURATION_MS + 30000)),
      },
    });

    return {
      sessionId: session.id,
      expiresAt: session.expiresAt,
      questions,
    };
  }

  async finishSession(userId: string, sessionId: string, answers: AnswerDto[]) {
    const session = await this.getActiveSession(userId, sessionId);

    // Récupère toutes les questions en une seule requête
    const questionIds = answers.map((a) => a.questionId);
    const questions = await this.prisma.question.findMany({
      where: { id: { in: questionIds } },
    });

    // Map pour accès rapide par id
    const questionMap = new Map(questions.map((q) => [q.id, q]));

    // Initialisation des accumulateurs (Boucle unique O(N) pour la performance)
    const soloAnswersData: Array<{
      sessionId: string;
      questionId: string;
      answerIndex: number;
      isCorrect: boolean;
    }> = [];

    const scoresByDifficulty: Record<string, number> = {};

    const answersResult: Array<{
      questionId: string;
      isCorrect: boolean;
      correctAnswer: string;
    }> = [];

    let totalScore = 0;

    // Boucle unique pour traiter chaque réponse
    for (const answer of answers) {
      const question = questionMap.get(answer.questionId);
      if (!question) {
        throw new BadRequestException(
          `Question ${answer.questionId} introuvable ou invalide.`,
        );
      }

      const isCorrect = question.correctIndex === answer.answerIndex;

      // 1. Data DTO pour l'insertion Prisma
      soloAnswersData.push({
        sessionId,
        questionId: answer.questionId,
        answerIndex: answer.answerIndex,
        isCorrect,
      });

      // 2. Calcule le score à la volée si correct
      if (isCorrect) {
        const diff = question.difficulty.toLowerCase() as Difficulty;
        scoresByDifficulty[diff] = (scoresByDifficulty[diff] ?? 0) + 1;
        totalScore++;
      }

      // 3. Construit directement le retour visuel
      const isfr = session.lang === "fr" && question.answersFr;
      const choices = (
        isfr ? question.answersFr : question.answersEn
      ) as string[];

      answersResult.push({
        questionId: answer.questionId,
        isCorrect,
        correctAnswer: choices[question.correctIndex],
      });
    }

    await this.prisma.$transaction([
      this.prisma.soloAnswer.createMany({
        data: soloAnswersData,
        skipDuplicates: true,
      }),

      this.prisma.soloSession.update({
        where: { id: sessionId },
        data: { status: "FINISHED" },
      }),

      ...Object.entries(scoresByDifficulty).map(([difficulty, value]) =>
        this.scoreService.getUpsertOperation(
          userId,
          difficulty as Difficulty,
          value,
        ),
      ),
    ]);

    // Retourne le récapitulatif formaté
    return {
      totalScore,
      details: Object.entries(scoresByDifficulty).map(
        ([difficulty, value]) => ({
          difficulty,
          value,
        }),
      ),
      answers: answersResult,
    };
  }

  // ─── Helper : session active ────────────────────────────────────────

  private async getActiveSession(userId: string, sessionId: string) {
    const session = await this.prisma.soloSession.findUnique({
      where: { id: sessionId },
    });

    if (!session) {
      throw new NotFoundException("Session not found");
    }

    if (session.userId !== userId) {
      throw new BadRequestException("Session does not belong to this user");
    }

    if (session.status !== "IN_PROGRESS") {
      throw new BadRequestException("Session is already finished");
    }

    if (new Date() > session.expiresAt) {
      await this.prisma.soloSession.update({
        where: { id: sessionId },
        data: { status: "EXPIRED" },
      });
      throw new BadRequestException("Session has expired");
    }

    return session;
  }
}
