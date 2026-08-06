export interface QuizCategory {
	id: string;
	name: string;
	unlockLevel: number;
}

/**
 * Above MAX_LEVEL (50), so the category can never be unlocked. Used to sideline
 * categories whose OTD question pool is too small for a 50-question game on any
 * difficulty (verified 2026-08-05 via OTD's api_count.php — see CLAUDE.md).
 */
export const SIDELINED_UNLOCK_LEVEL = 101;

export const QUIZ_CATEGORIES: QuizCategory[] = [
	{ id: '9', name: 'General Knowledge', unlockLevel: 0 },
	// hard only has 49 questions
	{ id: '11', name: 'Film', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '12', name: 'Music', unlockLevel: 1 },
	{ id: '15', name: 'Video Games', unlockLevel: 2 },
	{ id: '22', name: 'Geography', unlockLevel: 3 },
	{ id: '21', name: 'Sports', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '23', name: 'History', unlockLevel: 4 },
	{ id: '27', name: 'Animals', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '17', name: 'Science & Nature', unlockLevel: 5 },
	{ id: '14', name: 'Television', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '26', name: 'Celebrities', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '20', name: 'Mythology', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '25', name: 'Art', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '28', name: 'Vehicles', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '10', name: 'Books', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '18', name: 'Computers', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '29', name: 'Comics', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '32', name: 'Cartoon & Animations', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '31', name: 'Japanese Anime & Manga', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '16', name: 'Board Games', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '24', name: 'Politics', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '19', name: 'Mathematics', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '13', name: 'Musicals & Theatres', unlockLevel: SIDELINED_UNLOCK_LEVEL },
	{ id: '30', name: 'Gadgets', unlockLevel: SIDELINED_UNLOCK_LEVEL },
];

export const QUIZ_CATEGORY_IDS = QUIZ_CATEGORIES.map((c) => c.id);

export function isCategoryUnlocked(categoryId: string, level: number): boolean {
	const category = QUIZ_CATEGORIES.find((c) => c.id === categoryId);
	return category ? level >= category.unlockLevel : false;
}
