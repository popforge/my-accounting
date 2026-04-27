---
applyTo: "**"
---

# Environnement de développement local — Popforge

## Variables d'environnement (machine raclavo)

Ces variables doivent être définies au niveau utilisateur Windows (`[System.Environment]::SetEnvironmentVariable(..., "User")`).

| Variable | Usage |
|---|---|
| `NUGET_AUTHTOKEN` | PAT GitHub avec `read:packages` — utilisé par `nuget.config` pour résoudre `Popforge.AspNetCore.Extensions` depuis GitHub Packages |
| `ADO_PAT` | PAT Azure DevOps — accès aux ressources ADO du compte popforge |

Pour vérifier qu'elles sont en place :
```powershell
[System.Environment]::GetEnvironmentVariables("User").GetEnumerator() |
    Where-Object { $_.Key -in @("NUGET_AUTHTOKEN","ADO_PAT") } |
    Select-Object Key
```

## Clé SSH Oracle

Fichier : `C:\Users\raclavo\.ssh\id_ed25519.pub`

Utilisée pour l'accès aux ressources Oracle Cloud (OCI). La clé privée associée est `id_ed25519` dans le même dossier.

## Feed NuGet local (développement sans publication)

Quand le package `Popforge.AspNetCore.Extensions` n'est pas encore publié sur GitHub Packages (ex. : nouvelle version en cours de dev), un feed local est disponible :

```
C:\sources\rachellavoie\Popforge.Shared\local-nuget\
```

Pour regénérer le feed local après une modification de Shared :
```powershell
Set-Location "C:\sources\rachellavoie\Popforge.Shared"
dotnet pack packages/dotnet/Popforge.AspNetCore.Extensions/Popforge.AspNetCore.Extensions.csproj `
    --configuration Release -p:Version=<version> --output ./local-nuget
```

Le `nuget.config` de chaque cluster référence ce chemin automatiquement (feed `popforge-local`).

