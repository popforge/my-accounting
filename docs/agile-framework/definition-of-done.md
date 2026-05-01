---
version: 1.3
status: ACTIVE
author: Rachel (Product Lead)
date: 2026-05-01
objective: Standardiser la complétude d'une user story avant merge/production
audience: Tout développeur travaillant dans ce repos
changelog:
  - "1.3 (2026-05-01) : Section 5 — référence explicite au fichier recette-epic-NN.md. Retro Sprint 01 — action item."
  - "1.2 (2026-05-01) : Ajout section 4.5 (recette manuelle exécutée), section 5.5 (infra cross-cluster smoke). Retro Sprint 01."
---

# Definition of Done — User Stories

## Vue d'ensemble

Une **user story est complète et prête pour production** si et seulement si **TOUS** les critères suivants sont satisfaits.

---

## Checklist Complète

### 1. Acceptance Criteria (AC) — Comportement attendu ✓

- [ ] **Tous les AC** spécifiés dans la story sont implémentés
- [ ] Chaque AC est vérifiable — le comportement attendu peut être observé ou mesuré
- [ ] Aucun AC n'est contourné ou partiellement implémenté

---

### 2. Tranche verticale — Toutes les couches livrées ✓

- [ ] **UI** : comportements interactifs, messages d'erreur et états de chargement implémentés conformément à l'esquisse de la story et aux standards `docs/product/UX-UI/ux-ui-standards.md`
- [ ] **API** : tous les endpoints documentés dans la story sont implémentés avec les bons codes HTTP, payloads et messages d'erreur
- [ ] **Base de données** : tables, colonnes, contraintes et migrations EF Core créées et appliquées
- [ ] **Déploiement** : toutes les variables d'environnement requises sont documentées et configurées dans l'environnement beta

---

### 3. Tests automatisés ✓

#### Stories avec UI (flux utilisateur observable dans un navigateur)
- [ ] **≥ 1 fichier `.feature` Gherkin** (fr-CA) couvrant le workflow utilisateur principal
- [ ] Scénarios incluent le **happy path** + **≥ 1 cas d'erreur principal**
- [ ] Tests **isolés** — pas de pollution d'état entre scénarios
- [ ] Waits fiables — `waitForSelector` / `waitForURL` — aucun `sleep` ou timeout arbitraire
- [ ] **`npm run test:e2e` passe en vert** depuis le projet E2E du cluster ✓ (pas seulement un fichier `.feature` présent — le runner doit exécuter les scénarios avec succès)
- [ ] Le job **`smoke-e2e` du pipeline `deploy-beta.yml` passe en vert** après déploiement ✓

#### Stories Infrastructure ou API M2M sans UI
> Exception alignée avec le DOR section 4 — les scénarios Gherkin E2E sont remplacés par des tests xUnit.

- [ ] Tests xUnit couvrent le happy path + ≥ 1 cas d'erreur par AC
- [ ] Tests d'idempotence couverts si applicable (ex : seed workers)
- [ ] Tous les tests xUnit passent en CI ✓

#### Règle universelle — AC marqués xUnit (toutes stories)
> S'applique à toutes les stories, avec ou sans UI.

- [ ] Tout AC dont le type de test est `Unit (xUnit)` dans le story spec a **≥ 1 test xUnit écrit dans `tests/unit/`** et passant en CI
- [ ] Tout AC dont le type de test est `Intégration (xUnit)` dans le story spec a **≥ 1 test xUnit écrit dans `tests/integration/`** et passant en CI
- [ ] Les tests xUnit sont écrits **après les tests E2E** et couvrent la logique interne non observable par Gherkin

---

### 4. Qualité du code ✓

- [ ] Le code respecte les conventions du projet (voir `docs/architecture/architecture.md`)
- [ ] Une revue de code a été effectuée
- [ ] Tous les commentaires de revue ont été résolus (fils de discussion fermés)
- [ ] Les corrections issues de la revue sont tracées pour auditabilité

---

### 5. Validation en environnement beta ✓

- [ ] La story a été **déployée sur beta** (`my-accounting-beta.popsalon.app`)
- [ ] La **recette manuelle** a été **exécutée** par Rachel : tous les scénarios de la section correspondante dans `docs/product/stories/recettes/recette-epic-NN.md` cochés ✅ ou ❌ avec notes
- [ ] La story est marquée `Done` uniquement après approbation de Rachel dans le fichier recette (`recette-epic-NN.md` — section de la story signée)

### 5.5. Canal cross-cluster — smoke test ✓
> S'applique uniquement si la story utilise un canal inter-cluster (M2M, provisioning, etc.)

- [ ] Le canal est validé opérationnel en beta **avant** de marquer Done : token M2M obtenu, appel Admin API retourne 2xx
- [ ] Si un bug d'infrastructure cross-cluster a été corrigé durant la story, un test xUnit est ajouté pour le couvrir (évite régression silencieuse)
- [ ] Les clusters **en aval** (ex. : Auth quand Hub est modifié) sont vérifiés non régressés

---

## Résumé : Checklist Rapide DOD

```
AC
[ ] Tous les AC implémentés et vérifiables

TRANCHE VERTICALE
[ ] UI conforme à l'esquisse + ux-standards.md
[ ] API : endpoints, payloads, codes HTTP corrects
[ ] DB : tables, contraintes, migrations appliquées
[ ] Déploiement : variables d'env configurées en beta

TESTS
[ ] Stories UI  → .feature Gherkin (happy path + ≥1 erreur) passent en CI
[ ] Stories Infra/M2M → tests xUnit (happy path + ≥1 erreur) passent en CI

QUALITÉ
[ ] Revue de code effectuée + commentaires résolus

VALIDATION
[ ] Déployé en beta + recette dans docs/product/stories/recettes/recette-epic-NN.md complétée et signée par Rachel
[ ] Si cross-cluster : smoke test canal + clusters aval vérifiés non régressés
```