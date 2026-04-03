import { IsIn, IsOptional } from "class-validator";

export class StartSessionDto {
  @IsOptional()
  @IsIn(["easy", "medium", "hard"])
  difficulty?: string;
}
