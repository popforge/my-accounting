---
applyTo: "**"
---

## Synchronisation des instructions Copilot

### Règle absolue

Les fichiers dans les sous-répertoires `shared/`, `infra/`, `components/` de `.github/instructions/` sont **synchronisés depuis un repo source**. Ne jamais les modifier directement ici — toujours modifier dans le repo source puis synchroniser.

| Sous-répertoire | Source |
|---|---|
| `shared/` | `Popforge.Shared/.github/instructions/for-consumers/` |
| `infra/` | `popsalon-infra/.github/instructions/for-consumers/` |
| `components/` | `Popforge.Components/.github/instructions/for-consumers/` |

Les fichiers **à la racine de `.github/instructions/`** sont locaux au cluster — ils peuvent être modifiés librement.

### En début de session

Si un fichier `instructions-sources.yaml` existe à la racine du repo, proposer à Rachel de synchroniser les instructions si des sources sont plus récentes :

```powershell
cd <racine-du-repo>
& $env:POPFORGE_REPOS_ROOT\Popforge.Shared\scripts\sync-instructions.ps1 -DryRun
```

Si le dry-run montre des changements, proposer d'exécuter sans `-DryRun`.

### Quand quelqu'un demande de modifier une instruction synchronisée

Refuser poliment et rediriger :

> "Ce fichier est synchronisé depuis `<source_repo>`. Modifie-le dans `<source_repo>/.github/instructions/for-consumers/` puis lance `sync-instructions.ps1`."
