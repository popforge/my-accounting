---
applyTo: "**"
---

# Standards Docker — Popforge Platform

- **`.dockerignore` obligatoire** : tout `Dockerfile` doit avoir un `.dockerignore` dans le même répertoire — backend **et** frontend SPA. Exclure au minimum `obj/`, `bin/`, `Properties/launchSettings.json` (API .NET) ou `node_modules/`, `dist/`, `.env.development`, `.env.production` (SPA).
- **Secrets dans les layers** : tout token ou secret passé en `ARG` (ex : `NPM_TOKEN`) doit être utilisé, consommé et supprimé dans un **seul `RUN`**. Ne jamais séparer la création et la suppression du fichier secret en plusieurs `RUN` distincts.
- **nginx.conf et SPA** : quand le backend expose un nouveau path (ex : `/swagger/`, `/api/`), le proxy correspondant doit être ajouté dans `nginx.conf` dans le même commit.
- **Layer cache .NET** : dans un Dockerfile .NET, toujours copier le `.csproj` en premier, lancer `dotnet restore`, puis copier les sources. Utiliser `--no-restore` dans `dotnet publish`. Cela évite de re-télécharger les packages à chaque changement de source.
- **`UserSecretsId`** : générer via `dotnet user-secrets init` (ou `[System.Guid]::NewGuid()` en PowerShell). Ne jamais saisir un UUID manuellement ou séquentiel.
- **`docker-compose.deploy.yml`** : tout service web doit définir un `healthcheck` sur l'API et conditionner les services dépendants avec `depends_on: condition: service_healthy`.
