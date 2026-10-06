import { applyDecorators } from '@nestjs/common';
import {
	IsNotEmpty,
	IsString,
	Matches,
	MaxLength,
	MinLength,
} from 'class-validator';

// Doit rester alignée avec PASSWORD_REGEX côté front
// (Front-React-Native/QuizzApp/src/features/auth/schemas.ts)
export const PASSWORD_REGEX =
	/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d\s])\S+$/;

export function IsStrongPassword() {
	return applyDecorators(
		IsString(),
		IsNotEmpty(),
		MinLength(8, { message: 'Password must be at least 8 characters long' }),
		MaxLength(128, { message: 'Password must be at most 128 characters long' }),
		Matches(PASSWORD_REGEX, {
			message:
				'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character, and must not contain spaces',
		}),
	);
}
