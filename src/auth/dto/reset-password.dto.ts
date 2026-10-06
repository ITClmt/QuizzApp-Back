import { IsEmail, IsNotEmpty, Matches } from 'class-validator';
import { IsStrongPassword } from 'src/common/validators/is-strong-password.decorator';

export class ResetPasswordDto {
	@IsEmail()
	@IsNotEmpty()
	email: string;

	@Matches(/^\d{6}$/, { message: 'Code must be 6 digits' })
	code: string;

	@IsStrongPassword()
	newPassword: string;
}
