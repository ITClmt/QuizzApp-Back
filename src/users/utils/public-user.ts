import { Prisma } from 'src/generated/prisma/client';
import { getLevelFromXp } from 'src/quiz/utils/level.util';

// Profil public minimal : ni email, ni XP brute
export const publicUserSelect = {
	id: true,
	username: true,
	avatarSlug: true,
	xp: true,
} as const;

export type PublicUserRow = Prisma.UserGetPayload<{
	select: typeof publicUserSelect;
}>;

export function toPublicUser({ xp, ...user }: PublicUserRow) {
	return { ...user, level: getLevelFromXp(xp) };
}
