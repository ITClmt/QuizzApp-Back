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

	// unlockable/ — gated by level; ordered here from cheapest to priciest
	{ slug: 'honey-bunny', unlockLevel: 6 },
	// Pas de niveau 7 : le lapin violet doublonnait le "purple-bunny" gratuit — retire.
	// Pas de niveau 8 : sky-blob retire a la demande (2026-08-10).
	{ slug: 'blue-sprout', unlockLevel: 9 },
	{ slug: 'smoke-ghost', unlockLevel: 10 },
	{ slug: 'honey-monster', unlockLevel: 11 },
	{ slug: 'gold-blob', unlockLevel: 12 },
	{ slug: 'moss-monster', unlockLevel: 13 },
	{ slug: 'amber-cyclops', unlockLevel: 14 },
	{ slug: 'rune-golem', unlockLevel: 15 },
	// Pas de niveau 16 : le demon rouge doublonnait les "red-devil"/"red-tail-devil"
	// gratuits — retire.
	{ slug: 'ember-triclops', unlockLevel: 17 },
	{ slug: 'jade-triclops', unlockLevel: 18 },
	{ slug: 'mint-devil', unlockLevel: 19 },
	{ slug: 'leaf-sprite', unlockLevel: 20 },
	{ slug: 'phoenix', unlockLevel: 21 },
	{ slug: 'starry-cyclops', unlockLevel: 22 },
	{ slug: 'sparkle-cyclops', unlockLevel: 23 },
	{ slug: 'blue-flame', unlockLevel: 24 },
	{ slug: 'emerald-sparkle', unlockLevel: 25 },
	{ slug: 'opal-ghost', unlockLevel: 26 },
	{ slug: 'stardust-puff', unlockLevel: 27 },
	{ slug: 'crystal-golem', unlockLevel: 28 },
	{ slug: 'storm-monster', unlockLevel: 29 },
	// Pas de niveau 30 : le nuage galaxie prevu ici doublonnait visuellement
	// Epic_Spacey (special/, attribue a la main) — retire du catalogue.
	{ slug: 'steam-robot', unlockLevel: 31 },
	{ slug: 'copper-robot', unlockLevel: 32 },
	{ slug: 'monster-king', unlockLevel: 33 },

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
