---
applyTo: "docs/tests/recettes/**"
---

# Instructions — Création de fichiers de recette manuelle

## Structure obligatoire

Pour chaque épic livré, créer le dossier et les fichiers suivants :

```
docs/tests/recettes/
└── recette-epic-{PREFIX}<N>-<slug>/
    ├── recette-epic-{PREFIX}<N>-<slug>.md       ← résumé + tableau de bord épic
    └── recette-story-{PREFIX}<N.Y>-<slug>.md    ← un fichier par story (1..n)
```

> **{PREFIX}** = la lettre du cluster concerné (voir `epic-and-stories.instructions.md` pour le tableau des préfixes).

### Nommage

- `{PREFIX}` = lettre du cluster (ex. `a` pour Auth, `h` pour Hub, `p` pour PopSalon)
- `<N>` = numéro de l'épic (ex. `1`, `2`)
- `<slug>` = slug kebab-case du titre (ex. `acces-admin-gestion-tenant`)
- Exemples :
  - `recette-epic-a1-oidc/`
  - `recette-story-a1.1-login-pkce.md`
  - `recette-epic-p2-prise-de-rendez-vous/`
  - `recette-story-p2.3-annulation.md`

---

## Quand créer la recette

**À la fin du sprint**, avant de marquer une story `Done` :

1. Extraire les ACs de la story spec (`docs/product/stories/epic-{PREFIX}<N>-*/story-{PREFIX}<N.Y>-*.md`)
2. Pour chaque AC marqué `E2E Gherkin` ou `Manuel (Recette)` → créer un TC
3. Identifier les TC bloqués par des stories non encore livrées → les noter `⏳ Non testable`
4. Créer le fichier `recette-story-{PREFIX}<N.Y>-<slug>.md` depuis le template `docs/tests/recette-template.md`
5. Mettre à jour `recette-epic-{PREFIX}<N>-<slug>.md` depuis le template `docs/tests/recette-resume-epic-template.md`
6. Transmettre à Rachel en lui indiquant quels TC peuvent être testés maintenant

---

## Contenu d'un fichier story (`recette-template.md`)

Un fichier par story. Il contient :

- **En-tête** : story ID, titre, sprint, prérequis
- **TC-{PREFIX}<N.Y>-NN** : un bloc par AC ou groupe d'ACs logiquement liés
  - `> **AC couvert :** AC1 — [libellé de l'AC]`
  - Tableau `Action | Résultat attendu | ☐/☑ | Notes`
  - Nommer le TC selon ce qu'il valide (chemin nominal, cas d'erreur, cas limite)
  - Si non testable, remplacer le tableau par ⏳ + explication
- **Résultat Story {PREFIX}<N.Y>** : tableau synthèse + signature Rachel

### Règle de granularité des TC

| Situation | Action |
|-----------|--------|
| 1 AC clair et simple | 1 TC |
| Plusieurs ACs liés (même flux) | 1 TC couvrant plusieurs ACs |
| AC avec cas nominal + cas d'erreur | 2 TC séparés |
| AC bloqué par une story non livrée | TC marqué ⏳ non testable |

---

## Contenu du fichier résumé épic (`recette-resume-epic-template.md`)

Un seul fichier par épic. Il contient :

- **Tableau des stories** : lien vers chaque fichier `recette-story-*.md`
- **Tableau de bord** : statut par story (date + résultat + validé par)
- **Items bloqués** : TC cross-story non testables + raison
- **Résultat global** : signature Rachel pour l'épic complet

---

## Règles DOD — Gate recette

Une story ne peut être marquée `Done` que si :

- [ ] Le fichier `recette-story-{PREFIX}<N.Y>-<slug>.md` existe dans le bon dossier
- [ ] Tous les TC testables ont été remplis par Rachel (☑ ou ☐ avec note)
- [ ] Les TC bloqués sont explicitement documentés avec la dépendance
- [ ] Rachel a signé la section **Résultat Story {PREFIX}<N.Y>** (approuvée ou partielle)
- [ ] Le fichier résumé épic est mis à jour avec le statut de cette story

---

## Référence dans la story spec

Dans chaque story spec, la section **Validation manuelle — Recette** doit pointer vers le fichier :

```markdown
## Validation manuelle — Recette

Fichier : [`recette-story-{PREFIX}<N.Y>-<slug>.md`](../../../tests/recettes/recette-epic-{PREFIX}<N>-<slug>/recette-story-{PREFIX}<N.Y>-<slug>.md)
```
