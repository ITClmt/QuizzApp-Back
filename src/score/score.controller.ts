import { Controller, Get, Param, Query } from "@nestjs/common";
import { Public } from "src/auth/decorators/public.decorator";
import { Difficulty } from "src/generated/prisma/client";
import { ScoreService } from "./score.service";

@Controller("score")
export class ScoreController {
  constructor(private readonly scoreService: ScoreService) {}

  @Get("user/:id")
  async getUserScore(@Param() params: { id: string }) {
    return this.scoreService.getUserScores(params.id);
  }

  @Get("leaderboard")
  async getLeaderboard(@Query() query: { difficulty: Difficulty }) {
    const difficulty = query.difficulty ?? undefined;
    return this.scoreService.getLeaderboard(difficulty);
  }
}
