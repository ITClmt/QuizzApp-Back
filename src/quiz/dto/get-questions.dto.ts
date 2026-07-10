import { IsIn, IsOptional } from "class-validator";
import { QUIZ_CATEGORY_IDS } from "../constants/categories";

export class GetQuestionsDto {
  @IsOptional()
  @IsIn(["en", "fr"])
  lang?: string = "en";

  @IsOptional()
  @IsIn(["easy", "medium", "hard"])
  difficulty?: string;

  @IsOptional()
  @IsIn(QUIZ_CATEGORY_IDS)
  category?: string;
}
