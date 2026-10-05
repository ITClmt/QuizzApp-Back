import {
	ABANDON_MS,
	ANSWER_GRACE_MS,
	QUESTION_MS,
	REVEAL_MS,
} from '../constants';
import { GameEmitter } from '../game-emitter.service';
import { GamesService } from '../games.service';
import { GameEngineService } from './game-engine.service';
import { GameError } from './live-game';

const user = (id: string) => ({ id, username: id, avatarSlug: 'a', xp: 0 });

const question = (id: string, difficulty: string, withFr = false) => ({
	id: `gq-${id}`,
	question: {
		category: 'History',
		difficulty,
		correctIndex: 0,
		questionEn: `${id} en`,
		answersEn: ['right', 'w1', 'w2', 'w3'],
		questionFr: withFr ? `${id} fr` : null,
		answersFr: withFr ? ['juste', 'f1', 'f2', 'f3'] : null,
	},
});

/** 3 questions (facile, moyenne, difficile) suffisent pour dérouler toute une partie */
const QUESTIONS = [
	question('q0', 'easy', true),
	question('q1', 'medium'),
	question('q2', 'hard'),
];

/** Laisse s'exécuter les promesses en attente (fin de partie déclenchée par un timer) */
const flush = async () => {
	for (let i = 0; i < 10; i++) await Promise.resolve();
};

