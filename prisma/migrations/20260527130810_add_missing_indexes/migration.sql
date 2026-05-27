-- CreateIndex
CREATE INDEX "Question_difficulty_idx" ON "Question"("difficulty");

-- CreateIndex
CREATE INDEX "Question_category_idx" ON "Question"("category");

-- CreateIndex
CREATE INDEX "Question_category_difficulty_idx" ON "Question"("category", "difficulty");

-- CreateIndex
CREATE INDEX "Score_difficulty_value_idx" ON "Score"("difficulty", "value");

-- CreateIndex
CREATE INDEX "SoloSession_userId_status_idx" ON "SoloSession"("userId", "status");

-- CreateIndex
CREATE INDEX "SoloSession_status_expiresAt_idx" ON "SoloSession"("status", "expiresAt");
