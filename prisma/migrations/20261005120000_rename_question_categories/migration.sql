-- Les catégories perdent leur préfixe hérité de la source ("Entertainment: Video Games"
-- → "Video Games") : Question.category stocke désormais le name de QUIZ_CATEGORIES.
UPDATE "Question" SET "category" = CASE "category"
    WHEN 'Entertainment: Film' THEN 'Film'
    WHEN 'Entertainment: Music' THEN 'Music'
    WHEN 'Entertainment: Video Games' THEN 'Video Games'
    WHEN 'Entertainment: Television' THEN 'Television'
    WHEN 'Entertainment: Books' THEN 'Books'
    WHEN 'Entertainment: Comics' THEN 'Comics'
    WHEN 'Entertainment: Cartoon & Animations' THEN 'Cartoon & Animations'
    WHEN 'Entertainment: Japanese Anime & Manga' THEN 'Japanese Anime & Manga'
    WHEN 'Entertainment: Board Games' THEN 'Board Games'
    WHEN 'Entertainment: Musicals & Theatres' THEN 'Musicals & Theatres'
    WHEN 'Science: Computers' THEN 'Computers'
    WHEN 'Science: Mathematics' THEN 'Mathematics'
    WHEN 'Science: Gadgets' THEN 'Gadgets'
    ELSE "category"
END
WHERE "category" LIKE 'Entertainment: %' OR "category" LIKE 'Science: %';

-- Les questions OpenTriviaDB n'avaient qu'un base64 brut comme sourceId : on les préfixe
-- "otd-" (comme "gen-" pour les générées) pour garder leur provenance lisible.
UPDATE "Question" SET "sourceId" = 'otd-' || "sourceId"
WHERE "sourceId" NOT LIKE 'gen-%' AND "sourceId" NOT LIKE 'seed-%' AND "sourceId" NOT LIKE 'otd-%';
