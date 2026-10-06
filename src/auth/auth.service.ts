import { randomInt } from 'node:crypto';
import {
	BadRequestException,
	Injectable,
	Logger,
	UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { ErrorCode, errorBody } from 'src/common/error-codes';
import { MailService } from 'src/mail/mail.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { UsersService } from 'src/users/users.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import {
	RESET_CODE_MAX_ATTEMPTS,
	RESET_CODE_RESEND_COOLDOWN_MS,
	RESET_CODE_TTL_MINUTES,
} from './constants';
import { LoginDto } from './dto/login.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';

@Injectable()
export class AuthService {
	private readonly logger = new Logger(AuthService.name);

	constructor(
		private readonly userService: UsersService,
		private readonly jwtService: JwtService,
		private readonly configService: ConfigService,
		private readonly prisma: PrismaService,
		private readonly mailService: MailService,
	) {}

	private async generateAndSaveTokens(
		userId: string,
		email: string,
		role: string,
		username: string,
		lang: string,
		avatarSlug: string,
	) {
		const payload = { sub: userId, email, role, username, lang, avatarSlug };
		const refreshPayload = { sub: userId };

		const accessToken = await this.jwtService.signAsync(payload);

		const refreshToken = await this.jwtService.signAsync(refreshPayload, {
			secret: this.configService.getOrThrow<string>('JWT_REFRESH_SECRET'),
			expiresIn: '7d',
		});

		const hashedRefreshToken = await argon2.hash(refreshToken);

		const expiresAt = new Date();
		expiresAt.setDate(expiresAt.getDate() + 7);

		await this.prisma.refreshToken.create({
			data: {
				token: hashedRefreshToken,
				userId,
				expiresAt,
			},
		});

		return {
			access_token: accessToken,
			refresh_token: refreshToken,
		};
	}

	private async findValidRefreshToken(refreshToken: string) {
		let payload: { sub: string };
		try {
			payload = await this.jwtService.verifyAsync(refreshToken, {
				secret: this.configService.getOrThrow<string>('JWT_REFRESH_SECRET'),
			});
		} catch {
			throw new UnauthorizedException(
				errorBody(
					ErrorCode.AUTH_REFRESH_TOKEN_INVALID,
					'Refresh token invalide ou expiré',
				),
			);
		}

		const storedTokens = await this.prisma.refreshToken.findMany({
			where: { userId: payload.sub },
		});

		for (const stored of storedTokens) {
			if (
				stored.expiresAt > new Date() &&
				(await argon2.verify(stored.token, refreshToken))
			) {
				return { payload, matchedToken: stored };
			}
		}

		throw new UnauthorizedException(
			errorBody(
				ErrorCode.AUTH_REFRESH_TOKEN_REVOKED,
				'Refresh token révoqué ou inexistant',
			),
		);
	}

	async register(createUserDto: CreateUserDto) {
		const newUser = await this.userService.create(createUserDto);

		return this.generateAndSaveTokens(
			newUser.id,
			newUser.email,
			newUser.role,
			newUser.username,
			newUser.lang,
			newUser.avatarSlug,
		);
	}

	async login(loginDto: LoginDto) {
		const user = await this.userService.findByEmail(loginDto.email);
		if (!user)
			throw new UnauthorizedException(
				errorBody(
					ErrorCode.AUTH_INVALID_CREDENTIALS,
					'Email ou mot de passe incorrect',
				),
			);

		const isPwdMatch = await argon2.verify(user.password, loginDto.password);
		if (!isPwdMatch)
			throw new UnauthorizedException(
				errorBody(
					ErrorCode.AUTH_INVALID_CREDENTIALS,
					'Email ou mot de passe incorrect',
				),
			);

		return this.generateAndSaveTokens(
			user.id,
			user.email,
			user.role,
			user.username,
			user.lang,
			user.avatarSlug,
		);
	}

	async refreshTokens(refreshToken: string) {
		const { payload, matchedToken } =
			await this.findValidRefreshToken(refreshToken);

		await this.prisma.refreshToken.delete({ where: { id: matchedToken.id } });

		const user = await this.userService.findById(payload.sub);
		return this.generateAndSaveTokens(
			user.id,
			user.email,
			user.role,
			user.username,
			user.lang,
			user.avatarSlug,
		);
	}

	async logout(refreshToken: string) {
		const { matchedToken } = await this.findValidRefreshToken(refreshToken);

		await this.prisma.refreshToken.delete({ where: { id: matchedToken.id } });
	}

	// Ne lève jamais : la route répond 204 sans attendre, que le compte existe
	// ou non, pour ne révéler ni l'existence de l'e-mail ni (par le temps de
	// réponse) le travail fait derrière.
	async requestPasswordReset(email: string) {
		try {
			const user = await this.userService.findByEmail(email);
			if (!user) return;

			const existing = await this.prisma.passwordResetCode.findUnique({
				where: { userId: user.id },
			});
			if (
				existing &&
				Date.now() - existing.createdAt.getTime() <
					RESET_CODE_RESEND_COOLDOWN_MS
			)
				return;

			const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
			const codeHash = await argon2.hash(code);
			const expiresAt = new Date(
				Date.now() + RESET_CODE_TTL_MINUTES * 60 * 1000,
			);

			await this.prisma.passwordResetCode.upsert({
				where: { userId: user.id },
				create: { userId: user.id, codeHash, expiresAt },
				update: { codeHash, expiresAt, attempts: 0, createdAt: new Date() },
			});

			await this.mailService.sendPasswordResetCode(user.email, code, user.lang);
		} catch (error) {
			this.logger.error(
				'Échec de la demande de réinitialisation',
				error instanceof Error ? error.stack : error,
			);
		}
	}

	async resetPassword({ email, code, newPassword }: ResetPasswordDto) {
		// Même erreur pour compte inconnu, pas de code, code faux, expiré ou
		// essais épuisés : aucun indice pour qui teste des e-mails ou des codes
		const invalid = new BadRequestException(
			errorBody(
				ErrorCode.AUTH_RESET_CODE_INVALID,
				'Code de réinitialisation invalide ou expiré',
			),
		);

		const user = await this.userService.findByEmail(email);
		if (!user) throw invalid;

		// L'essai est consommé AVANT la vérification, de façon atomique : deux
		// requêtes simultanées ne peuvent pas dépasser la limite
		const { count } = await this.prisma.passwordResetCode.updateMany({
			where: {
				userId: user.id,
				attempts: { lt: RESET_CODE_MAX_ATTEMPTS },
				expiresAt: { gt: new Date() },
			},
			data: { attempts: { increment: 1 } },
		});
		if (count === 0) throw invalid;

		const entry = await this.prisma.passwordResetCode.findUniqueOrThrow({
			where: { userId: user.id },
		});
		if (!(await argon2.verify(entry.codeHash, code))) throw invalid;

		const password = await argon2.hash(newPassword);

		// Toutes les sessions sont fermées : si le compte était compromis,
		// l'intrus perd son refresh token
		await this.prisma.$transaction([
			this.prisma.user.update({ where: { id: user.id }, data: { password } }),
			this.prisma.passwordResetCode.delete({ where: { id: entry.id } }),
			this.prisma.refreshToken.deleteMany({ where: { userId: user.id } }),
		]);
	}
}
