import type { Difficulty } from "src/generated/prisma/client";

export interface ScoreResponse {
  id: string;
  value: number;
  difficulty: Difficulty;
  userId?: string;
  createdAt: Date;
}

export interface UserScoresResponse {
  totalScore: number;
  scores: ScoreResponse[];
}

export interface LeaderboardEntry {
  id: string;
  value: number;
  difficulty: Difficulty;
  userData: {
    id: string;
    username: string;
    avatarSlug: string;
  };
  createdAt: Date;
}

export interface UserRankResponse {
  rank: number;
  score: number;
  difficulty?: Difficulty;
  percentage: number;
}

export interface RankResponse {
  rank: number;
  value: number;
}
