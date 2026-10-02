import { NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ScoreService } from '../score/score.service';
import { QuizService } from './quiz.service';

describe('QuizService', () => {
	const prisma = {
		$queryRaw: jest.fn(),
		question: { findMany: jest.fn() },
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

		it("traduit l'id de catégorie en nom OTD", async () => {
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
});
