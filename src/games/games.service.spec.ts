import {
	BadRequestException,
	ConflictException,
	NotFoundException,
} from '@nestjs/common';
import { FriendsService } from 'src/friends/friends.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { QuizService } from 'src/quiz/quiz.service';
import { ScoreService } from 'src/score/score.service';
import { GAME_QUESTIONS } from './constants';
import { GamesService } from './games.service';

describe('GamesService', () => {
	const tx = {
		game: { findMany: jest.fn(), updateMany: jest.fn(), create: jest.fn() },
		gamePlayer: { findMany: jest.fn(), updateMany: jest.fn() },
	};
	const prisma = {
		game: { updateMany: jest.fn(), update: jest.fn() },
		gameQuestion: { createMany: jest.fn(), findMany: jest.fn() },
		gameAnswer: { createMany: jest.fn() },
		user: { findMany: jest.fn(), update: jest.fn() },
		gamePlayer: {
			findFirst: jest.fn(),
			findMany: jest.fn(),
			updateMany: jest.fn(),
			update: jest.fn(),
		},
		// Forme callback (createGame…) ou tableau d'opérations (finishGame)
		$transaction: jest.fn((arg: unknown) =>
			typeof arg === 'function' ? arg(tx) : Promise.all(arg as unknown[]),
		),
	};
	const friendsService = { assertAllFriends: jest.fn() };
	const quizService = { pickRandomQuestions: jest.fn() };
	const scoreService = {
		getUpsertOperation: jest.fn((userId, difficulty, points) => ({
			upsert: { userId, difficulty, points },
		})),
	};

	const service = new GamesService(
		prisma as unknown as PrismaService,
		friendsService as unknown as FriendsService,
		quizService as unknown as QuizService,
		scoreService as unknown as ScoreService,
	);

	beforeEach(() => jest.clearAllMocks());

	describe('createGame', () => {
		beforeEach(() => {
			prisma.gamePlayer.findFirst.mockResolvedValue(null);
			tx.game.create.mockResolvedValue({ id: 'game-1' });
			tx.game.findMany.mockResolvedValue([]);
			tx.gamePlayer.findMany.mockResolvedValue([]);
		});

		it('crée la partie : hôte JOINED, amis INVITED, sans questions', async () => {
			const result = await service.createGame('host', ['f1', 'f2'], 'medium');

			expect(result).toEqual({
				gameId: 'game-1',
				canceledGameIds: [],
				leftGameIds: [],
			});
			// Tirées au lancement : la difficulté peut changer dans le salon
			expect(quizService.pickRandomQuestions).not.toHaveBeenCalled();
			const { data } = tx.game.create.mock.calls[0][0];
			expect(data.difficulty).toBe('medium');
			expect(data.players.create).toEqual([
				{ userId: 'host', isHost: true, status: 'JOINED' },
				{ userId: 'f1' },
				{ userId: 'f2' },
			]);
			expect(data.gameQuestions).toBeUndefined();
		});

		it('sans difficulté : partie mixte (null)', async () => {
			await service.createGame('host', ['f1']);

			expect(tx.game.create.mock.calls[0][0].data.difficulty).toBeNull();
		});

		it("quitte les salons en attente de l'hôte et renvoie lesquels", async () => {
			tx.game.findMany.mockResolvedValue([{ id: 'hosted' }]);
			tx.gamePlayer.findMany.mockResolvedValue([{ gameId: 'joined' }]);

			const result = await service.createGame('host', ['f1']);

			expect(result).toEqual({
				gameId: 'game-1',
				canceledGameIds: ['hosted'],
				leftGameIds: ['joined'],
			});
			expect(tx.game.updateMany).toHaveBeenCalledWith({
				where: { id: { in: ['hosted'] } },
				data: { status: 'CANCELED' },
			});
			expect(tx.gamePlayer.updateMany).toHaveBeenCalledWith({
				where: { userId: 'host', gameId: { in: ['joined'] } },
				data: { status: 'LEFT' },
			});
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

	describe('joinLobby', () => {
		beforeEach(() => {
			prisma.gamePlayer.findFirst.mockResolvedValue(null);
			tx.game.findMany.mockResolvedValue([]);
			tx.gamePlayer.findMany.mockResolvedValue([]);
		});

		it('passe en JOINED en épargnant le salon rejoint', async () => {
			tx.gamePlayer.updateMany.mockResolvedValue({ count: 1 });

			await service.joinLobby('me', 'g1');

			expect(tx.game.findMany.mock.calls[0][0].where.id).toEqual({
				not: 'g1',
			});
			expect(tx.gamePlayer.updateMany).toHaveBeenLastCalledWith({
				where: {
					gameId: 'g1',
					userId: 'me',
					status: { in: ['INVITED', 'LEFT'] },
					game: { status: 'WAITING' },
				},
				data: { status: 'JOINED' },
			});
		});

		it('lève INVITATION_NOT_FOUND si aucune ligne ne correspond', async () => {
			tx.gamePlayer.updateMany.mockResolvedValue({ count: 0 });

			await expect(service.joinLobby('me', 'g1')).rejects.toBeInstanceOf(
				NotFoundException,
			);
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
		it('accepte aussi un invité parti du salon (il voit encore l’invitation)', async () => {
			prisma.gamePlayer.updateMany.mockResolvedValue({ count: 1 });

			await service.declineInvitation('me', 'g1');

			expect(
				prisma.gamePlayer.updateMany.mock.calls[0][0].where.status,
			).toEqual({
				in: ['INVITED', 'LEFT'],
			});
		});

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

	describe('setDifficulty', () => {
		it('ne touche qu’un salon encore en attente', async () => {
			await service.setDifficulty('g1', 'hard');

			expect(prisma.game.updateMany).toHaveBeenCalledWith({
				where: { id: 'g1', status: 'WAITING' },
				data: { difficulty: 'hard' },
			});
		});
	});

	describe('startGame', () => {
		beforeEach(() => {
			quizService.pickRandomQuestions.mockResolvedValue([
				{ id: 'q1' },
				{ id: 'q2' },
			]);
			prisma.gameQuestion.findMany.mockResolvedValue([]);
			prisma.user.findMany.mockResolvedValue([{ id: 'host', lang: 'fr' }]);
		});

		it("tire les questions dans la difficulté du salon et les enregistre dans l'ordre", async () => {
			const { langByUserId } = await service.startGame(
				'g1',
				['host'],
				'medium',
			);

			expect(quizService.pickRandomQuestions).toHaveBeenCalledWith({
				difficulty: 'medium',
				count: GAME_QUESTIONS,
			});
			expect(prisma.gameQuestion.createMany).toHaveBeenCalledWith({
				data: [
					{ gameId: 'g1', questionId: 'q1', order: 0 },
					{ gameId: 'g1', questionId: 'q2', order: 1 },
				],
			});
			expect(prisma.game.update.mock.calls[0][0].data).toMatchObject({
				status: 'PLAYING',
				difficulty: 'medium',
			});
			expect(langByUserId.get('host')).toBe('fr');
		});

		it('partie mixte : tirage sans filtre de difficulté', async () => {
			await service.startGame('g1', ['host'], null);

			expect(quizService.pickRandomQuestions).toHaveBeenCalledWith({
				difficulty: undefined,
				count: GAME_QUESTIONS,
			});
		});
	});

	describe('finishGame', () => {
		it('crédite XP et points de Score par difficulté, dans la même transaction', async () => {
			prisma.user.findMany.mockResolvedValue([
				{ id: 'alice', xp: 100 },
				{ id: 'bob', xp: 0 },
			]);

			const xpBefore = await service.finishGame('g1', [
				{
					userId: 'alice',
					gamePlayerId: 'gp-a',
					score: 3,
					xpEarned: 49,
					pointsByDifficulty: { easy: 1, hard: 2 },
					answers: [],
				},
				// Abandon : rien à créditer
				{
					userId: 'bob',
					gamePlayerId: 'gp-b',
					score: 1,
					xpEarned: 0,
					pointsByDifficulty: {},
					answers: [],
				},
			]);

			expect(scoreService.getUpsertOperation.mock.calls).toEqual([
				['alice', 'easy', 1],
				['alice', 'hard', 2],
			]);
			const operations = prisma.$transaction.mock.calls[0][0] as unknown[];
			expect(operations).toContainEqual({
				upsert: { userId: 'alice', difficulty: 'hard', points: 2 },
			});
			expect(prisma.user.update).toHaveBeenCalledTimes(1);
			expect(xpBefore.get('alice')).toBe(100);
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
