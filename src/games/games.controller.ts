import {
	Body,
	Controller,
	Get,
	HttpCode,
	HttpStatus,
	Param,
	ParseUUIDPipe,
	Post,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { CurrentUser } from 'src/auth/decorators/current-user.decorator';
import type { JwtPayload } from 'src/auth/types/jwt-payload.type';
import { CreateGameDto } from './dto/create-game.dto';
import { GamesService } from './games.service';

@Controller('games')
export class GamesController {
	constructor(private readonly gamesService: GamesService) {}

	@Throttle({ default: { limit: 10, ttl: 60000 } })
	@Post()
	@HttpCode(HttpStatus.CREATED)
	async create(@Body() dto: CreateGameDto, @CurrentUser() user: JwtPayload) {
		return this.gamesService.createGame(
			user.sub,
			dto.friendIds,
			dto.difficulty,
		);
	}

	@Get('invitations')
	async listInvitations(@CurrentUser() user: JwtPayload) {
		return this.gamesService.listInvitations(user.sub);
	}

	@Get('active')
	async getActiveGame(@CurrentUser() user: JwtPayload) {
		return this.gamesService.getActiveGame(user.sub);
	}

	@Post(':id/decline')
	@HttpCode(HttpStatus.NO_CONTENT)
	async decline(
		@Param('id', ParseUUIDPipe) id: string,
		@CurrentUser() user: JwtPayload,
	) {
		await this.gamesService.declineInvitation(user.sub, id);
	}
}
