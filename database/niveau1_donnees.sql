
INSERT INTO categorie (libelle) VALUES ('Goûter')
ON CONFLICT (libelle) DO NOTHING;

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Mokary', 500, id, 'Beignet de riz, parfumé à la vanille'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Koba', 1000, id, 'Pâte d''arachide, banane et farine de riz, cuite en feuille de bananier'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Godrogodro', 300, id, 'Beignet de farine de riz, frit et sucré'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Menakely', 400, id, 'Petit gâteau sucré, à savourer avec un café'
FROM categorie WHERE libelle = 'Goûter';

INSERT INTO plat (nom, prix, id_categorie, description)
SELECT 'Mofo gasy', 300, id, 'Petit gâteau de riz, cuit à la poêle'
FROM categorie WHERE libelle = 'Goûter';


UPDATE plat SET description = 'Riz, viande de zébu et brèdes, cuits ensemble'
WHERE nom = 'Romazava';

UPDATE plat SET description = 'Feuilles de manioc pilées, mijotées avec de la viande de porc'
WHERE nom = 'Ravitoto sy henakisoa';

UPDATE plat SET description = 'Poulet mijoté au lait de coco'
WHERE nom = 'Akoho sy voanio';

UPDATE plat SET description = 'Porc sauté avec des haricots secs'
WHERE nom = 'Henakisoa sy tsaramaso';

UPDATE plat SET description = 'Café noir servi chaud'
WHERE nom = 'Café';

UPDATE plat SET disponible = false WHERE nom = 'Mi sao';
UPDATE plat SET disponible = false WHERE nom = 'Jus de fruit';


INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE, (SELECT id FROM plat WHERE nom = 'Romazava'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 1, (SELECT id FROM plat WHERE nom = 'Akoho sy voanio'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 2, (SELECT id FROM plat WHERE nom = 'Ravitoto sy henakisoa'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 3, (SELECT id FROM plat WHERE nom = 'Henakisoa sy tsaramaso'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 4, (SELECT id FROM plat WHERE nom = 'Vary amin''anana'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 5, (SELECT id FROM plat WHERE nom = 'Soupe chinoise'))
ON CONFLICT (date_jour) DO NOTHING;

INSERT INTO plat_du_jour (date_jour, id_plat)
VALUES (CURRENT_DATE - 6, (SELECT id FROM plat WHERE nom = 'Koba'))
ON CONFLICT (date_jour) DO NOTHING;