import { HttpException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ScoreService } from '../score/score.service';
import { QuizService } from './quiz.service';

describe('QuizService', () => {
	const prisma = {
		$queryRaw: jest.fn(),
		question: { findMany: jest.fn() },
		soloSession: { findMany: jest.fn(), updateMany: jest.fn() },
	};
	const service = new QuizService(
		prisma as unknown as PrismaService,
		{} as ScoreService,
	);

	beforeEach(() => jest.clearAllMocks());

	describe('pickRandomQuestions', () => {
		it("rend les questions dans l'ordre du tirage, pas celui de findMany", async () => {
			prisma.$queryRaw.mockResolvedValue([
				{ id: 'c' },
				{ id: 'a' },
				{ id: 'b' },
			]);
			prisma.question.findMany.mockResolvedValue([
				{ id: 'a' },
				{ id: 'b' },
				{ id: 'c' },
			]);

			const questions = await service.pickRandomQuestions({ count: 3 });

			expect(questions.map((q) => q.id)).toEqual(['c', 'a', 'b']);
		});

		it('passe null pour les filtres absents et le count en LIMIT', async () => {
			prisma.$queryRaw.mockResolvedValue([{ id: 'a' }]);
			prisma.question.findMany.mockResolvedValue([{ id: 'a' }]);

			await service.pickRandomQuestions({ count: 15 });

			const [, ...values] = prisma.$queryRaw.mock.calls[0];
			expect(values).toEqual([null, null, null, null, 15]);
		});

		it("traduit l'id de catégorie en son nom", async () => {
			prisma.$queryRaw.mockResolvedValue([{ id: 'a' }]);
			prisma.question.findMany.mockResolvedValue([{ id: 'a' }]);

			await service.pickRandomQuestions({
				difficulty: 'hard',
				category: '22',
				count: 15,
			});

			const [, ...values] = prisma.$queryRaw.mock.calls[0];
			expect(values).toEqual(['hard', 'hard', 'Geography', 'Geography', 15]);
		});

		it('lève NO_QUESTIONS_AVAILABLE quand rien ne correspond', async () => {
			prisma.$queryRaw.mockResolvedValue([]);

			await expect(
				service.pickRandomQuestions({ difficulty: 'hard', count: 15 }),
			).rejects.toBeInstanceOf(NotFoundException);
			expect(prisma.question.findMany).not.toHaveBeenCalled();
		});
	});

	describe('getQuota', () => {
		const HOUR = 60 * 60 * 1000;
		const sessions = (count: number, oldest: Date) =>
			Array.from({ length: count }, (_, i) => ({
				createdAt: new Date(oldest.getTime() + i * 1000),
			}));

		it("rend le nombre de parties restantes sans resetAt tant qu'il en reste", async () => {
			prisma.soloSession.findMany.mockResolvedValue(
				sessions(4, new Date(Date.now() - HOUR)),
			);

			await expect(service.getQuota('u1')).resolves.toEqual({
				limit: 15,
				remaining: 11,
				resetAt: null,
			});
		});

		it('fixe resetAt 6 h après la plus ancienne partie de la fenêtre', async () => {
			const oldest = new Date(Date.now() - 2 * HOUR);
			prisma.soloSession.findMany.mockResolvedValue(sessions(15, oldest));

			const quota = await service.getQuota('u1');

			expect(quota.remaining).toBe(0);
			expect(quota.resetAt).toEqual(new Date(oldest.getTime() + 6 * HOUR));
		});
	});

	describe('startSession', () => {
		it('refuse en 429 sans annuler la partie en cours quand la limite est atteinte', async () => {
			prisma.soloSession.findMany.mockResolvedValue(
				Array.from({ length: 15 }, () => ({ createdAt: new Date() })),
			);

			const error = await service
				.startSession('u1', 'fr')
				.catch((e: unknown) => e);

			expect(error).toBeInstanceOf(HttpException);
			expect((error as HttpException).getStatus()).toBe(429);
			expect((error as HttpException).getResponse()).toMatchObject({
				code: 'GAME_LIMIT_REACHED',
			});
			expect(prisma.soloSession.updateMany).not.toHaveBeenCalled();
		});
	});
});
