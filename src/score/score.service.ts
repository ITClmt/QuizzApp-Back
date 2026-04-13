import { Injectable } from "@nestjs/common";
import { Difficulty } from "src/generated/prisma/client";
import { PrismaService } from "src/prisma/prisma.service";
import type { ScoreResponse, UserScoresResponse } from "./interfaces";

@Injectable()
export class ScoreService {
  constructor(private readonly prisma: PrismaService) {}

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
    const score = await this.prisma.score.upsert({
      where: { userId_difficulty: { userId, difficulty } },
      update: { value: { increment: points } },
      create: { userId, difficulty, value: points },
    });

    return {
      id: score.id,
      value: score.value,
      difficulty: score.difficulty,
      createdAt: score.createdAt,
    };
  }
}
