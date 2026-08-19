import {
	IsEmail,
	IsNotEmpty,
	IsString,
	Matches,
	MaxLength,
	MinLength,
} from 'class-validator';
import { IsNotForbiddenWord } from 'src/common/validators/is-not-forbidden-word.decorator';

export class CreateUserDto {
	@IsEmail()
	@IsNotEmpty()
	email: string;

	@IsString()
	@MinLength(3, { message: 'Name must be at least 3 characters long' })
	@MaxLength(20, { message: 'Name must be at most 20 characters long' })
	@IsNotForbiddenWord()
	username: string;

	@IsString()
	@IsNotEmpty()
	@MinLength(8, { message: 'Password must be at least 8 characters long' })
	@MaxLength(128, { message: 'Password must be at most 128 characters long' })
	@Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d\s])\S+$/, {
		message:
			'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character, and must not contain spaces',
	})
	password: string;

	@IsString()
	lang: string;
}
