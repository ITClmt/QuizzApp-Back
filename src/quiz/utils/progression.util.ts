import { getAvatarsUnlockedBetween } from '../../users/constants/avatars';
import { getCategoriesUnlockedBetween } from '../constants/categories';
import { getLevelFromXp } from './level.util';

/**
 * Ce que gagne un joueur en fin de partie : niveaux et déblocages, à partir de
 * son XP avant la partie. Fonction pure : l'incrément d'XP lui-même reste dans la
 * transaction de l'appelant (solo, ou fin de partie multijoueur).
 */
export function getProgression(xpBefore: number, xpEarned: number) {
	const previousLevel = getLevelFromXp(xpBefore);
	const level = getLevelFromXp(xpBefore + xpEarned);

	return {
		xpEarned,
		previousLevel,
		level,
		leveledUp: level > previousLevel,
		// Ids only — the client owns the localized labels
		unlockedCategoryIds: getCategoriesUnlockedBetween(previousLevel, level).map(
			(c) => c.id,
		),
		// Slugs only — the client owns the images
		unlockedAvatarSlugs: getAvatarsUnlockedBetween(previousLevel, level).map(
			(a) => a.slug,
		),
	};
}
