# QuizzApp — Backend

NestJS REST API for a quiz mobile app (React Native client).

## Stack

- **Framework:** NestJS v11 (TypeScript)
- **ORM:** Prisma v7 + PostgreSQL
- **Auth:** JWT (access + refresh tokens) + Argon2 password hashing
- **Validation:** class-validator / class-transformer (global ValidationPipe)
- **Security:** Helmet, ThrottlerGuard (global), `obscenity` (username profanity/slur filter)
- **Scheduler:** @nestjs/schedule (token cleanup cron)
- **Package manager:** pnpm

## Commands

```bash
pnpm start:dev          # dev with hot reload
pnpm build              # compile
pnpm start:prod         # run compiled dist
pnpm lint               # Biome check + fix
pnpm format             # Biome format

pnpm prisma migrate dev --name <name>   # create + apply migration
pnpm prisma generate                    # regenerate client after schema change — NOT optional
pnpm prisma studio                      # GUI explorer
```

## Project structure

```
src/
├── main.ts                  # Bootstrap: Helmet, ValidationPipe, global prefix /api
├── app.module.ts            # Root module: ThrottlerModule, ScheduleModule, ConfigModule
├── app.controller.ts        # GET /health (public)
├── auth/                    # JWT auth
│   ├── auth.controller.ts   # /auth — login, register, refresh, logout
│   ├── auth.service.ts
│   ├── token-cleanup.service.ts  # Cron every 6h: deletes expired refresh tokens
│   ├── guards/
│   │   ├── auth.guard.ts    # Global JWT guard — reads Bearer token, sets req.user
│   │   └── role.guard.ts    # RBAC guard — used with @Roles()
│   └── decorators/
│       ├── public.decorator.ts       # @Public() — bypasses auth.guard
│       ├── roles.decorator.ts        # @Roles(Role.ADMIN)
│       └── current-user.decorator.ts # @CurrentUser() — injects JwtPayload from req.user
├── users/                   # User CRUD
│   ├── users.controller.ts  # PATCH/DELETE protected by assertOwnerOrAdmin()
│   └── dto/
│       ├── create-user.dto.ts   # email, username, password (min 8 / max 128), lang
│       └── update-user.dto.ts   # email, username, lang only — password change NOT supported
├── quiz/                    # Quiz sessions
│   ├── quiz.controller.ts   # start, finish, cancel session + validateAnswer
│   └── quiz.service.ts      # serves questions from the local Question pool, manages SoloSession
├── score/                   # Scores & leaderboard
│   ├── score.controller.ts
│   └── dto/
│       └── leaderboard-query.dto.ts  # @IsEnum(Difficulty) — required
├── friends/                 # Friend requests & friend list
│   ├── friends.service.ts   # exports assertAllFriends() for multiplayer games
│   └── utils/pair-key.ts    # "<minId>:<maxId>" — one Friendship row per pair
└── prisma/                  # PrismaService wrapper
```

## Auth flow

All routes are protected by `AuthGuard` globally (set in `AuthModule`).  
Use `@Public()` to opt out.

```
POST /api/auth/register   @Public()
POST /api/auth/login      @Public()  — rate limited: 5 req / 15 min
POST /api/auth/refresh    @Public()
POST /api/auth/logout
```

Access token: short-lived JWT (Bearer).  
Refresh token: 7-day JWT, stored hashed in DB, rotated on each use, checked against `expiresAt`.

## Rate limiting

Configured in `ThrottlerModule` (app.module.ts) — a **single** named throttler:

| Throttler | TTL | Default limit |
|---|---|---|
| `default` | 60s | 600 req |

Deliberately only one throttler is registered. `ThrottlerGuard` is global (`APP_GUARD`),
and every named throttler in `forRoot()` applies to **every route by default** — a route
is NOT scoped to only the throttlers it references via `@Throttle()`. A second `auth`
bucket (10 req/15min) used to exist for login/register/refresh, but because nothing
opted the other controllers out, it silently rate-limited the *entire* API to 10
req/15min, not just `/auth/*` — this caused hard-to-diagnose bugs (stale XP bar,
leaderboard "fail to load") that only a container restart would clear (in-memory
counters, no Redis). Fixed 2026-08-05 by removing the second bucket entirely and
tightening the single `default` throttler per-route instead: `AuthController`'s
`login`/`register`/`refresh`/`logout` handlers each carry their own
`@Throttle({ default: { limit, ttl } })` override (5/15min for login, 10/15min for the
others); `GET /users/me` and every other controller are left undecorated and simply use
the loose 600/60s default. **Prefer this pattern going forward — per-route `@Throttle()`
overrides on the single `default` throttler — over adding another named throttler**,
since a new named throttler again applies everywhere unless every other controller is
updated to skip it.

