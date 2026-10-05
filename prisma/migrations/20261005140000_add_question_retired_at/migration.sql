-- Une question retirée n'est plus tirée au sort mais reste en base : SoloAnswer et
-- GameQuestion la référencent (sans cascade), un DELETE casserait l'historique.
ALTER TABLE "Question" ADD COLUMN "retiredAt" TIMESTAMP(3);

-- Cylindrées des moteurs Chevrolet LS en pouces cubes : trop américain, sans équivalent parlant.
UPDATE "Question" SET "retiredAt" = CURRENT_TIMESTAMP
WHERE "sourceId" IN (
    'otd-VGhlIExTMSBlbmdpbmUgaXMgaG93IG1hbnkgY3ViaWMgaW5jaG',
    'otd-VGhlIExTMiBlbmdpbmUgaXMgaG93IG1hbnkgY3ViaWMgaW5jaG',
    'otd-VGhlIExTMyBlbmdpbmUgaXMgaG93IG1hbnkgY3ViaWMgaW5jaG',
    'otd-VGhlIExTNyBlbmdpbmUgaXMgaG93IG1hbnkgY3ViaWMgaW5jaG'
);
