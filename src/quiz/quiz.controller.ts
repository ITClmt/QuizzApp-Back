import { Controller, Get, Query, UseGuards, Req } from '@nestjs/common'
import { QuizService } from './quiz.service'
import { GetQuestionsDto } from './dto/get-questions.dto'

@Controller('quiz')
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Get('questions')
  async getQuestions(@Query() query: GetQuestionsDto) {
    const lang = query.lang ?? 'en'
    return this.quizService.getQuestions(lang)
  }
}