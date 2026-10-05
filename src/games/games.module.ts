import { Module } from '@nestjs/common';
import { FriendsModule } from 'src/friends/friends.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuizModule } from 'src/quiz/quiz.module';
import { ScoreModule } from 'src/score/score.module';
import { GameEngineService } from './engine/game-engine.service';
import { GameEmitter } from './game-emitter.service';
import { GamesController } from './games.controller';
import { GamesGateway } from './games.gateway';
import { GamesService } from './games.service';

@Module({
	imports: [PrismaModule, FriendsModule, QuizModule, ScoreModule],
	controllers: [GamesController],
	providers: [GamesService, GameEmitter, GameEngineService, GamesGateway],
})
export class GamesModule {}
