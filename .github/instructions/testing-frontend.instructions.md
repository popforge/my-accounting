---
applyTo: "src/**/tests/**/*.{ts,feature}"
---

## Frontend E2E - Playwright BDD en français

Les tests E2E frontend utilisent **Playwright** avec **playwright-bdd** pour exprimer les scénarios métier en Gherkin français.

### Portée

Ces instructions s'appliquent aux :

- fichiers `.feature` ;
- step definitions TypeScript ;
- helpers E2E spécifiques au frontend.

### Structure cible

Structure attendue par cluster :

```text
src/my-accounting/tests/
  e2e/
    features/
      document-capture-mobile-icloud.feature
      document-import-icloud-existant.feature
    steps/
      document-capture.steps.ts
      document-search.steps.ts
    support/
      fixtures/
      pages/
      helpers/
```

Le dossier généré par `bddgen` doit rester hors édition manuelle et être ignoré par Git si nécessaire.

### Format des fichiers `.feature`

- Toujours inclure `# language: fr` en première ligne.
- Utiliser les mots-clés français : `Fonctionnalité:`, `Contexte:`, `Scénario:`, `Plan du scénario:`, `Soit`, `Quand`, `Et`, `Alors`.
- Ajouter les tags `@epic-<n>` et `@story-<n-n>` au niveau de la fonctionnalité ou du scénario selon le besoin.
- Employer le vocabulaire métier MyAccounting et les termes compréhensibles par Rachel.
- Ne pas réutiliser d'exemples métier provenant d'un autre produit.

Exemple :

```gherkin
# language: fr
@epic-1 @story-1-2
Fonctionnalité: Import des documents iCloud existants
  En tant que Rachel
  Je veux importer mes documents déjà classés dans iCloud
  Afin de conserver mon historique sans recommencer le classement

  Scénario: Import du dossier !Facturette d'une année
    Quand je lance l'import iCloud pour l'année "2026"
    Alors les documents du dossier "!Facturette" sont indexés
```

### Step definitions

- Les steps doivent être courtes, explicites et réutilisables.
- Les assertions principales doivent rester visibles dans les steps ou helpers proches, pas enfouies dans une couche opaque.
- Les steps doivent refléter des actions utilisateur et des résultats observables.
- Réutiliser un pattern cohérent avec l'installation réelle de `playwright-bdd` du repo.
- Ne pas introduire d'exemple d'imports ou d'API Playwright qui ne correspond pas au setup effectif.

### Règles de stabilité E2E

- Enregistrer les interceptions réseau **avant** navigation ou action déclenchante.
- Attendre des signaux déterministes : réponse réseau, disparition d'un loader, état visible stable.
- Ne pas utiliser `waitForTimeout(...)` sauf justification exceptionnelle documentée.
- Préférer une préparation de données rapide et contrôlée plutôt qu'un long setup via UI.

## Authentification OIDC en E2E

### Fixture auth-session obligatoire

Tous les tests avec flux d'authentification doivent utiliser la fixture `authToken` depuis `support/auth/auth-session.ts`.

```typescript
import { test } from '../support/auth/auth-session';

test('accès sans session → redirect vers Popforge.Auth', async ({ page }) => {
  // No token used here
  await page.goto('https://my-accounting-beta.popsalon.app/dashboard');
  await expect(page).toHaveURL(/auth-beta\.popsalon\.app/);
});

test('accès avec token valide → dashboard accessible', async ({ page, authToken }) => {
  // Token available from fixture - tests post-login flows
  await page.goto('https://my-accounting-beta.popsalon.app/dashboard');
  await expect(page.getByRole('heading', { name: /documents/i })).toBeVisible();
});
```

### Pattern network-first pour callback OIDC

Toujours attendre le callback **AVANT** de déclencher la redirection:

```typescript
test('OIDC login flow complet', async ({ page }) => {
  // 1. Enregistrer le callback FIRST
  const callbackPromise = page.waitForNavigation((nav) =>
    nav.url().includes('/auth/callback')
  );

  // 2. PUIS déclencher redirect
  await page.goto('https://my-accounting-beta.popsalon.app/'); 
  // → Redirected to auth-beta.popsalon.app

  // 3. PUIS attendre callback
  await callbackPromise; 
  // → Popforge.Auth renvoie vers /auth/callback → app home
});
```

**Jamais**:
```typescript
// ❌ MAUVAIS: Timeout arbitraire
await page.goto('https://my-accounting-beta.popsalon.app/');
await page.waitForTimeout(5000);

// ❌ MAUVAIS: Navigation attendue APRÈS action (trop tard)
await page.goto('https://my-accounting-beta.popsalon.app/');
await page.waitForNavigation();
```

### Scénarios autorisés en E2E

- `@auth-redirect`: Utilisateur non authentifié → redirect vers Popforge.Auth ✅
- `@auth-callback`: Callback depuis Popforge.Auth → session établie ✅
- `@auth-session-expired`: Token expiré → 401 → redirect vers login ✅

### Scénarios EXCLUS du E2E

- Input credentials (formulaire Popforge.Auth — pas notre repo)
- MFA flows (dépendance Popforge.Auth, complexité)
- Social login (out of scope V1)

**Raison**: Ces scénarios testent Popforge.Auth, pas MyAccounting. Les tester ici = coût de maintenance sans valeur pour ce repo.

### Couverture frontend

- Priorité aux E2E Gherkin pour les comportements visibles et critiques.
- Utiliser Vitest pour les règles isolées des stores, composables et transformations frontend.
- Éviter qu'un même comportement soit testé à la fois en E2E et en Vitest sans raison claire.

### Commandes

Les scripts exacts doivent refléter le `package.json` réel du cluster. Si des commandes standard existent, conserver cette logique :

```bash
npm run test:e2e        # Run all E2E tests against beta
npm run test:e2e:ui     # Run in UI mode (debugging)
```

`bddgen` doit toujours être exécuté avant `playwright test`, directement ou via les scripts du projet.

### Credentials d'authentification de test

Pour les tests E2E contre Popforge.Auth beta, les credentials sont injectées via GitHub Actions secrets:

- `TEST_USER_EMAIL` — Compte de test dans Popforge.Auth beta
- `TEST_USER_PASSWORD` — Mot de passe du compte de test
- `OIDC_CLIENT_SECRET` — Client secret pour `my-accounting-cluster`

**Jamais** committer de vrais credentials en `.env` ou en dur dans le code. Rotation trimestrielle obligatoire. Voir `docs/operations/oidc-test-credentials-rotation.md`.
