---
applyTo: "docs/product/stories/**/*.md"
---

# Epics et Stories — Popforge Platform

## Préfixes par cluster

Les identifiants d'epics et stories sont préfixés par une lettre propre à chaque cluster pour éviter les collisions entre clusters.

| Cluster | Préfixe | Exemple Epic | Exemple Story |
|---------|---------|-------------|---------------|
| Popforge.Auth | `a` | Epic A1 | Story A1-2 |
| Popforge.Hub | `h` | Epic H1 | Story H1-2 |
| Popforge.MyAccounting | `m` | Epic M1 | Story M1-2 |
| Popforge.PopSalon | `p` | Epic P1 | Story P1-2 |
| Popforge.Shared | `s` | Epic S01 | Story S01-1 |
| popsalon-infra | `i` | Epic I1 | Story I1-1 |

## Structure des documents

- Utiliser `docs/product/stories/story-template.md` comme base pour chaque nouvelle story.
- Utiliser `docs/product/personas.md` comme source de vérité pour les noms de personas.
- Créer un document par epic dans `docs/product/stories/epic-{PREFIX}<id>-<slug>/epic-{PREFIX}<id>.md`.
- Créer un document par story dans `docs/product/stories/epic-{PREFIX}<id>-<slug>/story-{PREFIX}<id>-<slug>.md`.
- Créer un index dans `docs/product/stories/index.md` avec liens vers epics et stories.

> **{PREFIX}** = la lettre du cluster concerné selon le tableau ci-dessus.

## Personas — Popforge Platform

| Cluster(s) | Persona | Alias | Description |
|------------|---------|-------|-------------|
| Auth | Admin | `popforge@icloud.com` | Utilisateur humain qui se connecte via la page de login |
| Auth | Client OIDC | ex: `hub-cluster`, `popsalon-app` | Application (SPA ou M2M) qui initie un flux OIDC |
| Hub, PopSalon | Anne-Marie | `coiffeuse` | Coiffeuse indépendante, non-technicienne, gère son salon |
| Hub, PopSalon | Cliente | `cliente` | Cliente du salon qui prend rendez-vous |
| MyAccounting | Rachel | `Rachel` | Administratrice de sa comptabilité personnelle et locative |

## Scénarios Gherkin

- Les scénarios Gherkin vivent sous `src/**/tests/e2e/features/` — ils sont la source de vérité.
- Les stories référencent le chemin du fichier `.feature` — **ne pas dupliquer les scénarios dans la story**.
- Un fichier `.feature` doit exister (ou être créé) avant que le développement commence (règle DOD).

## Format des critères d'acceptation

Chaque AC doit être rédigé comme un élément de liste numérotée en langage naturel :

```markdown
1. **AC1 — [Titre court]** : [Description complète : contexte, action de l'utilisateur, résultat observable. Ne pas mentionner de détails techniques (noms de classes, endpoints, status codes) — ceux-ci vont dans les Artefacts techniques.]

   *Type de test : E2E Gherkin*
```

**Règles :**
- Le texte doit être compréhensible sans connaissance technique
- Utiliser des phrases complètes, pas des abréviations ou des flèches (→)
- Le type de test s'indique en italique sur la ligne suivante, pas dans un tableau

**Types de test valides :**
- **E2E Gherkin** — comportement visible dans un navigateur, scénario `.feature` (Playwright + playwright-bdd)
- **Unit (xUnit)** — logique backend pure, règle métier ou validation non observable en E2E (.NET)
- **Unit (Vitest)** — logique isolée dans un store ou composable Vue (clusters avec SPA Vue uniquement)
- **Intégration** — controller REST, flux API complet, interaction service + base de données
- **Manuel (Recette)** — validation par Rachel dans l'environnement déployé — fichier `recette-story-*.md`

## Error / Output Table Format

Use HTTP status + errorCode + user-facing message (not raw integers):

| HTTP | errorCode | Message utilisateur affiché |
|------|-----------|---------------------------|
| 404  | `SalonNotFound` | Salon introuvable |

## Technical Artifacts Section

Include an "Artefacts techniques" table listing all files to create or modify,
so the implementing agent can scope the work without reading the full codebase.
