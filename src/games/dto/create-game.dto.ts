import {
	ArrayMaxSize,
	ArrayMinSize,
	ArrayUnique,
	IsArray,
	IsIn,
	IsOptional,
	IsUUID,
} from 'class-validator';
import { MAX_INVITED_FRIENDS, MIN_INVITED_FRIENDS } from '../constants';

export class CreateGameDto {
	@IsArray()
	@ArrayMinSize(MIN_INVITED_FRIENDS)
	@ArrayMaxSize(MAX_INVITED_FRIENDS)
	@ArrayUnique()
	@IsUUID('all', { each: true })
	friendIds: string[];

	// Absente = mixte
	@IsOptional()
	@IsIn(['easy', 'medium', 'hard'])
	difficulty?: 'easy' | 'medium' | 'hard';
}
