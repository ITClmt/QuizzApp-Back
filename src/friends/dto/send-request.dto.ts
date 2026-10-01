import { IsUUID } from 'class-validator';

export class SendRequestDto {
	@IsUUID()
	userId: string;
}
