import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { QuizController } from './quiz.controller';
import { QuizService } from './quiz.service';

@Module({
	imports: [HttpModule, PrismaModule],
	controllers: [QuizController],
	providers: [QuizService],
	exports: [QuizService],
})
export class QuizModule {}
