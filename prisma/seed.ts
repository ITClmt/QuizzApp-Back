import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import * as argon2 from 'argon2';
import { Difficulty, PrismaClient } from '../src/generated/prisma/client';

const connectionString = `${process.env.DATABASE_URL}`;
const prisma = new PrismaClient({
	adapter: new PrismaPg({ connectionString }),
});

// Domaine dédié aux comptes de seed : permet un reset ciblé sans toucher aux vrais comptes.
const SEED_EMAIL_DOMAIN = '@seed.local';
const SEED_PASSWORD = 'Password123!';

const USERS = [
	{ username: 'sophie_martin', first: 'sophie.martin', avatarSlug: 'default' },
	{ username: 'lucas_bernard', first: 'lucas.bernard', avatarSlug: 'default' },
	{ username: 'emma_dubois', first: 'emma.dubois', avatarSlug: 'Epic_Spacey' },
	{ username: 'hugo_thomas', first: 'hugo.thomas', avatarSlug: 'default' },
	{ username: 'chloe_robert', first: 'chloe.robert', avatarSlug: 'default' },
	{ username: 'nathan_petit', first: 'nathan.petit', avatarSlug: 'default' },
	{ username: 'lea_richard', first: 'lea.richard', avatarSlug: 'Epic_Spacey' },
	{ username: 'maxime_durand', first: 'maxime.durand', avatarSlug: 'default' },
	{
		username: 'camille_moreau',
		first: 'camille.moreau',
		avatarSlug: 'default',
	},
	{
		username: 'theo_laurent',
		first: 'theo.laurent',
		avatarSlug: 'Epic_Spacey',
	},
	{ username: 'julie_simon', first: 'julie.simon', avatarSlug: 'default' },
];

const QUESTIONS: Array<{
	sourceId: string;
	questionEn: string;
	answersEn: string[];
	correctIndex: number;
	category: string;
	difficulty: Difficulty;
}> = [
	{
		sourceId: 'seed-q-01',
		questionEn: 'What is the capital of France?',
		answersEn: ['Paris', 'Lyon', 'Marseille', 'Nice'],
		correctIndex: 0,
		category: 'Geography',
		difficulty: 'easy',
	},
	{
		sourceId: 'seed-q-02',
		questionEn: 'What is the chemical symbol for water?',
		answersEn: ['H2O', 'CO2', 'O2', 'NaCl'],
		correctIndex: 0,
		category: 'Science: General Knowledge',
		difficulty: 'easy',
	},
	{
		sourceId: 'seed-q-03',
		questionEn: 'How many continents are there on Earth?',
		answersEn: ['5', '6', '7', '8'],
		correctIndex: 2,
		category: 'Geography',
		difficulty: 'easy',
	},
	{
		sourceId: 'seed-q-04',
		questionEn: 'Who painted the Mona Lisa?',
		answersEn: ['Leonardo da Vinci', 'Michelangelo', 'Raphael', 'Donatello'],
		correctIndex: 0,
		category: 'Art',
		difficulty: 'easy',
	},
	{
		sourceId: 'seed-q-05',
		questionEn: 'What is the largest planet in our solar system?',
		answersEn: ['Earth', 'Saturn', 'Jupiter', 'Neptune'],
		correctIndex: 2,
		category: 'Science: Astronomy',
		difficulty: 'easy',
	},
	{
		sourceId: 'seed-q-06',
		questionEn: 'In what year did World War II end?',
		answersEn: ['1943', '1944', '1945', '1946'],
		correctIndex: 2,
		category: 'History',
		difficulty: 'medium',
	},
	{
		sourceId: 'seed-q-07',
		questionEn: 'Which programming language was created by Guido van Rossum?',
		answersEn: ['Java', 'Python', 'Ruby', 'C++'],
		correctIndex: 1,
		category: 'Science: Computers',
		difficulty: 'medium',
	},
	{
		sourceId: 'seed-q-08',
		questionEn: 'What is the smallest prime number?',
		answersEn: ['0', '1', '2', '3'],
		correctIndex: 2,
		category: 'Science: Mathematics',
		difficulty: 'medium',
	},
	{
		sourceId: 'seed-q-09',
		questionEn: 'Which video game franchise features a character named Link?',
		answersEn: ['Final Fantasy', 'The Legend of Zelda', 'Metroid', 'Kirby'],
		correctIndex: 1,
		category: 'Entertainment: Video Games',
		difficulty: 'medium',
	},
	{
		sourceId: 'seed-q-10',
		questionEn: 'What is the longest river in the world?',
		answersEn: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
		correctIndex: 1,
		category: 'Geography',
		difficulty: 'medium',
	},
	{
		sourceId: 'seed-q-11',
		questionEn: "Who wrote 'One Hundred Years of Solitude'?",
		answersEn: [
			'Gabriel Garcia Marquez',
			'Mario Vargas Llosa',
			'Jorge Luis Borges',
			'Pablo Neruda',
		],
		correctIndex: 0,
		category: 'Entertainment: Books',
		difficulty: 'hard',
	},
	{
		sourceId: 'seed-q-12',
		questionEn: 'What is the Heisenberg Uncertainty Principle related to?',
		answersEn: [
			'Thermodynamics',
			'Quantum Mechanics',
			'Relativity',
			'Electromagnetism',
		],
		correctIndex: 1,
		category: 'Science: General Knowledge',
		difficulty: 'hard',
	},
	{
		sourceId: 'seed-q-13',
		questionEn: 'Which treaty ended World War I?',
		answersEn: [
			'Treaty of Paris',
			'Treaty of Versailles',
			'Treaty of Vienna',
			'Treaty of Tordesillas',
		],
		correctIndex: 1,
		category: 'History',
		difficulty: 'hard',
	},
	{
		sourceId: 'seed-q-14',
		questionEn: 'What is the time complexity of binary search?',
		answersEn: ['O(n)', 'O(n log n)', 'O(log n)', 'O(1)'],
		correctIndex: 2,
		category: 'Science: Computers',
		difficulty: 'hard',
	},
	{
		sourceId: 'seed-q-15',
		questionEn: 'Which country has the most time zones?',
		answersEn: ['Russia', 'USA', 'France', 'China'],
		correctIndex: 2,
		category: 'Geography',
		difficulty: 'hard',
	},
];

