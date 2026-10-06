import { HttpException, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import {
	ConnectedSocket,
	MessageBody,
	OnGatewayConnection,
	OnGatewayDisconnect,
	OnGatewayInit,
	SubscribeMessage,
	WebSocketGateway,
} from '@nestjs/websockets';
import { isUUID } from 'class-validator';
import type { Server, Socket } from 'socket.io';
import type { JwtPayload } from 'src/auth/types/jwt-payload.type';
import { ErrorCode } from 'src/common/error-codes';
import { Difficulty } from 'src/generated/prisma/client';
import { GameEngineService } from './engine/game-engine.service';
import { GameError } from './engine/live-game';
import { GameEmitter, gameRoom, userRoom } from './game-emitter.service';

type SocketData = { userId: string; gameId?: string };
type GameSocket = Socket<
	Record<string, never>,
	Record<string, never>,
	Record<string, never>,
	SocketData
>;

/** Réponse renvoyée au client via l'ack de chaque évènement */
type Ack<T> = { ok: true; data: T } | { ok: false; error: string };

/**
 * Entrées/sorties temps réel uniquement : authentifie la connexion et traduit chaque
 * évènement en un appel au moteur. Aucune règle de jeu ici.
 *
 * Sous /api comme le REST, pour passer par le même routage côté proxy.
 */
@WebSocketGateway({ path: '/api/socket.io' })
export class GamesGateway
	implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
	private readonly logger = new Logger(GamesGateway.name);

	constructor(
		private readonly jwtService: JwtService,
		private readonly emitter: GameEmitter,
		private readonly engine: GameEngineService,
	) {}

	afterInit(server: Server) {
		this.emitter.attach(server);

		// Le token est vérifié une seule fois, à la connexion (les guards HTTP ignorent
		// le WebSocket). En cas d'échec, le client reçoit un `connect_error`
		// « unauthorized » : il rafraîchit son token et se reconnecte.
		server.use((socket, next) => {
			this.authenticate(socket as GameSocket).then(
				() => next(),
				() => next(new Error('unauthorized')),
			);
		});
	}

	handleConnection(socket: GameSocket) {
		socket.join(userRoom(socket.data.userId));
	}

	handleDisconnect(socket: GameSocket) {
		const { userId, gameId } = socket.data;
		if (gameId) this.engine.disconnect(userId, socket.id, gameId);
	}

	@SubscribeMessage('game:join')
	join(@ConnectedSocket() socket: GameSocket, @MessageBody() body: unknown) {
		return this.handle(body, async (gameId) => {
			const lobby = await this.engine.join(
				socket.data.userId,
				socket.id,
				gameId,
			);

			// Socket coupé pendant l'attente : ne pas le laisser compter comme connecté
			if (socket.disconnected) {
				this.engine.disconnect(socket.data.userId, socket.id, gameId);
				return lobby;
			}
			await socket.join(gameRoom(gameId));
			socket.data.gameId = gameId;
			return lobby;
		});
	}

	@SubscribeMessage('game:leave')
	leave(@ConnectedSocket() socket: GameSocket, @MessageBody() body: unknown) {
		return this.handle(body, async (gameId) => {
			await this.engine.leave(socket.data.userId, gameId);
			socket.data.gameId = undefined;
			return null;
		});
	}

	@SubscribeMessage('game:start')
	start(@ConnectedSocket() socket: GameSocket, @MessageBody() body: unknown) {
		return this.handle(body, async (gameId) => {
			await this.engine.start(socket.data.userId, gameId);
			return null;
		});
	}

	@SubscribeMessage('game:ready')
	ready(@ConnectedSocket() socket: GameSocket, @MessageBody() body: unknown) {
		return this.handle(body, async (gameId) => {
			const { ready } = body as { ready?: unknown };
			if (typeof ready !== 'boolean') {
				throw new GameError(ErrorCode.INVALID_PAYLOAD);
			}
			this.engine.setReady(socket.data.userId, gameId, ready);
			return null;
		});
	}

	/** `difficulty: null` = partie mixte */
	@SubscribeMessage('game:difficulty')
	difficulty(
		@ConnectedSocket() socket: GameSocket,
		@MessageBody() body: unknown,
	) {
		return this.handle(body, async (gameId) => {
			const { difficulty } = body as { difficulty?: unknown };
			const valid =
				difficulty === null ||
				Object.values(Difficulty).includes(difficulty as Difficulty);
			if (!valid) throw new GameError(ErrorCode.INVALID_PAYLOAD);

			await this.engine.setDifficulty(
				socket.data.userId,
				gameId,
				difficulty as Difficulty | null,
			);
			return null;
		});
	}

	@SubscribeMessage('answer')
	answer(@ConnectedSocket() socket: GameSocket, @MessageBody() body: unknown) {
		return this.handle(body, async (gameId) => {
			const { questionIndex, answerIndex } = body as {
				questionIndex?: unknown;
				answerIndex?: unknown;
			};
			if (!Number.isInteger(questionIndex) || !Number.isInteger(answerIndex)) {
				throw new GameError(ErrorCode.INVALID_PAYLOAD);
			}
			this.engine.answer(
				socket.data.userId,
				gameId,
				questionIndex as number,
				answerIndex as number,
			);
			return null;
		});
	}

	private async authenticate(socket: GameSocket) {
		const token: unknown = socket.handshake.auth?.token;
		if (typeof token !== 'string') throw new Error('missing token');

		const payload = await this.jwtService.verifyAsync<JwtPayload>(token);
		socket.data.userId = payload.sub;
	}

	/** Valide le `gameId` reçu et transforme toute erreur en ack `{ ok: false }` */
	private async handle<T>(
		body: unknown,
		fn: (gameId: string) => Promise<T>,
	): Promise<Ack<T>> {
		const gameId = (body as { gameId?: unknown } | null)?.gameId;
		if (typeof gameId !== 'string' || !isUUID(gameId)) {
			return { ok: false, error: ErrorCode.INVALID_PAYLOAD };
		}

		try {
			return { ok: true, data: await fn(gameId) };
		} catch (err) {
			return { ok: false, error: this.toErrorCode(err) };
		}
	}

	private toErrorCode(err: unknown): string {
		if (err instanceof GameError) return err.code;
		// Erreurs métier de GamesService (409 ALREADY_IN_GAME, 404…) : même `code` qu'en REST
		if (err instanceof HttpException) {
			const response = err.getResponse() as { code?: string };
			if (response.code) return response.code;
		}
		this.logger.error('Erreur inattendue sur un évènement socket', err);
		return ErrorCode.INTERNAL_ERROR;
	}
}
