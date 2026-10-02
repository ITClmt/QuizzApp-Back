import { ErrorCode } from 'src/common/error-codes';
import { Difficulty, GamePlayerStatus } from 'src/generated/prisma/client';
import { toPublicUser } from 'src/users/utils/public-user';

export type PublicUser = ReturnType<typeof toPublicUser>;

export type GamePhase = 'LOBBY';

export interface LivePlayer {
	user: PublicUser;
	isHost: boolean;
	status: GamePlayerStatus;
	/** Sockets du joueur actuellement dans la partie (un par appareil) */
	socketIds: Set<string>;
}

/** État d'une partie en mémoire. La base reste la source de vérité des statuts. */
export interface LiveGame {
	id: string;
	difficulty: Difficulty | null;
	createdAt: Date;
	hostId: string;
	phase: GamePhase;
	players: Map<string, LivePlayer>;
	lobbyTimer?: NodeJS.Timeout;
}

export type CancelReason = 'host_left' | 'lobby_timeout';

/** Erreur métier renvoyée telle quelle dans l'ack du client */
export class GameError extends Error {
	constructor(readonly code: ErrorCode) {
		super(code);
	}
}
