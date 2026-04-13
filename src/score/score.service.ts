import { Injectable } from "@nestjs/common";
import { Difficulty } from "src/generated/prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import type {
  LeaderboardEntry,
  ScoreResponse,
  UserScoresResponse,
} from "./interfaces";

@Injectable()
export class ScoreService {
  constructor(private readonly prisma: PrismaService) {}

  getUpsertOperation(userId: string, difficulty: Difficulty, points: number) {
    return this.prisma.score.upsert({
      where: { userId_difficulty: { userId, difficulty } },
      update: { value: { increment: points } },
      create: { userId, difficulty, value: points },
    });
  }

  async getUserScores(userId: string): Promise<UserScoresResponse> {
    const scores = await this.prisma.score.findMany({
      where: { userId },
      orderBy: { difficulty: "asc" },
    });

    // Calcule le total en une seule passe
    const totalScore = scores.reduce((sum, s) => sum + s.value, 0);

    return {
      totalScore,
      scores: scores.map((s) => ({
        id: s.id,
        value: s.value,
        difficulty: s.difficulty,
        createdAt: s.createdAt,
      })),
    };
  }

  async addScore(
    userId: string,
    difficulty: Difficulty,
    points: number,
  ): Promise<ScoreResponse> {
    const score = await this.getUpsertOperation(userId, difficulty, points);

    return {
      id: score.id,
      value: score.value,
      difficulty: score.difficulty,
      createdAt: score.createdAt,
    };
  }

  async getLeaderboard(difficulty: Difficulty): Promise<LeaderboardEntry[]> {
    const scores = await this.prisma.score.findMany({
      where: { difficulty },
      include: {
        user: {
          select: {
            username: true,
            avatarSlug: true,
          },
        },
      },
      orderBy: { value: "desc" },
      take: 10,
    });

    return scores.map((s) => ({
      id: s.id,
      value: s.value,
      difficulty: s.difficulty,
      userData: {
        id: s.userId,
        username: s.user.username,
        avatarSlug: s.user.avatarSlug,
      },
      createdAt: s.createdAt,
    }));
  }
}
