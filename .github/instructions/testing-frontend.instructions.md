---
applyTo: "src/**/tests/**/*.{ts,feature}"
---

## Frontend E2E - Playwright BDD en français — MyAccounting

Les tests E2E frontend utilisent **Playwright** avec **playwright-bdd** pour exprimer les scénarios métier en Gherkin français.

### Portée

Ces instructions s'appliquent aux :

- fichiers `.feature` ;
- step definitions TypeScript ;
- helpers E2E spécifiques au frontend.

### Structure cible

```text
src/my-accounting/tests/
  e2e/
    features/
      <fonctionnalite>.feature
    steps/
      <fonctionnalite>.steps.ts
    support/
      fixtures/
      pages/
      helpers/
```

Le dossier généré par `bddgen` doit rester hors édition manuelle et être ignoré par Git si nécessaire.

### Format des fichiers `.feature`

- Toujours inclure `# language: fr` en première ligne.
- Utiliser les mots-clés français : `Fonctionnalité:`, `Contexte:`, `Scénario:`, `Plan du scénario:`, `Soit`, `Quand`, `Et`, `Alors`.
- Ajouter les tags `@epic-m<n>` et `@story-m<n>-<n>` au niveau de la fonctionnalité ou du scénario.
- Employer le vocabulaire métier de MyAccounting.
- Ne pas réutiliser d'exemples métier provenant d'un autre cluster.

Exemple :

```gherkin
# language: fr
@epic-m1 @story-m1-2
Fonctionnalité: <Titre de la fonctionnalité>
  En tant que <persona>
  Je veux <action>
  Afin de <bénéfice>

  Scénario: <Titre du scénario>
    Quand <action déclenchante>
    Alors <résultat observable>
```

### Step definitions

- Les steps doivent être courtes, explicites et réutilisables.
- Les assertions principales doivent rester visibles dans les steps ou helpers proches, pas enfouies dans une couche opaque.
- Les steps doivent refléter des actions utilisateur et des résultats observables.

### Règles de stabilité E2E

- Enregistrer les interceptions réseau **avant** navigation ou action déclenchante.
- Attendre des signaux déterministes : réponse réseau, disparition d'un loader, état visible stable.
- Ne pas utiliser `waitForTimeout(...)` sauf justification exceptionnelle documentée.
- Préférer une préparation de données rapide et contrôlée plutôt qu'un long setup via UI.

### Authentification OIDC en E2E

### Fixture auth-session obligatoire

Tous les tests avec flux d'authentification doivent utiliser la fixture `authToken` depuis `support/auth/auth-session.ts`.

```typescript
import { test } from '../support/auth/auth-session';

test('accès sans session → redirect vers Popforge.Auth', async ({ page }) => {
  await page.goto('https://my-accounting-beta.popsalon.app/dashboard');
  await expect(page).toHaveURL(/auth-beta\.popsalon\.app/);
});

test('accès avec token valide → page accessible', async ({ page, authToken }) => {
  await page.goto('https://my-accounting-beta.popsalon.app/dashboard');
  await expect(page.getByRole('heading')).toBeVisible();
});
```

### Pattern network-first pour callback OIDC

Toujours attendre le callback **avant** de déclencher la redirection :

```typescript
// ✅ Correct
const callbackPromise = page.waitForNavigation(nav =>
  nav.url().includes('/auth/callback')
);
await page.goto('https://my-accounting-beta.popsalon.app/');
await callbackPromise;

// ❌ Mauvais : timeout arbitraire
await page.goto('https://my-accounting-beta.popsalon.app/');
await page.waitForTimeout(5000);
```

### Scénarios autorisés en E2E

- `@auth-redirect` : utilisateur non authentifié → redirect vers Popforge.Auth ✅
- `@auth-callback` : callback depuis Popforge.Auth → session établie ✅
- `@auth-session-expired` : token expiré → 401 → redirect vers login ✅

### Scénarios exclus du E2E de ce cluster

- Saisie de credentials sur le formulaire de Popforge.Auth (hors périmètre)
- Flux MFA (appartient à Popforge.Auth)
- Social login (hors périmètre)

**Raison** : ces scénarios testent Popforge.Auth, pas ce cluster.

### Credentials d'authentification de test

Les credentials sont injectés via GitHub Actions secrets → variables d'environnement :

- `TEST_USER_EMAIL` — Compte de test dans Popforge.Auth beta
- `TEST_USER_PASSWORD` — Mot de passe du compte de test
- `OIDC_CLIENT_SECRET` — Client secret pour `my-accounting-cluster`

**Jamais** committer de vrais credentials en `.env` ou en dur dans le code. Rotation trimestrielle obligatoire. Voir `docs/operations/oidc-test-credentials-rotation.md`.

### Couverture frontend

- Priorité aux E2E Gherkin pour les comportements visibles et critiques.
- Utiliser Vitest pour les règles isolées des stores, composables et transformations frontend.
- Éviter qu'un même comportement soit testé à la fois en E2E et en Vitest sans raison claire.

### Commandes

Les scripts exacts doivent refléter le `package.json` réel du cluster :

```bash
npm run test:e2e        # bddgen + playwright test (headless)
npm run test:e2e:ui     # bddgen + playwright test --ui (interactif)
```

`bddgen` doit toujours être exécuté avant `playwright test`, directement ou via les scripts du projet.

### Références

- Pour le standard global de test, voir `testing.instructions.md`.
- Pour les tests xUnit backend, voir `testing-backend.instructions.md`.
