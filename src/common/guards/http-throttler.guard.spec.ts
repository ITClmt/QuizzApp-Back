import { ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ThrottlerStorage } from '@nestjs/throttler';
import { HttpThrottlerGuard } from './http-throttler.guard';

describe('HttpThrottlerGuard', () => {
	const storage = { increment: jest.fn() };
	const guard = new HttpThrottlerGuard(
		{ throttlers: [{ name: 'default', ttl: 60000, limit: 1 }] },
		storage as unknown as ThrottlerStorage,
		new Reflector(),
	);

	it('ignore les évènements WebSocket sans toucher au compteur', async () => {
		const context = {
			getType: () => 'ws',
			getHandler: () => undefined,
			getClass: () => undefined,
		} as unknown as ExecutionContext;

		await expect(guard.canActivate(context)).resolves.toBe(true);
		expect(storage.increment).not.toHaveBeenCalled();
	});
});
