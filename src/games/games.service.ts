import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
  OnApplicationBootstrap,
} from "@nestjs/common";
import { ErrorCode, errorBody } from "src/common/error-codes";
import { FriendsService } from "src/friends/friends.service";
import { Difficulty, Prisma } from "src/generated/prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import { QuizService } from "src/quiz/quiz.service";
import { ScoreService } from "src/score/score.service";
import { publicUserSelect, toPublicUser } from "src/users/utils/public-user";
import { GAME_QUESTIONS, LOBBY_TIMEOUT_MS } from "./constants";

/** Salons quittés au passage, pour que le moteur prévienne leurs autres joueurs */
export type LobbyExits = { canceledGameIds: string[]; leftGameIds: string[] };

export type FinishedPlayer = {
  userId: string;
  gamePlayerId: string;
  score: number;
  xpEarned: number;
  /** Bonnes réponses par difficulté de question : alimente Score, comme en solo */
  pointsByDifficulty: Partial<Record<Difficulty, number>>;
  answers: {
    gameQuestionId: string;
    answerIndex: number;
    isCorrect: boolean;
    responseMs: number;
  }[];
};

@Injectable()
export class GamesService implements OnApplicationBootstrap {
  private readonly logger = new Logger(GamesService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly friendsService: FriendsService,
    private readonly quizService: QuizService,
    private readonly scoreService: ScoreService,
  ) {}

  /**
   * L'état des parties en cours ne vit qu'en mémoire : un redémarrage (chaque push
   * sur main redéploie) les tue toutes. On les passe en CANCELED pour qu'aucune ne
   * reste bloquée en WAITING/PLAYING, ce qui empêcherait ses joueurs d'en relancer.
   */
  async onApplicationBootstrap() {
    const { count } = await this.prisma.game.updateMany({
      where: { status: { in: ["WAITING", "PLAYING"] } },
      data: { status: "CANCELED" },
    });
    if (count > 0) {
      this.logger.warn(`${count} partie(s) interrompue(s) par le redémarrage`);
    }
  }

  async createGame(
    hostId: string,
    friendIds: string[],
    difficulty?: Difficulty,
  ) {
    await this.assertNotPlaying(hostId);
    await this.friendsService.assertAllFriends(hostId, friendIds);

    const questions = await this.quizService.pickRandomQuestions({
      difficulty,
      count: GAME_QUESTIONS,
    });

    return this.prisma.$transaction(async (tx) => {
      const exits = await this.leaveWaitingLobbies(tx, hostId);

      const game = await tx.game.create({
        data: {
          difficulty: difficulty ?? null,
          players: {
            create: [
              { userId: hostId, isHost: true, status: "JOINED" },
              ...friendIds.map((userId) => ({ userId })),
            ],
          },
          gameQuestions: {
            create: questions.map((q, order) => ({ questionId: q.id, order })),
          },
        },
        select: { id: true },
      });

      return { gameId: game.id, ...exits };
    });
  }

  /** Accepte une invitation, ou revient dans un salon quitté avant le lancement */
  async joinLobby(userId: string, gameId: string): Promise<LobbyExits> {
    await this.assertNotPlaying(userId);

    return this.prisma.$transaction(async (tx) => {
      const exits = await this.leaveWaitingLobbies(tx, userId, gameId);

      const { count } = await tx.gamePlayer.updateMany({
        where: {
          gameId,
          userId,
          status: { in: ["INVITED", "LEFT"] },
          game: { status: "WAITING" },
        },
        data: { status: "JOINED" },
      });
      if (count === 0) {
        throw new NotFoundException(
          errorBody(ErrorCode.INVITATION_NOT_FOUND, "Invitation introuvable"),
        );
      }

      return exits;
    });
  }

  async leaveGame(userId: string, gameId: string) {
    await this.prisma.gamePlayer.updateMany({
      where: { gameId, userId, status: "JOINED" },
      data: { status: "LEFT" },
    });
  }

  async cancelGame(gameId: string) {
    await this.prisma.game.updateMany({
      where: { id: gameId, status: { in: ["WAITING", "PLAYING"] } },
      data: { status: "CANCELED" },
    });
  }

  /** De quoi monter un salon en mémoire */
  async getLobby(gameId: string) {
    return this.prisma.game.findUniqueOrThrow({
      where: { id: gameId },
      select: {
        id: true,
        difficulty: true,
        createdAt: true,
        players: {
          select: {
            id: true,
            isHost: true,
            status: true,
            user: { select: publicUserSelect },
          },
        },
      },
    });
  }

  /**
   * Passe la partie en PLAYING et charge ce que le moteur garde en mémoire : les 15
   * questions (dans les deux langues) et la langue de chaque joueur, lue maintenant
   * plutôt qu'à la création du salon pour tenir compte d'un changement entre-temps.
   */
  async startGame(gameId: string, playerIds: string[]) {
    const [, gameQuestions, users] = await this.prisma.$transaction([
      this.prisma.game.update({
        where: { id: gameId },
        data: { status: "PLAYING", startedAt: new Date() },
      }),
      this.prisma.gameQuestion.findMany({
        where: { gameId },
        orderBy: { order: "asc" },
        select: { id: true, question: true },
      }),
      this.prisma.user.findMany({
        where: { id: { in: playerIds } },
        select: { id: true, lang: true },
      }),
    ]);

    return {
      gameQuestions,
      langByUserId: new Map(users.map((u) => [u.id, u.lang])),
    };
  }

