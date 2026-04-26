# Intégration OIDC — MyAccounting

> Instructions pour implanter l'authentification déléguée à Popforge.Auth
> dans ce cluster. À donner à l'IA pour qu'elle implante le code.

---

## Contexte

Ce cluster (`my-accounting`) délègue l'authentification à **Popforge.Auth** (serveur OIDC OpenIddict).
L'utilisateur est redirigé vers Auth pour se connecter, puis revient avec un token JWT.

| Paramètre | Valeur |
|---|---|
| ClientId | `my-accounting-cluster` |
| Flow | Authorization Code + PKCE (public client) |
| Scopes | `openid email profile roles` |
| Callback dev | `http://localhost:5175/auth/callback` |
| Callback beta | `https://my-accounting-beta.popsalon.app/auth/callback` |
| Post-logout dev | `http://localhost:5175/` |

| Environnement | Authority |
|---|---|
| Dev local | `https://auth-beta.popsalon.app` |
| Beta | `https://auth-beta.popsalon.app` |
| Production | `https://auth.popsalon.app` |

**Le client est déjà enregistré dans Popforge.Auth.** Aucune modification à faire dans ce repo.

---

## Partie 1 — Frontend Vue 3 (SPA)

La SPA se trouve dans `src/my-accounting/app/`.

### 1.1 — Installer la dépendance

```bash
npm install oidc-client-ts
```

### 1.2 — Créer `src/auth/oidc.ts`

```typescript
import { UserManager, WebStorageStateStore, type User } from 'oidc-client-ts'

const config = {
  authority: import.meta.env.VITE_OIDC_AUTHORITY as string,
  client_id: import.meta.env.VITE_OIDC_CLIENT_ID as string,
  redirect_uri: `${window.location.origin}/auth/callback`,
  post_logout_redirect_uri: `${window.location.origin}/`,
  response_type: 'code',
  scope: 'openid email profile roles',
  userStore: new WebStorageStateStore({ store: localStorage }),
  automaticSilentRenew: true,
}

export const oidcManager = new UserManager(config)

export async function getUser(): Promise<User | null> {
  return oidcManager.getUser()
}

export async function login(): Promise<void> {
  await oidcManager.signinRedirect()
}

export async function logout(): Promise<void> {
  await oidcManager.signoutRedirect()
}

export async function getAccessToken(): Promise<string | null> {
  const user = await oidcManager.getUser()
  return user?.access_token ?? null
}
```

### 1.3 — Créer `src/auth/AuthCallback.vue`

```vue
<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { oidcManager } from './oidc'

const router = useRouter()

onMounted(async () => {
  try {
    await oidcManager.signinRedirectCallback()
    router.push('/')
  } catch (e) {
    console.error('OIDC callback error:', e)
    router.push('/login-error')
  }
})
</script>

<template>
  <div>Authentification en cours…</div>
</template>
```

### 1.4 — Ajouter la route `/auth/callback` dans le router

Dans `src/router/index.ts` (ou équivalent) :

```typescript
import AuthCallback from '@/auth/AuthCallback.vue'

// Dans les routes :
{
  path: '/auth/callback',
  component: AuthCallback,
}
```

### 1.5 — Guard de navigation

Dans `src/router/index.ts`, après la définition des routes :

```typescript
import { getUser, login } from '@/auth/oidc'

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

Sur les routes protégées, ajouter `meta: { requiresAuth: true }`.

### 1.6 — Variables d'environnement

Créer `.env.development` à la racine du projet Vue :

```dotenv
VITE_OIDC_AUTHORITY=https://auth-beta.popsalon.app
VITE_OIDC_CLIENT_ID=my-accounting-cluster
```

Créer `.env.production` :

```dotenv
VITE_OIDC_AUTHORITY=https://auth.popsalon.app
VITE_OIDC_CLIENT_ID=my-accounting-cluster
```

### 1.7 — Appels API authentifiés

Créer `src/api/client.ts` :

```typescript
import { getAccessToken } from '@/auth/oidc'

export async function authFetch(input: RequestInfo, init?: RequestInit): Promise<Response> {
  const token = await getAccessToken()
  return fetch(input, {
    ...init,
    headers: {
      ...init?.headers,
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      'Content-Type': 'application/json',
    },
  })
}
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

Après `builder.Services.AddControllers()` :

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

Dans le pipeline HTTP, avant `app.MapControllers()` :

```csharp
app.UseAuthentication();
app.UseAuthorization();
```

### 2.3 — `appsettings.json`

```json
{
  "Oidc": {
    "Authority": "https://auth.popsalon.app"
  }
}
```

`appsettings.Development.json` :

```json
{
  "Oidc": {
    "Authority": "https://auth-beta.popsalon.app"
  }
}
```

### 2.4 — Protéger les controllers

```csharp
using Microsoft.AspNetCore.Authorization;
using OpenIddict.Validation.AspNetCore;

[Authorize(AuthenticationSchemes = OpenIddictValidationAspNetCoreDefaults.AuthenticationScheme)]
[ApiController]
[Route("api/[controller]")]
public class AccountsController : ControllerBase
{
    // Identité de l'utilisateur connecté :
    // var userId = User.FindFirst(OpenIddictConstants.Claims.Subject)?.Value;
    // var email  = User.FindFirst(OpenIddictConstants.Claims.Email)?.Value;
}
```

### 2.5 — Variable d'environnement Docker

Dans `docker-compose.deploy.yml`, section `environment` du service API :

```yaml
- Oidc__Authority=https://auth-beta.popsalon.app
```

En production : `https://auth.popsalon.app`.

---

## Checklist d'implantation

### Frontend (`src/my-accounting/app/`)
- [ ] `oidc-client-ts` ajouté dans `package.json`
- [ ] `src/auth/oidc.ts` créé
- [ ] `src/auth/AuthCallback.vue` créé
- [ ] Route `/auth/callback` ajoutée dans le router
- [ ] Guard `router.beforeEach` ajouté
- [ ] `.env.development` et `.env.production` créés
- [ ] Appels API utilisent `authFetch` avec `Authorization: Bearer <token>`

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
