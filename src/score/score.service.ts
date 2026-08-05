import { Injectable } from '@nestjs/common';
import { Difficulty } from 'src/generated/prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { getLevelFromXp } from 'src/quiz/utils/level.util';
import type {
	GlobalLeaderboardEntry,
	GlobalRankResponse,
	LeaderboardEntry,
	RankResponse,
	ScoreResponse,
	UserScoresResponse,
} from './interfaces';

@Injectable()
export class ScoreService {
	constructor(private readonly prisma: PrismaService) {}

	getUpsertOperation(userId: string, difficulty: Difficulty, points: number) {
		return this.prisma.score.upsert({
			where: { userId_difficulty: { userId, difficulty } },
			update: { value: { increment: points } },
			create: { userId, difficulty, value: points },
		});
	}

	async getUserScores(userId: string): Promise<UserScoresResponse> {
		const scores = await this.prisma.score.findMany({
			where: { userId },
			orderBy: { difficulty: 'asc' },
		});

		// Calcule le total en une seule passe
		const totalScore = scores.reduce((sum, s) => sum + s.value, 0);

		return {
			totalScore,
			scores: scores.map((s) => ({
				id: s.id,
				value: s.value,
				difficulty: s.difficulty,
				createdAt: s.createdAt,
			})),
		};
	}

	async addScore(
		userId: string,
		difficulty: Difficulty,
		points: number,
	): Promise<ScoreResponse> {
		const score = await this.getUpsertOperation(userId, difficulty, points);

		return {
			id: score.id,
			value: score.value,
			difficulty: score.difficulty,
			createdAt: score.createdAt,
		};
	}

	async getMyRank(
		userId: string,
		difficulty: Difficulty,
	): Promise<RankResponse | null> {
		const myScore = await this.prisma.score.findUnique({
			where: { userId_difficulty: { userId, difficulty } },
		});

		if (!myScore) return null;

		const above = await this.prisma.score.count({
			where: { difficulty, value: { gt: myScore.value } },
		});

		return { rank: above + 1, value: myScore.value };
	}

	async getLeaderboard(difficulty: Difficulty): Promise<LeaderboardEntry[]> {
		const scores = await this.prisma.score.findMany({
			where: { difficulty },
			include: {
				user: {
					select: {
						username: true,
						avatarSlug: true,
					},
				},
			},
			orderBy: { value: 'desc' },
			take: 10,
		});

		return scores.map((s) => ({
			id: s.id,
			value: s.value,
			difficulty: s.difficulty,
			userData: {
				id: s.userId,
				username: s.user.username,
				avatarSlug: s.user.avatarSlug,
			},
			createdAt: s.createdAt,
		}));
	}

	// Pas d'anti-grind en v1 (décision produit) : à revoir si le grind pur
	// (spam de sessions faciles) s'avère un vrai problème sur ce classement.
	async getGlobalLeaderboard(): Promise<GlobalLeaderboardEntry[]> {
		const users = await this.prisma.user.findMany({
			orderBy: { xp: 'desc' },
			take: 10,
			select: { id: true, username: true, avatarSlug: true, xp: true },
		});

		return users.map((u) => ({ ...u, level: getLevelFromXp(u.xp) }));
	}

	async getMyGlobalRank(userId: string): Promise<GlobalRankResponse | null> {
		const me = await this.prisma.user.findUnique({
			where: { id: userId },
			select: { xp: true },
		});

		if (!me) return null;

		const above = await this.prisma.user.count({
			where: { xp: { gt: me.xp } },
		});

		return { rank: above + 1, xp: me.xp, level: getLevelFromXp(me.xp) };
	}
}
