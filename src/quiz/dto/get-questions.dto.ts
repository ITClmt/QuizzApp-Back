import { IsOptional, IsIn } from 'class-validator'

export class GetQuestionsDto {
  @IsOptional()
  @IsIn(['en', 'fr'])
  lang?: string = 'en'
}