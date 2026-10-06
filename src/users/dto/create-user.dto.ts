import {
	IsEmail,
	IsNotEmpty,
	IsString,
	MaxLength,
	MinLength,
} from 'class-validator';
import { IsNotForbiddenWord } from 'src/common/validators/is-not-forbidden-word.decorator';
import { IsStrongPassword } from 'src/common/validators/is-strong-password.decorator';

export class CreateUserDto {
	@IsEmail()
	@IsNotEmpty()
	email: string;

	@IsString()
	@MinLength(3, { message: 'Name must be at least 3 characters long' })
	@MaxLength(20, { message: 'Name must be at most 20 characters long' })
	@IsNotForbiddenWord()
	username: string;

	@IsStrongPassword()
	password: string;

	@IsString()
	lang: string;
}
