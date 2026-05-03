---
applyTo: "**"
---

# Feed NuGet local — Popforge.Shared

Ce fichier décrit comment regénérer le package NuGet de `Popforge.Shared` localement pour développer sans passer par GitHub Packages.

## Package publié

| PackageId | Projet |
|-----------|--------|
| `Popforge.AspNetCore.Extensions` | `packages/dotnet/Popforge.AspNetCore.Extensions/` |

## Regénérer le feed local

```powershell
Set-Location "C:\sources\rachellavoie\Popforge.Shared"
dotnet pack packages/dotnet/Popforge.AspNetCore.Extensions/Popforge.AspNetCore.Extensions.csproj `
    --configuration Release -p:Version=<version> --output ./local-nuget
```

Le `.nupkg` généré est déposé dans `Popforge.Shared/local-nuget/`, référencé automatiquement par le `nuget.config` de chaque cluster consommateur (feed `popforge-local`).

## Activer le feed local dans un cluster consommateur

Le feed `popforge-local` est **désactivé par défaut** dans les `nuget.config` (clé `disabledPackageSources`) pour ne pas bloquer la CI. Pour l'activer en développement local, commenter temporairement la ligne de désactivation dans `nuget.config`.

> ⚠️ Ne jamais committer `nuget.config` avec le feed local activé — la CI n'a pas accès au chemin local.
