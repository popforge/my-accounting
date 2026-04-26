# ADR-001 - Reuse plateforme SaaS existante avec approche single-tenant first

**Date :** 2026-04-26
**Status :** `accepted`
**Deciders :** Rachel Lavoie

---

## Context

MyAccounting est une application de comptabilité personnelle et locative, usage privé, avec priorité mobile. Le contexte technique existant comprend déjà une plateforme SaaS multi-cluster opérationnelle (VM Oracle Cloud, nginx, Docker, auth OIDC, services tiers).

Le besoin est de déployer MyAccounting pour usage téléphone sans multiplier les stacks techniques, tout en évitant de surconstruire une architecture enterprise inutile pour une V1 personnelle.

Contraintes principales :
- limiter la complexité de maintenance
- réutiliser les services déjà opérationnels (notamment auth)
- conserver iCloud comme source de vérité documentaire
- offrir une recherche rapide sur les documents

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| A - Stack dédié distinct pour MyAccounting | Isolation totale, liberté de choix technologique | Nouvelle chaîne DevOps, plus de maintenance, fragmentation du savoir-faire |
| B - Reuse stack existant + cluster MyAccounting dédié + single-tenant V1 | Cohérence technique, déploiement plus rapide, auth mutualisée, évolution possible | Besoin de garde-fous pour ne pas imposer toute la complexité multi-tenant dès le début |
| C - Intégration MyAccounting dans cluster existant non dédié | Mise en route potentiellement rapide | Couplage fort, frontières fonctionnelles moins claires, évolution plus difficile |

## Decision

Choisir l'option B : réutiliser la plateforme SaaS existante et déployer MyAccounting comme cluster dédié, en mode single-tenant first pour la V1.

Principes associes :
- authentification via service OIDC existant
- documents sources conservés dans iCloud
- recherche performante via index applicatif serveur PostgreSQL (sans déplacer les fichiers sources)
- architecture prête pour évolution future, sans activer multi-tenant en V1
- exposition via sous-domaine dédié
- synchronisation documentaire : import initial complet puis incrémentale à la demande
- sécurité V1 : compte unique Rachel
- UI V1 : réutilisation partielle des composants/écrans partagés

## Consequences

### Positive
- Réduction du time-to-deploy
- Uniformité du stack et baisse du coût cognitif
- Réutilisation immédiate des composants opérationnels (infra, auth, monitoring)
- Base évolutive pour besoins futurs sans replatforming

### Trade-offs / Risks
- Risque de sur-ingénierie si des exigences multi-tenant sont introduites trop tôt
- Besoin de définir clairement les frontières entre "prêt pour plus tard" et "nécessaire maintenant"
- Besoin de stratégie claire pour index documentaire (local, serveur, ou hybride)
- Gouvernance des secrets et accès environnement à expliciter pour MyAccounting

## References

- [architecture.md](../architecture.md)
- [saas-cluster-topology.md](../saas-cluster-topology.md)
- [project-context.md](../../project-context.md)
- [index-rebuild-runbook.md](../index-rebuild-runbook.md)

## Operational note

Décisions complétées après revue :
- URL beta : my-accounting-beta.popsalon.app
- Rétention index PostgreSQL : aucune sauvegarde dédiée, réindexation iCloud en cas de perte

En cas de perte/corruption de l'index, appliquer la procédure documentée dans [index-rebuild-runbook.md](../index-rebuild-runbook.md).
