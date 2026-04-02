import { IsOptional, IsIn } from 'class-validator'

export class GetQuestionsDto {
  @IsOptional()
  @IsIn(['en', 'fr'])
  lang?: string = 'en'

  @IsOptional()
  @IsIn(['easy', 'medium', 'hard'])
  difficulty?: string

  @IsOptional()
  @IsIn(['9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32'])
  category?: string
}