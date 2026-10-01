import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { ErrorCode, errorBody } from "src/common/error-codes";
import { Prisma } from "src/generated/prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import { getLevelFromXp } from "src/quiz/utils/level.util";
import { pairKey } from "./utils/pair-key";

const MAX_PENDING_SENT = 50;
const MAX_FRIENDS = 200;
const SEARCH_LIMIT = 10;

// Profil public minimal : ni email, ni XP brute
const publicUserSelect = {
  id: true,
  username: true,
  avatarSlug: true,
  xp: true,
} as const;

type PublicUserRow = Prisma.UserGetPayload<{ select: typeof publicUserSelect }>;

function toPublicUser({ xp, ...user }: PublicUserRow) {
  return { ...user, level: getLevelFromXp(xp) };
}

export type FriendRelation = "none" | "friends" | "sent" | "received";

@Injectable()
export class FriendsService {
  constructor(private readonly prisma: PrismaService) {}

  async listFriends(me: string) {
    const friendships = await this.prisma.friendship.findMany({
      where: {
        status: "ACCEPTED",
        OR: [{ requesterId: me }, { receiverId: me }],
      },
      include: {
        requester: { select: publicUserSelect },
        receiver: { select: publicUserSelect },
      },
    });

    return friendships
      .map((f) => ({
        friendshipId: f.id,
        since: f.acceptedAt ?? f.createdAt,
        user: toPublicUser(f.requesterId === me ? f.receiver : f.requester),
      }))
      .sort((a, b) => a.user.username.localeCompare(b.user.username));
  }

