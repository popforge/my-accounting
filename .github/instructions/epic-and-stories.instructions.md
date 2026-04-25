---
applyTo: "docs/product/**/*.md"
---

## Epics and Stories Documentation Structure Preference

- Use `docs/product/stories/story-template.md` as the base for every new story
- Use `docs/product/personas.md` as the source of truth for persona names in user stories
- Create one document per epic in `docs/product/epic-<id>-<slug>/epic-<id>.md`
- Create one document per user story in `docs/product/epic-<id>-<slug>/story-<id>-<slug>.md`
- Create an index document in `docs/product/index.md` with links to epics and stories

## Gherkin Scenarios

- Gherkin scenarios live under `src/{..}` — they are the source of truth
- Stories reference the `.feature` file path — **do not duplicate scenarios inside the story**
- A `.feature` file must exist (or be created) before development starts (DOD rule)

## Acceptance Criterion Format

Each AC must be written as a numbered list item in natural language, readable by a Product Owner:

```markdown
1. **AC1 — [Titre court]** : [Description complète : contexte, action de l'utilisateur, résultat visible à l'écran. Ne pas mentionner de détails techniques (noms de classes, endpoints, status codes) — ceux-ci vont dans les Artefacts techniques.]  
   *Type de test : E2E Gherkin*
```

**Règles :**
- Le texte doit être compréhensible par un PO sans connaissance technique
- Le type de test s'indique en italique sur la ligne suivante, pas dans un tableau

**Types de test valides :**
- **E2E Gherkin** — comportement visible dans le navigateur (Playwright + playwright-bdd)
- **Unit (xUnit)** — règle métier ou logique backend non observable en E2E
- **Unit (Vitest)** — logique isolée dans un store ou composable Vue
- **Manuel** — validation par un PO dans l'environnement déployé (SMS réel, provider externe, etc.)

## Error / Output Table Format

Use HTTP status + errorCode + user-facing message (not raw integers):

| HTTP | errorCode | Message utilisateur affiché |
|------|-----------|---------------------------|
| 404  | `SalonNotFound` | Salon introuvable |

## Technical Artifacts Section

Include an "Artefacts techniques" table listing all files to create or modify,
so the implementing agent can scope the work without reading the full codebase.

