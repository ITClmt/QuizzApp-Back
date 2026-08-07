import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ScoreModule } from '../score/score.module';
import { UsersModule } from '../users/users.module';
import { QuizController } from './quiz.controller';
import { QuizService } from './quiz.service';

@Module({
	imports: [PrismaModule, ScoreModule, UsersModule],
	controllers: [QuizController],
	providers: [QuizService],
	exports: [QuizService],
})
export class QuizModule {}
