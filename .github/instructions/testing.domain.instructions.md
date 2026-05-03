---
applyTo: "src/**/*.{ts,vue,cs,feature}"
---

## Stratégie de test — Domaine MyAccounting

> Ce fichier contient les conventions de test spécifiques au domaine MyAccounting.
> Il complète `shared/testing/testing.instructions.md` (synchronisé depuis Popforge.Shared).
> Ne pas modifier sans raison — ce fichier ne sera PAS écrasé lors des syncs.

### Particularités de MyAccounting

MyAccounting est un **backend ASP.NET + SPA Vue 3** (architecture identique à PopSalon, mobile-first).
Le SPA Vue n'est pas encore implémenté — les tests Vitest s'appliqueront quand il sera créé.

### Niveaux de test applicables

| Niveau | Quand l'utiliser |
|---|---|
| **E2E Gherkin (Playwright)** | Flux utilisateur observables : classement, import, recherche |
| **Unit (Vitest)** | Composables, stores Pinia, services Vue (quand le SPA existera) |
| **Unit (xUnit)** | Règles de classement, validations, transformations de données |
| **Intégration (xUnit)** | Controllers API REST, flux complets |

### Tags Gherkin MyAccounting

- `@epic-m<n>` et `@story-m<n>-<n>` (préfixe `m`)
- `@area-myaccounting` — sur chaque fonctionnalité
- `@component-<nom>` — sur le composant testé

### Règles transverses

- Les scénarios Gherkin sont rédigés en **français**.
- Vocabulaire métier : `document`, `classement`, `iCloud`, `facture`, `catégorie`.
