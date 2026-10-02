interface Rankable {
	score: number;
	abandoned: boolean;
}

export type Ranked<T extends Rankable> = T & {
	/** null pour un abandon : classé après tout le monde, sans rang */
	rank: number | null;
	isWinner: boolean;
};

/**
 * Classement « olympique » : à égalité, même rang, et le suivant saute
 * (10, 10, 7 → 1, 1, 3). Tous les premiers sont gagnants. Les abandons sont
 * listés à la fin, sans rang ni victoire possible.
 */
export function rankPlayers<T extends Rankable>(players: T[]): Ranked<T>[] {
	const finishers = players
		.filter((p) => !p.abandoned)
		.sort((a, b) => b.score - a.score);
	const abandoned = players.filter((p) => p.abandoned);

	const ranked = finishers.map((p) => {
		const rank = 1 + finishers.filter((o) => o.score > p.score).length;
		return { ...p, rank, isWinner: rank === 1 };
	});

	return [
		...ranked,
		...abandoned.map((p) => ({ ...p, rank: null, isWinner: false })),
	];
}
