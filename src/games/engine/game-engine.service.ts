import { Injectable, Logger } from '@nestjs/common';
import { ErrorCode } from 'src/common/error-codes';
import { Difficulty } from 'src/generated/prisma/client';
import { XP_PER_DIFFICULTY } from 'src/quiz/constants/xp';
import { getProgression } from 'src/quiz/utils/progression.util';
import { toPublicUser } from 'src/users/utils/public-user';
import {
	ABANDON_MS,
	ANSWER_GRACE_MS,
	LOBBY_TIMEOUT_MS,
	MIN_PLAYERS_TO_START,
	QUESTION_MS,
	REVEAL_MS,
} from '../constants';
import { GameEmitter } from '../game-emitter.service';
import { FinishedPlayer, GamesService, LobbyExits } from '../games.service';
import {
	CancelReason,
	GameError,
	LiveGame,
	LivePlayer,
	LiveQuestion,
} from './live-game';
import { rankPlayers } from './ranking';

type LoadedQuestion = Awaited<
	ReturnType<GamesService['startGame']>
>['gameQuestions'][number];

/**
 * Maître du jeu : l'état des parties vit ici, en mémoire (une seule instance du
 * serveur). La base est mise à jour à chaque changement de statut, le moteur en
 * garde le miroir et prévient les clients via le GameEmitter.
 *
 * Règle pour les méthodes async : modifier l'état en mémoire (phase, Map) AVANT le
 * premier await, pour qu'un évènement arrivé pendant l'attente voie le nouvel état.
 * Après un await, vérifier que la partie est toujours là (`isLive`).
 */
@Injectable()
export class GameEngineService {
	private readonly logger = new Logger(GameEngineService.name);
	private readonly games = new Map<string, LiveGame>();

	constructor(
		private readonly gamesService: GamesService,
		private readonly emitter: GameEmitter,
	) {}

	// --- Appelé par le REST ---

	async createGame(
		hostId: string,
		friendIds: string[],
		difficulty?: Difficulty,
	) {
		const { gameId, ...exits } = await this.gamesService.createGame(
			hostId,
			friendIds,
			difficulty,
		);
		this.applyLobbyExits(hostId, exits);

		const game = await this.registerGame(gameId);
		const invitation = this.toInvitation(game);
		for (const player of game.players.values()) {
			if (player.status === 'INVITED') {
				this.emitter.toUser(player.user.id, 'invitation:received', invitation);
			}
		}

		return { gameId };
	}

	async declineInvitation(userId: string, gameId: string) {
		await this.gamesService.declineInvitation(userId, gameId);

		const game = this.games.get(gameId);
		const player = game?.players.get(userId);
		if (game && player) {
			player.status = 'DECLINED';
			this.broadcastLobby(game);
		}
	}

	// --- Appelé par le gateway ---

