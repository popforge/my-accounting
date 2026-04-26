---
version: 1.0
status: ACTIVE
date: 2026-04-24
owner: Bob (Scrum Master) / Rachel (Product Lead)
---

# Definition of Ready — User Stories

## Vue d'ensemble

Une story est **prête à entrer en développement** si et seulement si tous les critères suivants sont satisfaits. Un agent IA ou une développeuse ne doit jamais commencer l'implémentation d'une story qui ne satisfait pas ce DOR.

---

## Checklist DOR

### 1. Identité & Traçabilité ✓
- [ ] La story a un **identifiant unique** (`story-<epic>-<story>`, ex : `story-2-1`)
- [ ] La story est listée dans `docs/product/stories/index.md`
- [ ] La story suit le **format standard** (`docs/product/stories/story-template.md`)

### 2. Énoncé utilisateur ✓

- [ ] L'énoncé respecte le format : *En tant que [persona], je veux [action] afin de [bénéfice mesurable]*
- [ ] Le **persona est valide**
- [ ] Le bénéfice est **mesurable ou observable** 

### 3. Acceptance Criteria (AC) ✓

- [ ] **Tous les AC sont écrits** et numérotés
- [ ] Le **cas nominal (happy path)** est couvert
- [ ] Au moins **1 cas d'erreur ou cas limite** est couvert
- [ ] Les AC ne dictent **pas l'implémentation** — ils décrivent le comportement observable
- [ ] Les termes utilisés correspondent au **domaine**

### 4. Scénarios Gherkin pré-validés ✓
- [ ] Les scénarios `.feature` sont localisés dans `src/{ClusterName}/tests/e2e/features/`
- [ ] Les scénarios ont été **relus et approuvés par Rachel** avant le début du developpement
- [ ] Les tags obligatoires sont présents : `@acceptance`, `@epic-<n>`, `@story-<n>-<n>`, `@area-*`, `@component-*`
- [ ] Les scénarios sont rédigés en **français canadien (fr-CA)**

> **Exception — stories infra et M2M :** Une story classifiée comme **Infrastructure pure** (aucun comportement utilisateur observable dans un navigateur) ou **API M2M sans UI** (endpoint uniquement consommé par un service machine-to-machine) peut être exemptée des scénarios E2E Gherkin. L'exemption **doit être déclarée explicitement** dans la section « Scénarios Gherkin » de la story avec la raison : `Infrastructure` ou `API M2M sans UI`. Les tests xUnit remplacent les scénarios E2E pour ces stories.

### 5. Tranche verticale définie ✓
- [ ] La story représente une **tranche verticale** (end-to-end) de fonctionnalité
- [ ] La story comprends les informations nécessaires pour implémenter les couches suivantes : 
  - [ ] **UI** : maquettes ou esquisses présentes, comportements interactifs et messages d'erreur décrits, approche desktop/mobile conforme à `docs/architecture/ux-standards.md`
  - [ ] **API** : endpoints, payloads, erreurs, route, cluster et microservice concerné
  - [ ] **Tests E2E** : scénarios Gherkin, données de test
  - [ ] **Base de données** : tables, relations, contraintes
  - [ ] **Déploiement** : configuration, secrets, monitoring, alerting
- [ ] La story une fois terminée, peut être **déployée en production**

### 6. Dépendances ✓

- [ ] Les **stories prérequises** sont identifiées (ex : story 2.1 dépend de 1.1)
- [ ] Les dépendances prérequises sont **complétées**

### 7. Clarté technique suffisante ✓

- [ ] Pas de **décision d'architecture ouverte** bloquante (si oui → créer un ADR d'abord)

### 8. Sizing & Scope ✓

- [ ] La story est **réalisable en un seul cycle de développement** (typiquement ≤ 2 jours de travail)
- [ ] La story ne couvre **qu'un seul objectif utilisateur** — si deux objectifs indépendants : scinder
- [ ] La story n'a pas de **bloc "À définir plus tard"** ou "TODO"** dans les AC

### 9. Données de test ✓

- [ ] Les **données de test nécessaires** sont identifiées (comptes de test, créneaux, prestations, clientes)
- [ ] Si la story nécessite des données spécifiques, elles sont **décrites dans les AC** ou dans une note de test

---

## Résumé : Checklist Rapide DOR

```
IDENTITÉ & TRAÇABILITÉ
[ ] Identifiant unique (story-<epic>-<story>)
[ ] Listée dans docs/product/stories/index.md
[ ] Format standard respecté (story-template.md)

ÉNONCÉ UTILISATEUR
[ ] Format : En tant que [persona], je veux [action] afin de [bénéfice mesurable]
[ ] Persona valide, bénéfice observable

ACCEPTANCE CRITERIA
[ ] Tous les AC numérotés
[ ] Happy path + ≥ 1 cas d'erreur couverts
[ ] AC décrivent le comportement — pas l'implémentation

SCÉNARIOS GHERKIN
[ ] Fichier .feature dans src/{ClusterName}/tests/e2e/features/
[ ] Tags obligatoires : @acceptance @epic-<n> @story-<n>-<n> @area-* @component-*
[ ] Rédigés en français canadien (fr-CA)
[ ] Approuvés par Rachel avant le début du développement
    — Exception : story Infrastructure ou API M2M sans UI → exemption déclarée
      explicitement + tests xUnit en remplacement

TRANCHE VERTICALE
[ ] UI : esquisse ou maquette présente + comportements/erreurs décrits
         + approche desktop/mobile conforme à docs/architecture/ux-standards.md
[ ] API : endpoints, payloads JSON, codes d'erreur, cluster et microservice concerné
[ ] Tests E2E : scénarios Gherkin liés, données de test identifiées
[ ] Base de données : tables, colonnes, types, contraintes, relations
[ ] Déploiement : variables d'environnement requises, secrets, configuration nginx/Docker

DÉPENDANCES
[ ] Stories prérequises identifiées
[ ] Dépendances prérequises complétées (statut Done)

CLARTÉ TECHNIQUE
[ ] Aucune décision d'architecture ouverte bloquante (sinon → ADR d'abord)

SIZING & SCOPE
[ ] Réalisable en ≤ 2 jours de travail
[ ] Un seul objectif utilisateur (sinon → scinder)
[ ] Aucun bloc "À définir plus tard" ou TODO dans les AC

DONNÉES DE TEST
[ ] Données de test identifiées (comptes, états, cas limites)
[ ] Données décrites dans les AC ou dans une note de test
```

