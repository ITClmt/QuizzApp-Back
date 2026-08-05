import { Difficulty } from '../../generated/prisma/client';

export const XP_PER_DIFFICULTY: Record<Difficulty, number> = {
	easy: 7,
	medium: 14,
	hard: 28,
};
