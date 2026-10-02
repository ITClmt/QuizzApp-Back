// Liste blanche d'origines (séparées par des virgules) pour le build web.
// Non défini = tout est accepté : c'est le comportement voulu en dev, et les clients
// natifs n'envoient de toute façon pas d'en-tête Origin.
export function corsOrigin() {
	const allowed = (process.env.CORS_ORIGINS ?? '')
		.split(',')
		.map((o) => o.trim())
		.filter(Boolean);

	if (allowed.length === 0) return true;

	return (
		origin: string | undefined,
		callback: (err: Error | null, allow?: boolean) => void,
	) => {
		// Refus silencieux (false) plutôt qu'une Error : le navigateur bloque de toute
		// façon faute d'en-tête Access-Control-Allow-Origin, et on évite un 500 + stack
		// trace dans les logs à chaque requête d'une origine inconnue.
		callback(null, !origin || allowed.includes(origin));
	};
}
