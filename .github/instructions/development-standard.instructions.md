---
applyTo: "**"
---

# Standards de développement — MyAccounting

## Document normatif de référence

`docs/architecture/saas-cluster-topology.md` est le **document d'autorité** pour :
- Les URLs publiques de chaque cluster (ex : `/api-docs/index.html` pour le Swagger UI)
- Les numéros de port de déploiement
- La liste des clusters et environnements

**Règle** : Ne jamais modifier `saas-cluster-topology.md` sans demande explicite. Toujours lire ce fichier avant d'implémenter un endpoint, une URL ou un Dockerfile. Si une implémentation dérive du standard défini dans ce fichier, poser la question plutôt que de modifier le document.

## Standards techniques

- **Swagger UI** : exposé à `/api-docs/index.html` via `Microsoft.AspNetCore.OpenApi` + `Swashbuckle.AspNetCore.SwaggerUI`.
- **Environnements ASP.NET** : `Development` (local), `Beta` (staging), `Production` (prod).
- **Base de données** : Neon PostgreSQL. Connection string via `user-secrets` en dev, variable d'env en Beta/Prod.

## Standards Docker

- **`.dockerignore` obligatoire** : tout `Dockerfile` doit avoir un `.dockerignore` dans le même répertoire — backend **et** frontend SPA. Exclure au minimum `obj/`, `bin/`, `Properties/launchSettings.json` (API .NET) ou `node_modules/`, `dist/`, `.env.development`, `.env.production` (SPA).
- **Secrets dans les layers** : tout token ou secret passé en `ARG` (ex : `NPM_TOKEN`) doit être utilisé, consommé et supprimé dans un **seul `RUN`**. Ne jamais séparer la création et la suppression du fichier secret en plusieurs `RUN` distincts.
- **Layer cache .NET** : dans un Dockerfile .NET, toujours copier le `.csproj` en premier, lancer `dotnet restore`, puis copier les sources. Utiliser `--no-restore` dans `dotnet publish`.
- **`UserSecretsId`** : générer via `dotnet user-secrets init` (ou `[System.Guid]::NewGuid()` en PowerShell). Ne jamais saisir un UUID manuellement ou séquentiel.
- **`docker-compose.deploy.yml`** : tout service web doit définir un `healthcheck` sur l'API et conditionner les services dépendants avec `depends_on: condition: service_healthy`.

## Environnement de développement local

Variables d'environnement requises (configurées en variable utilisateur Windows) :

| Variable | Usage |
|---|---|
| `NUGET_AUTHTOKEN` | PAT GitHub (`read:packages`) — accès au feed NuGet `https://nuget.pkg.github.com/popforge` |
| `ADO_PAT` | PAT Azure DevOps — accès aux pipelines et artefacts ADO |

Clé SSH Oracle Cloud :
- Chemin : `C:\Users\raclavo\.ssh\id_ed25519.pub`
- Usage : accès SSH aux VMs et bastions Oracle Cloud

**Ces valeurs ne doivent jamais être committées dans le code source.**

## Code reviews

**Règle** : Après chaque code review, créer un fichier de log dans `docs/reviews/` avec le format :

```
docs/reviews/YYYY-MM-DD-<scope>.md
```

Le fichier doit contenir :
- La plage de commits reviewée (`git diff <from>..<to>`)
- Les findings (titre, catégorie : patch / defer / dismiss, fichier)
- Les corrections appliquées (description et fichiers modifiés)
- Les items différés (defer) pour référence future

**Après avoir écrit le fichier log**, analyser les findings et se poser les questions suivantes :
- Est-ce qu'un standard de programmation manquant aurait pu prévenir ce finding ? → Ajouter la règle dans ce fichier (`development-standard.instructions.md`).
- Est-ce qu'une instruction AI manquante aurait pu prévenir ce finding ? → Ajouter la règle dans le fichier d'instructions concerné (`.github/instructions/`).
- Est-ce qu'un document manquant sous `docs/` aurait pu guider le développeur ? → Créer ou compléter le document approprié.
