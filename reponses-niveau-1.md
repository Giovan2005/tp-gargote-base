1.1 Script de migration

1. 
La clé primaire est date_jour. Elle est unique, donc deux lignes ne peuvent pas avoir la même date

2. 
On perd l’historique , une colonne est_plat_du_jour indique seulement l’état actuel. On ne sait plus quels plats étaient proposés les jours précédents
On perd la garantie d’unicité. Rien n’empêche deux plats d’avoir est_plat_du_jour = true le même jour




1.2 Données de test
3.
INSERT INTO plat (nom, prix, id_categorie) VALUES ('Test zéro', 0, 1); 
INSERT INTO plat (nom, prix, id_categorie) VALUES ('Romazava', 500, 1);
ERROR:  new row for relation "plat" violates check constraint "ck_plat_prix"
DETAIL:  Failing row contains (16, Test zéro, 0, 1, null, t).
ERROR:  duplicate key value violates unique constraint "uq_plat_nom"
DETAIL:  Key (nom)=(Romazava) already exists.


