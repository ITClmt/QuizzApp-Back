import { Test, TestingModule } from '@nestjs/testing';
import { ErrorCode } from 'src/common/error-codes';
import { Prisma } from 'src/generated/prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { escapeLike, FriendsService } from './friends.service';
import { pairKey } from './utils/pair-key';

const ME = '11111111-1111-4111-8111-111111111111';
const OTHER = '22222222-2222-4222-8222-222222222222';

function makePrisma() {
	return {
		$queryRaw: jest.fn(),
		user: {
			findUnique: jest.fn(),
		},
		friendship: {
			findUnique: jest.fn(),
			findUniqueOrThrow: jest.fn(),
			findFirst: jest.fn(),
			findMany: jest.fn(),
			create: jest.fn(),
			update: jest.fn(),
			delete: jest.fn(),
			deleteMany: jest.fn(),
			count: jest.fn().mockResolvedValue(0),
		},
	};
}

async function expectErrorCode(promise: Promise<unknown>, code: ErrorCode) {
	await expect(promise).rejects.toMatchObject({ response: { code } });
}

describe('FriendsService', () => {
	let service: FriendsService;
	let prisma: ReturnType<typeof makePrisma>;

	beforeEach(async () => {
		prisma = makePrisma();
		const module: TestingModule = await Test.createTestingModule({
			providers: [FriendsService, { provide: PrismaService, useValue: prisma }],
		}).compile();

		service = module.get(FriendsService);
	});

	describe('pairKey', () => {
		it('is the same whatever the order', () => {
			expect(pairKey(ME, OTHER)).toBe(pairKey(OTHER, ME));
		});
	});

	describe('sendRequest', () => {
		beforeEach(() => {
			prisma.user.findUnique.mockResolvedValue({ id: OTHER });
		});

		it('rejects a request to oneself', async () => {
			await expectErrorCode(
				service.sendRequest(ME, ME),
				ErrorCode.CANNOT_FRIEND_SELF,
			);
		});

		it('rejects an unknown target', async () => {
			prisma.user.findUnique.mockResolvedValue(null);
			await expectErrorCode(
				service.sendRequest(ME, OTHER),
				ErrorCode.USER_NOT_FOUND,
			);
		});

		it('creates a pending request keyed by pair', async () => {
			prisma.friendship.findUnique.mockResolvedValue(null);
			prisma.friendship.create.mockResolvedValue({
				id: 'f1',
				status: 'PENDING',
			});

			await expect(service.sendRequest(ME, OTHER)).resolves.toEqual({
				id: 'f1',
				status: 'PENDING',
			});
			expect(prisma.friendship.create).toHaveBeenCalledWith({
				data: {
					pairKey: pairKey(ME, OTHER),
					requesterId: ME,
					receiverId: OTHER,
				},
			});
		});

		it('rejects a duplicate request', async () => {
			prisma.friendship.findUnique.mockResolvedValue({
				id: 'f1',
				status: 'PENDING',
				requesterId: ME,
			});
			await expectErrorCode(
				service.sendRequest(ME, OTHER),
				ErrorCode.FRIEND_REQUEST_EXISTS,
			);
		});

		it('rejects when already friends', async () => {
			prisma.friendship.findUnique.mockResolvedValue({
				id: 'f1',
				status: 'ACCEPTED',
				requesterId: OTHER,
			});
			await expectErrorCode(
				service.sendRequest(ME, OTHER),
				ErrorCode.ALREADY_FRIENDS,
			);
		});

		it('auto-accepts when the target already sent a request', async () => {
			prisma.friendship.findUnique.mockResolvedValue({
				id: 'f1',
				status: 'PENDING',
				requesterId: OTHER,
			});
			prisma.friendship.update.mockResolvedValue({
				id: 'f1',
				status: 'ACCEPTED',
			});

			await expect(service.sendRequest(ME, OTHER)).resolves.toEqual({
				id: 'f1',
				status: 'ACCEPTED',
			});
			expect(prisma.friendship.create).not.toHaveBeenCalled();
		});

		it('auto-accepts when losing a crossed-request race (P2002)', async () => {
			prisma.friendship.findUnique.mockResolvedValue(null);
			prisma.friendship.create.mockRejectedValue(
				new Prisma.PrismaClientKnownRequestError('unique', {
					code: 'P2002',
					clientVersion: 'test',
				}),
			);
			prisma.friendship.findUniqueOrThrow.mockResolvedValue({
				id: 'f2',
				status: 'PENDING',
				requesterId: OTHER,
			});
			prisma.friendship.update.mockResolvedValue({
				id: 'f2',
				status: 'ACCEPTED',
			});

			await expect(service.sendRequest(ME, OTHER)).resolves.toEqual({
				id: 'f2',
				status: 'ACCEPTED',
			});
		});

		it('enforces the pending requests limit', async () => {
			prisma.friendship.findUnique.mockResolvedValue(null);
			prisma.friendship.count.mockResolvedValueOnce(50);
			await expectErrorCode(
				service.sendRequest(ME, OTHER),
				ErrorCode.TOO_MANY_PENDING_REQUESTS,
			);
		});

		it('enforces the friends limit', async () => {
			prisma.friendship.findUnique.mockResolvedValue(null);
			prisma.friendship.count
				.mockResolvedValueOnce(0) // pending sent
				.mockResolvedValueOnce(200); // friends
			await expectErrorCode(
				service.sendRequest(ME, OTHER),
				ErrorCode.FRIEND_LIMIT_REACHED,
			);
		});
	});

	describe('acceptRequest', () => {
		it('refuses a request addressed to someone else', async () => {
			prisma.friendship.findFirst.mockResolvedValue({
				id: 'f1',
				requesterId: ME,
				receiverId: OTHER,
			});
			await expectErrorCode(
				service.acceptRequest(ME, 'f1'),
				ErrorCode.FRIEND_REQUEST_NOT_FOUND,
			);
		});

		it('accepts a request addressed to me', async () => {
			prisma.friendship.findFirst.mockResolvedValue({
				id: 'f1',
				requesterId: OTHER,
				receiverId: ME,
			});
			prisma.friendship.update.mockResolvedValue({
				id: 'f1',
				status: 'ACCEPTED',
			});
			await expect(service.acceptRequest(ME, 'f1')).resolves.toEqual({
				id: 'f1',
				status: 'ACCEPTED',
			});
		});
	});

	describe('deleteRequest', () => {
		it('lets the requester cancel', async () => {
			prisma.friendship.findFirst.mockResolvedValue({
				id: 'f1',
				requesterId: ME,
				receiverId: OTHER,
			});
			await service.deleteRequest(ME, 'f1');
			expect(prisma.friendship.delete).toHaveBeenCalledWith({
				where: { id: 'f1' },
			});
		});

		it('refuses a stranger', async () => {
			prisma.friendship.findFirst.mockResolvedValue({
				id: 'f1',
				requesterId: OTHER,
				receiverId: 'someone-else',
			});
			await expectErrorCode(
				service.deleteRequest(ME, 'f1'),
				ErrorCode.FRIEND_REQUEST_NOT_FOUND,
			);
		});
	});

	describe('removeFriend', () => {
		it('throws when not friends', async () => {
			prisma.friendship.deleteMany.mockResolvedValue({ count: 0 });
			await expectErrorCode(
				service.removeFriend(ME, OTHER),
				ErrorCode.NOT_FRIENDS,
			);
		});
	});

	describe('search', () => {
		it('maps each relation from the caller point of view', async () => {
			const users = ['a', 'b', 'c', 'd'].map((id) => ({
				id,
				username: id,
				avatarSlug: 'x',
				xp: 0,
			}));
			prisma.$queryRaw.mockResolvedValue(users);
			prisma.friendship.findMany.mockResolvedValue([
				{
					id: 'fb',
					pairKey: pairKey(ME, 'b'),
					status: 'ACCEPTED',
					requesterId: 'b',
				},
				{
					id: 'fc',
					pairKey: pairKey(ME, 'c'),
					status: 'PENDING',
					requesterId: ME,
				},
				{
					id: 'fd',
					pairKey: pairKey(ME, 'd'),
					status: 'PENDING',
					requesterId: 'd',
				},
			]);

			const results = await service.search(ME, 'ab');

			expect(results.map((r) => [r.user.id, r.relation, r.requestId])).toEqual([
				['a', 'none', undefined],
				['b', 'friends', undefined],
				['c', 'sent', 'fc'],
				['d', 'received', 'fd'],
			]);
			expect(results[0].user).not.toHaveProperty('xp');
		});

		it('excludes the caller and escapes LIKE wildcards', async () => {
			prisma.$queryRaw.mockResolvedValue([]);
			prisma.friendship.findMany.mockResolvedValue([]);

			await service.search(ME, '50%_off');

			// Tagged template : arguments = (fragments SQL, ...valeurs liées)
			const [, ...values] = prisma.$queryRaw.mock.calls[0];
			expect(values).toEqual([ME, '%50\\%\\_off%', 10]);
		});
	});

	describe('escapeLike', () => {
		it('escapes backslash, percent and underscore', () => {
			expect(escapeLike('a\\b%c_d')).toBe('a\\\\b\\%c\\_d');
		});
	});
});
