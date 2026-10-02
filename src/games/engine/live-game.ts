import { ErrorCode } from 'src/common/error-codes';
import { Difficulty, GamePlayerStatus } from 'src/generated/prisma/client';
import { toPublicUser } from 'src/users/utils/public-user';

export type PublicUser = ReturnType<typeof toPublicUser>;

/**
 * LOBBY → STARTING (chargement en base) → QUESTION ⇄ REVEAL (×15) → FINISHED.
 * STARTING bloque un double lancement et les nouvelles arrivées pendant l'attente.
 */
export type GamePhase =
	| 'LOBBY'
	| 'STARTING'
	| 'QUESTION'
	| 'REVEAL'
	| 'FINISHED';

export interface PlayerAnswer {
	answerIndex: number;
	isCorrect: boolean;
	responseMs: number;
}

export interface LivePlayer {
	gamePlayerId: string;
	user: PublicUser;
	isHost: boolean;
	status: GamePlayerStatus;
	/** Sockets du joueur actuellement dans la partie (un par appareil) */
	socketIds: Set<string>;
	/** Était JOINED au lancement : fait partie du classement, même s'il abandonne */
	playing: boolean;
	lang: string;
	score: number;
	/** Par index de question */
	answers: Map<number, PlayerAnswer>;
}

interface LocalizedQuestion {
	question: string;
	answers: string[];
}

export interface LiveQuestion {
	gameQuestionId: string;
	category: string;
	difficulty: string;
	correctIndex: number;
	en: LocalizedQuestion;
	/** Absente si la traduction manque : repli sur l'anglais */
	fr: LocalizedQuestion | null;
}

/** État d'une partie en mémoire. La base reste la source de vérité des statuts. */
export interface LiveGame {
	id: string;
	difficulty: Difficulty | null;
	createdAt: Date;
	hostId: string;
	phase: GamePhase;
	players: Map<string, LivePlayer>;
	questions: LiveQuestion[];
	/** -1 tant que la partie n'a pas commencé */
	questionIndex: number;
	questionStartedAt: number;
	/** Fin de la phase en cours : sert à calculer le temps restant envoyé aux clients */
	phaseEndsAt: number;
	/** Dernière révélation, renvoyée à qui se reconnecte pendant la phase REVEAL */
	lastReveal: unknown;
	lobbyTimer?: NodeJS.Timeout;
	phaseTimer?: NodeJS.Timeout;
	/** Armé quand plus aucun joueur n'est connecté en cours de partie */
	abandonTimer?: NodeJS.Timeout;
}

export type CancelReason =
	| 'host_left'
	| 'lobby_timeout'
	| 'all_disconnected'
	| 'all_left'
	| 'server_error';

/** Erreur métier renvoyée telle quelle dans l'ack du client */
export class GameError extends Error {
	constructor(readonly code: ErrorCode) {
		super(code);
	}
}
