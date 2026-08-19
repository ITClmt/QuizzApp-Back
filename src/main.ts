import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import helmet from 'helmet';
import { AppModule } from './app.module';

// Liste blanche d'origines (séparées par des virgules) pour le build web.
// Non défini = tout est accepté : c'est le comportement voulu en dev, et les clients
// natifs n'envoient de toute façon pas d'en-tête Origin.
function corsOrigin() {
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

async function bootstrap() {
	const app = await NestFactory.create<NestExpressApplication>(AppModule);

	// Derrière le reverse proxy de Dokploy (Traefik), req.ip vaut sinon l'IP du proxy :
	// le ThrottlerGuard mettrait alors tous les utilisateurs dans le même compteur et le
	// 5 req/15min de /auth/login verrouillerait tout le monde d'un coup.
	// À laisser à 0 hors production, sinon X-Forwarded-For devient falsifiable.
	app.set('trust proxy', Number(process.env.TRUST_PROXY ?? 0));

	app.enableCors({
		origin: corsOrigin(),
		methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
		allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
	});
	app.use(
		helmet({
			crossOriginResourcePolicy: false,
		}),
	);
	app.useGlobalPipes(
		new ValidationPipe({
			whitelist: true,
			forbidNonWhitelisted: true,
			transform: true,
		}),
	);
	app.setGlobalPrefix('api');
	await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
