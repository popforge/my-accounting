---
applyTo: "docs/product/stories/**/*.md"
---

## Epics and Stories — MyAccounting

- Utiliser `docs/product/stories/story-template.md` comme base pour chaque nouvelle story.
- Utiliser `docs/product/personas.md` comme source de vérité pour les noms de personas.
- Créer un document par epic dans `docs/product/stories/epic-m<id>-<slug>/epic-m<id>.md`.
- Créer un document par story dans `docs/product/stories/epic-m<id>-<slug>/story-m<id>-<slug>.md`.
- Créer un index dans `docs/product/stories/index.md` avec liens vers epics et stories.

> Les identifiants d'épics et stories de ce cluster sont préfixés `m` pour éviter les collisions avec d'autres clusters (ex : Epic m1, Story m1-2).

## Scénarios Gherkin

- Les scénarios Gherkin vivent sous `src/my-accounting/tests/e2e/features/` — ils sont la source de vérité.
- Les stories référencent le chemin du fichier `.feature` — **ne pas dupliquer les scénarios dans la story**.
- Un fichier `.feature` doit exister (ou être créé) avant que le développement commence (règle DOD).

## Format des critères d'acceptation

Chaque AC doit être rédigé comme un élément de liste numérotée en langage naturel :

```markdown
1. **AC1 — [Titre court]** : [Description complète : contexte, action de l'utilisateur, résultat observable. Ne pas mentionner de détails techniques (noms de classes, endpoints, status codes) — ceux-ci vont dans les Artefacts techniques.]

   *Type de test : E2E Gherkin*
```

**Règles :**
- Le texte doit être compréhensible sans connaissance technique approfondie.
- Utiliser des phrases complètes, pas des abréviations ou des flèches (→).
- Le type de test s'indique en italique sur la ligne suivante, pas dans un tableau.

**Types de test valides :**
- **E2E Gherkin** — comportement visible dans le navigateur (Playwright + playwright-bdd)
- **Unit (xUnit)** — règle métier ou logique backend non observable en E2E
- **Unit (Vitest)** — logique isolée dans un store ou composable Vue
- **Intégration (xUnit)** — controller REST ou flux API complet via WebApplicationFactory
- **Manuel** — validation dans l'environnement déployé (provider externe, SMS, token réel, etc.)

## Format de table d'erreurs

Utiliser HTTP status + errorCode + message utilisateur (pas d'entiers bruts) :

| HTTP | errorCode | Message utilisateur affiché |
|------|-----------|---------------------------|
| 404  | `ResourceNotFound` | Ressource introuvable |

## Section Artefacts techniques

Inclure un tableau "Artefacts techniques" listant tous les fichiers à créer ou modifier, pour que l'agent implémenteur puisse cadrer le travail sans lire tout le codebase.