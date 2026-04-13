import type { Difficulty } from "src/generated/prisma/client";

export interface ScoreResponse {
  id: string;
  value: number;
  difficulty: Difficulty;
  createdAt: Date;
}

export interface UserScoresResponse {
  totalScore: number;
  scores: ScoreResponse[];
}
