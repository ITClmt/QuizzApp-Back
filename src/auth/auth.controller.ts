import {
	Body,
	Controller,
	Get,
	HttpCode,
	HttpStatus,
	Post,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { CreateUserDto } from 'src/users/dto/create-user.dto';
import { AuthService } from './auth.service';
import { CurrentUser } from './decorators/current-user.decorator';
import { Public } from './decorators/public.decorator';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh_token.dto';
import type { JwtPayload } from './types/jwt-payload.type';

@Throttle({ auth: { ttl: 60000, limit: 5 } })
@Controller('auth')
export class AuthController {
	constructor(private readonly authService: AuthService) {}

	@Throttle({ auth: { limit: 3, ttl: 60000 } })
	@Public()
	@Post('login')
	@HttpCode(HttpStatus.OK)
	async login(@Body() loginDto: LoginDto) {
		return this.authService.login(loginDto);
	}

	@Get('profile')
	@HttpCode(HttpStatus.OK)
	async getProfile(@CurrentUser() user: JwtPayload) {
		return this.authService.getProfile(user.sub);
	}

	@Public()
	@Post('register')
	@HttpCode(HttpStatus.CREATED)
	async register(@Body() createUserDto: CreateUserDto) {
		return this.authService.register(createUserDto);
	}

	@Post('refresh')
	@HttpCode(HttpStatus.OK)
	async refreshTokens(@Body() data: RefreshTokenDto) {
		return this.authService.refreshTokens(data.refreshToken);
	}

	@Post('logout')
	@HttpCode(HttpStatus.NO_CONTENT)
	async logout(@Body() data: RefreshTokenDto) {
		await this.authService.logout(data.refreshToken);
	}
}
