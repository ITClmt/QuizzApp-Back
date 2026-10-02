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
import { GameEngineService } from './engine/game-engine.service';
import { GamesService } from './games.service';

@Controller('games')
export class GamesController {
	// Création et refus passent par le moteur : il prévient les joueurs en direct
	constructor(
		private readonly gamesService: GamesService,
		private readonly engine: GameEngineService,
	) {}

	@Throttle({ default: { limit: 10, ttl: 60000 } })
	@Post()
	@HttpCode(HttpStatus.CREATED)
	async create(@Body() dto: CreateGameDto, @CurrentUser() user: JwtPayload) {
		return this.engine.createGame(user.sub, dto.friendIds, dto.difficulty);
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
		await this.engine.declineInvitation(user.sub, id);
	}
}
