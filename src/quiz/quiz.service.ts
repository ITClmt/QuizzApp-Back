import {
	BadRequestException,
	ConflictException,
	Injectable,
	NotFoundException,
} from '@nestjs/common';
import { ErrorCode, errorBody } from '../common/error-codes';
import { Difficulty, Question } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ScoreService } from '../score/score.service';
import { getCategoryOtdName } from './constants/categories';
import { XP_PER_DIFFICULTY } from './constants/xp';
import { AnswerDto } from './dto/finish-session.dto';
import { SanitizedQuestion } from './interfaces/question.interface';
import { getLevelFromXp } from './utils/level.util';

@Injectable()
export class QuizService {
	private readonly QUESTIONS_PER_GAME = 50;
	private readonly GAME_DURATION_MS = 1.5 * 60 * 1000; // 1min30

	constructor(
		private readonly prisma: PrismaService,
		private readonly scoreService: ScoreService,
	) {}

	async getUserLevel(userId: string): Promise<number> {
		const user = await this.prisma.user.findUniqueOrThrow({
			where: { id: userId },
			select: { xp: true },
		});

		return getLevelFromXp(user.xp);
	}

	async getQuestions(
		lang: string = 'en',
		difficulty?: string,
		category?: string,
	): Promise<SanitizedQuestion[]> {
		const where = {
			...(difficulty && { difficulty }),
			...(category && { category: getCategoryOtdName(category) }),
		};

		const total = await this.prisma.question.count({ where });
		if (total === 0) {
			throw new NotFoundException(
				errorBody(
					ErrorCode.NO_QUESTIONS_AVAILABLE,
					'No questions available for this selection',
				),
			);
		}

		const take = Math.min(this.QUESTIONS_PER_GAME, total);
		const randomSkip = Math.floor(Math.random() * (total - take + 1));

		const questions = await this.prisma.question.findMany({
			where,
			take,
			skip: randomSkip,
		});

		return questions.map((question) => this.sanitize(question, lang));
	}

	private sanitize(question: Question, lang: string): SanitizedQuestion {
		const isfr = lang === 'fr' && question.questionFr;

		return {
			id: question.id,
			question: (isfr ? question.questionFr : question.questionEn) as string,
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
			lang === 'fr' && question.answersFr
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
				status: 'IN_PROGRESS',
				expiresAt: { gt: new Date() },
			},
		});

		if (existing) {
			throw new ConflictException(
				errorBody(
					ErrorCode.SESSION_ALREADY_IN_PROGRESS,
					'A session is already in progress',
				),
			);
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
			createdAt: session.createdAt,
			expiresAt: session.expiresAt,
			questions,
		};
	}

	async finishSession(userId: string, sessionId: string, answers: AnswerDto[]) {
		const session = await this.getActiveSession(userId, sessionId);

		if (!session) {
			throw new NotFoundException(
				errorBody(ErrorCode.SESSION_NOT_FOUND, 'Session not found'),
			);
		}

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
		let xpEarned = 0;

		// Boucle unique pour traiter chaque réponse
		for (const answer of answers) {
			const question = questionMap.get(answer.questionId);
			if (!question) {
				throw new BadRequestException(
					errorBody(
						ErrorCode.INVALID_ANSWER_QUESTION,
						`Question ${answer.questionId} introuvable ou invalide.`,
					),
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
				xpEarned += XP_PER_DIFFICULTY[diff];
			}

			// 3. Construit directement le retour visuel
			const isfr = session.lang === 'fr' && question.answersFr;
			const choices = (
				isfr ? question.answersFr : question.answersEn
			) as string[];

			answersResult.push({
				questionId: answer.questionId,
				isCorrect,
				correctAnswer: choices[question.correctIndex],
			});
		}

		const { xp: xpBefore } = await this.prisma.user.findUniqueOrThrow({
			where: { id: userId },
			select: { xp: true },
		});

		await this.prisma.$transaction([
			this.prisma.soloAnswer.createMany({
				data: soloAnswersData,
				skipDuplicates: true,
			}),

			this.prisma.soloSession.update({
				where: { id: sessionId },
				data: { status: 'EXPIRED' },
			}),

			...Object.entries(scoresByDifficulty).map(([difficulty, value]) =>
				this.scoreService.getUpsertOperation(
					userId,
					difficulty as Difficulty,
					value,
				),
			),

			...(xpEarned > 0
				? [
						this.prisma.user.update({
							where: { id: userId },
							data: { xp: { increment: xpEarned } },
						}),
					]
				: []),
		]);

		const level = getLevelFromXp(xpBefore + xpEarned);
		const leveledUp = level > getLevelFromXp(xpBefore);

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
			xpEarned,
			level,
			leveledUp,
		};
	}

	async cancelSession(userId: string, sessionId: string) {
		const session = await this.getActiveSession(userId, sessionId);

		if (!session) {
			throw new NotFoundException(
				errorBody(ErrorCode.SESSION_NOT_FOUND, 'Session not found'),
			);
		}

		await this.prisma.soloSession.update({
			where: { id: sessionId },
			data: { status: 'FINISHED' },
		});

		return {
			sessionId: session.id,
			status: 'FINISHED' as const,
			message: 'Session finished without saving answers',
		};
	}

	// ─── Helper : session active ────────────────────────────────────────

	private async getActiveSession(userId: string, sessionId: string) {
		const session = await this.prisma.soloSession.findUnique({
			where: { id: sessionId },
		});

		if (!session) {
			throw new NotFoundException(
				errorBody(ErrorCode.SESSION_NOT_FOUND, 'Session not found'),
			);
		}

		if (session.userId !== userId) {
			throw new BadRequestException(
				errorBody(
					ErrorCode.SESSION_NOT_OWNED,
					'Session does not belong to this user',
				),
			);
		}

		if (session.status !== 'IN_PROGRESS') {
			throw new BadRequestException(
				errorBody(
					ErrorCode.SESSION_ALREADY_FINISHED,
					'Session is already finished',
				),
			);
		}

		if (new Date() > session.expiresAt) {
			await this.prisma.soloSession.update({
				where: { id: sessionId },
				data: { status: 'EXPIRED' },
			});
			throw new BadRequestException(
				errorBody(ErrorCode.SESSION_EXPIRED, 'Session has expired'),
			);
		}

		return session;
	}
}
