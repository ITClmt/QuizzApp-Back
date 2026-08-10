import {
	IsEmail,
	IsIn,
	IsOptional,
	IsString,
	MaxLength,
	MinLength,
} from 'class-validator';
import { IsNotForbiddenWord } from 'src/common/validators/is-not-forbidden-word.decorator';
import { AVATAR_SLUGS } from '../constants/avatars';

export class UpdateUserDto {
	@IsOptional()
	@IsEmail()
	email?: string;

	@IsOptional()
	@IsString()
	@MinLength(3, { message: 'Name must be at least 3 characters long' })
	@MaxLength(20, { message: 'Name must be at most 20 characters long' })
	@IsNotForbiddenWord()
	username?: string;

	@IsOptional()
	@IsString()
	lang?: string;

	@IsOptional()
	@IsIn(AVATAR_SLUGS)
	avatarSlug?: string;
}
