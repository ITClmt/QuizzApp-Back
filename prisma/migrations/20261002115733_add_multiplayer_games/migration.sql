-- CreateEnum
CREATE TYPE "GamePlayerStatus" AS ENUM ('INVITED', 'JOINED', 'DECLINED', 'LEFT');

-- AlterEnum
ALTER TYPE "GameStatus" ADD VALUE 'CANCELED';

-- AlterTable
ALTER TABLE "Game" ADD COLUMN     "difficulty" "Difficulty",
ADD COLUMN     "finishedAt" TIMESTAMP(3),
ADD COLUMN     "startedAt" TIMESTAMP(3),
ALTER COLUMN "code" DROP NOT NULL;

-- AlterTable
ALTER TABLE "GamePlayer" ADD COLUMN     "status" "GamePlayerStatus" NOT NULL DEFAULT 'INVITED',
ADD COLUMN     "xpEarned" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "GameAnswer" (
    "id" TEXT NOT NULL,
    "answerIndex" INTEGER NOT NULL,
    "isCorrect" BOOLEAN NOT NULL,
    "responseMs" INTEGER NOT NULL,
    "gamePlayerId" TEXT NOT NULL,
    "gameQuestionId" TEXT NOT NULL,

    CONSTRAINT "GameAnswer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "GameAnswer_gamePlayerId_gameQuestionId_key" ON "GameAnswer"("gamePlayerId", "gameQuestionId");

-- CreateIndex
CREATE INDEX "Game_status_idx" ON "Game"("status");

-- CreateIndex
CREATE INDEX "GamePlayer_userId_status_idx" ON "GamePlayer"("userId", "status");

-- AddForeignKey
ALTER TABLE "GameAnswer" ADD CONSTRAINT "GameAnswer_gamePlayerId_fkey" FOREIGN KEY ("gamePlayerId") REFERENCES "GamePlayer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameAnswer" ADD CONSTRAINT "GameAnswer_gameQuestionId_fkey" FOREIGN KEY ("gameQuestionId") REFERENCES "GameQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
