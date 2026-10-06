import { BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { ErrorCode } from 'src/common/error-codes';
import { MailService } from 'src/mail/mail.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { UsersService } from 'src/users/users.service';
import { AuthService } from './auth.service';
import { RESET_CODE_MAX_ATTEMPTS } from './constants';

describe('AuthService', () => {
	const prisma = {
		passwordResetCode: {
			findUnique: jest.fn(),
			findUniqueOrThrow: jest.fn(),
			upsert: jest.fn(),
			updateMany: jest.fn(),
			delete: jest.fn(),
		},
		user: { update: jest.fn() },
		refreshToken: { deleteMany: jest.fn() },
		$transaction: jest.fn((ops: unknown[]) => Promise.all(ops)),
	};
	const usersService = { findByEmail: jest.fn() };
	const mailService = { sendPasswordResetCode: jest.fn() };

	const service = new AuthService(
		usersService as unknown as UsersService,
		{} as JwtService,
		{} as ConfigService,
		prisma as unknown as PrismaService,
		mailService as unknown as MailService,
	);

	const user = { id: 'user-1', email: 'a@b.fr', lang: 'fr' };

	beforeEach(() => jest.clearAllMocks());

	describe('requestPasswordReset', () => {
		it('ne fait rien pour un e-mail inconnu', async () => {
			usersService.findByEmail.mockResolvedValue(null);

			await service.requestPasswordReset('inconnu@b.fr');

			expect(prisma.passwordResetCode.upsert).not.toHaveBeenCalled();
			expect(mailService.sendPasswordResetCode).not.toHaveBeenCalled();
		});

		it('stocke un hash du code et envoie le code en clair', async () => {
			usersService.findByEmail.mockResolvedValue(user);
			prisma.passwordResetCode.findUnique.mockResolvedValue(null);

			await service.requestPasswordReset(user.email);

			const [, code, lang] = mailService.sendPasswordResetCode.mock.calls[0];
			expect(code).toMatch(/^\d{6}$/);
			expect(lang).toBe('fr');

			const { create } = prisma.passwordResetCode.upsert.mock.calls[0][0];
			expect(create.codeHash).not.toBe(code);
			expect(await argon2.verify(create.codeHash, code)).toBe(true);
		});

		it('ignore une nouvelle demande pendant le délai anti-spam', async () => {
			usersService.findByEmail.mockResolvedValue(user);
			prisma.passwordResetCode.findUnique.mockResolvedValue({
				createdAt: new Date(Date.now() - 10_000),
			});

			await service.requestPasswordReset(user.email);

			expect(prisma.passwordResetCode.upsert).not.toHaveBeenCalled();
			expect(mailService.sendPasswordResetCode).not.toHaveBeenCalled();
		});

		it("ne lève pas si l'envoi de l'e-mail échoue", async () => {
			usersService.findByEmail.mockResolvedValue(user);
			prisma.passwordResetCode.findUnique.mockResolvedValue(null);
			mailService.sendPasswordResetCode.mockRejectedValue(new Error('boom'));

			await expect(
				service.requestPasswordReset(user.email),
			).resolves.toBeUndefined();
		});
	});

	describe('resetPassword', () => {
		const dto = { email: user.email, code: '123456', newPassword: 'N3w!pass' };

		async function expectInvalid(promise: Promise<unknown>) {
			const error = await promise.catch((e: unknown) => e);
			expect(error).toBeInstanceOf(BadRequestException);
			expect((error as BadRequestException).getResponse()).toMatchObject({
				code: ErrorCode.AUTH_RESET_CODE_INVALID,
			});
			expect(prisma.$transaction).not.toHaveBeenCalled();
		}

		beforeEach(async () => {
			usersService.findByEmail.mockResolvedValue(user);
			prisma.passwordResetCode.updateMany.mockResolvedValue({ count: 1 });
			prisma.passwordResetCode.findUniqueOrThrow.mockResolvedValue({
				id: 'code-1',
				codeHash: await argon2.hash('123456'),
			});
		});

		it('change le mot de passe, supprime le code et toutes les sessions', async () => {
			await service.resetPassword(dto);

			const { data } = prisma.user.update.mock.calls[0][0];
			expect(await argon2.verify(data.password, dto.newPassword)).toBe(true);
			expect(prisma.passwordResetCode.delete).toHaveBeenCalledWith({
				where: { id: 'code-1' },
			});
			expect(prisma.refreshToken.deleteMany).toHaveBeenCalledWith({
				where: { userId: user.id },
			});
		});

		it("consomme un essai seulement s'il en reste et que le code n'a pas expiré", async () => {
			await service.resetPassword(dto);

			const { where } = prisma.passwordResetCode.updateMany.mock.calls[0][0];
			expect(where.attempts).toEqual({ lt: RESET_CODE_MAX_ATTEMPTS });
			expect(where.expiresAt.gt).toBeInstanceOf(Date);
		});

		it('rejette un code faux', async () => {
			await expectInvalid(service.resetPassword({ ...dto, code: '000000' }));
		});

		it('rejette un code expiré, absent ou aux essais épuisés', async () => {
			prisma.passwordResetCode.updateMany.mockResolvedValue({ count: 0 });

			await expectInvalid(service.resetPassword(dto));
			expect(prisma.passwordResetCode.findUniqueOrThrow).not.toHaveBeenCalled();
		});

		it('rejette un e-mail inconnu avec la même erreur', async () => {
			usersService.findByEmail.mockResolvedValue(null);

			await expectInvalid(service.resetPassword(dto));
		});
	});
});
