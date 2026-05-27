# QuizzApp — Backend

NestJS REST API for a quiz mobile app (React Native client).

## Stack

- **Framework:** NestJS v11 (TypeScript)
- **ORM:** Prisma v7 + PostgreSQL
- **Auth:** JWT (access + refresh tokens) + Argon2 password hashing
- **Validation:** class-validator / class-transformer (global ValidationPipe)
- **Security:** Helmet, ThrottlerGuard (global)
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
pnpm prisma generate                    # regenerate client after schema change
pnpm prisma studio                      # GUI explorer
```

## Project structure

```
src/
├── main.ts                  # Bootstrap: Helmet, ValidationPipe, global prefix /api
├── app.module.ts            # Root module: ThrottlerModule, ScheduleModule, ConfigModule
├── app.controller.ts        # GET /health (public)
├── auth/                    # JWT auth
│   ├── auth.controller.ts   # /auth — login, register, refresh, logout, profile
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
│   └── quiz.service.ts      # fetches from OpenTriviaDB, upserts questions, manages SoloSession
├── score/                   # Scores & leaderboard
│   ├── score.controller.ts
│   └── dto/
│       └── leaderboard-query.dto.ts  # @IsEnum(Difficulty) — required
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
GET  /api/auth/profile
```

Access token: short-lived JWT (Bearer).  
Refresh token: 7-day JWT, stored hashed in DB, rotated on each use, checked against `expiresAt`.

## Rate limiting

Configured in `ThrottlerModule` (app.module.ts):

| Throttler | TTL | Limit |
|---|---|---|
| `global` | 60s | 60 req |
| `auth` | 15 min | 10 req |
| `login` (override) | 15 min | 5 req |

Auth controller applies `@Throttle({ auth: {} })` by default. Login overrides to 5/15 min.

## API routes

```
GET    /api/health                        @Public()

POST   /api/auth/register                 @Public()
POST   /api/auth/login                    @Public() — 5 req/15min
POST   /api/auth/refresh                  @Public()
POST   /api/auth/logout
GET    /api/auth/profile

GET    /api/users                         @Roles(ADMIN)
GET    /api/users/:id
PATCH  /api/users/:id                     owner or ADMIN only
DELETE /api/users/:id                     owner or ADMIN only

GET    /api/quiz/questions                ?difficulty&category
POST   /api/quiz/start                    ?difficulty&category
POST   /api/quiz/finish
POST   /api/quiz/cancel
POST   /api/quiz/answer

GET    /api/score/user/:id                ParseUUIDPipe — scores are public
GET    /api/score/leaderboard             ?difficulty (required, IsEnum)
```

## Database schema (key models)

- **User** — `username` (unique), `email` (unique), `role` (USER|ADMIN), `lang`
- **RefreshToken** — hashed token, `expiresAt`, cascade delete on user
- **Question** — fetched from OpenTriviaDB, upserted by `sourceId`. Indexed on `(difficulty)`, `(category)`, `(category, difficulty)`
- **SoloSession** — status: IN_PROGRESS | FINISHED | EXPIRED. Indexed on `(userId, status)`, `(status, expiresAt)`
- **SoloAnswer** — unique `(sessionId, questionId)`
- **Score** — unique `(userId, difficulty)`, upserted on session finish. Indexed on `(difficulty, value)` for leaderboard
- **Friendship**, **Game**, **GamePlayer**, **GameQuestion** — schema defined, not yet implemented

## Key conventions

- DTOs use `class-validator`. `ValidationPipe` has `whitelist: true` + `forbidNonWhitelisted: true` — unknown fields are rejected with 400.
- Password changes are **not supported** via PATCH /users/:id. Requires a dedicated endpoint (not yet implemented).
- `lang` is hardcoded to `"en"` in quiz sessions for now — French translation via DeepL is a future TODO.
- External API errors (OpenTriviaDB down) return `503 ServiceUnavailableException`.
- Linter: Biome (not ESLint). Run `pnpm lint` before committing.
