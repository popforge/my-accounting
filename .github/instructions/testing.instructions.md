---
applyTo: "src/**/*.{ts,vue,cs,feature}"
---

## Standard global de test

Le projet MyAccounting suit une stratégie de test orientée risque avec séparation claire des niveaux de test.

### Choix du niveau de test

- **E2E Gherkin** : pour les parcours visibles par Rachel et les flux critiques de bout en bout.
- **Unit (Vitest)** : pour la logique isolée côté frontend, notamment stores, composables et règles de transformation.
- **Unit (xUnit)** : pour la logique métier backend, validations, services et règles non visibles en E2E.

### Règles de sélection

- Favoriser le niveau le plus bas qui couvre correctement le comportement.
- Ne pas dupliquer inutilement un même comportement en E2E et en test unitaire.
- Réserver les E2E aux scénarios critiques, transverses ou à forte valeur utilisateur.

### Définition de qualité minimale

Chaque test doit être :

- déterministe ;
- isolé ;
- lisible ;
- rapide ;
- explicite dans ses assertions.

À éviter :

- `waitForTimeout(...)` et attentes arbitraires ;
- logique conditionnelle qui change le chemin d'exécution du test ;
- données figées qui créent des collisions ;
- assertions cachées dans des helpers opaques ;
- doublons de couverture entre niveaux de test sans justification.

### Règles transverses

- Les scénarios Gherkin destinés à Rachel sont rédigés en français.
- Les tests doivent refléter le vocabulaire métier de MyAccounting, pas celui d'un autre produit.
- Les tests doivent être cohérents avec les stories et critères d'acceptation.
- Quand un test crée des données, il doit prévoir leur nettoyage ou un mécanisme d'isolation équivalent.

### Traçabilité attendue

- Une story qui exige un comportement visible doit référencer un fichier `.feature`.
- Les tags `@epic-<n>` et `@story-<n-n>` doivent permettre de relier feature, story et exécution de test.

### Références spécialisées

- Pour les conventions Playwright / Gherkin frontend, voir `testing-frontend.instructions.md`.