const DIFFICULTIES: Difficulty[] = ['easy', 'medium', 'hard'];

function randomInt(min: number, max: number): number {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}

function pastDate(daysAgo: number): Date {
	return new Date(Date.now() - daysAgo * 24 * 60 * 60 * 1000);
}

async function resetSeedData() {
	await prisma.user.deleteMany({
		where: { email: { endsWith: SEED_EMAIL_DOMAIN } },
	});
}

async function seedUsers() {
	const hashedPassword = await argon2.hash(SEED_PASSWORD);

	return Promise.all(
		USERS.map((u) =>
			prisma.user.create({
				data: {
					username: u.username,
					email: `${u.first}${SEED_EMAIL_DOMAIN}`,
					password: hashedPassword,
					avatarSlug: u.avatarSlug,
				},
			}),
		),
	);
}

async function seedQuestions() {
	return Promise.all(
		QUESTIONS.map((q) =>
			prisma.question.upsert({
				where: { sourceId: q.sourceId },
				update: {},
				create: q,
			}),
		),
	);
}

// Simule des SoloSession terminées avec leurs réponses et met à jour les Score en conséquence.
async function seedSoloQuizzes(
	users: Awaited<ReturnType<typeof seedUsers>>,
	questions: Awaited<ReturnType<typeof seedQuestions>>,
) {
	for (const user of users) {
		const sessionsCount = randomInt(2, 4);
		const scoreByDifficulty: Partial<Record<Difficulty, number>> = {};

		for (let i = 0; i < sessionsCount; i++) {
			const difficulty = DIFFICULTIES[randomInt(0, DIFFICULTIES.length - 1)];
			const pool = questions.filter((q) => q.difficulty === difficulty);
			const picked = [...pool].sort(() => Math.random() - 0.5).slice(0, 5);

			const createdAt = pastDate(randomInt(1, 30));
			const session = await prisma.soloSession.create({
				data: {
					userId: user.id,
					status: 'FINISHED',
					difficulty,
					category: picked[0]?.category ?? null,
					lang: 'en',
					createdAt,
					expiresAt: new Date(createdAt.getTime() + 3.5 * 60 * 1000),
				},
			});

			let correctCount = 0;
			for (const question of picked) {
				const answersCount = (question.answersEn as string[]).length;
				const isCorrect = Math.random() < 0.65;
				const answerIndex = isCorrect
					? question.correctIndex
					: (question.correctIndex + 1) % answersCount;

				await prisma.soloAnswer.create({
					data: {
						sessionId: session.id,
						questionId: question.id,
						answerIndex,
						isCorrect,
						createdAt,
					},
				});

				if (isCorrect) correctCount++;
			}

			scoreByDifficulty[difficulty] =
				(scoreByDifficulty[difficulty] ?? 0) + correctCount;
		}

		for (const [difficulty, value] of Object.entries(scoreByDifficulty)) {
			await prisma.score.upsert({
				where: {
					userId_difficulty: {
						userId: user.id,
						difficulty: difficulty as Difficulty,
					},
				},
				update: { value },
				create: {
					userId: user.id,
					difficulty: difficulty as Difficulty,
					value,
				},
			});
		}
	}
}

async function main() {
	await resetSeedData();
	const questions = await seedQuestions();
	const users = await seedUsers();
	await seedSoloQuizzes(users, questions);

	console.log(
		`Seed terminé : ${users.length} comptes, ${questions.length} questions.`,
	);
	console.log(`Mot de passe commun : ${SEED_PASSWORD}`);
}

main()
	.catch((e) => {
		console.error(e);
		process.exit(1);
	})
	.finally(async () => {
		await prisma.$disconnect();
	});
