/** Clé unique d'une paire d'utilisateurs, indépendante du sens de la demande */
export function pairKey(a: string, b: string): string {
	return a < b ? `${a}:${b}` : `${b}:${a}`;
}
