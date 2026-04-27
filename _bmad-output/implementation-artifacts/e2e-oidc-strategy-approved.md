---
date: 2026-04-26
stakeholder: Murat (TEA - Master Test Architect)
decision: APPROVED
scope: Story 0.0 E2E OIDC Foundation
---

# Stratégie E2E OIDC Approuvée — Story 0.0

## Décision formelle

✅ **Les tests E2E Playwright DOIVENT s'exécuter contre beta réellement déployé.** Aucune mocking d'auth OIDC.

**Justification** (par Murat):
- Mocking local = faux négatifs garantis (OIDC, CORS, token validation bugs s'échappent en prod)
- Bugs authentification = production disaster irréparable
- Beta est l'env réel le plus proche (même infra, même Auth config)

**Risk score**: P2 × I2 = 4 (ACCEPTABLE) avec mitigation.

---

## Tâches Story 0.0 — Phase 2 (Après patch #1-7)

### Tâche 1: Fixture auth-session

**Fichier à créer**: `src/my-accounting/tests/support/auth/auth-session.ts`

```typescript
import { test as base } from '@playwright/test';

// Auth fixture qui fetche un token valide depuis Popforge.Auth beta
export const test = base.extend({
  authToken: async ({}, use) => {
    const response = await fetch('https://auth-beta.popsalon.app/connect/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'password',
        client_id: 'my-accounting-cluster',
        client_secret: process.env.OIDC_CLIENT_SECRET!,
        username: process.env.TEST_USER_EMAIL!,
        password: process.env.TEST_USER_PASSWORD!,
        scope: 'openid email profile roles',
      }),
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch auth token: ${response.status}`);
    }

    const { access_token } = await response.json();
    await use(access_token);
  },
});

export { expect } from '@playwright/test';
```

**Note**: Credentials `TEST_USER_EMAIL`, `TEST_USER_PASSWORD`, `OIDC_CLIENT_SECRET` proviennent de GitHub Actions secrets, injectés en CI/CD.

### Tâche 2: GitHub Actions Secrets

**À configurer** (par vous ou DevOps):

| Secret | Description | Source |
|--------|-------------|--------|
| `TEST_USER_EMAIL` | Compte test Popforge.Auth beta | Email utilisateur test |
| `TEST_USER_PASSWORD` | Mot de passe du compte test | Changer tous les 3 mois |
| `OIDC_CLIENT_SECRET` | Client secret pour `my-accounting-cluster` | Popforge.Auth beta registration |

### Tâche 3: Step definitions authentification

**Fichier à créer**: `src/my-accounting/tests/e2e/steps/authentification.steps.ts`

Pattern network-first:

```typescript
import { Given, When, Then } from '@cucumber/cucumber';
import { test, expect } from '../support/auth/auth-session';

When('j\'accède à la page {string} sans session', async function(path: string) {
  // Clear auth storage
  await this.page.context().clearCookies();
  
  // Wait for OIDC redirect BEFORE navigation
  const redirectPromise = this.page.waitForNavigation((nav) =>
    nav.url().includes('auth-beta.popsalon.app')
  );
  
  await this.page.goto(`https://my-accounting-beta.popsalon.app${path}`);
  await redirectPromise;
});

Then('je suis redirigée vers Popforge.Auth', async function() {
  await expect(this.page).toHaveURL(/auth-beta\.popsalon\.app/);
});

Given('j\'ai un token OIDC valide', async function() {
  const token = await this.authToken;
  // Set bearer token in subsequent requests
  this.page.setExtraHTTPHeaders({
    'Authorization': `Bearer ${token}`,
  });
});
```

### Tâche 4: Déploiement beta OIDC validé

**Vérifications**:
- [ ] `docker-compose.deploy.yml` configure `Oidc__Authority=https://auth-beta.popsalon.app`
- [ ] CORS config accepte origin `https://my-accounting-beta.popsalon.app`
- [ ] Swagger accessible à `/swagger/index.html`
- [ ] Health check OK: `GET /api/health` → 200
- [ ] Protected endpoint retourne 401 sans token: `GET /api/documents` → 401

### Tâche 5: CI/CD E2E en beta

**Fichier à créer**: `.github/workflows/e2e-beta.yml`

```yaml
name: E2E Tests (Beta OIDC)

on:
  push:
    branches: [main]
  pull_request:

jobs:
  e2e-oidc:
    runs-on: ubuntu-latest
    environment: beta
    env:
      TEST_USER_EMAIL: ${{ secrets.TEST_USER_EMAIL }}
      TEST_USER_PASSWORD: ${{ secrets.TEST_USER_PASSWORD }}
      OIDC_CLIENT_SECRET: ${{ secrets.OIDC_CLIENT_SECRET }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci --cwd src/my-accounting/app
      - run: npm run test:e2e --cwd src/my-accounting/app
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: src/my-accounting/app/playwright-report/
```

### Tâche 6: Rotation credentials

**Créer runbook**: `docs/operations/oidc-test-credentials-rotation.md`

- Schedule: Rotation trimestrielle (4x/an)
- Processus: Mettre à jour Popforge.Auth test account + GitHub Actions secrets
- Notification: Email team

---

## Standards intégrés aux instructions

✅ `testing.instructions.md` — section "E2E OIDC"
✅ `testing-frontend.instructions.md` — section "Authentification OIDC"

Désormais, tous les développeurs consulteront ces instructions pour écrire les tests OIDC E2E.

---

## Patch #8 Déferred

**Raison de report**: 
Les step definitions E2E (`authentification.steps.ts`) dépendent de la fixture `auth-session` qui elle-même dépend de GitHub Actions secrets configurés. Il est plus efficace de:

1. D'abord créer la fixture (Tâche 1)
2. Configurer les secrets (Tâche 2)
3. PUIS écrire les steps et les valider en CI/CD (Tâche 3)

**Status**: À complèter après patch #1-7 + infrastructure de test OIDC en place.

---

## Prochain appel: Planification Story 0.0 Phase 2

Quand vous êtes prêt(e) à passer à la phase 2 (fixtures + CI/CD E2E), invoquez `bmad-dev-story` avec ce document comme contexte.

Murat reste disponible pour tout enjeu de test architecture. 🧪
