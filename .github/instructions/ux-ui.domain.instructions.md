---
applyTo: "src/**/*.{ts,vue,css},docs/product/UX-UI/**"
---

## Standards UX — Domaine MyAccounting

> Ce fichier contient les conventions UX spécifiques à MyAccounting.
> Il complète `components/platform/ux-ui.instructions.md` (synchronisé depuis Popforge.Components).
> Ne pas modifier sans raison — ce fichier ne sera PAS écrasé lors des syncs.

### Orientation : mobile-first

MyAccounting suit la même architecture que PopSalon — **mobile-first** à 375px.
Les ajustements desktop se font via `@media (min-width: 960px)`.

### Effet Aurora (activé — variant `standard`)

MyAccounting utilise l'aurora en variant **`standard`**.

```vue
<AuroraBackground variant="standard" />
```

> Le SPA Vue n'est pas encore implémenté — Aurora sera ajoutée lors de la création du frontend.
