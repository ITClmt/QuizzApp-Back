import {
	BadRequestException,
	ConflictException,
	NotFoundException,
} from '@nestjs/common';
import { FriendsService } from 'src/friends/friends.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { QuizService } from 'src/quiz/quiz.service';
import { GAME_QUESTIONS } from './constants';
import { GamesService } from './games.service';

describe('GamesService', () => {
	const tx = {
		game: { updateMany: jest.fn(), create: jest.fn() },
		gamePlayer: { updateMany: jest.fn() },
	};
	const prisma = {
		game: { updateMany: jest.fn() },
		gamePlayer: {
			findFirst: jest.fn(),
			findMany: jest.fn(),
			updateMany: jest.fn(),
		},
		$transaction: jest.fn((fn: (t: typeof tx) => unknown) => fn(tx)),
	};
	const friendsService = { assertAllFriends: jest.fn() };
	const quizService = { pickRandomQuestions: jest.fn() };

	const service = new GamesService(
		prisma as unknown as PrismaService,
		friendsService as unknown as FriendsService,
		quizService as unknown as QuizService,
	);

	beforeEach(() => jest.clearAllMocks());

	describe('createGame', () => {
		beforeEach(() => {
			prisma.gamePlayer.findFirst.mockResolvedValue(null);
			quizService.pickRandomQuestions.mockResolvedValue([
				{ id: 'q1' },
				{ id: 'q2' },
			]);
			tx.game.create.mockResolvedValue({ id: 'game-1' });
		});

		it("crée la partie : hôte JOINED, amis INVITED, questions dans l'ordre", async () => {
			const result = await service.createGame('host', ['f1', 'f2'], 'medium');

			expect(result).toEqual({ gameId: 'game-1' });
			expect(quizService.pickRandomQuestions).toHaveBeenCalledWith({
				difficulty: 'medium',
				count: GAME_QUESTIONS,
			});
			const { data } = tx.game.create.mock.calls[0][0];
			expect(data.difficulty).toBe('medium');
			expect(data.players.create).toEqual([
				{ userId: 'host', isHost: true, status: 'JOINED' },
				{ userId: 'f1' },
				{ userId: 'f2' },
			]);
			expect(data.gameQuestions.create).toEqual([
				{ questionId: 'q1', order: 0 },
				{ questionId: 'q2', order: 1 },
			]);
		});

		it('sans difficulté : partie mixte (null)', async () => {
			await service.createGame('host', ['f1']);

			expect(tx.game.create.mock.calls[0][0].data.difficulty).toBeNull();
		});

		it("quitte les salons en attente de l'hôte dans la même transaction", async () => {
			await service.createGame('host', ['f1']);

			expect(tx.game.updateMany).toHaveBeenCalledWith({
				where: {
					status: 'WAITING',
					players: { some: { userId: 'host', isHost: true } },
				},
				data: { status: 'CANCELED' },
			});
			expect(tx.gamePlayer.updateMany).toHaveBeenCalledWith(
				expect.objectContaining({ data: { status: 'LEFT' } }),
			);
		});

		it('refuse si l’hôte est dans une partie en cours', async () => {
			prisma.gamePlayer.findFirst.mockResolvedValue({ id: 'gp' });

			await expect(service.createGame('host', ['f1'])).rejects.toBeInstanceOf(
				ConflictException,
			);
			expect(prisma.$transaction).not.toHaveBeenCalled();
		});

		it('refuse si un invité n’est pas un ami', async () => {
			friendsService.assertAllFriends.mockRejectedValueOnce(
				new BadRequestException(),
			);

			await expect(service.createGame('host', ['x'])).rejects.toBeInstanceOf(
				BadRequestException,
			);
			expect(prisma.$transaction).not.toHaveBeenCalled();
		});
	});

	describe('listInvitations', () => {
		it("renvoie l'hôte en profil public et le nombre de joueurs", async () => {
			const createdAt = new Date();
			prisma.gamePlayer.findMany.mockResolvedValue([
				{
					game: {
						id: 'g1',
						difficulty: null,
						createdAt,
						players: [
							{
								isHost: true,
								user: { id: 'h', username: 'host', avatarSlug: 'a', xp: 0 },
							},
							{
								isHost: false,
								user: { id: 'me', username: 'me', avatarSlug: 'b', xp: 0 },
							},
						],
					},
				},
			]);

			await expect(service.listInvitations('me')).resolves.toEqual([
				{
					gameId: 'g1',
					difficulty: null,
					createdAt,
					host: { id: 'h', username: 'host', avatarSlug: 'a', level: 0 },
					playerCount: 2,
				},
			]);
		});
	});

	describe('declineInvitation', () => {
		it('lève INVITATION_NOT_FOUND si rien ne correspond', async () => {
			prisma.gamePlayer.updateMany.mockResolvedValue({ count: 0 });

			await expect(
				service.declineInvitation('me', 'g1'),
			).rejects.toBeInstanceOf(NotFoundException);
		});
	});

	describe('getActiveGame', () => {
		it('renvoie { game: null } sans partie active', async () => {
			prisma.gamePlayer.findFirst.mockResolvedValue(null);

			await expect(service.getActiveGame('me')).resolves.toEqual({
				game: null,
			});
		});
	});

	describe('onApplicationBootstrap', () => {
		it('annule les parties WAITING et PLAYING', async () => {
			prisma.game.updateMany.mockResolvedValue({ count: 0 });

			await service.onApplicationBootstrap();

			expect(prisma.game.updateMany).toHaveBeenCalledWith({
				where: { status: { in: ['WAITING', 'PLAYING'] } },
				data: { status: 'CANCELED' },
			});
		});
	});
});
