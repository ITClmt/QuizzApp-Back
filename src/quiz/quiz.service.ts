import { HttpService } from "@nestjs/axios";
import { Injectable, Logger } from "@nestjs/common";
import { firstValueFrom } from "rxjs";
import { PrismaService } from "../prisma/prisma.service";
import { OtdQuestion, OtdResponse } from "./interfaces/otd-question.interface";
import { SanitizedQuestion } from "./interfaces/question.interface";

@Injectable()
export class QuizService {
  private readonly logger = new Logger(QuizService.name);
  private readonly OTD_URL = "https://opentdb.com/api.php";
  private readonly QUESTIONS_PER_GAME = 50;

  constructor(
    private readonly httpService: HttpService,
    private readonly prisma: PrismaService,
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

    // 4. Sanitize et retourne (sans correctIndex)
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
    const decode = (str: string) =>
      str
        .replace(/&amp;/g, "&")
        .replace(/&lt;/g, "<")
        .replace(/&gt;/g, ">")
        .replace(/&quot;/g, '"')
        .replace(/&#039;/g, "'")
        .replace(/&eacute;/g, "é")
        .replace(/&egrave;/g, "è")
        .replace(/&ecirc;/g, "ê")
        .replace(/&agrave;/g, "à")
        .replace(/&ccedil;/g, "ç")
        .replace(/&ugrave;/g, "ù")
        .replace(/&ucirc;/g, "û")
        .replace(/&ocirc;/g, "ô")
        .replace(/&icirc;/g, "î")
        .replace(/&iacute;/g, "í")
        .replace(/&iacute;/g, "í");

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

  private sanitize(question: any, lang: string): SanitizedQuestion {
    const isfr = lang === "fr" && question.questionFr;

    return {
      id: question.id,
      questionEn: question.questionEn,
      questionFr: question.questionFr ?? null,
      answers: isfr ? question.answersFr : question.answersEn,
      category: question.category,
      difficulty: question.difficulty,
    };
  }

  // Appelé par le GameService pour valider une réponse
  async validateAnswer(
    questionId: string,
    answerIndex: number,
  ): Promise<boolean> {
    const question = await this.prisma.question.findUnique({
      where: { id: questionId },
    });

    if (!question) return false;
    return question.correctIndex === answerIndex;
  }
}
