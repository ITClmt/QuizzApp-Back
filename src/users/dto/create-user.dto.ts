import {
	IsEmail,
	IsNotEmpty,
	IsString,
	Matches,
	MaxLength,
	MinLength,
} from 'class-validator';

export class CreateUserDto {
	@IsEmail()
	@IsNotEmpty()
	email: string;

	@IsString()
	@MinLength(3, { message: 'Name must be at least 3 characters long' })
	@MaxLength(20, { message: 'Name must be at most 20 characters long' })
	username: string;

	@IsString()
	@IsNotEmpty()
	@MinLength(8, { message: 'Password must be at least 8 characters long' })
	@MaxLength(128, { message: 'Password must be at most 128 characters long' })
	@Matches(
		/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/,
		{
			message:
				'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character',
		},
	)
	password: string;

	@IsString()
	lang: string;
}
