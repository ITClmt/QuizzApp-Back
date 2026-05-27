import { IsEmail, IsOptional, IsString, MaxLength, MinLength } from "class-validator";

export class UpdateUserDto {
  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  @MinLength(3, { message: "Name must be at least 3 characters long" })
  @MaxLength(20, { message: "Name must be at most 20 characters long" })
  username?: string;

  @IsOptional()
  @IsString()
  lang?: string;
}
