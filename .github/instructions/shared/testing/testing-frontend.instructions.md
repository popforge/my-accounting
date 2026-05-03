---
applyTo: "src/**/tests/**/*.{ts,feature}"
---

# Tests E2E Gherkin — Popforge Platform

Les tests E2E utilisent **Playwright** avec **playwright-bdd** pour valider les comportements observables dans un navigateur.

## Format des fichiers `.feature`

- Toujours inclure `# language: fr` en première ligne.
- Utiliser les mots-clés français : `Fonctionnalité:`, `Contexte:`, `Scénario:`, `Soit`, `Quand`, `Et`, `Alors`.
- Ajouter les tags de traçabilité au niveau de la fonctionnalité ou du scénario :
  - `@epic-{PREFIX}<n>` — ex. : `@epic-a1`, `@epic-p2`
  - `@story-{PREFIX}<n>-<n>` — ex. : `@story-a1-1`, `@story-h3-2`
  - `@component-<nom>` — composant ou page testée

> **{PREFIX}** = la lettre du cluster. Voir `epic-and-stories.instructions.md`.
> Le tag `@area-<cluster>` est défini dans le fichier `.domain.` du cluster concerné.

Exemple de structure :

```gherkin
# language: fr
@epic-{PREFIX}1 @story-{PREFIX}1-1 @component-login
Fonctionnalité: [Titre de la fonctionnalité]
  En tant que [persona]
  Je veux [action]
  Afin de [bénéfice]

  Contexte:
    Etant donné que [précondition]

  Scénario: [Titre du scénario nominal]
    Etant donné que [état initial]
    Quand [action utilisateur]
    Alors [résultat observable]
```

## Règles de stabilité

- Enregistrer les interceptions réseau **avant** navigation ou action déclenchante.
- Attendre des signaux déterministes : réponse réseau, disparition d'un loader, état visible stable.
- Ne pas utiliser `waitForTimeout(...)` sauf justification exceptionnelle documentée.
- Préférer une préparation d'état serveur via API (rapide) plutôt qu'un setup via UI.

## Commandes

Les scripts doivent refléter le `package.json` réel du cluster :

```bash
npm run test:e2e
npm run test:e2e:ui
```

`bddgen` doit toujours être exécuté avant `playwright test`, directement ou via les scripts du projet.

## Références

- Pour le standard global de sélection du niveau, voir `testing.instructions.md`.
- Pour les tests backend, voir `testing-backend.instructions.md`.
