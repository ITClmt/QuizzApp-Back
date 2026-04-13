import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { PrismaModule } from './prisma/prisma.module';
import { QuizController } from './quiz/quiz.controller';
import { QuizModule } from './quiz/quiz.module';
import { UsersModule } from './users/users.module';
import { ScoreModule } from './score/score.module';

@Module({
	imports: [
		ConfigModule.forRoot({ isGlobal: true }),
		ScheduleModule.forRoot(),
		ThrottlerModule.forRoot([
			{
				name: 'global',
				ttl: 60000,
				limit: 10,
			},
			{
				name: 'auth',
				ttl: 60000,
				limit: 5,
			},
		]),
		PrismaModule,
		UsersModule,
		AuthModule,
		QuizModule,
		ScoreModule,
	],
	controllers: [AppController, QuizController],
	providers: [AppService, { provide: APP_GUARD, useClass: ThrottlerGuard }],
})
export class AppModule {}
