---
applyTo: "docs/**/*.md"
---

## Conventions de placement de la documentation — MyAccounting

Préférer un contenu bref, clair et concis avec des listes à puces ou des listes de contrôle. Lors de la création ou de la mise à jour de documentation de projet et d'analyse (pas de code) :

- Convention de nommage kebab-case obligatoire.
- Préférer les minuscules. Peut être remplacé par des considérations de lisibilité (ex. : `ADR-001-stack-technique-mvp.md`).
- Toujours écrire en français avec les accents.

Hiérarchie de dossiers :

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
│       └── epic-m<n>-<slug>/
├── reviews/
└── project-context.md
```

**Cadre Agile & Processus d'équipe :**
- Definition of Done, Definition of Ready, modèles de Sprint Planning, workflow Git → `docs/agile-framework/`

**Stratégie de test & Données de test (documentation) :**
- Architecture de test, stratégie de données de test, directives de test → `docs/test/`
- Documentation provenant de conversations avec TEA (Murat) devraient être ici.
- Les fichiers `.feature` (Gherkin) se trouvent dans `src/my-accounting/tests/e2e/features/`

**Architecture & Décisions techniques :**
- Architecture Decision Records (ADRs) → `docs/architecture/adr/`
- Convention de nommage ADR : kebab-case (ex. : `ADR-001-stack-technique-mvp.md`)
- Autre documentation d'architecture → `docs/architecture/`

**DevSecOps & Sécurité :**
- Vérifications de sécurité go/no-go, sécurité du déploiement, vérification de conformité → `docs/devsecops/`

**Fichiers gitignored (ne jamais committer) :**
- `docs/architecture/dev-secrets-setup.md` — credentials locaux de développement
