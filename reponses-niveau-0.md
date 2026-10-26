# TP Gargote — Compte rendu

## 0.2 — Lire le schema relationnel

### 1. Schema des tables

- `categorie` (**id**, `libelle`)
- `plat` (**id**, `nom`, `prix`, `#id_categorie`)
- `commande` (**id**, `date_commande`, `numero_table`)
- `commande_ligne` (**id**, `#id_commande`, `#id_plat`, `quantite`, `prix_unitaire`)



### 2. Difference entre `plat.prix` et `commande_ligne.prix_unitaire`

- `plat.prix` contient le prix actuel du plat.
- `commande_ligne.prix_unitaire` conserve le prix du plat au moment de la commande.

**Exemple :**
- Le 1er octobre, un Romazava -> 3 000 Ar. Une commande contient 2 Romazava : `quantite = 2` et `prix_unitaire = 3000`.
- Le 20 novembre, le prix actuel du Romazava -> 3 500 Ar  la table `plat` contient alors `prix = 3500`, alors que l’ancienne commande conserve `prix_unitaire = 3000`.

### 3. Suppression en cascade

Lorsqu’une commande est supprimee, ses lignes associees dans `commande_ligne` sont supprimes automatiquement grace à la contrainte `ON DELETE CASCADE` sur `commande_ligne.id_commande`.

### 4. Exemples de donnees absurdes

- Un prix négatif.
- Une quantité négative.
- Un nom de plat vide.

---

## 0.3 — Interroger l’API à la main

### a) 

**Code HTTP :** `200`

**Résultat :**

```json
[
  {
    "id": 7,
    "nom": "Mi sao",
    "prix": 6500,
    "id_categorie": 2,
    "categorie": "Soupe"
  },
  {
    "id": 6,
    "nom": "Soupe chinoise",
    "prix": 6000,
    "id_categorie": 2,
    "categorie": "Soupe"
  }
]
```

### b) 

**Code HTTP :** `201 `

**Résultat :**

```json
{
  "id": 12,
  "nom": "Mofo gasy",
  "prix": 300,
  "id_categorie": 1
}
```

### c) 

**Code HTTP :** `422 `

**Résultat :**

```json
{
  "message": "Données invalides.",
  "errors": {
    "nom": "Le nom du plat est obligatoire.",
    "prix": "Le prix doit être un nombre entier (en Ariary).",
    "id_categorie": "Choisissez une catégorie."
  }
}
```

### d) 

**Code HTTP :** `409 `

**Résultat :**

```json
{
  "message": "Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.",
  "errors": {}
}
```

### e) 

**Code HTTP :** `404`

**Résultat :**

```json
{
  "message": "Commande 999 introuvable.",
  "errors": {}
}
```

---


### 5. 
- `201 Created` signifie qu’une nouvelle ressource a été créée
- `200 OK` signifie que la requête a réussi

### 6.

PostgreSQL bloque la suppression grace a la cle etrangere `commande_ligne.id_plat`. PHP intercepte ensuite l’erreur et la transforme en réponse HTTP `409 Conflict`.

Exemple de ligne

```php
return $this->response->setStatusCode(409);
```


### 7. 



```bash
curl -i -X POST "http://localhost:8080/api/commandes" \
  -H "Content-Type: application/json" \
  -d '{"numero_table":6,"lignes":[{"id_plat":ID_ROMAZAVA,"quantite":2},{"id_plat":ID_CAFE,"quantite":1}]}'
```

## 0.4 Suivre une requête de bout en bout

### 8. 

Le code metier se trouve dans `app/Services/CommandeService.php`, dans la methode `creer()`, le controleur `Commandes.php` gere principalement la requête HTTP et la réponse

---

## 0.5 — Repérer les notions de Vue

| Fichier et ligne | Explication |
|---|---|
| `CarteView.vue`, ligne 7 | La variable `plats` est réactive : quand sa valeur change, l’écran se met à jour. |
| `PlatList.vue`, ligne 13 | `groupes` est calculé à partir de `props.plats` et se recalcule lorsque cette liste change. |
| `PlatList.vue`, ligne 23 | La balise `<li>` est répétée pour chaque plat de la catégorie. |
| `Panier.vue`, lignes 18 et 20 | Le message « Touchez un plat… » apparaît si le panier est vide ; sinon, les lignes du panier sont affichées. |
| `PlatForm.vue`, ligne 64 | Le champ de saisie et `form.nom` restent synchronisés dans les deux sens. |
| `PlatList.vue`, ligne 6 | Le composant reçoit la donnée `plats` de son parent, `CarteView`. |
| `PlatList.vue`, lignes 11 et 28 | Le composant déclare des événements puis envoie `modifier` au parent lors du clic sur « Modifier ». |
| `CarteView.vue`, ligne 40 | `charger()` est exécutée lorsque l’écran apparaît afin de charger la carte. |

### 9. 
`Panier.vue` affiche le panier et signale les clics , l’état du panier est géré par `CommandeView.vue`.

### 10. 

`watch` recopie les valeurs du plat sélectionné dans le formulaire. Ainsi, lorsqu’on choisit un autre plat à modifier, les champs sont actualisés au lieu de conserver les anciennes valeurs

---

## 0.6 — Premières modifications

### 10. 



1. `CarteView.vue` appelle `api.categories.lister()`
2. Cette fonction envoie une requête `GET /api/categories`
3. `Routes.php` dirige la requête vers `Categories::index()`
4. `Categories::index()` récupère les catégories dans la base de données
5. `CarteView.vue` transmet la liste à `PlatForm.vue`
6. `PlatForm.vue` crée une option pour chaque catégorie avec `v-for`
