---
applyTo: "src/**/*.{ts,vue,cs,feature}"
---

## Standard global de test — MyAccounting

Le projet MyAccounting suit une stratégie de test orientée risque avec séparation claire des niveaux de test.

### Choix du niveau de test

- **Acceptance Gherkin** : pour les parcours utilisateur critiques et observables dans un navigateur.
- **Unit (xUnit)** : pour la logique métier backend — validations, services, règles de transformation.
- **Unit (Vitest)** : pour la logique isolée côté frontend — stores, composables, règles de transformation.
- **Intégration (xUnit + WebApplicationFactory)** : pour les controllers API REST et flux API complets.

### Règles de sélection

- Favoriser le niveau le plus bas qui couvre correctement le comportement.
- Ne pas dupliquer un même flux en Gherkin et en test d'intégration sans raison claire.
- Réserver les scénarios Gherkin aux flux utilisateur observables dans un navigateur.

### Définition de qualité minimale

Chaque test doit être :

- déterministe ;
- isolé ;
- lisible ;
- rapide ;
- explicite dans ses assertions.

À éviter :

- `waitForTimeout(...)` et attentes arbitraires ;
- logique conditionnelle qui change le chemin d'exécution du test ;
- données figées qui créent des collisions ;
- assertions cachées dans des helpers opaques ;
- doublons de couverture entre niveaux de test sans justification.

### Règles transverses

- Les scénarios Gherkin sont rédigés en français.
- Les tests doivent refléter le vocabulaire métier de MyAccounting, pas celui d'un autre cluster.
- Les tests doivent être cohérents avec les stories et critères d'acceptation.
- Quand un test crée des données, il doit prévoir leur nettoyage ou utiliser un mécanisme d'isolation équivalent.

### Traçabilité attendue

- Une story qui exige un comportement visible doit référencer un fichier `.feature`.
- Les tags `@epic-m<n>` et `@story-m<n>-<n>` doivent permettre de relier feature, story et exécution de test.

## E2E OIDC : toujours contre beta réellement déployé

### ⚠️ Règle non-négociable

Tous les tests E2E Playwright qui incluent des flux d'authentification **doivent s'exécuter contre l'environnement beta réellement déployé**. Aucun mock d'auth OIDC, aucune simulation locale de Popforge.Auth.

### Justification

1. **Mocking local = faux négatifs garantis** : cache les bugs OIDC, CORS, validation de token qui explosent en production.
2. **Bugs d'authentification = désastre** : accès non autorisés, session hijacking — impossible à récupérer après Go Live.
3. **Beta est l'environnement réel le plus proche** : même infra, même Auth, même config CORS.

### Pattern obligatoire : Network-First pour OIDC

- Enregistrer la redirection OIDC **avant** la navigation qui la déclenche.
- Attendre la réponse réseau explicitement — jamais `waitForTimeout()`.
- Vérifier le callback `/auth/callback` qui ramène l'utilisateur.

### Secrets de test

Les credentials de test sont injectés via GitHub Actions secrets → variables d'environnement :

- `TEST_USER_EMAIL` — Compte de test dans Popforge.Auth beta
- `TEST_USER_PASSWORD` — Mot de passe du compte de test
- `OIDC_CLIENT_SECRET` — Client secret pour `my-accounting-cluster`

**Jamais** committer de vrais credentials. Rotation trimestrielle obligatoire. Voir `docs/operations/oidc-test-credentials-rotation.md`.

### Références spécialisées

- Pour les conventions Playwright / Gherkin frontend, voir `testing-frontend.instructions.md`.
- Pour les conventions xUnit backend, voir `testing-backend.instructions.md`.
