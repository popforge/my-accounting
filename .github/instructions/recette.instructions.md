---
applyTo: "docs/tests/recettes/**"
---

# Instructions — Création de fichiers de recette manuelle

## Structure obligatoire

Pour chaque épic livré, créer le dossier et les fichiers suivants :

```
docs/tests/recettes/
└── recette-epic-<N>-<slug>/
    ├── recette-epic-<N>-<slug>.md       ← résumé + tableau de bord épic
    └── recette-story-<X.Y>-<slug>.md    ← un fichier par story (1..n)
```

### Nommage MyAccounting
- `<N>` = numéro de l'épic (ex. `0`, `1`)
- Préfixe `m` optionnel sur les identifiants selon besoin
- `<slug>` = slug kebab-case du titre
- Exemples :
  - `recette-epic-0-fondation-infrastructure/`
  - `recette-story-0.0-integration-oidc.md`

---

## Quand créer la recette

**À la fin du sprint**, avant de marquer une story `Done` :

1. Extraire les ACs de la story spec (`docs/product/stories/epic-<N>-*/story-<N.Y>-*.md`)
2. Pour chaque AC marqué `Acceptance Gherkin` ou `Recette manuelle` → créer un TC
3. Identifier les TC bloqués par des stories non encore livrées → les noter `⏳ Non testable`
4. Créer le fichier `recette-story-<X.Y>-<slug>.md` depuis le template `docs/tests/recette-template.md`
5. Mettre à jour `recette-epic-<N>-<slug>.md` depuis le template `docs/tests/recette-resume-epic-template.md`
6. Transmettre à Rachel en lui indiquant quels TC peuvent être testés maintenant

---

## Contenu d'un fichier story (`recette-template.md`)

Un fichier par story. Il contient :

- **En-tête** : story ID, titre, sprint, prérequis
- **TC-X.Y-NN** : un bloc par AC ou groupe d'ACs logiquement liés
  - `> **AC couvert :** AC1 — [libellé de l'AC]`
  - Tableau `Action | Résultat attendu | ☐/☑ | Notes`
  - Nommer le TC selon ce qu'il valide (chemin nominal, cas d'erreur, cas limite)
  - Si non testable, remplacer le tableau par ⏳ + explication
- **Résultat Story X.Y** : tableau synthèse + signature Rachel

### Règle de granularité des TC

| Situation | Action |
|-----------|--------|
| 1 AC clair et simple | 1 TC |
| Plusieurs ACs liés (même flux) | 1 TC couvrant plusieurs ACs |
| AC avec cas nominal + cas d'erreur | 2 TC séparés |
| AC bloqué par une story non livrée | TC marqué ⏳ non testable |

---

## Règles DOD — Gate recette

Une story ne peut être marquée `Done` que si :

- [ ] Le fichier `recette-story-<X.Y>-<slug>.md` existe dans le bon dossier
- [ ] Tous les TC testables ont été remplis par Rachel (☑ ou ☐ avec note)
- [ ] Les TC bloqués sont explicitement documentés avec la dépendance
- [ ] Rachel a signé la section **Résultat Story X.Y** (approuvée ou partielle)
- [ ] Le fichier résumé épic est mis à jour avec le statut de cette story

---

## Référence dans la story spec

Dans chaque story spec, la section **Validation manuelle — Recette** doit pointer vers le fichier :

```markdown
## Validation manuelle — Recette

Fichier : [`recette-story-0.0-integration-oidc.md`](../../../tests/recettes/recette-epic-0-fondation-infrastructure/recette-story-0.0-integration-oidc.md)
```

---

## Propagation cross-cluster

Ce fichier d'instructions s'applique uniquement au cluster **MyAccounting**. Si des clusters parallèles (Hub, Auth, PopSalon) adoptent le même process, propager ce fichier selon la règle de propagation cross-cluster définie dans les instructions Shared.
