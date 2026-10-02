import { Injectable, Logger } from '@nestjs/common';
import { ErrorCode } from 'src/common/error-codes';
import { Difficulty } from 'src/generated/prisma/client';
import { toPublicUser } from 'src/users/utils/public-user';
import { LOBBY_TIMEOUT_MS } from '../constants';
import { GameEmitter } from '../game-emitter.service';
import { GamesService, LobbyExits } from '../games.service';
import { CancelReason, GameError, LiveGame, LivePlayer } from './live-game';

/**
 * Maître du jeu : l'état des parties vit ici, en mémoire (une seule instance du
 * serveur). La base est mise à jour à chaque changement de statut, le moteur en
 * garde le miroir et prévient les clients via le GameEmitter.
 *
 * Règle pour les méthodes async : modifier l'état en mémoire (phase, Map) AVANT le
 * premier await, pour qu'un évènement arrivé pendant l'attente voie le nouvel état.
 */
@Injectable()
export class GameEngineService {
	private readonly logger = new Logger(GameEngineService.name);
	private readonly games = new Map<string, LiveGame>();

	constructor(
		private readonly gamesService: GamesService,
		private readonly emitter: GameEmitter,
	) {}

	// --- Appelé par le REST ---

	async createGame(
		hostId: string,
		friendIds: string[],
		difficulty?: Difficulty,
	) {
		const { gameId, ...exits } = await this.gamesService.createGame(
			hostId,
			friendIds,
			difficulty,
		);
		this.applyLobbyExits(hostId, exits);

		const game = await this.registerGame(gameId);
		const invitation = this.toInvitation(game);
		for (const player of game.players.values()) {
			if (player.status === 'INVITED') {
				this.emitter.toUser(player.user.id, 'invitation:received', invitation);
			}
		}

		return { gameId };
	}

	async declineInvitation(userId: string, gameId: string) {
		await this.gamesService.declineInvitation(userId, gameId);

		const game = this.games.get(gameId);
		const player = game?.players.get(userId);
		if (game && player) {
			player.status = 'DECLINED';
			this.broadcastLobby(game);
		}
	}

	// --- Appelé par le gateway ---

	/**
	 * Entrer dans la partie depuis un socket : accepter une invitation, revenir dans
	 * un salon quitté, ou simplement rattacher un nouvel appareil (l'hôte, une
	 * reconnexion).
	 */
	async join(userId: string, socketId: string, gameId: string) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);

		if (player.status !== 'JOINED') {
			if (player.status === 'DECLINED') {
				throw new GameError(ErrorCode.INVITATION_NOT_FOUND);
			}
			const exits = await this.gamesService.joinLobby(userId, gameId);
			this.applyLobbyExits(userId, exits);
			// Le salon a pu être annulé pendant l'attente (l'hôte est parti, timeout…)
			if (!this.games.has(gameId)) {
				throw new GameError(ErrorCode.GAME_NOT_FOUND);
			}
			player.status = 'JOINED';
		}

		player.socketIds.add(socketId);
		this.broadcastLobby(game);
		return this.toLobby(game);
	}

	/** Quitter volontairement. L'hôte qui quitte annule le salon. */
	async leave(userId: string, gameId: string) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);

		if (player.isHost) {
			await this.cancel(game, 'host_left');
			return;
		}
		// Un invité qui n'a jamais rejoint refuse via POST /games/:id/decline
		if (player.status !== 'JOINED') return;

		player.status = 'LEFT';
		player.socketIds.clear();
		this.emitter.removeUserFromGame(userId, gameId);
		this.broadcastLobby(game);
		await this.gamesService.leaveGame(userId, gameId);
	}

	/** Coupure réseau, app en arrière-plan… : le joueur reste dans la partie */
	disconnect(userId: string, socketId: string, gameId: string) {
		const game = this.games.get(gameId);
		const player = game?.players.get(userId);
		if (!game || !player?.socketIds.delete(socketId)) return;

		this.broadcastLobby(game);
	}

	// --- Interne ---

	private async registerGame(gameId: string) {
		const row = await this.gamesService.getLobby(gameId);

		const players = new Map<string, LivePlayer>();
		let hostId = '';
		for (const p of row.players) {
			const user = toPublicUser(p.user);
			if (p.isHost) hostId = user.id;
			players.set(user.id, {
				user,
				isHost: p.isHost,
				status: p.status,
				socketIds: new Set(),
			});
		}

		const game: LiveGame = {
			id: row.id,
			difficulty: row.difficulty,
			createdAt: row.createdAt,
			hostId,
			phase: 'LOBBY',
			players,
		};
		game.lobbyTimer = setTimeout(() => {
			this.cancel(game, 'lobby_timeout').catch((err) =>
				this.logger.error(`Annulation du salon ${game.id} échouée`, err),
			);
		}, LOBBY_TIMEOUT_MS);

		this.games.set(game.id, game);
		return game;
	}

	private async cancel(game: LiveGame, reason: CancelReason) {
		this.close(game, reason);
		await this.gamesService.cancelGame(game.id);
	}

	/** Retire la partie de la mémoire et prévient tout le monde (la base est à jour) */
	private close(game: LiveGame, reason: CancelReason) {
		if (this.games.get(game.id) !== game) return;
		this.games.delete(game.id);
		clearTimeout(game.lobbyTimer);

		this.emitter.toGame(game.id, 'game:canceled', { gameId: game.id, reason });
		for (const player of game.players.values()) {
			if (player.status === 'INVITED') {
				this.emitter.toUser(player.user.id, 'invitation:canceled', {
					gameId: game.id,
				});
			}
		}
		this.emitter.closeGameRoom(game.id);
	}

	/** Répercute en mémoire les salons quittés en base par GamesService */
	private applyLobbyExits(userId: string, exits: LobbyExits) {
		for (const gameId of exits.canceledGameIds) {
			const game = this.games.get(gameId);
			if (game) this.close(game, 'host_left');
		}
		for (const gameId of exits.leftGameIds) {
			const game = this.games.get(gameId);
			const player = game?.players.get(userId);
			if (!game || !player) continue;
			player.status = 'LEFT';
			player.socketIds.clear();
			this.emitter.removeUserFromGame(userId, gameId);
			this.broadcastLobby(game);
		}
	}

	private requireGame(gameId: string) {
		const game = this.games.get(gameId);
		// Inconnue en mémoire : annulée, terminée, ou tuée par un redéploiement
		if (!game) throw new GameError(ErrorCode.GAME_NOT_FOUND);
		return game;
	}

	private requirePlayer(game: LiveGame, userId: string) {
		const player = game.players.get(userId);
		if (!player) throw new GameError(ErrorCode.NOT_A_PLAYER);
		return player;
	}

	private broadcastLobby(game: LiveGame) {
		this.emitter.toGame(game.id, 'lobby:update', this.toLobby(game));
	}

	private toLobby(game: LiveGame) {
		return {
			gameId: game.id,
			hostId: game.hostId,
			difficulty: game.difficulty,
			phase: game.phase,
			players: [...game.players.values()].map((p) => ({
				user: p.user,
				isHost: p.isHost,
				status: p.status,
				connected: p.socketIds.size > 0,
			})),
		};
	}

	/** Même forme que GET /games/invitations */
	private toInvitation(game: LiveGame) {
		const players = [...game.players.values()];
		return {
			gameId: game.id,
			difficulty: game.difficulty,
			createdAt: game.createdAt,
			host: game.players.get(game.hostId)?.user,
			playerCount: players.filter(
				(p) => p.status === 'INVITED' || p.status === 'JOINED',
			).length,
		};
	}
}
