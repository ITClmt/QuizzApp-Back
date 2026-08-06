export interface SanitizedQuestion {
	id: string;
	question: string;
	answers: string[];
	correctIndex: number;
	category: string;
	difficulty: string;
}
