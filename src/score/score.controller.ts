import { Controller, Get, Param } from "@nestjs/common";
import { ScoreService } from "./score.service";

@Controller("score")
export class ScoreController {
  constructor(private readonly scoreService: ScoreService) {}

  @Get("user/:id")
  async getUserScore(@Param() params: { id: string }) {
    return this.scoreService.getUserScores(params.id);
  }
}
