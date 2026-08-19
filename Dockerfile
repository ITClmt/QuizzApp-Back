# syntax=docker/dockerfile:1

# ---------- base ----------
FROM node:22-slim AS base
# openssl : requis par le moteur de migration Prisma (`migrate deploy`),
# absent de l'image slim.
RUN apt-get update -y \
	&& apt-get install -y --no-install-recommends openssl ca-certificates \
	&& rm -rf /var/lib/apt/lists/*
RUN npm install -g pnpm@10
WORKDIR /app

# ---------- dépendances (dev + prod) ----------
FROM base AS deps
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# ---------- dev : cible utilisée par docker-compose ----------
# Le code est bind-monté par le compose, cette copie ne sert qu'à faire tourner
# `prisma generate` au build de l'image.
FROM deps AS dev
COPY . .
RUN pnpm prisma generate
EXPOSE 3000
CMD ["sh", "-c", "pnpm prisma migrate deploy && pnpm start:dev"]

# ---------- build ----------
FROM deps AS build
COPY . .
RUN pnpm prisma generate
RUN pnpm build

# ---------- prod : cible par défaut (celle que Dokploy construit) ----------
FROM base AS runner
ENV NODE_ENV=production
# Le CLI prisma reste installé : `migrate deploy` tourne au démarrage du conteneur.
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY prisma ./prisma
COPY prisma.config.ts ./
COPY --from=build /app/dist ./dist
EXPOSE 3000
CMD ["sh", "-c", "pnpm prisma migrate deploy && node dist/main"]