  async listRequests(me: string) {
    const [received, sent] = await Promise.all([
      this.prisma.friendship.findMany({
        where: { receiverId: me, status: "PENDING" },
        include: { requester: { select: publicUserSelect } },
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.friendship.findMany({
        where: { requesterId: me, status: "PENDING" },
        include: { receiver: { select: publicUserSelect } },
        orderBy: { createdAt: "desc" },
      }),
    ]);

    return {
      received: received.map((f) => ({
        id: f.id,
        createdAt: f.createdAt,
        user: toPublicUser(f.requester),
      })),
      sent: sent.map((f) => ({
        id: f.id,
        createdAt: f.createdAt,
        user: toPublicUser(f.receiver),
      })),
    };
  }

  async search(me: string, q: string) {
    const users = await this.prisma.user.findMany({
      where: {
        id: { not: me },
        username: { contains: q, mode: "insensitive" },
      },
      select: publicUserSelect,
      orderBy: { username: "asc" },
      take: SEARCH_LIMIT,
    });

    // Une seule requête pour toutes les relations, jamais une par résultat
    const friendships = await this.prisma.friendship.findMany({
      where: { pairKey: { in: users.map((u) => pairKey(me, u.id)) } },
    });
    const byPair = new Map(friendships.map((f) => [f.pairKey, f]));

    return users.map((user) => {
      const friendship = byPair.get(pairKey(me, user.id));
      let relation: FriendRelation = "none";
      if (friendship?.status === "ACCEPTED") relation = "friends";
      else if (friendship)
        relation = friendship.requesterId === me ? "sent" : "received";

      return {
        user: toPublicUser(user),
        relation,
        ...(relation === "sent" || relation === "received"
          ? { requestId: friendship?.id }
          : {}),
      };
    });
  }

  async sendRequest(me: string, targetId: string) {
    if (targetId === me) {
      throw new BadRequestException(
        errorBody(ErrorCode.CANNOT_FRIEND_SELF, "Cannot friend self"),
      );
    }

    const target = await this.prisma.user.findUnique({
      where: { id: targetId },
      select: { id: true },
    });
    if (!target) {
      throw new NotFoundException(
        errorBody(ErrorCode.USER_NOT_FOUND, "User not found"),
      );
    }

    const key = pairKey(me, targetId);
    const existing = await this.prisma.friendship.findUnique({
      where: { pairKey: key },
    });
    if (existing) return this.resolveExisting(me, existing);

    await this.assertCanSendRequest(me);

    try {
      const created = await this.prisma.friendship.create({
        data: { pairKey: key, requesterId: me, receiverId: targetId },
      });
      return { id: created.id, status: created.status };
    } catch (error) {
      // Demandes croisées envoyées au même instant : l'autre ligne a gagné la
      // course sur pairKey — on la relit et on applique la même logique
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === "P2002"
      ) {
        const winner = await this.prisma.friendship.findUniqueOrThrow({
          where: { pairKey: key },
        });
        return this.resolveExisting(me, winner);
      }
      throw error;
    }
  }

  async acceptRequest(me: string, requestId: string) {
    const request = await this.findPendingRequest(requestId);
    if (!request || request.receiverId !== me) throw requestNotFound();

    await this.assertBelowFriendLimit(me);

    return this.accept(request.id);
  }

  /** Refus (destinataire) ou annulation (émetteur) — la ligne est supprimée */
  async deleteRequest(me: string, requestId: string) {
    const request = await this.findPendingRequest(requestId);
    if (!request || (request.receiverId !== me && request.requesterId !== me)) {
      throw requestNotFound();
    }

    await this.prisma.friendship.delete({ where: { id: request.id } });
  }

  async removeFriend(me: string, userId: string) {
    const { count } = await this.prisma.friendship.deleteMany({
      where: { pairKey: pairKey(me, userId), status: "ACCEPTED" },
    });
    if (count === 0) {
      throw new NotFoundException(
        errorBody(ErrorCode.NOT_FRIENDS, "Not friends"),
      );
    }
  }

  /** Pour la création de parties multijoueur : tous doivent être des amis acceptés */
  async assertAllFriends(me: string, userIds: string[]) {
    const count = await this.prisma.friendship.count({
      where: {
        status: "ACCEPTED",
        pairKey: { in: userIds.map((id) => pairKey(me, id)) },
      },
    });
    if (count !== new Set(userIds).size) {
      throw new BadRequestException(
        errorBody(ErrorCode.NOT_FRIENDS, "All players must be friends"),
      );
    }
  }

  private async resolveExisting(
    me: string,
    friendship: { id: string; status: string; requesterId: string },
  ) {
    if (friendship.status === "ACCEPTED") {
      throw new ConflictException(
        errorBody(ErrorCode.ALREADY_FRIENDS, "Already friends"),
      );
    }
    if (friendship.requesterId === me) {
      throw new ConflictException(
        errorBody(
          ErrorCode.FRIEND_REQUEST_EXISTS,
          "Friend request already sent to this user",
        ),
      );
    }

    // L'autre m'avait déjà envoyé une demande : on l'accepte directement
    await this.assertBelowFriendLimit(me);
    return this.accept(friendship.id);
  }

  private async accept(id: string) {
    const accepted = await this.prisma.friendship.update({
      where: { id },
      data: { status: "ACCEPTED", acceptedAt: new Date() },
    });
    return { id: accepted.id, status: accepted.status };
  }

  private findPendingRequest(id: string) {
    return this.prisma.friendship.findFirst({
      where: { id, status: "PENDING" },
    });
  }

  private async assertCanSendRequest(me: string) {
    const pendingSent = await this.prisma.friendship.count({
      where: { requesterId: me, status: "PENDING" },
    });
    if (pendingSent >= MAX_PENDING_SENT) {
      throw new BadRequestException(
        errorBody(
          ErrorCode.TOO_MANY_PENDING_REQUESTS,
          "Too many pending requests",
        ),
      );
    }
    await this.assertBelowFriendLimit(me);
  }

  private async assertBelowFriendLimit(me: string) {
    const friends = await this.prisma.friendship.count({
      where: {
        status: "ACCEPTED",
        OR: [{ requesterId: me }, { receiverId: me }],
      },
    });
    if (friends >= MAX_FRIENDS) {
      throw new BadRequestException(
        errorBody(ErrorCode.FRIEND_LIMIT_REACHED, "Friend limit reached"),
      );
    }
  }
}

function requestNotFound() {
  return new NotFoundException(
    errorBody(ErrorCode.FRIEND_REQUEST_NOT_FOUND, "Friend request not found"),
  );
}