Polling-style GETs like `/users/me` are refetched on React Navigation focus by
several screens (Navbar, Profile, Home, Leaderboard) — keep this in mind before adding
more focus-triggered refetches, even against the looser 600/60s default.

## API routes

```
GET    /api/health                        @Public()

POST   /api/auth/register                 @Public()
POST   /api/auth/login                    @Public() — 5 req/15min
POST   /api/auth/refresh                  @Public()
POST   /api/auth/logout

GET    /api/users                         @Roles(ADMIN)
GET    /api/users/avatars                 avatar catalog + unlock status per user level
GET    /api/users/me                      current user's own profile + pendingFriendRequests (profile badge)
GET    /api/users/:id
PATCH  /api/users/:id                     owner or ADMIN only
DELETE /api/users/:id                     owner or ADMIN only

GET    /api/quiz/categories                curated OTD subset, unlock status per user level
GET    /api/quiz/questions                ?difficulty&category
POST   /api/quiz/start                    ?difficulty&category
POST   /api/quiz/finish
POST   /api/quiz/cancel
POST   /api/quiz/answer
GET    /api/quiz/history                  ?cursor&limit — cursor-paginated list of the caller's past sessions
GET    /api/quiz/history/:sessionId       detail of one past session

GET    /api/score/user/:id                ParseUUIDPipe — scores are public
GET    /api/score/leaderboard             ?difficulty (required, IsEnum)
GET    /api/score/leaderboard/global      top 10 by XP
GET    /api/score/my-rank                 ?difficulty (required, IsEnum)
GET    /api/score/my-rank/global          rank by XP

GET    /api/friends                       accepted friends, sorted by username
GET    /api/friends/requests              { received, sent } pending requests
GET    /api/friends/search                ?q (2–20 chars) — accent/case-insensitive (Postgres `unaccent`, raw SQL), 10 results max, with caller's relation — 30 req/min
POST   /api/friends/requests              { userId } — auto-accepts a crossed request — 20 req/min
POST   /api/friends/requests/:id/accept   receiver only
DELETE /api/friends/requests/:id          decline (receiver) or cancel (requester) — deletes the row
DELETE /api/friends/:userId               remove a friend

POST   /api/games                         { friendIds (1–3, accepted friends), difficulty? (absent = mixed) } — 15 random questions; cancels/leaves the caller's WAITING lobbies, 409 ALREADY_IN_GAME if PLAYING — 10 req/min
GET    /api/games/invitations             caller's INVITED rows in WAITING games younger than 10 min, with host public profile
GET    /api/games/active                  { game: { id, status } | null } — WAITING/PLAYING game the caller has JOINED (resume after app kill)
POST   /api/games/:id/decline             INVITED → DECLINED (204), 404 INVITATION_NOT_FOUND otherwise
```

## Database schema (key models)

- **User** — `username` (unique), `email` (unique), `role` (USER|ADMIN), `lang`, `xp` (uncapped, drives the derived level via `src/quiz/utils/level.util.ts`, capped display at level 50)
- **RefreshToken** — hashed token, `expiresAt`, cascade delete on user
- **Question** — harvested offline from OpenTriviaDB via `local-scripts/harvest-otd-questions.ts` (translated to FR via DeepL), upserted by `sourceId`. Indexed on `(difficulty)`, `(category)`, `(category, difficulty)`. `category` stores OTD's display name (mapped from the route's numeric category id via `getCategoryOtdName` in `src/quiz/constants/categories.ts`)
- **Tag** — internal sub-category (`slug` unique, e.g. `football`, `ligue-1`), never shown to players. Many-to-many with Question (implicit relation, table `_QuestionToTag`), 0..n tags per question. Free-floating: not tied to `Question.category`, so one tag can span several categories. OTD-harvested questions have no tags; tags come from `local-scripts/generate-questions.ts` (Gemini, review in `generated/pending.json`, then `import-questions.ts`, which also rejects any category outside `QUIZ_CATEGORIES`)
- **SoloSession** — status: IN_PROGRESS | FINISHED | EXPIRED. Indexed on `(userId, status)`, `(status, expiresAt)`
- **SoloAnswer** — unique `(sessionId, questionId)`
- **Score** — unique `(userId, difficulty)`, upserted on session finish. Indexed on `(difficulty, value)` for leaderboard
- **Friendship** — status PENDING | ACCEPTED (no DECLINED: declining/cancelling deletes the row, so the request can be re-sent). `pairKey` (`@unique`, sorted ids) guarantees one row per pair whatever the direction — crossed simultaneous requests hit P2002 and resolve to an accept. Limits: 50 pending sent, 200 friends. Public user shape exposed: `{ id, username, avatarSlug, level }` — never email or raw XP
- **Game** — status WAITING | PLAYING | FINISHED | CANCELED, `difficulty` (null = mixed), `code` nullable (reserved for join-by-code). Live game state is in memory only (single instance): `GamesService.onApplicationBootstrap` sets every WAITING/PLAYING game to CANCELED, since each deploy kills them
- **GamePlayer** — status INVITED | JOINED | DECLINED | LEFT (an invitation *is* an INVITED GamePlayer, no separate table), `score` = correct answers, `xpEarned`. One active game per player: creating a game cancels the lobbies you host and leaves the ones you joined
- **GameQuestion** — the 15 questions drawn at creation, `order` 0–14. **GameAnswer** — unique `(gamePlayerId, gameQuestionId)`, no row = no answer; `responseMs` is display-only, never scored

