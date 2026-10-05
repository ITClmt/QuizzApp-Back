export const GAME_QUESTIONS = 15;

// Amis invités par l'hôte : 2 à 4 joueurs au total
export const MIN_INVITED_FRIENDS = 1;
export const MAX_INVITED_FRIENDS = 3;

// Au-delà, un salon resté en WAITING est considéré comme abandonné
export const LOBBY_TIMEOUT_MS = 10 * 60 * 1000;

// Une partie : 2 à 4 joueurs. Il en faut au moins 2 en JOINED pour lancer.
export const MIN_PLAYERS_TO_START = 2;

export const QUESTION_MS = 12_000;
// Marge pour la latence : une réponse partie juste avant la fin doit encore compter
export const ANSWER_GRACE_MS = 500;
export const REVEAL_MS = 3_000;
// Plus aucun joueur connecté en cours de partie pendant ce délai : annulée
export const ABANDON_MS = 30_000;
