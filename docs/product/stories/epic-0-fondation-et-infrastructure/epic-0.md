# Epic 0 — Fondation et infrastructure

## Objectif

Mettre en place les fondations techniques du cluster `my-accounting` : authentification déléguée à Popforge.Auth, déploiement initial, et connectivité de base, afin que toutes les fonctionnalités métier des épics suivants puissent s'appuyer sur une base sécurisée et opérationnelle.

## Valeur utilisateur

- Rachel peut accéder à son application de façon sécurisée avec son compte Popforge existant.
- Aucune donnée n'est accessible sans session valide.
- Le déploiement est stable et reproductible pour les épics suivants.

## Périmètre

- Intégration OIDC (Authorization Code + PKCE) avec Popforge.Auth côté frontend et backend.
- Protection de toutes les routes frontend et endpoints API.
- Déploiement initial du cluster `my-accounting` (Docker, nginx, variables d'environnement).

## Critères d'acceptation (niveau epic)

1. **AC1 — Accès sécurisé** : Toute page de l'application et tout endpoint API est inaccessible sans session OIDC valide.
   *Type de test : E2E Gherkin + Unit (xUnit)*

2. **AC2 — Connexion avec compte Popforge** : Rachel se connecte avec son compte Popforge existant sans créer de nouveau compte.
   *Type de test : Manuel*

3. **AC3 — Base stable pour les épics suivants** : L'infrastructure déployée est fonctionnelle, monitored et prête à recevoir les fonctionnalités métier de l'Epic 1.
   *Type de test : Manuel*

## Stories de l'epic

- [Story 0.0 — Intégration OIDC et déploiement initial](./story-0-0-integration-oidc-et-deploiement-initial.md)

## Sources

- [Architecture OIDC](../../architecture/oidc-integration.md)
- [Architecture générale](../../architecture/architecture.md)
- [Topologie SaaS](../../architecture/saas-cluster-topology.md)
