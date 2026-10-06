import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerModule } from '@nestjs/throttler';
import { AccountModule } from './account/account.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { HttpThrottlerGuard } from './common/guards/http-throttler.guard';
import { FriendsModule } from './friends/friends.module';
import { GamesModule } from './games/games.module';
import { PrismaModule } from './prisma/prisma.module';
import { QuizController } from './quiz/quiz.controller';
import { QuizModule } from './quiz/quiz.module';
import { ScoreModule } from './score/score.module';
import { UsersModule } from './users/users.module';

@Module({
	imports: [
		ConfigModule.forRoot({ isGlobal: true }),
		ScheduleModule.forRoot(),
		ThrottlerModule.forRoot([
			{
				name: 'default',
				ttl: 60000,
				limit: 600,
			},
		]),
		PrismaModule,
		UsersModule,
		AuthModule,
		QuizModule,
		ScoreModule,
		FriendsModule,
		GamesModule,
		AccountModule,
	],
	controllers: [AppController, QuizController],
	providers: [AppService, { provide: APP_GUARD, useClass: HttpThrottlerGuard }],
})
export class AppModule {}
