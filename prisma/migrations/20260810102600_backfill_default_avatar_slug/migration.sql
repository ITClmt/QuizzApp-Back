-- L'avatar 'default' a été retiré du catalogue et son image supprimée du repo.
-- Les comptes qui le portaient encore pointeraient sur une image inexistante :
-- on les bascule sur le nouveau défaut, qui est le même personnage.
UPDATE "User" SET "avatarSlug" = 'yellow-cyclops' WHERE "avatarSlug" = 'default';
