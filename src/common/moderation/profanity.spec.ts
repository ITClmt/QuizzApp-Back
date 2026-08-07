import { containsForbiddenWord } from './profanity';

describe('containsForbiddenWord', () => {
	it('blocks known English slurs/profanity', () => {
		expect(containsForbiddenWord('fuck')).toBe(true);
	});

	it('blocks known French slurs/profanity (with leetspeak/accent/case evasion)', () => {
		expect(containsForbiddenWord('connard')).toBe(true);
		expect(containsForbiddenWord('c0nn4rd')).toBe(true);
		expect(containsForbiddenWord('salope')).toBe(true);
	});

	it('does not flag legitimate names containing a forbidden substring (Scunthorpe problem)', () => {
		expect(containsForbiddenWord('Cassandra')).toBe(false);
		expect(containsForbiddenWord('Constance')).toBe(false);
		expect(containsForbiddenWord('Connor')).toBe(false);
		expect(containsForbiddenWord('Assassin')).toBe(false);
		expect(containsForbiddenWord('meuf')).toBe(false);
	});

	it('allows clean usernames', () => {
		expect(containsForbiddenWord('QuizMaster42')).toBe(false);
		expect(containsForbiddenWord('Clement')).toBe(false);
	});
});
