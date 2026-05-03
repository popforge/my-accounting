---
applyTo: "src/**/*.{ts,vue,cs,feature}"
---

# Standard global de test — Popforge Platform

## Choix du niveau de test

- **E2E Gherkin** : pour les flux critiques observables dans un navigateur (parcours utilisateur, états visibles).
- **Unit** : pour la logique métier backend — validations, règles, calculs purs.
- **Intégration** : pour les controllers REST et flux API complets.

### Règles de sélection

- Favoriser le niveau le plus bas qui couvre correctement le comportement (pyramide : Unit → Intégration → E2E).
- Ne pas dupliquer un même flux en E2E et en intégration sans raison claire.
- Réserver les scénarios Gherkin aux flux observables dans un navigateur.

## Dérivation obligatoire AC → niveau de test

Lors de la rédaction d'une story, chaque AC **doit indiquer son type de test** en italique. Ce type crée une obligation :

| Type dans l'AC | Obligation |
|---|---|
| `E2E Gherkin` | Scénario `.feature` obligatoire avant le développement (DOR) |
| `Unit (xUnit)` | Test xUnit obligatoire sous `tests/unit/`, écrit après les E2E |
| `Unit (Vitest)` | Test Vitest obligatoire sous `tests/unit/`, écrit après les E2E |
| `Intégration` | Test obligatoire sous `tests/integration/`, écrit après les E2E |
| `Manuel (Recette)` | Scénario dans la recette manuelle, exécuté par Rachel avant Done |

Un AC sans type de test est **invalide** et bloque le DOR.

## Définition de qualité minimale

Chaque test doit être :

- déterministe ;
- isolé ;
- lisible ;
- rapide ;
- explicite dans ses assertions.

À éviter :

- `waitForTimeout(...)` et attentes arbitraires ;
- logique conditionnelle qui change le chemin d'exécution du test ;
- assertions cachées dans des helpers opaques ;
- doublons de couverture entre niveaux de test sans justification.

## Traçabilité attendue

Les tags de traçabilité suivent le pattern de préfixe du cluster (voir `epic-and-stories.instructions.md`) :

- `@epic-{PREFIX}<n>` — relie le test à l'epic (ex. : `@epic-a1`, `@epic-h2`)
- `@story-{PREFIX}<n>-<n>` — relie le test à la story (ex. : `@story-a1-2`, `@story-p3-1`)

> **{PREFIX}** = la lettre du cluster concerné. Voir le tableau des préfixes dans `epic-and-stories.instructions.md`.

Une story qui exige un flux observable doit référencer un fichier `.feature` avec ces tags.

## Règles transverses

- Les scénarios Gherkin sont rédigés en **français**.
- Les tests doivent refléter le vocabulaire du domaine du cluster — pas celui d'un autre cluster.
- Quand un test crée des données, il doit prévoir leur nettoyage ou utiliser une base isolée.

## Références spécialisées

- Pour les conventions Gherkin E2E, voir `testing-frontend.instructions.md`.
- Pour les conventions de test backend, voir `testing-backend.instructions.md`.
