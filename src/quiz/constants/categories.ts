export interface QuizCategory {
	id: string;
	name: string;
	/** Value stored in Question.category — OTD's original category label, used to filter the local pool */
	otdName: string;
	unlockLevel: number;
}

/**
 * Above MAX_LEVEL (50), so the category can never be unlocked. Used to sideline
 * categories whose OTD question pool is too small for a 50-question game on any
 * difficulty (verified 2026-08-05 via OTD's api_count.php — see CLAUDE.md).
 */
export const SIDELINED_UNLOCK_LEVEL = 101;

export const QUIZ_CATEGORIES: QuizCategory[] = [
	{
		id: '9',
		name: 'General Knowledge',
		otdName: 'General Knowledge',
		unlockLevel: 0,
	},
	// hard only has 49 questions
	{
		id: '11',
		name: 'Film',
		otdName: 'Entertainment: Film',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{ id: '12', name: 'Music', otdName: 'Entertainment: Music', unlockLevel: 1 },
	{
		id: '15',
		name: 'Video Games',
		otdName: 'Entertainment: Video Games',
		unlockLevel: 2,
	},
	{ id: '22', name: 'Geography', otdName: 'Geography', unlockLevel: 3 },
	{
		id: '21',
		name: 'Sports',
		otdName: 'Sports',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{ id: '23', name: 'History', otdName: 'History', unlockLevel: 4 },
	{
		id: '27',
		name: 'Animals',
		otdName: 'Animals',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '17',
		name: 'Science & Nature',
		otdName: 'Science & Nature',
		unlockLevel: 5,
	},
	{
		id: '14',
		name: 'Television',
		otdName: 'Entertainment: Television',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '26',
		name: 'Celebrities',
		otdName: 'Celebrities',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '20',
		name: 'Mythology',
		otdName: 'Mythology',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '25',
		name: 'Art',
		otdName: 'Art',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '28',
		name: 'Vehicles',
		otdName: 'Vehicles',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '10',
		name: 'Books',
		otdName: 'Entertainment: Books',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '18',
		name: 'Computers',
		otdName: 'Science: Computers',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '29',
		name: 'Comics',
		otdName: 'Entertainment: Comics',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '32',
		name: 'Cartoon & Animations',
		otdName: 'Entertainment: Cartoon & Animations',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '31',
		name: 'Japanese Anime & Manga',
		otdName: 'Entertainment: Japanese Anime & Manga',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '16',
		name: 'Board Games',
		otdName: 'Entertainment: Board Games',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '24',
		name: 'Politics',
		otdName: 'Politics',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '19',
		name: 'Mathematics',
		otdName: 'Science: Mathematics',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '13',
		name: 'Musicals & Theatres',
		otdName: 'Entertainment: Musicals & Theatres',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
	{
		id: '30',
		name: 'Gadgets',
		otdName: 'Science: Gadgets',
		unlockLevel: SIDELINED_UNLOCK_LEVEL,
	},
];

export const QUIZ_CATEGORY_IDS = QUIZ_CATEGORIES.map((c) => c.id);

export const AVAILABLE_QUIZ_CATEGORIES = QUIZ_CATEGORIES.filter(
	(c) => c.unlockLevel !== SIDELINED_UNLOCK_LEVEL,
);

export function getCategoriesUnlockedBetween(
	previousLevel: number,
	newLevel: number,
): QuizCategory[] {
	if (newLevel <= previousLevel) return [];
	return AVAILABLE_QUIZ_CATEGORIES.filter(
		(c) => c.unlockLevel > previousLevel && c.unlockLevel <= newLevel,
	);
}

export function isCategoryUnlocked(categoryId: string, level: number): boolean {
	const category = QUIZ_CATEGORIES.find((c) => c.id === categoryId);
	return category ? level >= category.unlockLevel : false;
}

export function getCategoryOtdName(categoryId: string): string | undefined {
	return QUIZ_CATEGORIES.find((c) => c.id === categoryId)?.otdName;
}
