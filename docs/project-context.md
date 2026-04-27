## GitHub Repository Defaults (PopSalon)

- Owner GitHub: `my-accounting`
- Repository Name: `hub`
- Repos actuel: `https://github.com/popforge/my-accounting.git`
- Visibilite par defaut pour les repos PopSalon: `private`

## Conventions cluster my-accounting

> Référence complète : [docs/architecture/saas-cluster-topology.md](./architecture/saas-cluster-topology.md)

Tout agent ou développeuse qui intervient sur ce repo **doit respecter les standards de la plateforme Popforge** :

### Structure URL standard

Chaque cluster expose ses endpoints selon ce patron :

```
https://[cluster]-beta.popsalon.app/
├── /                     -> Frontend SPA (Vue 3)
├── /api/*                -> Backend API (.NET 10)
├── /api/health           -> Health check endpoint
├── /swagger/index.html   -> Swagger UI (toujours exposé)
└── /auth/callback        -> Callback OIDC (route Vue Router, pas un endpoint serveur)
```

- **Swagger UI est obligatoire** sur le backend — accessible à `/swagger/index.html`, toujours actif (pas seulement en Development).
- Toutes les routes frontend sont protégées par le guard OIDC (`meta: { requiresAuth: true }`) sauf `/auth/callback`.
- Tous les endpoints API sont protégés par `[Authorize]` sauf `/api/health`.

### URLs du cluster my-accounting

| Environnement | Frontend | API |
|---|---|---|
| Beta | `https://my-accounting-beta.popsalon.app/` | `https://my-accounting-beta.popsalon.app/api/` |
| Production | `https://my-accounting.popsalon.app/` | `https://my-accounting.popsalon.app/api/` |
| Dev local | `http://localhost:5175/` | `http://localhost:5080/api/` |

---

## Overview
Ce projet sert au développement d'une application qui me permet de faire ma propre comptabilité personnelle et locative, en utilisant ou pas SigaFinance evo selon la solution qui sera la meilleure. L'objectif est d'avoir une solution qui me convient parfaitement, que je peux faire évoluer facilement au fil du temps, et qui me permet de mieux comprendre ma comptabilité pour optimiser mes déclarations et payer le moins d'impôts possible.

Je ne revendrai pas ce produit, je peux être la seule qui a accès. 

### Services tiers

Pour optimiser des coûts et ressources, j'utiliserai, si pertinent, des plateformes  déjà existantes pour d'autres projets. Actuellement j'ai ceci ; 

- **DNS** : Cloudflare, zone `popsalon.app`
- **TLS** : Let's Encrypt via certbot sur la VM
- **PostgreSQL** : Neon (https://console.neon.tech/)
- **Email** : Resend (https://resend.com/)
- **SMS** : Twilio
- **OIDC** : OpenIddict (.NET) — cluster `auth` (`auth.popsalon.app`)

