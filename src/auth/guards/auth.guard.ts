import {
	CanActivate,
	ExecutionContext,
	Injectable,
	UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';
import { ErrorCode, errorBody } from 'src/common/error-codes';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

const unauthorized = () =>
	new UnauthorizedException(
		errorBody(ErrorCode.AUTH_UNAUTHORIZED, 'Authentification requise'),
	);

@Injectable()
export class AuthGuard implements CanActivate {
	constructor(
		private jwtService: JwtService,
		private reflector: Reflector,
	) {}

	async canActivate(context: ExecutionContext): Promise<boolean> {
		// Guard global : Nest l'applique aussi aux handlers WebSocket, où il n'y a ni
		// requête HTTP ni en-tête Authorization. Le socket est authentifié une seule
		// fois, à la connexion, par le gateway.
		if (context.getType() !== 'http') return true;

		const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
			context.getHandler(),
			context.getClass(),
		]);
		if (isPublic) {
			// 💡 See this condition
			return true;
		}

		const request = context.switchToHttp().getRequest();
		const token = this.extractTokenFromHeader(request);
		if (!token) {
			throw unauthorized();
		}
		try {
			// 💡 Here the JWT secret key that's used for verifying the payload
			// is the key that was passsed in the JwtModule
			const payload = await this.jwtService.verifyAsync(token);
			// 💡 We're assigning the payload to the request object here
			// so that we can access it in our route handlers
			request['user'] = payload;
		} catch {
			throw unauthorized();
		}
		return true;
	}

	private extractTokenFromHeader(request: Request): string | undefined {
		const [type, token] = request.headers.authorization?.split(' ') ?? [];
		return type === 'Bearer' ? token : undefined;
	}
}
