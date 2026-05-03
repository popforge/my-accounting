---
applyTo: "**"
---

# Environnement de développement local — Popforge

## Variables d'environnement (machine raclavo)

Ces variables doivent être définies au niveau utilisateur Windows (`[System.Environment]::SetEnvironmentVariable(..., "User")`).

| Variable | Usage |
|---|---|
| `NUGET_AUTHTOKEN` | PAT GitHub avec `read:packages` — utilisé par `nuget.config` pour résoudre `Popforge.AspNetCore.Extensions` depuis GitHub Packages |
| `GHCR_READ_TOKEN` | PAT GitHub avec `read:packages` — utilisé pour lire les images privées GHCR (ex: `ghcr.io/popforge/base-api`) dans les workflows CI/CD |
| `ADO_PAT` | PAT Azure DevOps — accès aux ressources ADO du compte popforge |

Pour vérifier qu'elles sont en place :
```powershell
[System.Environment]::GetEnvironmentVariables("User").GetEnumerator() |
    Where-Object { $_.Key -in @("NUGET_AUTHTOKEN","GHCR_READ_TOKEN","ADO_PAT") } |
    Select-Object Key
```

**Ces valeurs ne doivent jamais être committées dans le code source.**

## Clé SSH Oracle

Fichier : `C:\Users\raclavo\.ssh\id_ed25519.pub`

Utilisée pour l'accès aux ressources Oracle Cloud (OCI). La clé privée associée est `id_ed25519` dans le même dossier.

## Feed NuGet local (développement sans publication)

Tout repo Popforge qui publie un package NuGet maintient un dossier `local-nuget/` à sa racine. Les clusters consommateurs référencent ce feed dans leur `nuget.config` (clé `popforge-local`).

Pour savoir comment regénérer le package d'un producteur spécifique, consulter le fichier `nuget-local-dev.instructions.md` dans le sous-répertoire correspondant :

- `.github/instructions/shared/nuget-local-dev.instructions.md` — Popforge.Shared
- `.github/instructions/auth/nuget-local-dev.instructions.md` — Popforge.Auth *(à venir)*
- `.github/instructions/hub/nuget-local-dev.instructions.md` — Popforge.Hub *(à venir)*
