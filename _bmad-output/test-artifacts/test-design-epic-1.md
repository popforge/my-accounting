---
workflowStatus: 'completed'
totalSteps: 5
stepsCompleted: ['step-01-detect-mode', 'step-02-load-context', 'step-03-risk-and-testability', 'step-04-coverage-plan', 'step-05-generate-output']
lastStep: 'step-05-generate-output'
nextStep: ''
lastSaved: '2026-04-26'
---

# Test Design : Epic 1 — Capture mobile et classement iCloud

**Date :** 2026-04-26
**Auteur :** Rachel
**Mode :** Epic-Level (Phase 4)
**Statut :** Approuvé

---

## Résumé exécutif

**Périmètre :** Plan de test Epic 1 — 3 stories couvrant le classement iCloud, l'import de l'historique existant, et la capture mobile.

**Résumé des risques :**

- Risques identifiés : 8
- Risques haute priorité (score ≥ 6) : 3
- Catégories critiques : DATA, TECH, BUS

**Résumé de couverture :**

- Scénarios P0 : 6 (~12–18 h)
- Scénarios P1 : 9 (~18–28 h)
- Scénarios P2/P3 : 7 (~8–14 h)
- **Effort total estimé :** ~38–60 h (~5–8 jours)

---

## Hors périmètre

| Élément | Raison | Mitigation |
|---|---|---|
| Multi-utilisateur | Non prévu en V1 (compte unique Rachel) | Architecture prévoit l'extension future |
| OCR / catégorisation automatique | Complexité et variabilité élevées — reporté Epic 2+ | Import manuel avec aide à la saisie |
| Synchronisation temps réel iCloud | Sync incrémentale à la demande uniquement en V1 | Import complet initial + sync manuelle |
| Tests de performance à grande échelle | Volume V1 limité (usage personnel) | Seuil : index < 2 s pour 5 000 documents |

---

## Évaluation de testabilité

### Contrôlabilité ✅

- L'index PostgreSQL (Neon) est réinitialisable en test via `DatabaseFixture` xUnit.
- Les builders `.NET` (ex. `DocumentBuilder`) permettront la création rapide de données de test cohérentes.
- L'arborescence iCloud peut être simulée en test avec un répertoire local de fixtures.

### Observabilité ✅

- Les endpoints API retournent des codes HTTP et `errorCode` explicites.
- Les scénarios Gherkin valident des états visibles (listes affichées, fiches document, messages de confirmation).
- Les logs applicatifs .NET doivent inclure les événements d'import et d'indexation.

### Fiabilité ⚠️

- **Risque isolation :** L'import iCloud est non destructif mais rejouer un import peut créer des doublons dans l'index. Chaque test d'intégration doit nettoyer l'index après exécution (`IAsyncLifetime`).
- **Risque parallélisme :** Les tests Playwright doivent utiliser des données isolées par run pour éviter les collisions.

---

## Matrice des risques

### Risques haute priorité (score ≥ 6)

