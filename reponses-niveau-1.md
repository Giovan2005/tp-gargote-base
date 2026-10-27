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


1.3 Le modèle PlatModel

{
    "id": 1,
    "nom": "Vary amin'anana",
    "prix": 2000,
    "id_categorie": 1,
    "description": null,
    "disponible": true
}

1.5

4  R2 renvoie 409 et non 422, car la requête est bien écrite et le plat existe
5  Je propose que le plat reste plat du jour mais que l’interface affiche « Épuisé » à côté Bao peut ainsi choisir un autre plat

