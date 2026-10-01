import {
	Body,
	Controller,
	Delete,
	Get,
	HttpCode,
	HttpStatus,
	Param,
	ParseUUIDPipe,
	Post,
	Query,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { CurrentUser } from 'src/auth/decorators/current-user.decorator';
import type { JwtPayload } from 'src/auth/types/jwt-payload.type';
import { SearchUsersDto } from './dto/search-users.dto';
import { SendRequestDto } from './dto/send-request.dto';
import { FriendsService } from './friends.service';

@Controller('friends')
export class FriendsController {
	constructor(private readonly friendsService: FriendsService) {}

	@Get()
	async listFriends(@CurrentUser() user: JwtPayload) {
		return this.friendsService.listFriends(user.sub);
	}

	@Get('requests')
	async listRequests(@CurrentUser() user: JwtPayload) {
		return this.friendsService.listRequests(user.sub);
	}

	@Throttle({ default: { limit: 30, ttl: 60000 } })
	@Get('search')
	async search(
		@Query() query: SearchUsersDto,
		@CurrentUser() user: JwtPayload,
	) {
		return this.friendsService.search(user.sub, query.q);
	}

	@Throttle({ default: { limit: 20, ttl: 60000 } })
	@Post('requests')
	@HttpCode(HttpStatus.CREATED)
	async sendRequest(
		@Body() dto: SendRequestDto,
		@CurrentUser() user: JwtPayload,
	) {
		return this.friendsService.sendRequest(user.sub, dto.userId);
	}

	@Post('requests/:id/accept')
	@HttpCode(HttpStatus.OK)
	async acceptRequest(
		@Param('id', ParseUUIDPipe) id: string,
		@CurrentUser() user: JwtPayload,
	) {
		return this.friendsService.acceptRequest(user.sub, id);
	}

	@Delete('requests/:id')
	@HttpCode(HttpStatus.NO_CONTENT)
	async deleteRequest(
		@Param('id', ParseUUIDPipe) id: string,
		@CurrentUser() user: JwtPayload,
	): Promise<void> {
		await this.friendsService.deleteRequest(user.sub, id);
	}

	@Delete(':userId')
	@HttpCode(HttpStatus.NO_CONTENT)
	async removeFriend(
		@Param('userId', ParseUUIDPipe) userId: string,
		@CurrentUser() user: JwtPayload,
	): Promise<void> {
		await this.friendsService.removeFriend(user.sub, userId);
	}
}
