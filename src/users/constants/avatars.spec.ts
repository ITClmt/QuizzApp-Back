import { MAX_LEVEL } from 'src/quiz/utils/level.util';
import {
	AVATAR_SLUGS,
	type Avatar,
	getAvatarsUnlockedBetween,
	HIDDEN_UNLOCK_LEVEL,
	isAvatarUnlocked,
	SELECTABLE_AVATARS,
} from './avatars';

// Fixture, not the real catalog: every shipped avatar is at unlockLevel 0 today,
// so the level boundaries have nothing to bite on until gated avatars are added.
const FIXTURE: Avatar[] = [
	{ slug: 'free-one', unlockLevel: 0 },
	{ slug: 'gated-two', unlockLevel: 2 },
	{ slug: 'gated-four', unlockLevel: 4 },
	{ slug: 'gated-seven', unlockLevel: 7 },
	{ slug: 'hidden-one', unlockLevel: HIDDEN_UNLOCK_LEVEL },
];

describe('avatars catalog', () => {
	it('has unique slugs', () => {
		expect(new Set(AVATAR_SLUGS).size).toBe(AVATAR_SLUGS.length);
	});

	it('keeps hand-granted avatars out of the picker but valid for the API', () => {
		expect(SELECTABLE_AVATARS.some((a) => a.slug === 'Epic_Spacey')).toBe(
			false,
		);
		expect(AVATAR_SLUGS).toContain('Epic_Spacey');
	});

	it('ships every free avatar unlocked from level 0', () => {
		for (const avatar of SELECTABLE_AVATARS) {
			expect(isAvatarUnlocked(avatar.slug, 0)).toBe(true);
		}
	});

	describe('isAvatarUnlocked', () => {
		it('unlocks at the exact level, not below', () => {
			expect(isAvatarUnlocked('gated-two', 1, FIXTURE)).toBe(false);
			expect(isAvatarUnlocked('gated-two', 2, FIXTURE)).toBe(true);
			expect(isAvatarUnlocked('gated-two', 3, FIXTURE)).toBe(true);
		});

		it('never unlocks a hidden avatar, even at max level', () => {
			expect(HIDDEN_UNLOCK_LEVEL).toBeGreaterThan(MAX_LEVEL);
			expect(isAvatarUnlocked('hidden-one', MAX_LEVEL, FIXTURE)).toBe(false);
			expect(isAvatarUnlocked('Epic_Spacey', MAX_LEVEL)).toBe(false);
		});

		it('rejects an unknown slug', () => {
			expect(isAvatarUnlocked('does-not-exist', MAX_LEVEL)).toBe(false);
		});
	});

	describe('getAvatarsUnlockedBetween', () => {
		it('returns nothing when the level did not increase', () => {
			expect(getAvatarsUnlockedBetween(5, 5, FIXTURE)).toEqual([]);
			expect(getAvatarsUnlockedBetween(5, 3, FIXTURE)).toEqual([]);
		});

		it('returns every avatar crossed by a multi-level jump', () => {
			expect(
				getAvatarsUnlockedBetween(1, 5, FIXTURE).map((a) => a.slug),
			).toEqual(['gated-two', 'gated-four']);
		});

		it('excludes the level already reached and includes the new one', () => {
			expect(
				getAvatarsUnlockedBetween(2, 4, FIXTURE).map((a) => a.slug),
			).toEqual(['gated-four']);
		});

		it('never returns a hand-granted avatar', () => {
			expect(
				getAvatarsUnlockedBetween(0, HIDDEN_UNLOCK_LEVEL).map((a) => a.slug),
			).not.toContain('Epic_Spacey');
		});
	});
});
