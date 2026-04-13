-- AlterTable: set default value for Score.value
ALTER TABLE "Score" ALTER COLUMN "value" SET DEFAULT 0;

-- AlterTable: add updatedAt column (backfill existing rows with NOW())
ALTER TABLE "Score" ADD COLUMN "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT NOW();

-- Remove the default on updatedAt (Prisma @updatedAt manages it at app level)
ALTER TABLE "Score" ALTER COLUMN "updatedAt" DROP DEFAULT;

-- CreateIndex: unique constraint on userId + difficulty
CREATE UNIQUE INDEX "Score_userId_difficulty_key" ON "Score"("userId", "difficulty");
