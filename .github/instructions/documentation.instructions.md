---
applyTo: "docs/**/*.md"
---

## Documentation Placement Conventions

Prefer brief, clear, and concise content with bullet points or checklists where appropriate. When creating or updating project and analysis documentation (not code):

- Naming convention kebab-case mandatory.
- Prefer lowercase. Can be overruled by readability concerns (e.g., `ADR-001-template.md`).
- Always write in french with accents.

Folder hierachy :

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
│       └── epic-a<n>-<slug>/
├── reviews/
└── project-context.md
```

**Agile Framework & Team Process:**
- Definition of Done, Definition of Ready, Sprint Planning templates, Git workflow → `docs/agile-framework/`

**Testing Strategy & Test Data (Documentation):**
- Test architecture, test data strategy, testing guidelines → `docs/test/`
- All documentation from TEA (Murat) conversation should be placed here.
- Note: does not include `.feature` files (Gherkin) which should be located in `src/{ClusterName}/tests/e2e/features/`

**Architecture & Technical Decisions:**
- Architecture Decision Records (ADRs) → `docs/architecture/adr/`
- ADR naming convention: kebab-case (e.g., `ADR-001-stack-technique-mvp.md`)
- Other architecture documentation → `docs/architecture/`

**DevSecOps & Security:**
- Security go/no-go checks, deployment security, compliance verification → `docs/devsecops/`
