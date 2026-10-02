import { Module } from '@nestjs/common';
import { FriendsModule } from 'src/friends/friends.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuizModule } from 'src/quiz/quiz.module';
import { GamesController } from './games.controller';
import { GamesService } from './games.service';

@Module({
	imports: [PrismaModule, FriendsModule, QuizModule],
	controllers: [GamesController],
	providers: [GamesService],
})
export class GamesModule {}
