export interface SanitizedQuestion {
	id: string;
	questionEn: string;
	questionFr: string | null;
	answers: string[];
	category: string;
	difficulty: string;
}
