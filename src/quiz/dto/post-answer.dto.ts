import { IsInt, IsNotEmpty, IsString, Max, Min } from "class-validator";

export class PostAnswerDto {
  @IsString()
  @IsNotEmpty()
  questionId: string;

  @IsInt()
  @IsNotEmpty()
  @Min(0)
  @Max(3)
  answerIndex: number;
}
