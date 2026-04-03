import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { CurrentUser } from "../auth/decorators/current-user.decorator";
import type { JwtPayload } from "../auth/types/jwt-payload.type";
import { GetQuestionsDto } from "./dto/get-questions.dto";
import { PostAnswerDto } from "./dto/post-answer.dto";
import { QuizService } from "./quiz.service";

@Controller("quiz")
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Get("questions")
  async getQuestions(
    @Query() query: GetQuestionsDto,
    @CurrentUser() user: JwtPayload,
  ) {
    const difficulty = query.difficulty ?? undefined;
    const category = query.category ?? undefined;
    return this.quizService.getQuestions(user.lang, difficulty, category);
  }

  @Post("answer")
  async validateAnswer(
    @Body() body: PostAnswerDto,
    @CurrentUser() user: JwtPayload,
  ) {
    return this.quizService.validateAnswer(
      body.questionId,
      body.answerIndex,
      user.lang,
    );
  }
}
