import { Controller, Get, Param, ParseUUIDPipe, Query } from "@nestjs/common";
import { ScoreService } from "./score.service";
import { LeaderboardQueryDto } from "./dto/leaderboard-query.dto";

@Controller("score")
export class ScoreController {
  constructor(private readonly scoreService: ScoreService) {}

  @Get("user/:id")
  async getUserScore(@Param("id", ParseUUIDPipe) id: string) {
    return this.scoreService.getUserScores(id);
  }

  @Get("leaderboard")
  async getLeaderboard(@Query() query: LeaderboardQueryDto) {
    return this.scoreService.getLeaderboard(query.difficulty);
  }
}
