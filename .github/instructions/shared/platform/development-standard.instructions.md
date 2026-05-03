---
applyTo: "**"
---

# Standards de développement — Popforge Platform

## Document normatif de référence

`docs/architecture/saas-cluster-topology.md` est le **document d'autorité** pour :
- Les URLs publiques de chaque cluster (ex : `/swagger/index.html` pour le Swagger UI)
- Les numéros de port de déploiement
- La liste des clusters et environnements

**Règle** : Ne jamais modifier `saas-cluster-topology.md` sans demande explicite. Toujours lire ce fichier avant d'implémenter un endpoint, une URL ou un Dockerfile. Si une implémentation dérive du standard défini dans ce fichier, poser la question plutôt que de modifier le document.

## Standards techniques

- **Swagger UI** : exposé à `/swagger/index.html` via Swashbuckle.AspNetCore — pas Scalar, pas un autre chemin.
- **Environnements ASP.NET** : `Development` (local), `Beta` (staging), `Production` (prod).
- **Base de données** : Neon PostgreSQL. Connection string via `user-secrets` en dev, variable d'env en Beta/Prod.

## Code reviews

**Règle** : Après chaque code review, créer un fichier de log dans `docs/reviews/` avec le format :

```
docs/reviews/YYYY-MM-DD-<scope>.md
```

Exemples : `2026-04-26-hub-backend-pipeline.md`, `2026-05-10-auth-oidc-flow.md`

Le fichier doit contenir :
- La plage de commits reviewée (`git diff <from>..<to>`)
- Les findings (titre, catégorie : patch / defer / dismiss, fichier)
- Les corrections appliquées (description et fichiers modifiés)
- Les items différés (defer) pour référence future

**Après avoir écrit le fichier log**, analyser les findings et se poser les questions suivantes :
- Est-ce qu'un standard de programmation manquant aurait pu prévenir ce finding ? → Ajouter la règle dans ce fichier (`development-standard.instructions.md`).
- Est-ce qu'une instruction AI manquante aurait pu prévenir ce finding ? → Ajouter la règle dans le fichier d'instructions concerné (`.github/instructions/`).
- Est-ce qu'un document manquant sous `docs/` aurait pu guider le développeur ? → Créer ou compléter le document approprié (`docs/architecture/`, `docs/devsecops/`, etc.).
