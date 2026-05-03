---
applyTo: "src/**/*.{ts,vue,feature}"
---

## Tests Frontend — Domaine MyAccounting

> Ce fichier contient les conventions de test frontend spécifiques à MyAccounting.
> Il complète `shared/testing/testing-frontend.instructions.md` (synchronisé depuis Popforge.Shared).
> Ne pas modifier sans raison — ce fichier ne sera PAS écrasé lors des syncs.

### Chemin des fichiers `.feature` MyAccounting

```
src/my-accounting/tests/e2e/features/
```

### Tags Gherkin MyAccounting

- `@epic-m<n>` et `@story-m<n>-<n>` (préfixe `m`)
- `@area-myaccounting` sur chaque fonctionnalité
- `@component-<nom>` sur le composant testé

### Couverture E2E prioritaire

- Classement automatique d'un document importé.
- Recherche et filtrage par catégorie / année.
- Import depuis iCloud.

### Tests Vitest (Vue 3 — à venir)

> Le SPA Vue n'est pas encore implémenté. Ces conventions s'appliqueront à sa création.

- Fichiers de test : `*.spec.ts` colocalisés ou dans `__tests__/`
- Tester composables sous `src/composables/__tests__/`
- Pour les stores Pinia : `setActivePinia(createPinia())` avant chaque test
