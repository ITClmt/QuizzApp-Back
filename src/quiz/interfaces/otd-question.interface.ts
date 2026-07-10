export interface OtdQuestion {
	type: string;
	difficulty: string;
	category: string;
	question: string;
	correct_answer: string;
	incorrect_answers: string[];
}

export interface OtdResponse {
	response_code: number;
	results: OtdQuestion[];
}
