# Topologie SaaS — Tous les Clusters

> **Document de référence pour tous les agents IA.**
> Lire ce document avant d'implémenter quoi que ce soit qui touche à un cluster, une URL, un port ou un déploiement.

---

## Glossaire

| Terme | Définition |
|-------|------------|
| Microservice | Service backend spécialisé dans une fonctionnalité métier spécifique, communiquant avec d'autres services via des API |
| Cluster | Unité déployable composée d'une SPA, d'une API et de ses dépendances runtime |
| Single-tenant | Une seule utilisatrice et un seul espace de données |
| Multi-tenant | Plusieurs locataires/entreprises isolés sur la même plateforme |

---

## Environnements

Development is available across two isolated environments:
- beta : environnement de développement et tests manuels et automatisés
- production : environnement principal d'utilisation par les clients

---

## Pattern de routage plateforme

Format general de l'ecosysteme existant :

https://[cluster][-env].popsalon.app/[tenantCode]

Regles :
- cluster: nom du cluster SAAS déployé (e.g., "hub", "auth")
- `-env` : nom de l'environnement (omis en production)
- `tenantCode` : présent uniquement pour les clusters multi-tenant
- les clusters non multi-tenant n'utilisent pas de tenant dans l'URL

Structure standard (hors exceptions) :

```
https://[cluster]-beta.popsalon.app/
├── /                     → Frontend SPA
├── /api/*                → Backend API
├── /api/health/live      → Backend API retourne 200 OK si vivant (health check)
├── /api/health/ready     → Backend API retourne 200 OK si prêt à recevoir du trafic, après migration (health check)
├── /api-docs/index.html  → Swagger UI
└── /docs/*               → User documentation
```

---

# Topologie de tous les clusters

| Cluster        | Production                  | Beta                   | Multi-tenant | Rôle                                             |
|----------------|-----------------------------|------------------------|--------------|--------------------------------------------------|
| popsalon       | popsalon.app                | beta.popsalon.app               | Oui | Produit SaaS salon                               |
| hub 	         | hub.popsalon.app            | hub-beta.popsalon.app           | Non | Services centraux plateforme                     |
| auth 	         | auth.popsalon.app           | auth-beta.popsalon.app          | Non | Serveur OIDC OpenIddict                          |
| my-accounting  | my-accounting.popsalon.app  | my-accounting-beta.popsalon.app | Non | Application comptabilité personnelle et locative |

---

## Positionnement de MyAccounting

- MyAccounting réutilise l'infrastructure et les standards de la plateforme existante
- Authentification déléguée au cluster `auth`
- Les documents sources restent dans iCloud, avec index applicatif pour la recherche rapide
- Exposition en sous-domaine dédié
- Stockage de l'index documentaire : serveur (PostgreSQL)
- Synchronisation iCloud : import complet initial puis sync incrémentale à la demande

---

## Chemins spécifiques au cluster `auth`

Le cluster `auth` n'utilise pas la structure standard (`/api/*`, `/swagger/`). Ses chemins sont définis par le protocole OIDC :

```
https://auth.popsalon.app/
├── /                                    → UI de login unifiée (email + password)
├── /connect/authorize                   → Démarrage du flux OIDC (redirect)
├── /connect/token                       → Échange code → JWT
├── /connect/userinfo                    → Claims utilisateur
└── /.well-known/openid-configuration    → Discovery endpoint
```

---

## Informations à confirmer pour finaliser cette topologie

- Aucune information bloquante restante identifiée à ce stade.

## Politique index documentaire

- Stockage index : PostgreSQL (serveur)
- Rétention/sauvegarde : aucune sauvegarde dédiée, réindexation iCloud en cas de perte
