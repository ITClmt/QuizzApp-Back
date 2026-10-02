import { LOBBY_TIMEOUT_MS } from '../constants';
import { GameEmitter } from '../game-emitter.service';
import { GamesService } from '../games.service';
import { GameEngineService } from './game-engine.service';
import { GameError } from './live-game';

const user = (id: string) => ({ id, username: id, avatarSlug: 'a', xp: 0 });

const lobbyRow = {
	id: 'g1',
	difficulty: null,
	createdAt: new Date('2026-10-02T10:00:00Z'),
	players: [
		{ isHost: true, status: 'JOINED', user: user('host') },
		{ isHost: false, status: 'INVITED', user: user('bob') },
		{ isHost: false, status: 'INVITED', user: user('eve') },
	],
};

describe('GameEngineService (salon)', () => {
	let gamesService: Record<string, jest.Mock>;
	let emitter: Record<string, jest.Mock>;
	let engine: GameEngineService;

	/** Évènements émis, sous forme [cible, évènement] */
	const emitted = () => [
		...emitter.toUser.mock.calls.map(([to, event]) => [`user:${to}`, event]),
		...emitter.toGame.mock.calls.map(([to, event]) => [`game:${to}`, event]),
	];
	const lastLobby = () =>
		emitter.toGame.mock.calls
			.filter(([, e]) => e === 'lobby:update')
			.at(-1)?.[2];

	beforeEach(async () => {
		jest.useFakeTimers();
		gamesService = {
			createGame: jest.fn().mockResolvedValue({
				gameId: 'g1',
				canceledGameIds: [],
				leftGameIds: [],
			}),
			getLobby: jest.fn().mockResolvedValue(structuredClone(lobbyRow)),
			declineInvitation: jest.fn(),
			joinLobby: jest
				.fn()
				.mockResolvedValue({ canceledGameIds: [], leftGameIds: [] }),
			leaveGame: jest.fn(),
			cancelGame: jest.fn(),
		};
		emitter = {
			toUser: jest.fn(),
			toGame: jest.fn(),
			removeUserFromGame: jest.fn(),
			closeGameRoom: jest.fn(),
		};
		engine = new GameEngineService(
			gamesService as unknown as GamesService,
			emitter as unknown as GameEmitter,
		);

		await engine.createGame('host', ['bob', 'eve']);
		jest.clearAllMocks();
	});

	afterEach(() => jest.useRealTimers());

	it('envoie une invitation en direct à chaque invité', async () => {
		gamesService.getLobby.mockResolvedValue({
			...structuredClone(lobbyRow),
			id: 'g2',
		});
		gamesService.createGame.mockResolvedValue({
			gameId: 'g2',
			canceledGameIds: [],
			leftGameIds: [],
		});

		await engine.createGame('host', ['bob', 'eve']);

		expect(emitter.toUser).toHaveBeenCalledWith(
			'bob',
			'invitation:received',
			expect.objectContaining({
				gameId: 'g2',
				host: { id: 'host', username: 'host', avatarSlug: 'a', level: 0 },
				playerCount: 3,
			}),
		);
		expect(emitter.toUser).toHaveBeenCalledWith(
			'eve',
			'invitation:received',
			expect.anything(),
		);
		expect(emitter.toUser).not.toHaveBeenCalledWith(
			'host',
			'invitation:received',
			expect.anything(),
		);
	});

	it("créer une nouvelle partie annule en direct l'ancien salon de l'hôte", async () => {
		gamesService.getLobby.mockResolvedValue({
			...structuredClone(lobbyRow),
			id: 'g2',
		});
		gamesService.createGame.mockResolvedValue({
			gameId: 'g2',
			canceledGameIds: ['g1'],
			leftGameIds: [],
		});

		await engine.createGame('host', ['bob']);

		expect(emitter.toGame).toHaveBeenCalledWith('g1', 'game:canceled', {
			gameId: 'g1',
			reason: 'host_left',
		});
		expect(emitter.toUser).toHaveBeenCalledWith('bob', 'invitation:canceled', {
			gameId: 'g1',
		});
		await expect(engine.join('bob', 's1', 'g1')).rejects.toEqual(
			new GameError('GAME_NOT_FOUND'),
		);
	});

	describe('join', () => {
		it('un invité qui rejoint passe JOINED et connecté', async () => {
			const lobby = await engine.join('bob', 's-bob', 'g1');

			expect(gamesService.joinLobby).toHaveBeenCalledWith('bob', 'g1');
			expect(lobby.players.find((p) => p.user.id === 'bob')).toMatchObject({
				status: 'JOINED',
				connected: true,
			});
			expect(lastLobby()).toEqual(lobby);
		});

		it("l'hôte rattache son socket sans repasser par la base", async () => {
			await engine.join('host', 's-host', 'g1');

			expect(gamesService.joinLobby).not.toHaveBeenCalled();
		});

		it('refuse une partie inconnue (annulée, redéploiement…)', async () => {
			await expect(engine.join('bob', 's1', 'nope')).rejects.toEqual(
				new GameError('GAME_NOT_FOUND'),
			);
		});

		it("refuse quelqu'un qui n'est pas dans la partie", async () => {
			await expect(engine.join('mallory', 's1', 'g1')).rejects.toEqual(
				new GameError('NOT_A_PLAYER'),
			);
		});

		it('refuse un invité qui a décliné', async () => {
			await engine.declineInvitation('bob', 'g1');

			await expect(engine.join('bob', 's1', 'g1')).rejects.toEqual(
				new GameError('INVITATION_NOT_FOUND'),
			);
		});

		it('échoue si le salon a été annulé pendant la requête en base', async () => {
			gamesService.joinLobby.mockImplementation(async () => {
				await engine.leave('host', 'g1');
				return { canceledGameIds: [], leftGameIds: [] };
			});

			await expect(engine.join('bob', 's1', 'g1')).rejects.toEqual(
				new GameError('GAME_NOT_FOUND'),
			);
		});
	});

	describe('leave', () => {
		it("l'hôte qui quitte annule le salon et prévient les invités restants", async () => {
			await engine.join('bob', 's-bob', 'g1');
			jest.clearAllMocks();

			await engine.leave('host', 'g1');

			expect(gamesService.cancelGame).toHaveBeenCalledWith('g1');
			expect(emitted()).toEqual(
				expect.arrayContaining([
					['game:g1', 'game:canceled'],
					['user:eve', 'invitation:canceled'],
				]),
			);
			// bob avait rejoint : il reçoit game:canceled via la room, pas d'invitation:canceled
			expect(emitted()).not.toContainEqual(['user:bob', 'invitation:canceled']);
			expect(emitter.closeGameRoom).toHaveBeenCalledWith('g1');
		});

		it('un invité qui quitte passe LEFT et peut revenir', async () => {
			await engine.join('bob', 's-bob', 'g1');

			await engine.leave('bob', 'g1');

			expect(gamesService.leaveGame).toHaveBeenCalledWith('bob', 'g1');
			expect(emitter.removeUserFromGame).toHaveBeenCalledWith('bob', 'g1');
			expect(
				lastLobby().players.find((p) => p.user.id === 'bob'),
			).toMatchObject({
				status: 'LEFT',
				connected: false,
			});

			const lobby = await engine.join('bob', 's-bob-2', 'g1');
			expect(lobby.players.find((p) => p.user.id === 'bob')?.status).toBe(
				'JOINED',
			);
		});
	});

	it('rejoindre un autre salon fait quitter le précédent en direct', async () => {
		await engine.join('bob', 's-bob', 'g1');
		gamesService.getLobby.mockResolvedValue({
			...structuredClone(lobbyRow),
			id: 'g2',
			players: [
				{ isHost: true, status: 'JOINED', user: user('eve') },
				{ isHost: false, status: 'INVITED', user: user('bob') },
			],
		});
		gamesService.createGame.mockResolvedValue({
			gameId: 'g2',
			canceledGameIds: [],
			leftGameIds: [],
		});
		await engine.createGame('eve', ['bob']);
		gamesService.joinLobby.mockResolvedValue({
			canceledGameIds: [],
			leftGameIds: ['g1'],
		});
		emitter.toGame.mockClear();

		await engine.join('bob', 's-bob', 'g2');

		const g1Lobby = emitter.toGame.mock.calls.find(
			([to, e]) => to === 'g1' && e === 'lobby:update',
		)?.[2];
		expect(g1Lobby.players.find((p) => p.user.id === 'bob').status).toBe(
			'LEFT',
		);
	});

	it('une déconnexion garde le joueur mais le marque déconnecté', async () => {
		await engine.join('bob', 's-bob', 'g1');

		engine.disconnect('bob', 's-bob', 'g1');

		expect(lastLobby().players.find((p) => p.user.id === 'bob')).toMatchObject({
			status: 'JOINED',
			connected: false,
		});
	});

	it('reste connecté tant qu’un des appareils du joueur l’est', async () => {
		await engine.join('bob', 's-phone', 'g1');
		await engine.join('bob', 's-web', 'g1');

		engine.disconnect('bob', 's-phone', 'g1');

		expect(lastLobby().players.find((p) => p.user.id === 'bob').connected).toBe(
			true,
		);
	});

	it('annule le salon au bout de 10 min', async () => {
		jest.advanceTimersByTime(LOBBY_TIMEOUT_MS - 1);
		expect(gamesService.cancelGame).not.toHaveBeenCalled();

		jest.advanceTimersByTime(1);

		expect(gamesService.cancelGame).toHaveBeenCalledWith('g1');
		expect(emitter.toGame).toHaveBeenCalledWith('g1', 'game:canceled', {
			gameId: 'g1',
			reason: 'lobby_timeout',
		});
	});

	it("un salon annulé n'expire pas une seconde fois", async () => {
		await engine.leave('host', 'g1');
		gamesService.cancelGame.mockClear();

		jest.advanceTimersByTime(LOBBY_TIMEOUT_MS);

		expect(gamesService.cancelGame).not.toHaveBeenCalled();
	});
});