| ID | Catégorie | Description | P | I | Score | Mitigation | Propriétaire | Délai |
|---|---|---|---|---|---|---|---|---|
| R-001 | DATA | Import rejouable crée des doublons dans l'index PostgreSQL | 3 | 2 | **6** | Contrainte d'unicité sur `(chemin_icloud, checksum)` + détection de doublons avant insertion | Dev | Story 1.1 |
| R-002 | TECH | Parsing du format de nom existant `{Date}_{Fournisseur}_{description}_{Montant}` — variabilité élevée (espaces, accents, montants avec `$`, `,`) | 3 | 2 | **6** | Tests unitaires exhaustifs du parseur avec corpus de vrais noms de fichiers fournis par Rachel | Dev | Story 1.1 |
| R-003 | BUS | Flux capture mobile trop lent ou complexe → non adoption (critère #1 du brief) | 2 | 3 | **6** | E2E Gherkin mesurant le nombre d'opérations + recette manuelle par Rachel sur device réel | Rachel | Story 1.2 |

### Risques priorité moyenne (score 3–4)

| ID | Catégorie | Description | P | I | Score | Mitigation | Propriétaire |
|---|---|---|---|---|---|---|---|
| R-004 | DATA | Perte de document lors de l'import si erreur iCloud Drive API | 2 | 2 | **4** | Import transactionnel : indexation annulée si écriture iCloud échoue — AC6 Story 1.1 | Dev |
| R-005 | PERF | Recherche multi-critères lente sur grand historique | 2 | 2 | **4** | Index PostgreSQL sur `(annee, fournisseur, categorie, montant)` — validation < 2 s en intégration | Dev |
| R-006 | SEC | Accès aux données financières personnelles sans authentification | 1 | 3 | **3** | OpenIddict OIDC déjà en place — valider que tous les endpoints retournent 401 sans token | Dev |

### Risques faible priorité (score 1–2)

| ID | Catégorie | Description | P | I | Score | Action |
|---|---|---|---|---|---|---|
| R-007 | OPS | Indisponibilité de Neon PostgreSQL en test | 1 | 2 | **2** | Surveiller — base de test séparée de prod |
| R-008 | BUS | Format de classement non compris par Rachel à l'usage | 1 | 2 | **2** | Recette manuelle obligatoire avant `Done` sur chaque story |

---

## Critères d'entrée

- [ ] Stories 1.0, 1.1, 1.2 validées (DOR complet)
- [ ] Environnement de test Neon provisionné et distinct de la prod
- [ ] Framework Playwright + xUnit initialisé (`[TF]`)
- [ ] Builders de données de test disponibles (`DocumentBuilder`)
- [ ] Corpus de noms de fichiers existants iCloud fourni par Rachel pour les tests du parseur

## Critères de sortie

- [ ] Tous les scénarios P0 passent (100 %)
- [ ] Tous les scénarios P1 passent (≥ 95 %)
- [ ] Aucun bogue critique ouvert (R-001, R-002, R-003 mitigés)
- [ ] Recette manuelle réussie par Rachel sur device réel pour Story 1.2
- [ ] Import non destructif validé sur arborescence iCloud réelle

---

## Plan de couverture de test

### P0 — Sur chaque commit (bloquant)

| Exigence | Niveau de test | Risque lié | Nb scénarios | Notes |
|---|---|---|---|---|
| Classement d'un document selon les 5 critères | E2E Gherkin | R-003 | 2 | Story 1.0 AC1 |
| Recherche multi-critères combinée (≥ 2 critères) | E2E Gherkin | R-005 | 2 | Story 1.0 AC2 |
| Import sans doublons (import rejouable) | Intégration xUnit | R-001 | 2 | Story 1.1 — contrainte unicité DB |

**Total P0 :** 6 scénarios, ~12–18 h

---

### P1 — Sur PR vers main

| Exigence | Niveau de test | Risque lié | Nb scénarios | Notes |
|---|---|---|---|---|
| Parsing noms de fichiers existants (formats variés) | Unitaire xUnit | R-002 | 4 | Corpus de noms réels Rachel |
| Import `!Facturette` — sous-dossiers reconnus | E2E Gherkin | R-004 | 2 | Story 1.1 AC3 |
| Résultats de recherche affichent infos classement | E2E Gherkin | — | 1 | Story 1.0 AC3 |
| Modification de classement → document reclassé | E2E Gherkin | — | 1 | Story 1.0 AC4 |
| Authentification — 401 sans token sur tous les endpoints | Intégration xUnit | R-006 | 1 | `[Trait("Epic","1")]` |

**Total P1 :** 9 scénarios, ~18–28 h

---

### P2 — Nightly

| Exigence | Niveau de test | Nb scénarios | Notes |
|---|---|---|---|
| Capture mobile en quelques opérations (Story 1.2 AC1) | E2E Gherkin | 2 | Recette UI mobile |
| Stockage iCloud fiable après fermeture/réouverture | E2E Gherkin | 1 | Story 1.2 AC2 |
| Import `Relevés - X` | E2E Gherkin | 1 | Story 1.1 AC2 |
| Interprétation et évolution vers format cible | E2E Gherkin | 2 | Story 1.1 AC4-AC5 |
| Import non destructif — sources iCloud préservées | Manuel | 1 | Story 1.1 AC6 — recette Rachel |

**Total P2 :** 7 scénarios, ~8–14 h

---

## Stratégie d'exécution

| Déclencheur | Suite | Durée cible |
|---|---|---|
| Chaque commit / PR | P0 (6 scénarios E2E + intégration) | < 10 min |
| PR vers `main` | P0 + P1 | < 20 min |
| Nightly | P0 + P1 + P2 | < 45 min |
| Avant release | P0 + P1 + P2 + recette manuelle Rachel | 1 journée |

---

## Portes de qualité (Quality Gates)

| Porte | Seuil |
|---|---|
| P0 pass rate | 100 % obligatoire |
| P1 pass rate | ≥ 95 % |
| Risques R-001, R-002, R-003 | Mitigations implémentées avant Story 1.2 |
| Couverture unitaire parseur | ≥ 80 % des branches du `documentFilenameParser` |
| Recette Rachel Story 1.2 | Approuvée sur device réel avant `Done` |

---

## Références

- [Epic 1](../../docs/product/stories/epic-1-capture-mobile-et-classement-icloud/epic-1.md)
- [Story 1.0 — Classement](../../docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-0-classement-icloud-et-recherche-multi-criteres.md)
- [Story 1.1 — Import](../../docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-1-import-documents-existants-icloud.md)
- [Story 1.2 — Capture](../../docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-2-capture-mobile-et-stockage-icloud.md)
- [Architecture](../../docs/architecture/architecture.md)
- [ADR-001](../../docs/architecture/adr/ADR-001-reuse-existing-saas-stack-single-tenant-first.md)
- [Standard de test global](../../.github/instructions/testing.instructions.md)
- [Standard de test backend](../../.github/instructions/testing-backend.instructions.md)
- [Standard de test frontend](../../.github/instructions/testing-frontend.instructions.md)
