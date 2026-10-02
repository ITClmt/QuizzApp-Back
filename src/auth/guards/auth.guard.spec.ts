import { ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { AuthGuard } from './auth.guard';

function contextOf(type: string, headers: Record<string, string> = {}) {
	const request = { headers };
	return {
		getType: () => type,
		getHandler: () => undefined,
		getClass: () => undefined,
		switchToHttp: () => ({ getRequest: () => request }),
	} as unknown as ExecutionContext;
}

describe('AuthGuard', () => {
	const jwtService = { verifyAsync: jest.fn() };
	const reflector = { getAllAndOverride: jest.fn().mockReturnValue(false) };
	const guard = new AuthGuard(
		jwtService as unknown as JwtService,
		reflector as unknown as Reflector,
	);

	beforeEach(() => jest.clearAllMocks());

	it('laisse passer un contexte WebSocket sans token', async () => {
		await expect(guard.canActivate(contextOf('ws'))).resolves.toBe(true);
		expect(jwtService.verifyAsync).not.toHaveBeenCalled();
	});

	it('rejette une requête HTTP sans token', async () => {
		await expect(guard.canActivate(contextOf('http'))).rejects.toBeInstanceOf(
			UnauthorizedException,
		);
	});

	it('accepte une requête HTTP avec un token valide', async () => {
		jwtService.verifyAsync.mockResolvedValue({ sub: 'u1' });
		await expect(
			guard.canActivate(
				contextOf('http', { authorization: 'Bearer valid-token' }),
			),
		).resolves.toBe(true);
	});
});
