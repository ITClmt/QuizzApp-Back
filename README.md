# Quizzly — Backend

API REST (NestJS) pour Quizzly, une app de quiz mobile. Sert l'auth, les questions, les sessions de jeu, le score et le classement au client React Native de [`Front-React-Native/QuizzApp`](../Front-React-Native/QuizzApp).

Projet perso avant tout **prétexte pour apprendre** :
- construire une API REST complète et réaliste avec NestJS + Prisma/PostgreSQL (auth JWT, rate limiting, RBAC, modération de contenu...)
- mener un workflow de développement assisté par IA (Claude Code et consorts) sur la durée — `CLAUDE.md` comme mémoire vivante du projet, délégation à des agents, revue de code, itération en boucle

Stack : NestJS, Prisma + PostgreSQL, JWT (access + refresh), Argon2, pnpm. Détails techniques dans [`CLAUDE.md`](./CLAUDE.md).

## Démarrer

```bash
pnpm install
pnpm start:dev
```
