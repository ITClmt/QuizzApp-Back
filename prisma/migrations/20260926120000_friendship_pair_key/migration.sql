-- La table est censée être vide (aucun endpoint n'écrivait dedans), mais la
-- migration reste sûre si des lignes existent : on retire les DECLINED avant de
-- supprimer la valeur, et on dédoublonne les paires A→B / B→A avant l'index unique.
DELETE FROM "Friendship" WHERE "status" = 'DECLINED';

DELETE FROM "Friendship" f
USING "Friendship" other
WHERE LEAST(f."requesterId", f."receiverId") = LEAST(other."requesterId", other."receiverId")
  AND GREATEST(f."requesterId", f."receiverId") = GREATEST(other."requesterId", other."receiverId")
  AND (f."createdAt", f."id") > (other."createdAt", other."id");

-- AlterEnum
BEGIN;
CREATE TYPE "FriendshipStatus_new" AS ENUM ('PENDING', 'ACCEPTED');
ALTER TABLE "Friendship" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Friendship" ALTER COLUMN "status" TYPE "FriendshipStatus_new" USING ("status"::text::"FriendshipStatus_new");
ALTER TYPE "FriendshipStatus" RENAME TO "FriendshipStatus_old";
ALTER TYPE "FriendshipStatus_new" RENAME TO "FriendshipStatus";
DROP TYPE "FriendshipStatus_old";
ALTER TABLE "Friendship" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;

-- DropIndex
DROP INDEX "Friendship_requesterId_receiverId_key";

-- AlterTable : ajout nullable, remplissage, puis NOT NULL
ALTER TABLE "Friendship" ADD COLUMN "acceptedAt" TIMESTAMP(3),
ADD COLUMN "pairKey" TEXT;

UPDATE "Friendship"
SET "pairKey" = LEAST("requesterId", "receiverId") || ':' || GREATEST("requesterId", "receiverId");

UPDATE "Friendship" SET "acceptedAt" = "createdAt" WHERE "status" = 'ACCEPTED';

ALTER TABLE "Friendship" ALTER COLUMN "pairKey" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Friendship_pairKey_key" ON "Friendship"("pairKey");

-- CreateIndex
CREATE INDEX "Friendship_receiverId_status_idx" ON "Friendship"("receiverId", "status");

-- CreateIndex
CREATE INDEX "Friendship_requesterId_status_idx" ON "Friendship"("requesterId", "status");
