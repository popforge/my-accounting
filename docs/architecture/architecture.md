# Architecture - Popforge.MyAccounting

## Contexte

Ce repository porte l'application MyAccounting pour un usage personnel (comptabilité personnelle et locative), avec une approche "single-tenant first".

Objectif d'architecture : réutiliser au maximum le stack existant déjà en production sur l'écosystème Popforge afin d'éviter la multiplication des technologies.

## Stack technique cible (reuse)

- Frontend : Vue 3 (Composition API) + Vite + TypeScript + Pinia + Vue Router
- Backend : API REST .NET 10
- Tests E2E : Playwright + playwright-bdd (Gherkin)
- Tests backend : xUnit
- Composants UI partagés : bibliothèque Popforge existante (à confirmer selon les besoins MyAccounting)

## Décision d'architecture

- Réutiliser la plateforme SaaS multi-cluster existante (DNS, VM, reverse proxy, auth, CI/CD)
- Déployer MyAccounting comme cluster dédié dans le même environnement
- Conserver un mode fonctionnel single-tenant pour la V1 (Rachel uniquement)
- Garder la possibilité d'évolution multi-tenant plus tard sans replatforming
- Exposer MyAccounting via un sous-domaine dédié

## Positionnement du stockage documentaire

- Les fichiers sources restent dans iCloud Drive
- L'application maintient un index applicatif serveur (PostgreSQL) pour la recherche multi-critères rapide
- Import des documents existants iCloud en mode non destructif
- Synchronisation cible : import complet initial puis sync incrémentale à la demande
- Procédure incident index : voir [index-rebuild-runbook.md](./index-rebuild-runbook.md)

## Topologie SaaS

Référence complète : voir [saas-cluster-topology.md](./saas-cluster-topology.md).

## Infrastructure existante réutilisée

### Hébergement

- VM : Oracle Cloud (IP publique actuelle : 148.116.77.58)
- Reverse proxy : nginx
- Conteneurisation : Docker

### Services tiers

- DNS : Cloudflare, zone popsalon.app
- TLS : Let's Encrypt via certbot sur la VM
- PostgreSQL : Neon
- Email : Resend
- SMS : Twilio
- OIDC : cluster auth (OpenIddict .NET)

## Principes d'implémentation

- Priorité mobile : les parcours critiques doivent être utilisables depuis téléphone
- Simplicité d'opération : minimiser les manipulations manuelles de documents
- Performance perçue : recherche quasi instantanée sur l'historique importé
- Évolutivité : décisions compatibles avec l'extension future du produit
- Sécurité V1 : compte unique Rachel uniquement
- UI V1 : réutilisation partielle des écrans/composants communs de la bibliothèque partagée
