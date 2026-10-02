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
import { publicUserSelect, toPublicUser } from "src/users/utils/public-user";
import { GAME_QUESTIONS, LOBBY_TIMEOUT_MS } from "./constants";

@Injectable()
export class GamesService implements OnApplicationBootstrap {
  private readonly logger = new Logger(GamesService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly friendsService: FriendsService,
    private readonly quizService: QuizService,
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

    const game = await this.prisma.$transaction(async (tx) => {
      await this.leaveWaitingLobbies(tx, hostId);

      return tx.game.create({
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
    });

    return { gameId: game.id };
  }

  /** Invitations encore valables : partie en WAITING, créée il y a moins de 10 min */
  async listInvitations(me: string) {
    const rows = await this.prisma.gamePlayer.findMany({
      where: {
        userId: me,
        status: "INVITED",
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
              where: { status: { in: ["INVITED", "JOINED"] } },
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
        status: "INVITED",
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
   * Une seule partie active par joueur : créer une
   * partie fait quitter les salons en attente, comme le solo annule sa session
   * précédente. Ceux qu'on hébergeait sont annulés, puisque l'hôte qui part annule
   * le salon.
   */
  private async leaveWaitingLobbies(
    tx: Prisma.TransactionClient,
    userId: string,
  ) {
    await tx.game.updateMany({
      where: { status: "WAITING", players: { some: { userId, isHost: true } } },
      data: { status: "CANCELED" },
    });
    await tx.gamePlayer.updateMany({
      where: {
        userId,
        status: "JOINED",
        isHost: false,
        game: { status: "WAITING" },
      },
      data: { status: "LEFT" },
    });
  }
}
