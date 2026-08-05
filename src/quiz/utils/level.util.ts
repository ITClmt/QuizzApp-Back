export const MAX_LEVEL = 50;
const XP_LEVEL_FACTOR = 50;

export function getLevelFromXp(xp: number): number {
	return Math.min(MAX_LEVEL, Math.floor(Math.sqrt(xp / XP_LEVEL_FACTOR)));
}

export function xpForLevel(level: number): number {
	return XP_LEVEL_FACTOR * Math.min(level, MAX_LEVEL) ** 2;
}
