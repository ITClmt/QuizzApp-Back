export interface Avatar {
	/** Matches the file name (without extension) bundled in the client's assets/images/profile_pics */
	slug: string;
	unlockLevel: number;
}

/**
 * Above MAX_LEVEL (50), so the avatar can never be unlocked through PATCH /users/:id —
 * not even by an ADMIN. Used for avatars only ever set directly in the database (see
 * prisma/seed.ts); same idea as SIDELINED_UNLOCK_LEVEL for quiz categories.
 */
export const HIDDEN_UNLOCK_LEVEL = 101;

/** Applied by the DB to new accounts, and used as the client's fallback for an unknown slug */
export const DEFAULT_AVATAR_SLUG = 'yellow-cyclops';

export const AVATARS: Avatar[] = [
	// free/ — no unlock condition
	{ slug: 'blue-blob', unlockLevel: 0 },
	{ slug: 'blue-bunny', unlockLevel: 0 },
	{ slug: 'blue-cyclops', unlockLevel: 0 },
	{ slug: 'blue-fuzzy', unlockLevel: 0 },
	{ slug: 'brown-cyclops', unlockLevel: 0 },
	{ slug: 'crimson-monster', unlockLevel: 0 },
	{ slug: 'green-furry', unlockLevel: 0 },
	{ slug: 'green-horned', unlockLevel: 0 },
	{ slug: 'green-spotted', unlockLevel: 0 },
	{ slug: 'orange-bat', unlockLevel: 0 },
	{ slug: 'pink-horned', unlockLevel: 0 },
	{ slug: 'pink-star-eyes', unlockLevel: 0 },
	{ slug: 'purple-blob', unlockLevel: 0 },
	{ slug: 'purple-bunny', unlockLevel: 0 },
	{ slug: 'purple-worm', unlockLevel: 0 },
	{ slug: 'red-devil', unlockLevel: 0 },
	{ slug: 'red-flame', unlockLevel: 0 },
	{ slug: 'red-tail-devil', unlockLevel: 0 },
	{ slug: 'teal-four-arms', unlockLevel: 0 },
	{ slug: 'teal-sprout', unlockLevel: 0 },
	{ slug: 'water-drop', unlockLevel: 0 },
	{ slug: 'yellow-chick', unlockLevel: 0 },
	{ slug: 'yellow-cyclops', unlockLevel: 0 },

	// special/ — DB-only, never reachable through PATCH /users/:id
	{ slug: 'Epic_Spacey', unlockLevel: HIDDEN_UNLOCK_LEVEL },
];

/** Every slug the API validates as a known avatar — the hidden ones included */
export const AVATAR_SLUGS = AVATARS.map((a) => a.slug);

/** What the avatar picker shows: everything obtainable by playing, locked or not */
export const SELECTABLE_AVATARS = AVATARS.filter(
	(a) => a.unlockLevel !== HIDDEN_UNLOCK_LEVEL,
);

// `catalog` param exists for the specs to inject a fixture — callers always use the default.
export function isAvatarUnlocked(
	slug: string,
	level: number,
	catalog: Avatar[] = AVATARS,
): boolean {
	const avatar = catalog.find((a) => a.slug === slug);
	return avatar ? level >= avatar.unlockLevel : false;
}

export function getAvatarsUnlockedBetween(
	previousLevel: number,
	newLevel: number,
	catalog: Avatar[] = SELECTABLE_AVATARS,
): Avatar[] {
	if (newLevel <= previousLevel) return [];
	return catalog.filter(
		(a) => a.unlockLevel > previousLevel && a.unlockLevel <= newLevel,
	);
}
