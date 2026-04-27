---
applyTo: "src/**/*.{ts,vue,cs,feature}"
---

## Standard global de test

Le projet MyAccounting suit une stratégie de test orientée risque avec séparation claire des niveaux de test.

### Choix du niveau de test

- **E2E Gherkin** : pour les parcours visibles par Rachel et les flux critiques de bout en bout.
- **Unit (Vitest)** : pour la logique isolée côté frontend, notamment stores, composables et règles de transformation.
- **Unit (xUnit)** : pour la logique métier backend, validations, services et règles non visibles en E2E.

### Règles de sélection

- Favoriser le niveau le plus bas qui couvre correctement le comportement.
- Ne pas dupliquer inutilement un même comportement en E2E et en test unitaire.
- Réserver les E2E aux scénarios critiques, transverses ou à forte valeur utilisateur.

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

- Les scénarios Gherkin destinés à Rachel sont rédigés en français.
- Les tests doivent refléter le vocabulaire métier de MyAccounting, pas celui d'un autre produit.
- Les tests doivent être cohérents avec les stories et critères d'acceptation.
- Quand un test crée des données, il doit prévoir leur nettoyage ou un mécanisme d'isolation équivalent.

### Traçabilité attendue

- Une story qui exige un comportement visible doit référencer un fichier `.feature`.
- Les tags `@epic-<n>` et `@story-<n-n>` doivent permettre de relier feature, story et exécution de test.

## E2E OIDC: Toujours contre beta réellement déployé

### ⚠️ Règle non-négociable

Tous les tests E2E Playwright qui incluent des flows d'authentification **DOIVENT s'exécuter contre l'environnement beta réellement déployé**. Aucune mocking d'auth OIDC, aucune simulation locale de Popforge.Auth.

### Justification

1. **Mocking local = faux négatifs garantis**: Cache les bugs OIDC, CORS, token validation qui détonent en production.
2. **Bugs authentification = disaster**: Attaques, session hijacking, accès non autorisés — impossible à récupérer après GO.
3. **Beta est l'environnement réel le plus proche**: Même infra, même Auth, même CORS config — donc même risque que prod.

### Pattern obligatoire: Network-First pour OIDC

- Enregistrer la redirection OIDC **AVANT** la navigation qui la déclenche, avec `waitForNavigation()`.
- Attendre la réponse réseau explicitement — jamais `waitForTimeout()`.
- Vérifier le callback `/auth/callback` qui ramène l'utilisateur.

### Fixtures + Credentials

- Utiliser fixture `authToken` (auth-session) pour pré-fetcher un token valide depuis Popforge.Auth.
- **Jamais** hardcoder credentials en test ou commit.
- **Toujours** injecter credentials via GitHub Actions secrets → variables d'environnement.
- Rotation trimestrielle des credentials (voir `docs/operations/oidc-test-credentials-rotation.md`).

### CI/CD E2E

- Tests E2E OIDC runs **APRÈS** unit + integration tests (pas en parallèle).
- Redeployer beta que si nouveau code, pas sur chaque test retry.
- Gestion des secrets: `TEST_USER_EMAIL`, `TEST_USER_PASSWORD`, `OIDC_CLIENT_SECRET`.

### Références spécialisées

- Pour les conventions Playwright / Gherkin frontend, voir `testing-frontend.instructions.md`.
- Pour la fixture auth-session et pattern network-first, voir `testing-frontend.instructions.md` section "Authentification OIDC".

