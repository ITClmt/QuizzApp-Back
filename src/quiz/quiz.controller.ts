import {
	Body,
	Controller,
	ForbiddenException,
	Get,
	Post,
	Query,
} from '@nestjs/common';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import type { JwtPayload } from '../auth/types/jwt-payload.type';
import { UsersService } from '../users/users.service';
import { isCategoryUnlocked, QUIZ_CATEGORIES } from './constants/categories';
import { FinishSessionDto } from './dto/finish-session.dto';
import { GetQuestionsDto } from './dto/get-questions.dto';
import { PostAnswerDto } from './dto/post-answer.dto';
import { QuizService } from './quiz.service';

@Controller('quiz')
export class QuizController {
	constructor(
		private readonly quizService: QuizService,
		private readonly usersService: UsersService,
	) {}

	private async assertCategoryUnlocked(user: JwtPayload, category?: string) {
		if (!category) return;
		const level = await this.quizService.getUserLevel(user.sub);
		if (!isCategoryUnlocked(category, level)) {
			throw new ForbiddenException('Category not unlocked for your level');
		}
	}

	@Get('categories')
	async getCategories(@CurrentUser() user: JwtPayload) {
		const level = await this.quizService.getUserLevel(user.sub);
		return QUIZ_CATEGORIES.map((category) => ({
			...category,
			unlocked: level >= category.unlockLevel,
		}));
	}

	@Get('questions')
	async getQuestions(
		@Query() query: GetQuestionsDto,
		@CurrentUser() user: JwtPayload,
	) {
		const difficulty = query.difficulty ?? undefined;
		const category = query.category ?? undefined;
		await this.assertCategoryUnlocked(user, category);
		const lang = await this.usersService.getUserLang(user.sub);
		return this.quizService.getQuestions(lang, difficulty, category);
	}

	@Post('start')
	async startSession(
		@Query() query: GetQuestionsDto,
		@CurrentUser() user: JwtPayload,
	) {
		const difficulty = query.difficulty ?? undefined;
		const category = query.category ?? undefined;
		await this.assertCategoryUnlocked(user, category);
		const lang = await this.usersService.getUserLang(user.sub);
		return this.quizService.startSession(user.sub, lang, difficulty, category);
	}

	@Post('finish')
	async finishSession(
		@Body() body: FinishSessionDto,
		@CurrentUser() user: JwtPayload,
	) {
		return this.quizService.finishSession(
			user.sub,
			body.sessionId,
			body.answers,
		);
	}

	@Post('cancel')
	async cancelSession(
		@Body() body: { sessionId: string },
		@CurrentUser() user: JwtPayload,
	) {
		return this.quizService.cancelSession(user.sub, body.sessionId);
	}

	@Post('answer')
	async validateAnswer(
		@Body() body: PostAnswerDto,
		@CurrentUser() user: JwtPayload,
	) {
		const lang = await this.usersService.getUserLang(user.sub);
		return this.quizService.validateAnswer(
			body.questionId,
			body.answerIndex,
			lang,
		);
	}
}
