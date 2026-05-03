---
applyTo: "docs/**/*.md"
---

# Documentation Placement Conventions — Popforge Platform

Prefer brief, clear, and concise content with bullet points or checklists where appropriate. When creating or updating project and analysis documentation (not code):

- Naming convention kebab-case mandatory.
- Prefer lowercase. Can be overruled by readability concerns (e.g., `ADR-001-openiddict-oidc-auth-server.md`).
- Always write in french with accents.

Folder hierarchy :

```
docs/
├── agile-framework/
├── architecture/
│   ├── adr/
│   └── deployment-beta.md
├── devsecops/
├── test/
├── product/
│   ├── personas.md
│   └── stories/
│       ├── index.md
│       ├── story-template.md
│       └── epic-{PREFIX}<n>-<slug>/
├── reviews/
└── project-context.md
```

> **{PREFIX}** = la lettre du cluster (voir `epic-and-stories.instructions.md` pour le tableau des préfixes).

**Agile Framework & Team Process:**
- Definition of Done, Definition of Ready, Sprint Planning templates, Git workflow → `docs/agile-framework/`
- Sprint planning, sprint status, sprint reviews, retrospectives → `docs/agile-framework/sprints/`
- Nommage des sprints : `sprint-NN-YYYY-MM-DD.yaml` ou `YYYY-MM-DD-sprint-review-<slug>.md`
- Format du titre de sprint : `Sprint NN — du JJ Mois au JJ Mois AAAA`

**Testing Strategy & Test Data (Documentation):**
- Test architecture, test data strategy, testing guidelines → `docs/test/`
- Note: does not include `.feature` files (Gherkin) which should be located in `src/**/tests/e2e/features/`

**Architecture & Technical Decisions:**
- Architecture Decision Records (ADRs) → `docs/architecture/adr/`
- ADR naming convention: kebab-case (e.g., `ADR-001-stack-technique-mvp.md`)
- Other architecture documentation → `docs/architecture/`

**DevSecOps & Security:**
- Security go/no-go checks, deployment security, compliance verification → `docs/devsecops/`

**Product & Stories:**
- Epics et stories → `docs/product/stories/epic-{PREFIX}<n>-<slug>/`

**Fichiers gitignored (ne jamais committer) :**
- `docs/architecture/dev-secrets-setup.md` — credentials locaux de développement
