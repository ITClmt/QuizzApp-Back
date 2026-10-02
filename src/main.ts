import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { corsOrigin } from './common/cors';
import { SocketIoAdapter } from './games/socket-io.adapter';

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
	// Même liste blanche pour le socket.io des parties multijoueur
	app.useWebSocketAdapter(new SocketIoAdapter(app));
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
