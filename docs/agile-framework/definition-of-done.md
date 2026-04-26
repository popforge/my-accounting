---
version: 1.1
status: ACTIVE
author: Rachel (Product Lead)
date: 2026-04-25
objective: Standardiser la complétude d'une user story avant merge/production
audience: Tout développeur travaillant dans ce repos
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

- [ ] **UI** : comportements interactifs, messages d'erreur et états de chargement implémentés conformément à l'esquisse de la story et aux standards `docs/architecture/ux-standards.md`
- [ ] **API** : tous les endpoints documentés dans la story sont implémentés avec les bons codes HTTP, payloads et messages d'erreur
- [ ] **Base de données** : tables, colonnes, contraintes et migrations EF Core créées et appliquées
- [ ] **Déploiement** : toutes les variables d'environnement requises sont documentées et configurées dans l'environnement beta

---

### 3. Tests automatisés ✓

#### Stories avec UI (flux utilisateur)
- [ ] **≥ 1 fichier `.feature` Gherkin** (fr-CA) couvrant le workflow utilisateur principal
- [ ] Scénarios incluent le **happy path** + **≥ 1 cas d'erreur principal**
- [ ] Tests **isolés** — pas de pollution d'état entre scénarios
- [ ] Waits fiables — `waitForSelector` / `waitForURL` — aucun `sleep` ou timeout arbitraire
- [ ] Tous les scénarios passent en CI ✓

#### Stories Infrastructure ou API M2M sans UI
> Exception alignée avec le DOR section 4 — les scénarios Gherkin E2E sont remplacés par des tests xUnit.

- [ ] Tests xUnit couvrent le happy path + ≥ 1 cas d'erreur par AC
- [ ] Tests d'idempotence couverts si applicable (ex : seed workers)
- [ ] Tous les tests xUnit passent en CI ✓

---

### 4. Qualité du code ✓

- [ ] Le code respecte les conventions du projet (voir `docs/architecture/architecture.md`)
- [ ] Une revue de code a été effectuée
- [ ] Tous les commentaires de revue ont été résolus (fils de discussion fermés)
- [ ] Les corrections issues de la revue sont tracées pour auditabilité

---

### 5. Validation en environnement beta ✓

- [ ] La story a été **déployée sur beta**
- [ ] La **recette manuelle** (section « Validation manuelle » de la story) a été complétée par Rachel
- [ ] La story est marquée `Done` uniquement après approbation de Rachel en beta

---

## Résumé : Checklist Rapide DOD

```
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
[ ] Déployé en beta + recette manuelle approuvée par Rachel
```