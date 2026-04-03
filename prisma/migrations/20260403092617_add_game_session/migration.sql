/*
  Warnings:

  - Added the required column `difficulty` to the `Score` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "SoloSessionStatus" AS ENUM ('IN_PROGRESS', 'FINISHED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "Difficulty" AS ENUM ('EASY', 'MEDIUM', 'HARD');

-- AlterTable
ALTER TABLE "Score" ADD COLUMN     "difficulty" "Difficulty" NOT NULL;

-- CreateTable
CREATE TABLE "SoloSession" (
    "id" TEXT NOT NULL,
    "status" "SoloSessionStatus" NOT NULL DEFAULT 'IN_PROGRESS',
    "difficulty" "Difficulty",
    "lang" TEXT NOT NULL DEFAULT 'en',
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,

    CONSTRAINT "SoloSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SoloAnswer" (
    "id" TEXT NOT NULL,
    "answerIndex" INTEGER NOT NULL,
    "isCorrect" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sessionId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,

    CONSTRAINT "SoloAnswer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SoloAnswer_sessionId_questionId_key" ON "SoloAnswer"("sessionId", "questionId");

-- AddForeignKey
ALTER TABLE "SoloSession" ADD CONSTRAINT "SoloSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SoloAnswer" ADD CONSTRAINT "SoloAnswer_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "SoloSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SoloAnswer" ADD CONSTRAINT "SoloAnswer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
