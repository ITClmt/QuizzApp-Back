import { IoAdapter } from '@nestjs/platform-socket.io';
import type { ServerOptions } from 'socket.io';
import { corsOrigin } from '../common/cors';

/**
 * Adaptateur socket.io qui reprend la liste blanche CORS du HTTP (CORS_ORIGINS).
 * Le faire ici plutôt que dans `@WebSocketGateway({ cors })` : les options du
 * décorateur sont évaluées au chargement du module, avant que l'env soit garanti.
 */
export class SocketIoAdapter extends IoAdapter {
	createIOServer(port: number, options?: ServerOptions) {
		return super.createIOServer(port, {
			...options,
			cors: { origin: corsOrigin() },
		});
	}
}
