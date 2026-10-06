import { Module } from '@nestjs/common';
import { AuthModule } from 'src/auth/auth.module';
import { GamesModule } from 'src/games/games.module';
import { AccountController } from './account.controller';
import { AccountService } from './account.service';

@Module({
	imports: [AuthModule, GamesModule],
	controllers: [AccountController],
	providers: [AccountService],
})
export class AccountModule {}
