# Topologie SaaS - Écosystème MyAccounting

> Document de référence pour les décisions de déploiement de MyAccounting.
> Lire ce document avant toute modification de cluster, URL, port, routage ou authentification.

---

## Glossaire

| Terme | Définition |
|-------|------------|
| Cluster | Unité déployable composée d'une SPA, d'une API et de ses dépendances runtime |
| Single-tenant | Une seule utilisatrice et un seul espace de données |
| Multi-tenant | Plusieurs clients isolés sur la même plateforme |

---

## Environnements

- beta : environnement de développement et tests
- production : environnement principal d'utilisation

---

## Pattern de routage plateforme

Format general de l'ecosysteme existant :

https://[cluster][-env].popsalon.app/[tenantCode]

Regles :
- `-env` est omis en production
- `tenantCode` est present uniquement pour les clusters multi-tenant
- les clusters non multi-tenant n'utilisent pas de tenant dans l'URL

Structure standard (hors exceptions) :

```
https://[cluster]-beta.popsalon.app/
├── /                     -> Frontend SPA
├── /api/*                -> Backend API
├── /swagger/index.html   -> Swagger UI
└── /docs/*               -> Documentation utilisateur
```

---

## Topologie des clusters (plateforme partagée)

| Cluster | Production | Beta | Multi-tenant | Rôle |
|---------|------------|------|--------------|------|
| popsalon | popsalon.app | beta.popsalon.app | Oui | Produit SaaS salon |
| hub | hub.popsalon.app | hub-beta.popsalon.app | Non | Services centraux plateforme |
| auth | auth.popsalon.app | auth-beta.popsalon.app | Non | Serveur OIDC OpenIddict |
| my-accounting | my-accounting.popsalon.app | my-accounting-beta.popsalon.app | Non (V1) | Application comptabilité personnelle et locative |

---

## Positionnement de MyAccounting

- MyAccounting réutilise l'infrastructure et les standards de la plateforme existante
- V1 en single-tenant (usage personnel)
- Authentification déléguée au cluster `auth`
- Les documents sources restent dans iCloud, avec index applicatif pour la recherche rapide
- Exposition en sous-domaine dédié
- Stockage de l'index documentaire : serveur (PostgreSQL)
- Synchronisation iCloud : import complet initial puis sync incrémentale à la demande

---

## Chemins spécifiques du cluster auth

Le cluster `auth` suit les endpoints OIDC standards :

```
https://auth.popsalon.app/
├── /                                   -> UI de login
├── /connect/authorize                  -> Début du flux OIDC
├── /connect/token                      -> Échange code vers token
├── /connect/userinfo                   -> Claims utilisateur
└── /.well-known/openid-configuration   -> Endpoint discovery
```

---

## Informations à confirmer pour finaliser cette topologie

- Aucune information bloquante restante identifiée à ce stade.

## Politique index documentaire

- Stockage index : PostgreSQL (serveur)
- Rétention/sauvegarde : aucune sauvegarde dédiée, réindexation iCloud en cas de perte
