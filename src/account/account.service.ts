import {
	BadRequestException,
	ConflictException,
	Injectable,
	Logger,
} from '@nestjs/common';
import * as argon2 from 'argon2';
import { AuthService } from 'src/auth/auth.service';
import { ErrorCode, errorBody } from 'src/common/error-codes';
import { GameEngineService } from 'src/games/engine/game-engine.service';
import { GameEmitter } from 'src/games/game-emitter.service';
import { GamesService } from 'src/games/games.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { ChangePasswordDto } from './dto/change-password.dto';

@Injectable()
export class AccountService {
	private readonly logger = new Logger(AccountService.name);

	constructor(
		private readonly prisma: PrismaService,
		private readonly authService: AuthService,
		private readonly gamesService: GamesService,
		private readonly gameEngine: GameEngineService,
		private readonly gameEmitter: GameEmitter,
	) {}

	// 400 et pas 401 : un 401 ferait croire au front que son token a expiré
	// (refresh + nouvel essai automatique)
	private async getUserCheckingPassword(userId: string, password: string) {
		const user = await this.prisma.user.findUniqueOrThrow({
			where: { id: userId },
		});
		if (!(await argon2.verify(user.password, password))) {
			throw new BadRequestException(
				errorBody(ErrorCode.AUTH_WRONG_PASSWORD, 'Mot de passe incorrect'),
			);
		}
		return user;
	}

	async changePassword(
		userId: string,
		{ currentPassword, newPassword }: ChangePasswordDto,
	) {
		const user = await this.getUserCheckingPassword(userId, currentPassword);

		if (await argon2.verify(user.password, newPassword)) {
			throw new BadRequestException(
				errorBody(
					ErrorCode.PASSWORD_UNCHANGED,
					"Le nouveau mot de passe doit être différent de l'actuel",
				),
			);
		}

		const password = await argon2.hash(newPassword);

		// Tous les appareils sont déconnectés…
		await this.prisma.$transaction([
			this.prisma.user.update({ where: { id: userId }, data: { password } }),
			this.prisma.refreshToken.deleteMany({ where: { userId } }),
		]);

		// …sauf celui qui vient de faire le changement
		return this.authService.issueTokens(user);
	}

	async deleteAccount(userId: string, password: string) {
		await this.getUserCheckingPassword(userId, password);

		// Le moteur garde la partie en mémoire : supprimer un joueur en plein
		// milieu ferait échouer l'enregistrement de fin pour tous les autres
		const { game } = await this.gamesService.getActiveGame(userId);
		if (game) {
			throw new ConflictException(
				errorBody(
					ErrorCode.ALREADY_IN_GAME,
					'Quitte ta partie avant de supprimer ton compte',
				),
			);
		}

		// Décliner via le moteur met à jour les salons ouverts chez l'hôte ;
		// sinon il verrait encore un invité qui n'existe plus
		const invitations = await this.prisma.gamePlayer.findMany({
			where: {
				userId,
				status: { in: ['INVITED', 'LEFT'] },
				game: { status: 'WAITING' },
			},
			select: { gameId: true },
		});
		for (const { gameId } of invitations) {
			await this.gameEngine
				.declineInvitation(userId, gameId)
				.catch((error) =>
					this.logger.warn(
						`Invitation ${gameId} non déclinée avant suppression : ${error}`,
					),
				);
		}

		// Cascade : scores, sessions, amis, parties, refresh tokens…
		await this.prisma.user.delete({ where: { id: userId } });

		this.gameEmitter.disconnectUser(userId);
	}
}
