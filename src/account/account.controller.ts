import {
	Body,
	Controller,
	Delete,
	HttpCode,
	HttpStatus,
	Patch,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { CurrentUser } from 'src/auth/decorators/current-user.decorator';
import type { JwtPayload } from 'src/auth/types/jwt-payload.type';
import { AccountService } from './account.service';
import { ChangePasswordDto } from './dto/change-password.dto';
import { DeleteAccountDto } from './dto/delete-account.dto';

// Actions sensibles sur son propre compte : toujours le mot de passe en
// confirmation, et une limite serrée contre un token volé qui tenterait de
// le deviner
@Controller('users/me')
export class AccountController {
	constructor(private readonly accountService: AccountService) {}

	@Throttle({ default: { limit: 5, ttl: 900000 } })
	@Patch('password')
	@HttpCode(HttpStatus.OK)
	async changePassword(
		@CurrentUser() user: JwtPayload,
		@Body() data: ChangePasswordDto,
	) {
		return this.accountService.changePassword(user.sub, data);
	}

	@Throttle({ default: { limit: 5, ttl: 900000 } })
	@Delete()
	@HttpCode(HttpStatus.NO_CONTENT)
	async deleteAccount(
		@CurrentUser() user: JwtPayload,
		@Body() data: DeleteAccountDto,
	) {
		await this.accountService.deleteAccount(user.sub, data.password);
	}
}
