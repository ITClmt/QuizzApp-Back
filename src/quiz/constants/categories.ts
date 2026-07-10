export interface QuizCategory {
	id: string;
	name: string;
	unlockLevel: number;
}

export const QUIZ_CATEGORIES: QuizCategory[] = [
	{ id: '9', name: 'General Knowledge', unlockLevel: 0 },
	{ id: '10', name: 'Entertainment: Books', unlockLevel: 3 },
	{ id: '11', name: 'Entertainment: Film', unlockLevel: 0 },
	{ id: '12', name: 'Entertainment: Music', unlockLevel: 0 },
	{ id: '13', name: 'Entertainment: Musicals & Theatres', unlockLevel: 6 },
	{ id: '14', name: 'Entertainment: Television', unlockLevel: 4 },
	{ id: '15', name: 'Entertainment: Video Games', unlockLevel: 0 },
	{ id: '16', name: 'Entertainment: Board Games', unlockLevel: 5 },
	{ id: '17', name: 'Science & Nature', unlockLevel: 0 },
	{ id: '18', name: 'Science: Computers', unlockLevel: 4 },
	{ id: '19', name: 'Science: Mathematics', unlockLevel: 5 },
	{ id: '20', name: 'Mythology', unlockLevel: 3 },
	{ id: '21', name: 'Sports', unlockLevel: 0 },
	{ id: '22', name: 'Geography', unlockLevel: 0 },
	{ id: '23', name: 'History', unlockLevel: 0 },
	{ id: '24', name: 'Politics', unlockLevel: 6 },
	{ id: '25', name: 'Art', unlockLevel: 3 },
	{ id: '26', name: 'Celebrities', unlockLevel: 2 },
	{ id: '27', name: 'Animals', unlockLevel: 0 },
	{ id: '28', name: 'Vehicles', unlockLevel: 4 },
	{ id: '29', name: 'Entertainment: Comics', unlockLevel: 3 },
	{ id: '30', name: 'Science: Gadgets', unlockLevel: 5 },
	{ id: '31', name: 'Entertainment: Japanese Anime & Manga', unlockLevel: 3 },
	{ id: '32', name: 'Entertainment: Cartoon & Animations', unlockLevel: 2 },
];

export const QUIZ_CATEGORY_IDS = QUIZ_CATEGORIES.map((c) => c.id);

export function isCategoryUnlocked(categoryId: string, level: number): boolean {
	const category = QUIZ_CATEGORIES.find((c) => c.id === categoryId);
	return category ? level >= category.unlockLevel : false;
}
