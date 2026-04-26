---
applyTo: "src/**/tests/**/*.{ts,feature}"
---

## Frontend E2E - Playwright BDD en français

Les tests E2E frontend utilisent **Playwright** avec **playwright-bdd** pour exprimer les scénarios métier en Gherkin français.

### Portée

Ces instructions s'appliquent aux :

- fichiers `.feature` ;
- step definitions TypeScript ;
- helpers E2E spécifiques au frontend.

### Structure cible

Structure attendue par cluster :

```text
src/my-accounting/tests/
  e2e/
    features/
      document-capture-mobile-icloud.feature
      document-import-icloud-existant.feature
    steps/
      document-capture.steps.ts
      document-search.steps.ts
    support/
      fixtures/
      pages/
      helpers/
```

Le dossier généré par `bddgen` doit rester hors édition manuelle et être ignoré par Git si nécessaire.

### Format des fichiers `.feature`

- Toujours inclure `# language: fr` en première ligne.
- Utiliser les mots-clés français : `Fonctionnalité:`, `Contexte:`, `Scénario:`, `Plan du scénario:`, `Soit`, `Quand`, `Et`, `Alors`.
- Ajouter les tags `@epic-<n>` et `@story-<n-n>` au niveau de la fonctionnalité ou du scénario selon le besoin.
- Employer le vocabulaire métier MyAccounting et les termes compréhensibles par Rachel.
- Ne pas réutiliser d'exemples métier provenant d'un autre produit.

Exemple :

```gherkin
# language: fr
@epic-1 @story-1-2
Fonctionnalité: Import des documents iCloud existants
  En tant que Rachel
  Je veux importer mes documents déjà classés dans iCloud
  Afin de conserver mon historique sans recommencer le classement

  Scénario: Import du dossier !Facturette d'une année
    Quand je lance l'import iCloud pour l'année "2026"
    Alors les documents du dossier "!Facturette" sont indexés
```

### Step definitions

- Les steps doivent être courtes, explicites et réutilisables.
- Les assertions principales doivent rester visibles dans les steps ou helpers proches, pas enfouies dans une couche opaque.
- Les steps doivent refléter des actions utilisateur et des résultats observables.
- Réutiliser un pattern cohérent avec l'installation réelle de `playwright-bdd` du repo.
- Ne pas introduire d'exemple d'imports ou d'API Playwright qui ne correspond pas au setup effectif.

### Règles de stabilité E2E

- Enregistrer les interceptions réseau **avant** navigation ou action déclenchante.
- Attendre des signaux déterministes : réponse réseau, disparition d'un loader, état visible stable.
- Ne pas utiliser `waitForTimeout(...)` sauf justification exceptionnelle documentée.
- Préférer une préparation de données rapide et contrôlée plutôt qu'un long setup via UI.

### Couverture frontend

- Priorité aux E2E Gherkin pour les comportements visibles et critiques.
- Utiliser Vitest pour les règles isolées des stores, composables et transformations frontend.
- Éviter qu'un même comportement soit testé à la fois en E2E et en Vitest sans raison claire.

### Commandes

Les scripts exacts doivent refléter le `package.json` réel du cluster. Si des commandes standard existent, conserver cette logique :

```bash
npm run test:e2e
npm run test:e2e:ui
```

`bddgen` doit toujours être exécuté avant `playwright test`, directement ou via les scripts du projet.