describe('GameEngineService (partie)', () => {
	let gamesService: Record<string, jest.Mock>;
	let emitter: Record<string, jest.Mock>;
	let engine: GameEngineService;

	const sent = (event: string) =>
		[...emitter.toUser.mock.calls, ...emitter.toGame.mock.calls].filter(
			([, e]) => e === event,
		);
	const sentTo = (userId: string, event: string) =>
		emitter.toUser.mock.calls
			.filter(([to, e]) => to === userId && e === event)
			.map(([, , payload]) => payload);
	const lastReveal = () => sent('reveal').at(-1)?.[2];
	const answer = (userId: string, questionIndex: number, answerIndex: number) =>
		engine.answer(userId, 'g1', questionIndex, answerIndex);

	beforeEach(async () => {
		jest.useFakeTimers();
		gamesService = {
			createGame: jest.fn().mockResolvedValue({
				gameId: 'g1',
				canceledGameIds: [],
				leftGameIds: [],
			}),
			getLobby: jest.fn().mockResolvedValue({
				id: 'g1',
				difficulty: null,
				createdAt: new Date(),
				players: [
					{ id: 'gp-host', isHost: true, status: 'JOINED', user: user('host') },
					{ id: 'gp-bob', isHost: false, status: 'INVITED', user: user('bob') },
					{ id: 'gp-eve', isHost: false, status: 'INVITED', user: user('eve') },
				],
			}),
			joinLobby: jest
				.fn()
				.mockResolvedValue({ canceledGameIds: [], leftGameIds: [] }),
			startGame: jest.fn().mockResolvedValue({
				gameQuestions: QUESTIONS,
				langByUserId: new Map([
					['host', 'en'],
					['bob', 'fr'],
				]),
			}),
			finishGame: jest.fn().mockResolvedValue(
				new Map([
					['host', 0],
					['bob', 0],
				]),
			),
			leaveGame: jest.fn(),
			cancelGame: jest.fn(),
			declineInvitation: jest.fn(),
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

		// Salon : l'hôte et bob ont rejoint, eve n'a jamais répondu à l'invitation
		await engine.createGame('host', ['bob', 'eve']);
		await engine.join('host', 's-host', 'g1');
		await engine.join('bob', 's-bob', 'g1');
		jest.clearAllMocks();
	});

	afterEach(() => jest.useRealTimers());

	describe('lancement', () => {
		it("seul l'hôte peut lancer", async () => {
			await expect(engine.start('bob', 'g1')).rejects.toEqual(
				new GameError('NOT_HOST'),
			);
		});

		it('il faut au moins 2 joueurs dans le salon', async () => {
			await engine.leave('bob', 'g1');

			await expect(engine.start('host', 'g1')).rejects.toEqual(
				new GameError('NOT_ENOUGH_PLAYERS'),
			);
		});

		it('un second lancement est refusé', async () => {
			await engine.start('host', 'g1');

			await expect(engine.start('host', 'g1')).rejects.toEqual(
				new GameError('GAME_ALREADY_STARTED'),
			);
		});

		it('envoie la 1re question à chacun dans sa langue, sans la bonne réponse', async () => {
			await engine.start('host', 'g1');

			expect(gamesService.startGame).toHaveBeenCalledWith('g1', [
				'host',
				'bob',
			]);
			const [toHost] = sentTo('host', 'question');
			const [toBob] = sentTo('bob', 'question');
			expect(toHost).toMatchObject({
				index: 0,
				total: 3,
				question: 'q0 en',
				answers: ['right', 'w1', 'w2', 'w3'],
				remainingMs: QUESTION_MS,
			});
			expect(toBob).toMatchObject({
				question: 'q0 fr',
				answers: ['juste', 'f1', 'f2', 'f3'],
			});
			expect(toHost).not.toHaveProperty('correctIndex');
			expect(sentTo('eve', 'question')).toEqual([]);
		});

		it("annule l'invitation de ceux qui n'ont pas rejoint", async () => {
			await engine.start('host', 'g1');

			expect(sentTo('eve', 'invitation:canceled')).toEqual([{ gameId: 'g1' }]);
		});

		it("annule aussi l'invitation d'un invité parti du salon avant le lancement", async () => {
			await engine.join('eve', 's-eve', 'g1');
			await engine.leave('eve', 'g1');

			await engine.start('host', 'g1');

			expect(sentTo('eve', 'invitation:canceled')).toEqual([{ gameId: 'g1' }]);
		});

		it('un invité ne peut plus rejoindre une partie lancée', async () => {
			await engine.start('host', 'g1');

			await expect(engine.join('eve', 's-eve', 'g1')).rejects.toEqual(
				new GameError('GAME_ALREADY_STARTED'),
			);
		});
	});

	describe('questions et réponses', () => {
		beforeEach(async () => {
			await engine.start('host', 'g1');
			jest.clearAllMocks();
		});

		it('annonce qui a répondu, jamais quoi', () => {
			answer('host', 0, 2);

			expect(sent('player:answered')).toEqual([
				['g1', 'player:answered', { gameId: 'g1', userId: 'host' }],
			]);
		});

		it('passe à la révélation dès que tous les joueurs connectés ont répondu', () => {
			answer('host', 0, 0);
			expect(lastReveal()).toBeUndefined();

			answer('bob', 0, 3);

			expect(lastReveal()).toMatchObject({
				index: 0,
				correctIndex: 0,
				results: [
					{ userId: 'host', answerIndex: 0, isCorrect: true, score: 1 },
					{ userId: 'bob', answerIndex: 3, isCorrect: false, score: 0 },
				],
			});
		});

		it('sans réponse, révèle après la durée de la question + la marge de latence', () => {
			jest.advanceTimersByTime(QUESTION_MS);
			expect(lastReveal()).toBeUndefined();

			jest.advanceTimersByTime(ANSWER_GRACE_MS);

			expect(lastReveal()).toMatchObject({
				results: [
					{ userId: 'host', answerIndex: null, isCorrect: false },
					{ userId: 'bob', answerIndex: null, isCorrect: false },
				],
			});
		});

		it('accepte une réponse arrivée dans la marge, avec son temps mesuré côté serveur', () => {
			jest.advanceTimersByTime(QUESTION_MS + 200);
			answer('host', 0, 0);
			answer('bob', 0, 0);

			expect(lastReveal().results[0]).toMatchObject({
				isCorrect: true,
				responseMs: QUESTION_MS + 200,
			});
		});

		it('refuse une deuxième réponse, une mauvaise question ou un index hors bornes', () => {
			answer('host', 0, 1);

			expect(() => answer('host', 0, 0)).toThrow(
				new GameError('ANSWER_REJECTED'),
			);
			expect(() => answer('bob', 1, 0)).toThrow(
				new GameError('ANSWER_REJECTED'),
			);
			expect(() => answer('bob', 0, 4)).toThrow(
				new GameError('ANSWER_REJECTED'),
			);
		});

		it('refuse une réponse pendant la révélation', () => {
			jest.advanceTimersByTime(QUESTION_MS + ANSWER_GRACE_MS);

			expect(() => answer('host', 0, 0)).toThrow(
				new GameError('ANSWER_REJECTED'),
			);
		});

		it('enchaîne sur la question suivante 3 s après la révélation', () => {
			answer('host', 0, 0);
			answer('bob', 0, 0);

			jest.advanceTimersByTime(REVEAL_MS - 1);
			expect(sentTo('host', 'question')).toEqual([]);

			jest.advanceTimersByTime(1);
			expect(sentTo('host', 'question')).toEqual([
				expect.objectContaining({ index: 1, question: 'q1 en' }),
			]);
		});
	});

	describe('fin de partie', () => {
		beforeEach(async () => {
			await engine.start('host', 'g1');
		});

		/**
		 * Joue les questions à partir de `from`, une ligne de réponses par question.
		 * Si tout le monde a répondu, la révélation est déjà partie : on n'attend le
		 * timeout de la question que dans le cas contraire.
		 */
		const play = async (rounds: Record<string, number>[], from = 0) => {
			rounds.forEach((round, i) => {
				const index = from + i;
				for (const [userId, answerIndex] of Object.entries(round)) {
					answer(userId, index, answerIndex);
				}
				if (lastReveal()?.index !== index) {
					jest.advanceTimersByTime(QUESTION_MS + ANSWER_GRACE_MS);
				}
				jest.advanceTimersByTime(REVEAL_MS);
			});
			await flush();
		};

		it('enregistre scores, XP et réponses, puis envoie le classement et la progression', async () => {
			// host : 0 → juste (easy 7), 1 → faux, 2 → juste (hard 28) ; bob : seulement la 2 (medium 14)
			await play([{ host: 0, bob: 1 }, { host: 3, bob: 0 }, { host: 0 }]);

			const [gameId, results] = gamesService.finishGame.mock.calls[0];
			expect(gameId).toBe('g1');
			expect(results).toEqual([
				expect.objectContaining({
					userId: 'host',
					gamePlayerId: 'gp-host',
					score: 2,
					xpEarned: 35,
					pointsByDifficulty: { easy: 1, hard: 1 },
				}),
				expect.objectContaining({
					userId: 'bob',
					gamePlayerId: 'gp-bob',
					score: 1,
					xpEarned: 14,
					pointsByDifficulty: { medium: 1 },
				}),
			]);
			expect(results[0].answers).toHaveLength(3);
			expect(results[1].answers).toEqual([
				expect.objectContaining({
					gameQuestionId: 'gq-q0',
					answerIndex: 1,
					isCorrect: false,
				}),
				expect.objectContaining({
					gameQuestionId: 'gq-q1',
					answerIndex: 0,
					isCorrect: true,
				}),
			]);

			const [end] = sentTo('host', 'game:end');
			expect(end.ranking.map((r) => [r.user.id, r.rank, r.isWinner])).toEqual([
				['host', 1, true],
				['bob', 2, false],
			]);
			expect(end.progression).toMatchObject({ xpEarned: 35 });
			expect(sentTo('bob', 'game:end')[0].progression).toMatchObject({
				xpEarned: 14,
			});
			expect(emitter.closeGameRoom).toHaveBeenCalledWith('g1');
		});

		it('égalité : deux gagnants', async () => {
			await play([{ host: 0, bob: 0 }, {}, {}]);

			const [end] = sentTo('host', 'game:end');
			expect(end.ranking.map((r) => [r.rank, r.isWinner])).toEqual([
				[1, true],
				[1, true],
			]);
		});

		it("un abandon : 0 XP, classé à la fin, et la partie continue pour l'autre", async () => {
			answer('bob', 0, 0);
			await engine.leave('bob', 'g1');
			jest.clearAllMocks();

			// Seul en jeu, l'hôte avance dès qu'il répond
			await play([{ host: 0 }, { host: 0 }, { host: 0 }]);

			const results = gamesService.finishGame.mock.calls[0][1];
			expect(results.find((r) => r.userId === 'bob')).toMatchObject({
				score: 1,
				xpEarned: 0,
				// Sa bonne réponse reste enregistrée, mais ne rapporte rien
				pointsByDifficulty: {},
			});
			const [end] = sentTo('host', 'game:end');
			expect(end.ranking.at(-1)).toMatchObject({
				user: expect.objectContaining({ id: 'bob' }),
				abandoned: true,
				rank: null,
			});
			expect(sentTo('bob', 'game:end')).toEqual([]);
		});

		it('si tout le monde abandonne, la partie est annulée', async () => {
			await engine.leave('bob', 'g1');
			await engine.leave('host', 'g1');

			expect(gamesService.cancelGame).toHaveBeenCalledWith('g1');
			expect(sent('game:canceled').at(-1)?.[2]).toEqual({
				gameId: 'g1',
				reason: 'all_left',
			});
		});
	});

	describe('déconnexions', () => {
		beforeEach(async () => {
			await engine.start('host', 'g1');
			jest.clearAllMocks();
		});

		it('un joueur déconnecté ne bloque pas le passage anticipé', () => {
			engine.disconnect('bob', 's-bob', 'g1');

			answer('host', 0, 0);

			expect(lastReveal()).toBeDefined();
		});

		it('se déconnecter quand les autres ont déjà répondu déclenche la révélation', () => {
			answer('host', 0, 0);
			expect(lastReveal()).toBeUndefined();

			engine.disconnect('bob', 's-bob', 'g1');

			expect(lastReveal()).toBeDefined();
		});

		it("à la reconnexion, renvoie l'état de la partie", async () => {
			answer('host', 0, 2);
			engine.disconnect('bob', 's-bob', 'g1');
			jest.clearAllMocks();
			// La révélation est passée (l'hôte était seul connecté), on attend 1 s dedans
			jest.advanceTimersByTime(1_000);

			const { state } = await engine.join('bob', 's-bob-2', 'g1');

			expect(state).toMatchObject({
				phase: 'REVEAL',
				questionIndex: 0,
				total: 3,
				// La question reste fournie : l'écran affiche la révélation dessus
				question: expect.objectContaining({ index: 0, question: 'q0 fr' }),
				remainingMs: REVEAL_MS - 1_000,
				reveal: expect.objectContaining({ correctIndex: 0 }),
				scores: [
					{ userId: 'host', score: 0 },
					{ userId: 'bob', score: 0 },
				],
			});
		});

		it('reconnexion pendant une question : la question dans sa langue et le temps restant', async () => {
			engine.disconnect('bob', 's-bob', 'g1');
			jest.advanceTimersByTime(4_000);

			const { state } = await engine.join('bob', 's-bob-2', 'g1');

			expect(state?.question).toMatchObject({
				question: 'q0 fr',
				remainingMs: QUESTION_MS - 4_000,
			});
		});

		it('tout le monde déconnecté pendant 30 s : partie annulée', () => {
			engine.disconnect('bob', 's-bob', 'g1');
			engine.disconnect('host', 's-host', 'g1');

			jest.advanceTimersByTime(ABANDON_MS - 1);
			expect(gamesService.cancelGame).not.toHaveBeenCalled();
			jest.advanceTimersByTime(1);

			expect(gamesService.cancelGame).toHaveBeenCalledWith('g1');
			expect(sent('game:canceled').at(-1)?.[2]).toEqual({
				gameId: 'g1',
				reason: 'all_disconnected',
			});
		});

		it("revenir avant 30 s désarme l'annulation", async () => {
			engine.disconnect('bob', 's-bob', 'g1');
			engine.disconnect('host', 's-host', 'g1');
			jest.advanceTimersByTime(ABANDON_MS - 1_000);

			await engine.join('host', 's-host-2', 'g1');
			jest.advanceTimersByTime(ABANDON_MS);

			expect(sent('game:canceled')).toEqual([]);
		});
	});
});
