# Intégration OIDC — MyAccounting

> Instructions pour implanter l'authentification déléguée à Popforge.Auth
> dans ce cluster. À donner à l'IA pour qu'elle implante le code.
>
> Source : `Popforge.Shared/docs/oidc-cluster-integration.md` (template générique)

---

## Contexte

Ce cluster (`my-accounting`) délègue l'authentification à **Popforge.Auth** (serveur OIDC OpenIddict).
Le package `@popforge/cluster-core` (repo `Popforge.Shared`) fournit toute la mécanique OIDC.

| Paramètre | Valeur |
|---|---|
| ClientId | `my-accounting-cluster` |
| Flow | Authorization Code + PKCE (public client) |
| Scopes | `openid email profile roles` |
| Callback dev | `http://localhost:5175/auth/callback` |
| Callback beta | `https://my-accounting-beta.popsalon.app/auth/callback` |

| Environnement | Authority |
|---|---|
| Dev local | `https://auth-beta.popsalon.app` |
| Beta | `https://auth-beta.popsalon.app` |
| Production | `https://auth.popsalon.app` |

**Le client est déjà enregistré dans Popforge.Auth.** Aucune modification côté Auth.

---

## Partie 1 — Frontend Vue 3 (SPA)

La SPA se trouve dans `src/my-accounting/app/`.

### 1.1 — Configurer `.npmrc` à la racine du projet Vue

```ini
@popforge:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NPM_TOKEN}
```

> `NPM_TOKEN` = PAT GitHub avec scope `read:packages`. À définir localement via
> `$env:NPM_TOKEN = "ghp_..."` et dans les secrets GitHub CI.

### 1.2 — Installer le package

```bash
npm install @popforge/cluster-core
```

### 1.3 — Initialiser OIDC dans `src/main.ts`

```typescript
import { createOidcManager } from '@popforge/cluster-core'

createOidcManager({
  authority: import.meta.env.VITE_OIDC_AUTHORITY,
  clientId: import.meta.env.VITE_OIDC_CLIENT_ID,
  scope: 'openid email profile roles',
})

// puis createApp(App).use(router)...
```

### 1.4 — Ajouter la route `/auth/callback` dans le router

```typescript
import { AuthCallback } from '@popforge/cluster-core'

{
  path: '/auth/callback',
  component: AuthCallback,
}
```

### 1.5 — Guard de navigation

```typescript
import { getUser, login } from '@popforge/cluster-core'

router.beforeEach(async (to) => {
  if (to.meta.requiresAuth) {
    const user = await getUser()
    if (!user || user.expired) {
      await login()
      return false
    }
  }
})
```

Sur les routes protégées : `meta: { requiresAuth: true }`.

### 1.6 — Utiliser `useAuth` dans les composants

```typescript
import { useAuth } from '@popforge/cluster-core'

const { isAuthenticated, profile, login, logout } = useAuth()
```

### 1.7 — Appels API authentifiés

```typescript
import { authFetch } from '@popforge/cluster-core'

const data = await authFetch('/api/accounts').then(r => r.json())
```

### 1.8 — Variables d'environnement

`.env.development` :

```dotenv
VITE_OIDC_AUTHORITY=https://auth-beta.popsalon.app
VITE_OIDC_CLIENT_ID=my-accounting-cluster
```

`.env.production` :

```dotenv
VITE_OIDC_AUTHORITY=https://auth.popsalon.app
VITE_OIDC_CLIENT_ID=my-accounting-cluster
```

---

## Partie 2 — Backend .NET 10 API

Le serveur se trouve dans `src/my-accounting/server/MyAccounting.Server/`.

### 2.1 — Ajouter les packages NuGet

```bash
dotnet add package OpenIddict.AspNetCore
dotnet add package OpenIddict.Client.SystemNetHttp
```

### 2.2 — Configurer dans `Program.cs`

```csharp
builder.Services.AddOpenIddict()
    .AddValidation(options =>
    {
        options.SetIssuer(builder.Configuration["Oidc:Authority"]
            ?? throw new InvalidOperationException("Oidc:Authority is required."));
        options.AddAudiences("my-accounting-cluster");
        options.UseSystemNetHttp();
        options.UseAspNetCore();
    });

builder.Services.AddAuthentication(OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme);
builder.Services.AddAuthorization();
```

```csharp
app.UseAuthentication();
app.UseAuthorization();
```

### 2.3 — `appsettings.json` + `appsettings.Development.json`

```json
{ "Oidc": { "Authority": "https://auth.popsalon.app" } }
```

```json
{ "Oidc": { "Authority": "https://auth-beta.popsalon.app" } }
```

### 2.4 — Protéger les controllers

```csharp
[Authorize(AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme)]
[ApiController]
[Route("api/[controller]")]
public class AccountsController : ControllerBase
{
    // var userId = User.FindFirst(OpenIddictConstants.Claims.Subject)?.Value;
    // var email  = User.FindFirst(OpenIddictConstants.Claims.Email)?.Value;
}
```

### 2.5 — Variable d'environnement Docker

```yaml
- Oidc__Authority=https://auth-beta.popsalon.app
```

---

## Checklist d'implantation

### Frontend (`src/my-accounting/app/`)
- [ ] `.npmrc` configuré avec `@popforge:registry`
- [ ] `@popforge/cluster-core` installé
- [ ] `createOidcManager()` appelé dans `main.ts`
- [ ] Route `/auth/callback` avec `AuthCallback` ajoutée dans le router
- [ ] Guard `router.beforeEach` ajouté
- [ ] `.env.development` et `.env.production` créés
- [ ] Appels API utilisent `authFetch()`
- [ ] `NPM_TOKEN` configuré dans les secrets GitHub CI

### Backend (`src/my-accounting/server/MyAccounting.Server/`)
- [ ] Packages `OpenIddict.AspNetCore` et `OpenIddict.Client.SystemNetHttp` ajoutés
- [ ] `AddOpenIddict().AddValidation(...)` dans `Program.cs`
- [ ] `UseAuthentication()` + `UseAuthorization()` dans le pipeline
- [ ] `appsettings.json` + `appsettings.Development.json` avec `Oidc:Authority`
- [ ] Controllers protégés avec `[Authorize]`
- [ ] `Oidc__Authority` dans `docker-compose.deploy.yml`

---

## Test de validation

1. `npm run dev` → `http://localhost:5175`
2. Naviguer vers une route protégée → redirection vers `https://auth-beta.popsalon.app/Connect/Login`
3. Se connecter → retour sur `http://localhost:5175/auth/callback` puis `/`
4. Token visible dans localStorage (`oidc.user:https://auth-beta.popsalon.app:my-accounting-cluster`)
5. Appel API avec Bearer token → 200 (pas 401)
