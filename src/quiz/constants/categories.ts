export interface QuizCategory {
	id: string;
	name: string;
	unlockLevel: number;
}

export const QUIZ_CATEGORIES: QuizCategory[] = [
	{ id: '9', name: 'General Knowledge', unlockLevel: 0 },
	{ id: '11', name: 'Film', unlockLevel: 0 },
	{ id: '12', name: 'Music', unlockLevel: 0 },
	{ id: '15', name: 'Video Games', unlockLevel: 0 },
	{ id: '22', name: 'Geography', unlockLevel: 0 },
	{ id: '21', name: 'Sports', unlockLevel: 1 },
	{ id: '23', name: 'History', unlockLevel: 2 },
	{ id: '27', name: 'Animals', unlockLevel: 3 },
	{ id: '17', name: 'Science & Nature', unlockLevel: 4 },
	{ id: '14', name: 'Television', unlockLevel: 5 },
	{ id: '26', name: 'Celebrities', unlockLevel: 6 },
	{ id: '20', name: 'Mythology', unlockLevel: 7 },
	{ id: '25', name: 'Art', unlockLevel: 8 },
	{ id: '28', name: 'Vehicles', unlockLevel: 9 },
	{ id: '10', name: 'Books', unlockLevel: 10 },
	{ id: '18', name: 'Computers', unlockLevel: 11 },
	{ id: '29', name: 'Comics', unlockLevel: 11 },
	{ id: '32', name: 'Cartoon & Animations', unlockLevel: 12 },
	{ id: '31', name: 'Japanese Anime & Manga', unlockLevel: 12 },
	{ id: '16', name: 'Board Games', unlockLevel: 13 },
	{ id: '24', name: 'Politics', unlockLevel: 13 },
	{ id: '19', name: 'Mathematics', unlockLevel: 14 },
	{ id: '13', name: 'Musicals & Theatres', unlockLevel: 14 },
	{ id: '30', name: 'Gadgets', unlockLevel: 15 },
];

export const QUIZ_CATEGORY_IDS = QUIZ_CATEGORIES.map((c) => c.id);

export function isCategoryUnlocked(categoryId: string, level: number): boolean {
	const category = QUIZ_CATEGORIES.find((c) => c.id === categoryId);
	return category ? level >= category.unlockLevel : false;
}
