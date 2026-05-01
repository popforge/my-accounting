---
applyTo: "**"
---

# Nomenclature des répertoires — Sprints

## Structure de répertoires

Chaque sprint a son propre sous-répertoire :

```
docs/agile-framework/sprints/
└── sprint-NN-YYYY-MM-DD/
    ├── sprint-NN-YYYY-MM-DD.yaml     ← statut du sprint
    ├── sprint-NN-review.md            ← sprint review (livraison)
    ├── sprint-NN-retro.md             ← rétrospective formelle
    └── sprint-NN-retro-brouillon.md   ← brouillon (ne pas committer comme final)
```

Exemple pour Sprint 01 démarré le 2026-04-30 :
```
docs/agile-framework/sprints/sprint-01-2026-04-30/
```

## Convention de nommage

- **Répertoire :** `sprint-NN-YYYY-MM-DD` (date de début du sprint)
- **YAML de statut :** `sprint-NN-YYYY-MM-DD.yaml`
- **Sprint review :** `sprint-NN-review.md`
- **Rétrospective :** `sprint-NN-retro.md`
- **Brouillon rétro :** `sprint-NN-retro-brouillon.md`

## Format du titre de sprint

`Sprint NN — du JJ Mois au JJ Mois AAAA`
