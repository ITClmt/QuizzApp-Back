import { IsEnum, IsNotEmpty } from "class-validator";
import { Difficulty } from "src/generated/prisma/client";

export class LeaderboardQueryDto {
  @IsNotEmpty()
  @IsEnum(Difficulty)
  difficulty: Difficulty;
}
