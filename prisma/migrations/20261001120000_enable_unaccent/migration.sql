-- Recherche d'amis insensible aux accents (FriendsService.search).
-- unaccent est une extension « trusted » depuis Postgres 13 : le propriétaire
-- de la base peut l'activer sans être superutilisateur.
CREATE EXTENSION IF NOT EXISTS unaccent;
