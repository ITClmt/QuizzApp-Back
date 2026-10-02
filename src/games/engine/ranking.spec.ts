import { rankPlayers } from './ranking';

const p = (id: string, score: number, abandoned = false) => ({
	id,
	score,
	abandoned,
});

describe('rankPlayers', () => {
	it('classe par score décroissant', () => {
		const ranking = rankPlayers([p('a', 3), p('b', 9), p('c', 5)]);

		expect(ranking.map((r) => [r.id, r.rank, r.isWinner])).toEqual([
			['b', 1, true],
			['c', 2, false],
			['a', 3, false],
		]);
	});

	it('égalités : même rang, le suivant saute, plusieurs gagnants', () => {
		const ranking = rankPlayers([p('a', 10), p('b', 7), p('c', 10)]);

		expect(ranking.map((r) => [r.id, r.rank, r.isWinner])).toEqual([
			['a', 1, true],
			['c', 1, true],
			['b', 3, false],
		]);
	});

	it('les abandons passent à la fin, sans rang, même avec un meilleur score', () => {
		const ranking = rankPlayers([p('a', 12, true), p('b', 4)]);

		expect(ranking.map((r) => [r.id, r.rank, r.isWinner])).toEqual([
			['b', 1, true],
			['a', null, false],
		]);
	});
});
