# Intégration OIDC — Template cluster Popforge

> **Usage** : Copier ce fichier dans `docs/architecture/oidc-integration.md` du repo cluster
> et remplir les valeurs du tableau ci-dessous.
>
> **Guide complet** : `node_modules/@popforge/cluster-core/docs/integration.md`
> (disponible après `npm install @popforge/cluster-core` — toujours à jour avec la version installée)

---

## Valeurs du cluster

| Paramètre | Valeur |
|---|---|
| Client ID | `my-accounting-cluster` |
| Port dev local | `5175` |
| Scopes | `openid email profile roles` |
| Callback dev | `http://localhost:5175/auth/callback` |
| Callback beta | `https://my-accounting-beta.popsalon.app/auth/callback` |
| Auth dev/beta | `https://auth-beta.popsalon.app` |
| Auth production | `https://auth.popsalon.app` |

---

## Prérequis

1. Client `my-accounting-cluster` enregistré dans `Popforge.Auth/src/auth/server/Auth.Server/appsettings.json`
   → Voir `docs/architecture/oidc-client-registration.md` dans le repo `Popforge.Auth`
2. Secret `NPM_TOKEN` (PAT `read:packages`) dans les GitHub Actions secrets du repo

---

## Conventions de déploiement

> Lire [docs/architecture/saas-cluster-topology.md](./saas-cluster-topology.md) avant d'implanter.
> Ce fichier définit la structure URL standard de la plateforme, notamment :
> - `/api/*` → Backend API
> - `/swagger/index.html` → Swagger UI (obligatoire sur tous les clusters)
> - `/auth/callback` → Callback OIDC (route Vue Router)

---

## Implémentation

Suivre le guide complet dans le package installé :

```
node_modules/@popforge/cluster-core/docs/integration.md
```

Ou lire directement dans le repo source :
`Popforge.Shared/packages/cluster-core/docs/integration.md`

---

## Checklist

### Frontend
- [ ] `.npmrc` avec `@popforge:registry`
- [ ] `@popforge/cluster-core` installé
- [ ] `createOidcManager()` dans `main.ts`
- [ ] `addOidcRoutes(router)` + `addOidcGuard(router)`
- [ ] `src/roles.ts` avec `defineRoles()`
- [ ] `env.d.ts` avec `ImportMetaEnv`
- [ ] `.env.development` + `.env.production`
- [ ] Secret `NPM_TOKEN` dans GitHub Actions

### Backend
- [ ] Packages OpenIddict ajoutés
- [ ] `AddOpenIddict().AddValidation(...)` dans `Program.cs`
- [ ] `appsettings` avec `Oidc:Authority`
- [ ] `[Authorize]` sur les controllers

