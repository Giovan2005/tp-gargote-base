# TP Gargote — Niveau 1 : La carte

## 1.1 Script de migration

### 1. 

La clé primaire est `date_jour` elle est unique, donc deux lignes ne peuvent pas avoir la même date

### 2. 

On perd l’historique : une colonne `est_plat_du_jour` indique seulement l’état actuel. On ne sait plus quels plats étaient proposés les jours précédents.

On perd la garantie d’unicité. Rien n’empêche deux plats d’avoir `est_plat_du_jour = true` le même jour

---

## 1.2 Données de test

### 3. 

```sql
INSERT INTO plat (nom, prix, id_categorie) VALUES ('Test zéro', 0, 1);
INSERT INTO plat (nom, prix, id_categorie) VALUES ('Romazava', 500, 1);
```

**Erreurs obtenues :**

```text
ERROR: new row for relation "plat" violates check constraint "ck_plat_prix"
DETAIL: Failing row contains (16, Test zéro, 0, 1, null, t).

ERROR: duplicate key value violates unique constraint "uq_plat_nom"
DETAIL: Key (nom)=(Romazava) already exists.
```

---

## 1.3 Le modèle `PlatModel`

```json
{
  "id": 1,
  "nom": "Vary amin'anana",
  "prix": 2000,
  "id_categorie": 1,
  "description": null,
  "disponible": true
}
```

---

## 1.5

### 4. 

R2 renvoie `409` et non `422`, car la requête est bien écrite et le plat existe

### 5. 

Je propose que le plat reste plat du jour mais que l’interface affiche « Épuisé » à côté Bao peut ainsi choisir un autre plat

---

## 1.7 Jeu de tests


### Test 1 : 
```bash
curl -i -X POST "http://localhost:8080/api/plats" \
  -H "Content-Type: application/json" \
  -d '{"nom":"Café","prix":1000,"id_categorie":3}'
```

**Code obtenu : `422`** 

```json
{
  "message": "Données invalides.",
  "errors": {
    "nom": "Un plat porte déjà ce nom."
  }
}
```

### Test 2 :

```bash
curl -i -X PUT "http://localhost:8080/api/plats/4" \
  -H "Content-Type: application/json" \
  -d '{"nom":"Romazava","prix":7500}'
```

**Code obtenu : `200`** 
Le prix du Romazava a été changé de 7000 à 7500 pour ce test. Il a été remis à 7000 ensuite.

### Test 3 :

```bash
curl -i -X POST "http://localhost:8080/api/plats" \
  -H "Content-Type: application/json" \
  -d '{"nom":"Thé","prix":0,"id_categorie":3}'
```

**Code obtenu : `422`** 

```json
{
  "message": "Données invalides.",
  "errors": {
    "prix": "Le prix doit être supérieur à 0 Ar."
  }
}
```

### Test 4 :

```bash
curl -i -X POST "http://localhost:8080/api/plats" \
  -H "Content-Type: application/json" \
  -d '{"nom":"Thé","prix":500,"id_categorie":99}'
```

**Code obtenu : `422`** 

```json
{
  "message": "Données invalides.",
  "errors": {
    "id_categorie": "Cette catégorie n’existe pas."
  }
}
```

### Test 5 : 

```bash
curl -i -X PUT "http://localhost:8080/api/plats/7" \
  -H "Content-Type: application/json" \
  -d '{"disponible":"oui"}'
```

**Code obtenu : `422`**

```json
{
  "message": "Données invalides.",
  "errors": {
    "disponible": "La valeur doit être vrai ou faux."
  }
}
```

### Test 6 : 

```bash
curl -i -X PUT "http://localhost:8080/api/plats/7" \
  -H "Content-Type: application/json" \
  -d '{"disponible":false}'
```

**Code obtenu : `200`** 

Le *Mi sao* (id 7) est maintenant épuisé.

### Test 7 : 

```bash
curl -i -X PUT "http://localhost:8080/api/plat-du-jour" \
  -H "Content-Type: application/json" \
  -d '{"id_plat":7}'
```

**Code obtenu : `409`** 

```json
{
  "message": "Le mi sao est épuisé : il ne peut pas être plat du jour.",
  "errors": {
    "id_plat": "Ce plat est épuisé."
  }
}
```

### Test 8 : 

```bash
curl -i "http://localhost:8080/api/plats?categorie=2&disponible=1"
```

**Code obtenu : `200`** 

Seule la *Soupe chinoise* est renvoyée. Le *Mi sao* est absent.

---

### Constat : 


```bash
curl -i -X POST "http://localhost:8080/api/commandes" \
  -H "Content-Type: application/json" \
  -d '{"numero_table":5,"lignes":[{"id_plat":7,"quantite":1}]}'
```

**Code obtenu : `201 Created`.** Le *Mi sao* figure dans les lignes, avec son `prix_unitaire` de 6500 Ar l'API n'interdit donc pas la commande d'un plat epuise