	/**
	 * Entrer dans la partie depuis un socket : accepter une invitation, revenir dans
	 * un salon quitté, rattacher un nouvel appareil (l'hôte), ou se reconnecter à une
	 * partie en cours — `state` décrit alors où elle en est.
	 */
	async join(userId: string, socketId: string, gameId: string) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);

		if (game.phase !== 'LOBBY') {
			// Partie lancée : seuls ceux qui y jouent encore peuvent revenir
			if (!player.playing || player.status !== 'JOINED') {
				throw new GameError(ErrorCode.GAME_ALREADY_STARTED);
			}
		} else if (player.status !== 'JOINED') {
			if (player.status === 'DECLINED') {
				throw new GameError(ErrorCode.INVITATION_NOT_FOUND);
			}
			const exits = await this.gamesService.joinLobby(userId, gameId);
			this.applyLobbyExits(userId, exits);
			// Le salon a pu être annulé (hôte parti, timeout…) ou lancé pendant l'attente
			if (!this.isLive(game)) {
				throw new GameError(ErrorCode.GAME_NOT_FOUND);
			}
			if (game.phase !== 'LOBBY') {
				await this.gamesService.leaveGame(userId, gameId);
				throw new GameError(ErrorCode.GAME_ALREADY_STARTED);
			}
			player.status = 'JOINED';
		}

		player.socketIds.add(socketId);
		clearTimeout(game.abandonTimer);
		game.abandonTimer = undefined;
		this.broadcastLobby(game);

		return {
			...this.toLobby(game),
			state: game.phase === 'LOBBY' ? null : this.toState(game, player),
		};
	}

	/**
	 * Quitter volontairement. Dans le salon, l'hôte qui part annule tout ; en cours
	 * de partie, c'est un abandon (0 XP) et la partie continue sans lui.
	 */
	async leave(userId: string, gameId: string) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);

		if (game.phase === 'LOBBY' && player.isHost) {
			await this.cancel(game, 'host_left');
			return;
		}
		// Un invité qui n'a jamais rejoint refuse via POST /games/:id/decline
		if (player.status !== 'JOINED') return;

		player.status = 'LEFT';
		player.socketIds.clear();
		this.emitter.removeUserFromGame(userId, gameId);
		this.broadcastLobby(game);

		const everyoneLeft =
			game.phase !== 'LOBBY' && this.activePlayers(game).length === 0;
		if (everyoneLeft) {
			this.close(game, 'all_left');
		} else {
			this.onPresenceChange(game);
		}

		await this.gamesService.leaveGame(userId, gameId);
		if (everyoneLeft) await this.gamesService.cancelGame(gameId);
	}

	/** Coupure réseau, app en arrière-plan… : le joueur reste dans la partie */
	disconnect(userId: string, socketId: string, gameId: string) {
		const game = this.games.get(gameId);
		const player = game?.players.get(userId);
		if (!game || !player?.socketIds.delete(socketId)) return;

		this.broadcastLobby(game);
		this.onPresenceChange(game);
	}

	/** L'hôte lance la partie, à partir de 2 joueurs dans le salon */
	async start(userId: string, gameId: string) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);
		if (!player.isHost) throw new GameError(ErrorCode.NOT_HOST);
		if (game.phase !== 'LOBBY') {
			throw new GameError(ErrorCode.GAME_ALREADY_STARTED);
		}

		const joined = [...game.players.values()].filter(
			(p) => p.status === 'JOINED',
		);
		if (joined.length < MIN_PLAYERS_TO_START) {
			throw new GameError(ErrorCode.NOT_ENOUGH_PLAYERS);
		}

		game.phase = 'STARTING';
		clearTimeout(game.lobbyTimer);
		for (const p of joined) p.playing = true;

		let loaded: Awaited<ReturnType<GamesService['startGame']>>;
		try {
			loaded = await this.gamesService.startGame(
				game.id,
				joined.map((p) => p.user.id),
			);
		} catch (err) {
			await this.cancel(game, 'server_error');
			throw err;
		}
		// Annulée pendant le chargement (tout le monde est parti)
		if (!this.isLive(game)) return;

		game.questions = loaded.gameQuestions.map(toLiveQuestion);
		for (const p of joined) {
			p.lang = loaded.langByUserId.get(p.user.id) ?? 'en';
		}

		// Les invitations restées sans réponse n'ont plus d'objet
		for (const p of game.players.values()) {
			if (p.status === 'INVITED') {
				this.emitter.toUser(p.user.id, 'invitation:canceled', {
					gameId: game.id,
				});
			}
		}

		this.broadcastLobby(game);
		this.nextQuestion(game);
	}

	/** Une seule réponse par question, tant que la question est ouverte */
	answer(
		userId: string,
		gameId: string,
		questionIndex: number,
		answerIndex: number,
	) {
		const game = this.requireGame(gameId);
		const player = this.requirePlayer(game, userId);
		const question = game.questions[game.questionIndex];

		const accepted =
			game.phase === 'QUESTION' &&
			questionIndex === game.questionIndex &&
			player.playing &&
			player.status === 'JOINED' &&
			!player.answers.has(questionIndex) &&
			Number.isInteger(answerIndex) &&
			answerIndex >= 0 &&
			answerIndex < question.en.answers.length;
		if (!accepted) throw new GameError(ErrorCode.ANSWER_REJECTED);

		const isCorrect = answerIndex === question.correctIndex;
		player.answers.set(questionIndex, {
			answerIndex,
			isCorrect,
			responseMs: Date.now() - game.questionStartedAt,
		});
		if (isCorrect) player.score += 1;

		// Qui a répondu, jamais quoi : la réponse ne se révèle qu'en fin de question
		this.emitter.toGame(game.id, 'player:answered', { gameId, userId });

		if (this.everyoneConnectedAnswered(game)) this.reveal(game);
	}

	// --- Déroulé de la partie ---

	private nextQuestion(game: LiveGame) {
		if (!this.isLive(game)) return;

		game.questionIndex += 1;
		if (game.questionIndex >= game.questions.length) {
			this.finish(game).catch((err) =>
				this.logger.error(`Fin de la partie ${game.id} échouée`, err),
			);
			return;
		}

		const now = Date.now();
		game.phase = 'QUESTION';
		game.questionStartedAt = now;
		game.phaseEndsAt = now + QUESTION_MS;

		// Chacun dans sa langue, d'où un envoi par joueur plutôt qu'à la room
		for (const p of this.activePlayers(game)) {
			this.emitter.toUser(p.user.id, 'question', this.toQuestion(game, p));
		}

		game.phaseTimer = setTimeout(
			() => this.reveal(game),
			QUESTION_MS + ANSWER_GRACE_MS,
		);
	}

	private reveal(game: LiveGame) {
		if (!this.isLive(game) || game.phase !== 'QUESTION') return;
		clearTimeout(game.phaseTimer);

		const index = game.questionIndex;
		game.phase = 'REVEAL';
		game.phaseEndsAt = Date.now() + REVEAL_MS;
		game.lastReveal = {
			gameId: game.id,
			index,
			correctIndex: game.questions[index].correctIndex,
			results: this.playingPlayers(game).map((p) => {
				const answer = p.answers.get(index);
				return {
					userId: p.user.id,
					answerIndex: answer?.answerIndex ?? null,
					isCorrect: answer?.isCorrect ?? false,
					responseMs: answer?.responseMs ?? null,
					score: p.score,
				};
			}),
		};
		this.emitter.toGame(game.id, 'reveal', game.lastReveal);

		game.phaseTimer = setTimeout(() => this.nextQuestion(game), REVEAL_MS);
	}

	private async finish(game: LiveGame) {
		game.phase = 'FINISHED';
		this.games.delete(game.id);
		this.clearTimers(game);

		const playing = this.playingPlayers(game);
		const results: FinishedPlayer[] = playing.map((p) => ({
			userId: p.user.id,
			gamePlayerId: p.gamePlayerId,
			score: p.score,
			// Abandon : 0 XP, mais ses réponses sont gardées
			xpEarned: p.status === 'JOINED' ? this.xpFor(game, p) : 0,
			answers: [...p.answers].map(([index, answer]) => ({
				gameQuestionId: game.questions[index].gameQuestionId,
				...answer,
			})),
		}));

		let xpBefore: Map<string, number>;
		try {
			xpBefore = await this.gamesService.finishGame(game.id, results);
		} catch (err) {
			this.logger.error(`Enregistrement de la partie ${game.id} échoué`, err);
			this.emitter.toGame(game.id, 'game:canceled', {
				gameId: game.id,
				reason: 'server_error',
			});
			this.emitter.closeGameRoom(game.id);
			await this.gamesService.cancelGame(game.id);
			return;
		}

		const ranking = rankPlayers(
			results.map((r) => {
				const player = game.players.get(r.userId) as LivePlayer;
				return {
					user: player.user,
					score: r.score,
					abandoned: player.status !== 'JOINED',
				};
			}),
		);

		// La progression (niveau, déblocages) est propre à chacun. Ceux qui ont
		// abandonné ont quitté l'écran de jeu : rien à leur envoyer.
		for (const r of results) {
			if (game.players.get(r.userId)?.status !== 'JOINED') continue;
			this.emitter.toUser(r.userId, 'game:end', {
				gameId: game.id,
				ranking,
				progression: getProgression(xpBefore.get(r.userId) ?? 0, r.xpEarned),
			});
		}
		this.emitter.closeGameRoom(game.id);
	}

	// --- Interne ---

	private async registerGame(gameId: string) {
		const row = await this.gamesService.getLobby(gameId);

		const players = new Map<string, LivePlayer>();
		let hostId = '';
		for (const p of row.players) {
			const user = toPublicUser(p.user);
			if (p.isHost) hostId = user.id;
			players.set(user.id, {
				gamePlayerId: p.id,
				user,
				isHost: p.isHost,
				status: p.status,
				socketIds: new Set(),
				playing: false,
				lang: 'en',
				score: 0,
				answers: new Map(),
			});
		}

		const game: LiveGame = {
			id: row.id,
			difficulty: row.difficulty,
			createdAt: row.createdAt,
			hostId,
			phase: 'LOBBY',
			players,
			questions: [],
			questionIndex: -1,
			questionStartedAt: 0,
			phaseEndsAt: 0,
			lastReveal: null,
		};
		game.lobbyTimer = setTimeout(() => {
			this.cancel(game, 'lobby_timeout').catch((err) =>
				this.logger.error(`Annulation du salon ${game.id} échouée`, err),
			);
		}, LOBBY_TIMEOUT_MS);

		this.games.set(game.id, game);
		return game;
	}

	/**
	 * Après une déconnexion ou un abandon en cours de partie :
	 * - le joueur parti ne doit plus bloquer le passage anticipé ;
	 * - si plus personne n'est connecté, on laisse 30 s avant d'annuler.
	 */
	private onPresenceChange(game: LiveGame) {
		if (!['STARTING', 'QUESTION', 'REVEAL'].includes(game.phase)) return;

		if (game.phase === 'QUESTION' && this.everyoneConnectedAnswered(game)) {
			this.reveal(game);
		}

		const anyoneConnected = this.activePlayers(game).some(
			(p) => p.socketIds.size > 0,
		);
		if (!anyoneConnected && !game.abandonTimer) {
			game.abandonTimer = setTimeout(() => {
				this.cancel(game, 'all_disconnected').catch((err) =>
					this.logger.error(`Annulation de la partie ${game.id} échouée`, err),
				);
			}, ABANDON_MS);
		}
	}

	private async cancel(game: LiveGame, reason: CancelReason) {
		this.close(game, reason);
		await this.gamesService.cancelGame(game.id);
	}

	/** Retire la partie de la mémoire et prévient tout le monde (la base est à jour) */
	private close(game: LiveGame, reason: CancelReason) {
		if (!this.isLive(game)) return;
		this.games.delete(game.id);
		this.clearTimers(game);

		this.emitter.toGame(game.id, 'game:canceled', { gameId: game.id, reason });
		// Avant le lancement, les invitations sont encore affichées chez les invités
		if (game.phase === 'LOBBY' || game.phase === 'STARTING') {
			for (const player of game.players.values()) {
				if (player.status === 'INVITED') {
					this.emitter.toUser(player.user.id, 'invitation:canceled', {
						gameId: game.id,
					});
				}
			}
		}
		this.emitter.closeGameRoom(game.id);
	}

	private clearTimers(game: LiveGame) {
		clearTimeout(game.lobbyTimer);
		clearTimeout(game.phaseTimer);
		clearTimeout(game.abandonTimer);
	}

	/** Répercute en mémoire les salons quittés en base par GamesService */
	private applyLobbyExits(userId: string, exits: LobbyExits) {
		for (const gameId of exits.canceledGameIds) {
			const game = this.games.get(gameId);
			if (game) this.close(game, 'host_left');
		}
		for (const gameId of exits.leftGameIds) {
			const game = this.games.get(gameId);
			const player = game?.players.get(userId);
			if (!game || !player) continue;
			player.status = 'LEFT';
			player.socketIds.clear();
			this.emitter.removeUserFromGame(userId, gameId);
			this.broadcastLobby(game);
		}
	}

	private isLive(game: LiveGame) {
		return this.games.get(game.id) === game;
	}

	private requireGame(gameId: string) {
		const game = this.games.get(gameId);
		// Inconnue en mémoire : annulée, terminée, ou tuée par un redéploiement
		if (!game) throw new GameError(ErrorCode.GAME_NOT_FOUND);
		return game;
	}

	private requirePlayer(game: LiveGame, userId: string) {
		const player = game.players.get(userId);
		if (!player) throw new GameError(ErrorCode.NOT_A_PLAYER);
		return player;
	}

	/** Dans le classement : JOINED au lancement, même s'ils ont abandonné depuis */
	private playingPlayers(game: LiveGame) {
		return [...game.players.values()].filter((p) => p.playing);
	}

	/** Encore en jeu : reçoivent les questions et peuvent répondre */
	private activePlayers(game: LiveGame) {
		return this.playingPlayers(game).filter((p) => p.status === 'JOINED');
	}

	/** Les déconnectés ne bloquent pas : on n'attend que ceux qui sont là */
	private everyoneConnectedAnswered(game: LiveGame) {
		const connected = this.activePlayers(game).filter(
			(p) => p.socketIds.size > 0,
		);
		return (
			connected.length > 0 &&
			connected.every((p) => p.answers.has(game.questionIndex))
		);
	}

	private xpFor(game: LiveGame, player: LivePlayer) {
		let xp = 0;
		for (const [index, answer] of player.answers) {
			if (!answer.isCorrect) continue;
			const difficulty = game.questions[index].difficulty.toLowerCase();
			xp += XP_PER_DIFFICULTY[difficulty as Difficulty];
		}
		return xp;
	}

	private broadcastLobby(game: LiveGame) {
		this.emitter.toGame(game.id, 'lobby:update', this.toLobby(game));
	}

	private toLobby(game: LiveGame) {
		return {
			gameId: game.id,
			hostId: game.hostId,
			difficulty: game.difficulty,
			phase: game.phase,
			players: [...game.players.values()].map((p) => ({
				user: p.user,
				isHost: p.isHost,
				status: p.status,
				connected: p.socketIds.size > 0,
			})),
		};
	}

	/** Sans `correctIndex` : la bonne réponse n'est envoyée qu'à la révélation */
	private toQuestion(game: LiveGame, player: LivePlayer) {
		const question = game.questions[game.questionIndex];
		const text =
			player.lang === 'fr' && question.fr ? question.fr : question.en;
		return {
			gameId: game.id,
			index: game.questionIndex,
			total: game.questions.length,
			question: text.question,
			answers: text.answers,
			category: question.category,
			difficulty: question.difficulty,
			// Durée restante plutôt qu'une heure absolue : les horloges des téléphones
			// ne sont pas synchronisées avec celle du serveur
			remainingMs: Math.max(0, game.phaseEndsAt - Date.now()),
		};
	}

	/** Où en est la partie, pour un joueur qui se reconnecte */
	private toState(game: LiveGame, player: LivePlayer) {
		const index = game.questionIndex;
		return {
			phase: game.phase,
			questionIndex: index,
			total: game.questions.length,
			question:
				game.phase === 'QUESTION' ? this.toQuestion(game, player) : null,
			myAnswerIndex: player.answers.get(index)?.answerIndex ?? null,
			answeredUserIds:
				game.phase === 'QUESTION'
					? this.playingPlayers(game)
							.filter((p) => p.answers.has(index))
							.map((p) => p.user.id)
					: [],
			reveal: game.phase === 'REVEAL' ? game.lastReveal : null,
			remainingMs: Math.max(0, game.phaseEndsAt - Date.now()),
			scores: this.playingPlayers(game).map((p) => ({
				userId: p.user.id,
				score: p.score,
			})),
		};
	}

	/** Même forme que GET /games/invitations */
	private toInvitation(game: LiveGame) {
		const players = [...game.players.values()];
		return {
			gameId: game.id,
			difficulty: game.difficulty,
			createdAt: game.createdAt,
			host: game.players.get(game.hostId)?.user,
			playerCount: players.filter(
				(p) => p.status === 'INVITED' || p.status === 'JOINED',
			).length,
		};
	}
}

function toLiveQuestion({ id, question: q }: LoadedQuestion): LiveQuestion {
	return {
		gameQuestionId: id,
		category: q.category,
		difficulty: q.difficulty,
		correctIndex: q.correctIndex,
		en: { question: q.questionEn, answers: q.answersEn as string[] },
		fr:
			q.questionFr && q.answersFr
				? { question: q.questionFr, answers: q.answersFr as string[] }
				: null,
	};
}
