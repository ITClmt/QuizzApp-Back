import { BadRequestException, ConflictException } from '@nestjs/common';
import * as argon2 from 'argon2';
import { AuthService } from 'src/auth/auth.service';
import { ErrorCode } from 'src/common/error-codes';
import { GameEngineService } from 'src/games/engine/game-engine.service';
import { GameEmitter } from 'src/games/game-emitter.service';
import { GamesService } from 'src/games/games.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { AccountService } from './account.service';

describe('AccountService', () => {
	const prisma = {
		user: {
			findUniqueOrThrow: jest.fn(),
			update: jest.fn(),
			delete: jest.fn(),
		},
		refreshToken: { deleteMany: jest.fn() },
		gamePlayer: { findMany: jest.fn() },
		$transaction: jest.fn((ops: unknown[]) => Promise.all(ops)),
	};
	const authService = { issueTokens: jest.fn() };
	const gamesService = { getActiveGame: jest.fn() };
	const gameEngine = { declineInvitation: jest.fn() };
	const gameEmitter = { disconnectUser: jest.fn() };

	const service = new AccountService(
		prisma as unknown as PrismaService,
		authService as unknown as AuthService,
		gamesService as unknown as GamesService,
		gameEngine as unknown as GameEngineService,
		gameEmitter as unknown as GameEmitter,
	);

	const CURRENT = 'Old!pass1';
	let user: { id: string; password: string };

	beforeAll(async () => {
		user = { id: 'user-1', password: await argon2.hash(CURRENT) };
	});

	beforeEach(() => {
		jest.clearAllMocks();
		prisma.user.findUniqueOrThrow.mockResolvedValue(user);
	});

	async function expectBadRequest(promise: Promise<unknown>, code: ErrorCode) {
		const error = await promise.catch((e: unknown) => e);
		expect(error).toBeInstanceOf(BadRequestException);
		expect((error as BadRequestException).getResponse()).toMatchObject({
			code,
		});
	}

	describe('changePassword', () => {
		it('change le hash, coupe toutes les sessions et renvoie de nouveaux tokens', async () => {
			authService.issueTokens.mockResolvedValue({ access_token: 'a' });

			const result = await service.changePassword(user.id, {
				currentPassword: CURRENT,
				newPassword: 'New!pass2',
			});

			const { data } = prisma.user.update.mock.calls[0][0];
			expect(await argon2.verify(data.password, 'New!pass2')).toBe(true);
			expect(prisma.refreshToken.deleteMany).toHaveBeenCalledWith({
				where: { userId: user.id },
			});
			// Les tokens sont émis après la purge, sinon ils seraient effacés aussi
			expect(prisma.$transaction.mock.invocationCallOrder[0]).toBeLessThan(
				authService.issueTokens.mock.invocationCallOrder[0],
			);
			expect(result).toEqual({ access_token: 'a' });
		});

		it('rejette un mot de passe actuel faux', async () => {
			await expectBadRequest(
				service.changePassword(user.id, {
					currentPassword: 'Wrong!pass1',
					newPassword: 'New!pass2',
				}),
				ErrorCode.AUTH_WRONG_PASSWORD,
			);
			expect(prisma.$transaction).not.toHaveBeenCalled();
		});

		it("rejette un nouveau mot de passe identique à l'actuel", async () => {
			await expectBadRequest(
				service.changePassword(user.id, {
					currentPassword: CURRENT,
					newPassword: CURRENT,
				}),
				ErrorCode.PASSWORD_UNCHANGED,
			);
			expect(prisma.$transaction).not.toHaveBeenCalled();
		});
	});

	describe('deleteAccount', () => {
		beforeEach(() => {
			gamesService.getActiveGame.mockResolvedValue({ game: null });
			prisma.gamePlayer.findMany.mockResolvedValue([]);
		});

		it('supprime le compte et coupe ses sockets', async () => {
			await service.deleteAccount(user.id, CURRENT);

			expect(prisma.user.delete).toHaveBeenCalledWith({
				where: { id: user.id },
			});
			expect(gameEmitter.disconnectUser).toHaveBeenCalledWith(user.id);
		});

		it('rejette un mot de passe faux', async () => {
			await expectBadRequest(
				service.deleteAccount(user.id, 'Wrong!pass1'),
				ErrorCode.AUTH_WRONG_PASSWORD,
			);
			expect(prisma.user.delete).not.toHaveBeenCalled();
		});

		it('refuse pendant une partie (salon rejoint ou en cours)', async () => {
			gamesService.getActiveGame.mockResolvedValue({
				game: { id: 'g1', status: 'PLAYING' },
			});

			await expect(service.deleteAccount(user.id, CURRENT)).rejects.toThrow(
				ConflictException,
			);
			expect(prisma.user.delete).not.toHaveBeenCalled();
		});

		it('décline les invitations en attente avant de supprimer, même si une échoue', async () => {
			prisma.gamePlayer.findMany.mockResolvedValue([
				{ gameId: 'g1' },
				{ gameId: 'g2' },
			]);
			gameEngine.declineInvitation
				.mockRejectedValueOnce(new Error('déjà annulée'))
				.mockResolvedValueOnce(undefined);

			await service.deleteAccount(user.id, CURRENT);

			expect(gameEngine.declineInvitation).toHaveBeenCalledWith(user.id, 'g1');
			expect(gameEngine.declineInvitation).toHaveBeenCalledWith(user.id, 'g2');
			expect(prisma.user.delete).toHaveBeenCalled();
		});
	});
});
