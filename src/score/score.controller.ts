import { Controller, Get, Param, ParseUUIDPipe, Query } from '@nestjs/common';
import { CurrentUser } from 'src/auth/decorators/current-user.decorator';
import type { JwtPayload } from 'src/auth/types/jwt-payload.type';
import { LeaderboardQueryDto } from './dto/leaderboard-query.dto';
import { ScoreService } from './score.service';

@Controller('score')
export class ScoreController {
	constructor(private readonly scoreService: ScoreService) {}

	@Get('user/:id')
	async getUserScore(@Param('id', ParseUUIDPipe) id: string) {
		return this.scoreService.getUserScores(id);
	}

	@Get('leaderboard')
	async getLeaderboard(@Query() query: LeaderboardQueryDto) {
		return this.scoreService.getLeaderboard(query.difficulty);
	}

	@Get('my-rank')
	async getMyRank(
		@Query() query: LeaderboardQueryDto,
		@CurrentUser() user: JwtPayload,
	) {
		return this.scoreService.getMyRank(user.sub, query.difficulty);
	}
}