## Key conventions

- DTOs use `class-validator`. `ValidationPipe` has `whitelist: true` + `forbidNonWhitelisted: true` — unknown fields are rejected with 400.
- `username` in `CreateUserDto`/`UpdateUserDto` is checked against a profanity/slur filter via the `@IsNotForbiddenWord()` custom validator (`src/common/validators/is-not-forbidden-word.decorator.ts`). Matching engine: `obscenity` (`src/common/moderation/profanity.ts`), combining its built-in English dataset with a French word list sourced from the community LDNOOBW repo (`src/common/moderation/forbidden-words.fr.ts`, with a few upstream entries dropped as Scunthorpe-style false positives — see file comment). French words are matched whole-word only (`|word|` boundary patterns) and accent-normalized via a custom transformer, since `obscenity`'s built-in transformers are ASCII-only. Perspective API (Google/Jigsaw) was considered and rejected: it's sunsetting (service ends 2026-12-31, no new quota requests accepted since 2026-02), needs a synchronous external call on the register path, and its toxicity model isn't tuned for single-token strings like usernames.
- Password changes are **not supported** via PATCH /users/:id. Requires a dedicated endpoint (not yet implemented).
- Avatars follow the same architecture as quiz categories: a static catalog in code
  (`src/users/constants/avatars.ts`) with a per-avatar `unlockLevel`, and ownership **derived**
  from `getLevelFromXp(user.xp)` — never persisted, so there is no unlock table to migrate or
  re-sync when avatars are added. Split of responsibility on `PATCH /users/:id`: `UpdateUserDto`
  only checks the slug **exists** (`@IsIn(AVATAR_SLUGS)` → 400), while `UsersService.update()`
  checks the caller may **wear** it (`isAvatarUnlocked` against the target's level → 403
  `AVATAR_LOCKED`). Hand-granted avatars (`HIDDEN_UNLOCK_LEVEL`, above `MAX_LEVEL` — e.g.
  `Epic_Spacey`) sit above every reachable level, so no one can unlock them through this endpoint,
  admins included; they're excluded from `SELECTABLE_AVATARS` so they never show up in the picker,
  and are only ever set directly in the database (see `prisma/seed.ts`). The client owns the
  images (`constants/avatars.ts` maps slug → bundled PNG), the server owns the unlock rules.
- `lang` on quiz sessions comes from the account's `User.lang`, read fresh from the DB in `QuizController` (`UsersService.getUserLang`) rather than trusted from the JWT — the JWT claim is only a snapshot from token issuance and goes stale as soon as the user changes their language preference, until the next token refresh. Once a session is created, `SoloSession.lang` snapshots the value for that session's lifetime. French accounts get `questionFr`/`answersFr` when present, falling back to EN per-question if a translation is missing.
- XP: 7/14/28 per correct easy/medium/hard answer (`src/quiz/constants/xp.ts`), awarded in `QuizService.finishSession`. Level is a pure function of XP (`getLevelFromXp`, quadratic curve, capped display at 50) — no anti-grind yet, deliberately deferred.
- Quiz questions are served straight from the local `Question` pool (no live OpenTriviaDB call at request time) — empty result sets return `404 NotFoundException`.
- Linter: Biome (not ESLint). Run `pnpm lint` before committing.
- ⚠️ **`@default(...)` values are applied by the Prisma *client*, not by Postgres.** The generated
  client embeds a full copy of `schema.prisma` (`inlineSchema` in `src/generated/prisma/internal/`)
  and fills defaults from it, so it sends the value explicitly on insert and the column's DB default
  never gets a chance to apply. `prisma migrate dev` updates the database but does **not** always
  regenerate the client: after changing any `@default`, run `pnpm prisma generate` and rebuild, or
  the app keeps writing the old value against a correctly-migrated database (cost a real debugging
  session on the `avatarSlug` default, 2026-08-10).
