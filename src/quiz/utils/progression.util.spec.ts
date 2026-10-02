import { getAvatarsUnlockedBetween } from '../../users/constants/avatars';
import { MAX_LEVEL, xpForLevel } from './level.util';
import { getProgression } from './progression.util';

describe('getProgression', () => {
	it('sans gain : même niveau, rien de débloqué', () => {
		expect(getProgression(xpForLevel(4), 0)).toEqual({
			xpEarned: 0,
			previousLevel: 4,
			level: 4,
			leveledUp: false,
			unlockedCategoryIds: [],
			unlockedAvatarSlugs: [],
		});
	});

	it('passage de niveau : renvoie les déblocages entre les deux niveaux', () => {
		const result = getProgression(xpForLevel(3) - 1, 1);

		expect(result.previousLevel).toBe(2);
		expect(result.level).toBe(3);
		expect(result.leveledUp).toBe(true);
		// Geography (id 22) se débloque au niveau 3
		expect(result.unlockedCategoryIds).toContain('22');
		expect(result.unlockedAvatarSlugs).toEqual(
			getAvatarsUnlockedBetween(2, 3).map((a) => a.slug),
		);
	});

	it('plafonne au niveau max', () => {
		const result = getProgression(xpForLevel(MAX_LEVEL), 10_000);

		expect(result.level).toBe(MAX_LEVEL);
		expect(result.leveledUp).toBe(false);
		expect(result.unlockedCategoryIds).toEqual([]);
	});
});
