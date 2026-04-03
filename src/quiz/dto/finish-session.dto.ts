import { Type } from "class-transformer";
import {
  IsArray,
  IsInt,
  IsString,
  Max,
  Min,
  ValidateNested,
} from "class-validator";

export class AnswerDto {
  @IsString()
  questionId: string;

  @IsInt()
  @Min(0)
  @Max(3)
  answerIndex: number;
}

export class FinishSessionDto {
  @IsString()
  sessionId: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => AnswerDto)
  answers: AnswerDto[];
}
