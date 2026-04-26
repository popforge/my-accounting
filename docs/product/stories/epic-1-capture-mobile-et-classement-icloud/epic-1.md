# Epic 1 - Capture mobile et classement iCloud

## Objectif
Permettre a Rachel de photographier un document depuis l'application mobile et de le stocker rapidement dans iCloud avec un classement utile pour la Comptabilité personnelle et locative.

## Valeur utilisateur
- Si le flux mobile est rapide et simple, l'usage devient quotidien.
- Les pieces sont conservees au bon endroit et retrouvables en fin d'année.
- Le risque d'oubli de justificatifs et d'erreurs de declaration diminue.

## Perimêtre
- Capture photo mobile dans l'application.
- Stockage iCloud des documents.
- Classement et recherche par année, fournisseur, type de paiement, montant, et classification de depense déductible.

## critères d'acceptation (niveau epic)
1. **AC1 — Priorite mobile** : Rachel peut photographier et sauvegarder un document depuis mobile en quelques operations seulement, avec une experience suffisamment simple pour être utilisee au quotidien.
   *Type de test : E2E Gherkin*
2. **AC2 — Classement iCloud exploitable** : Les documents stockes dans iCloud sont classes et retrouvables selon les critères metier definis dans le brief.
   *Type de test : E2E Gherkin*
3. **AC3 — Base prete pour les epics suivants** : La capture et le classement etablissent une base fiable pour les actions administratives, l'ingestion bancaire et le rapport annuel.
   *Type de test : Manuel*

## Stories de l'epic
- [Story 1.0 - Classement iCloud et recherche multi-critères](./story-1-0-classement-icloud-et-recherche-multi-criteres.md)
- [Story 1.1 - Import des documents existants iCloud](./story-1-1-import-documents-existants-icloud.md)
- [Story 1.2 - Capture mobile et stockage iCloud rapide](./story-1-2-capture-mobile-et-stockage-icloud.md)

## Sources
- [Product Brief](../../product-brief-Comptabilité-personnelle.md)
- [Personas](../../personas.md)