  /**
   * Enregistre toute la partie en une transaction : réponses, scores de la partie,
   * XP gagnée et points de Score par difficulté (le classement compte les bonnes
   * réponses du solo comme du multijoueur).
   * Renvoie l'XP de chaque joueur avant la partie, pour calculer sa progression.
   */
  async finishGame(gameId: string, results: FinishedPlayer[]) {
    const users = await this.prisma.user.findMany({
      where: { id: { in: results.map((r) => r.userId) } },
      select: { id: true, xp: true },
    });

    await this.prisma.$transaction([
      this.prisma.gameAnswer.createMany({
        data: results.flatMap((r) =>
          r.answers.map((a) => ({ ...a, gamePlayerId: r.gamePlayerId })),
        ),
      }),
      ...results.map((r) =>
        this.prisma.gamePlayer.update({
          where: { id: r.gamePlayerId },
          data: { score: r.score, xpEarned: r.xpEarned },
        }),
      ),
      ...results
        .filter((r) => r.xpEarned > 0)
        .map((r) =>
          this.prisma.user.update({
            where: { id: r.userId },
            data: { xp: { increment: r.xpEarned } },
          }),
        ),
      ...results.flatMap((r) =>
        Object.entries(r.pointsByDifficulty).map(([difficulty, points]) =>
          this.scoreService.getUpsertOperation(
            r.userId,
            difficulty as Difficulty,
            points,
          ),
        ),
      ),
      this.prisma.game.update({
        where: { id: gameId },
        data: { status: "FINISHED", finishedAt: new Date() },
      }),
    ]);

    return new Map(users.map((u) => [u.id, u.xp]));
  }

  /**
   * Invitations encore valables : partie en WAITING, créée il y a moins de 10 min.
   * LEFT compris : un invité qui a quitté le salon avant le lancement peut y revenir.
   */
  async listInvitations(me: string) {
    const rows = await this.prisma.gamePlayer.findMany({
      where: {
        userId: me,
        status: { in: ["INVITED", "LEFT"] },
        game: {
          status: "WAITING",
          createdAt: { gt: new Date(Date.now() - LOBBY_TIMEOUT_MS) },
        },
      },
      orderBy: { game: { createdAt: "desc" } },
      select: {
        game: {
          select: {
            id: true,
            difficulty: true,
            createdAt: true,
            players: {
              // Soi-même compris même si on a quitté le salon : on compte les
              // joueurs de la partie qu'on rejoindrait
              where: {
                OR: [{ status: { in: ["INVITED", "JOINED"] } }, { userId: me }],
              },
              select: { isHost: true, user: { select: publicUserSelect } },
            },
          },
        },
      },
    });

    return rows.flatMap(({ game }) => {
      const host = game.players.find((p) => p.isHost);
      // Un salon sans hôte est annulé : ne devrait jamais arriver ici
      if (!host) return [];
      return {
        gameId: game.id,
        difficulty: game.difficulty,
        createdAt: game.createdAt,
        host: toPublicUser(host.user),
        playerCount: game.players.length,
      };
    });
  }

  async declineInvitation(me: string, gameId: string) {
    const { count } = await this.prisma.gamePlayer.updateMany({
      where: {
        gameId,
        userId: me,
        status: { in: ["INVITED", "LEFT"] },
        game: { status: "WAITING" },
      },
      data: { status: "DECLINED" },
    });
    if (count === 0) {
      throw new NotFoundException(
        errorBody(ErrorCode.INVITATION_NOT_FOUND, "Invitation introuvable"),
      );
    }
  }

  /** La partie (salon ou en cours) à laquelle revenir, par exemple après avoir tué l'app */
  async getActiveGame(me: string) {
    const player = await this.prisma.gamePlayer.findFirst({
      where: {
        userId: me,
        status: "JOINED",
        game: { status: { in: ["WAITING", "PLAYING"] } },
      },
      orderBy: { game: { createdAt: "desc" } },
      select: { game: { select: { id: true, status: true } } },
    });

    return { game: player?.game ?? null };
  }

  /** Une partie déjà lancée bloque ; un simple salon, lui, est quitté automatiquement */
  private async assertNotPlaying(userId: string) {
    const playing = await this.prisma.gamePlayer.findFirst({
      where: { userId, status: "JOINED", game: { status: "PLAYING" } },
      select: { id: true },
    });
    if (playing) {
      throw new ConflictException(
        errorBody(ErrorCode.ALREADY_IN_GAME, "Déjà dans une partie en cours"),
      );
    }
  }

  /**
   * Une seule partie active par joueur : créer ou rejoindre une
   * partie fait quitter les salons en attente, comme le solo annule sa session
   * précédente. Ceux qu'on hébergeait sont annulés, puisque l'hôte qui part annule
   * le salon.
   */
  private async leaveWaitingLobbies(
    tx: Prisma.TransactionClient,
    userId: string,
    exceptGameId?: string,
  ): Promise<LobbyExits> {
    // Lus avant la mise à jour : le moteur doit prévenir les autres joueurs de ces salons
    const hosted = await tx.game.findMany({
      where: {
        id: { not: exceptGameId },
        status: "WAITING",
        players: { some: { userId, isHost: true } },
      },
      select: { id: true },
    });
    const joined = await tx.gamePlayer.findMany({
      where: {
        userId,
        gameId: { not: exceptGameId },
        status: "JOINED",
        isHost: false,
        game: { status: "WAITING" },
      },
      select: { gameId: true },
    });

    const canceledGameIds = hosted.map((g) => g.id);
    const leftGameIds = joined.map((p) => p.gameId);

    await tx.game.updateMany({
      where: { id: { in: canceledGameIds } },
      data: { status: "CANCELED" },
    });
    await tx.gamePlayer.updateMany({
      where: { userId, gameId: { in: leftGameIds } },
      data: { status: "LEFT" },
    });

    return { canceledGameIds, leftGameIds };
  }
}
