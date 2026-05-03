# Bases de données Neon PostgreSQL — Tous les clusters

> **Document de référence pour tous les agents IA.**
> Lire ce document avant d'implémenter quoi que ce soit qui touche à une base de données.

---

## Organisation Neon

- **Organisation :** Popforge (`org-sweet-rice-35551258`)
- **Fournisseur :** Neon (https://console.neon.tech)
- **Région :** `aws-us-east-1`
- **Version PostgreSQL :** 17

---

## Projets Neon par cluster

| Cluster | Projet Neon | Neon Project ID | Pooler host | Base |
|---------|-------------|-----------------|-------------|------|
| `auth` | `popforge-auth` | `wild-poetry-33489871` | `ep-fragrant-moon-amy183rl-pooler.c-5.us-east-1.aws.neon.tech` | `neondb` |
| `hub` | `popforge-hub` | `sparkling-bread-95641739` | `ep-super-lab-anfree0t-pooler.c-6.us-east-1.aws.neon.tech` | `neondb` |
| `popsalon` | `popforge-popsalon` | `jolly-firefly-95969993` | `ep-plain-bird-amcvu04q-pooler.c-5.us-east-1.aws.neon.tech` | `neondb` |
| `tenantmanagement` (legacy) | `popforge-tenantmanagement` | `late-wave-06607667` | `ep-*.c-6.us-east-1.aws.neon.tech` | `neondb` |
| `licensing` (legacy) | `popforge-licensing` | `floral-flower-10535208` | `ep-*.c-6.us-east-1.aws.neon.tech` | `neondb` |

> **Note :** Les clusters `tenantmanagement` et `licensing` sont des projets legacy de `Popforge.PopSalon`. Ils ne sont pas utilisés par `Popforge.Hub` ou `Popforge.Auth`.

---

## Format de connection string (Npgsql)

```
Host=<pooler-host>;Port=5432;Database=neondb;Username=neondb_owner;Password=<password>;SSL Mode=Require;Trust Server Certificate=true
```

> Les mots de passe ne sont **jamais** stockés dans le code source. Voir la section ci-dessous.

---

## Variables d'environnement par cluster

### Cluster `auth` (`Popforge.Auth`)

| Variable | Usage |
|----------|-------|
| `ConnectionStrings__AuthDb` | Connection string complète (production / beta) |
| `Seed__AdminPassword` | Mot de passe initial du compte admin `popforge@icloud.com` |
| `Seed__HubAdminClientSecret` | Secret M2M du client `hub-admin-client` dans OpenIddict |

### Cluster `hub` (`Popforge.TenantManager`)

| Variable | Usage |
|----------|-------|
| `ConnectionStrings__HubDb` | Connection string complète (production / beta) |
| `AuthAdmin__ClientSecret` | Secret M2M pour appeler l'Auth Admin API |

---

## Gestion des secrets par environnement

| Environnement | Mécanisme | Emplacement |
|---------------|-----------|-------------|
| **Développement local** | `dotnet user-secrets` | `%APPDATA%\Microsoft\UserSecrets\<UserSecretsId>\secrets.json` — jamais dans git |
| **Beta / Production** | Variable d'environnement Docker | Injectée via `deploy.env` sur la VM Oracle — jamais dans git |
| **CI/CD (GitHub Actions)** | GitHub Secrets (environment `beta`) | Configurés dans Settings > Environments > beta |

> Pour configurer les secrets de développement local, voir `docs/architecture/dev-secrets-setup.md` (fichier gitignored — contient les valeurs réelles).

---

## Références

- [Architecture générale](./architecture.md)
- [Topologie SaaS](./saas-cluster-topology.md)
- [ADR-001 — OpenIddict OIDC](./adr/ADR-001-openiddict-oidc-auth-server.md)
