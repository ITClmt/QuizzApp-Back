import type { ValidationOptions } from 'class-validator';
import { registerDecorator } from 'class-validator';
import { containsForbiddenWord } from '../moderation/profanity';

export function IsNotForbiddenWord(validationOptions?: ValidationOptions) {
	return (object: object, propertyName: string) => {
		registerDecorator({
			name: 'isNotForbiddenWord',
			target: object.constructor,
			propertyName,
			options: validationOptions,
			validator: {
				validate(value: unknown) {
					return typeof value !== 'string' || !containsForbiddenWord(value);
				},
				defaultMessage() {
					return 'Username contains inappropriate language';
				},
			},
		});
	};
}
