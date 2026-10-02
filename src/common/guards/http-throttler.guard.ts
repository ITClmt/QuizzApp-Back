import { ExecutionContext, Injectable } from '@nestjs/common';
import { ThrottlerGuard } from '@nestjs/throttler';

/**
 * ThrottlerGuard limité au HTTP. Enregistré en APP_GUARD, le guard d'origine
 * s'appliquerait aussi aux évènements WebSocket, où il lit l'IP via une requête
 * HTTP qui n'existe pas.
 */
@Injectable()
export class HttpThrottlerGuard extends ThrottlerGuard {
	protected async shouldSkip(context: ExecutionContext): Promise<boolean> {
		return context.getType() !== 'http';
	}
}
