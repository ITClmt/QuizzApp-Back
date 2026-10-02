import { Injectable } from '@nestjs/common';
import type { Server } from 'socket.io';

export const userRoom = (userId: string) => `user:${userId}`;
export const gameRoom = (gameId: string) => `game:${gameId}`;

/**
 * Seul point de sortie vers les clients. Le moteur passe par ici plutôt que par le
 * Server socket.io directement, ce qui permet de le remplacer par un mock en test.
 *
 * Chaque socket rejoint `user:<id>` à la connexion : écrire à un joueur atteint donc
 * tous ses appareils connectés.
 */
@Injectable()
export class GameEmitter {
	private server: Server | null = null;

	/** Appelé par le gateway une fois le serveur socket.io créé */
	attach(server: Server) {
		this.server = server;
	}

	toUser(userId: string, event: string, payload: unknown) {
		this.server?.to(userRoom(userId)).emit(event, payload);
	}

	toGame(gameId: string, event: string, payload: unknown) {
		this.server?.to(gameRoom(gameId)).emit(event, payload);
	}

	/** Retire tous les appareils d'un joueur de la room de la partie */
	removeUserFromGame(userId: string, gameId: string) {
		this.server?.in(userRoom(userId)).socketsLeave(gameRoom(gameId));
	}

	/** Vide la room d'une partie terminée ou annulée */
	closeGameRoom(gameId: string) {
		this.server?.in(gameRoom(gameId)).socketsLeave(gameRoom(gameId));
	}
}
