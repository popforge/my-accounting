---
applyTo: "docs/product/**/*.md"
---

## Epics et Stories — Domaine MyAccounting

> Ce fichier contient les conventions spécifiques au domaine MyAccounting.
> Il complète `shared/agile/epic-and-stories.instructions.md` (synchronisé depuis Popforge.Shared).
> Ne pas modifier sans raison — ce fichier ne sera PAS écrasé lors des syncs.

### Préfixe MyAccounting

Dans ce cluster, `{PREFIX}` = **`m`** — les epics et stories sont donc nommés `m<n>` (ex. : `Epic M1`, `Story M1-2`).

### Structure docs MyAccounting

- Template de story : `docs/product/stories/story-template.md`
- Personas : `docs/product/personas.md`
- Epics : `docs/product/stories/epic-m<id>-<slug>/epic-m<id>.md`
- Stories : `docs/product/stories/epic-m<id>-<slug>/story-m<id>-<slug>.md`
- Index : `docs/product/stories/index.md`

### Chemin des fichiers `.feature` MyAccounting

```
src/my-accounting/tests/e2e/features/
```

### Personas MyAccounting

| Persona | Identifiant | Rôle |
|---------|-------------|------|
| **Rachel** | `popforge@icloud.com` | Utilisatrice principale — gestion comptable personnelle |

### Vocabulaire métier dans les ACs

- Utiliser `document`, `classement`, `iCloud`, `facture`, `catégorie` — pas de synonymes.
- Les validations de nommage sont des comportements critiques à couvrir en test unitaire.
