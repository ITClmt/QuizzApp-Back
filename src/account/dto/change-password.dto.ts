import { IsNotEmpty, IsString } from 'class-validator';
import { IsStrongPassword } from 'src/common/validators/is-strong-password.decorator';

export class ChangePasswordDto {
	@IsString()
	@IsNotEmpty()
	currentPassword: string;

	@IsStrongPassword()
	newPassword: string;
}
