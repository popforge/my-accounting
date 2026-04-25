# Copilot Instructions
- Prefer brief, clear, and concise responses of a single paragraph
- When editing code or providing code samples, please use the combination of Carriage return and Line feed as an end-of-line characters sequence (AKA. "CRLF") rather than simple Line feed characters (AKA. "LF").

## Initialisation d'un nouveau dépôt Popforge

Lors de la création ou du clonage d'un dépôt pour le compte GitHub **popforge**, exécuter immédiatement depuis la racine du dépôt :

```powershell
.\scripts\setup-repo.ps1
```

Ce script (présent dans tout dépôt Popforge) configure automatiquement :
- `user.email = 37725632+popforge@users.noreply.github.com` — adresse noreply obligatoire (évite GH007)
- `user.name = Poppy`
- Renomme `master` → `main` et supprime la branche remote `master`
- Préfixe l'URL remote avec `popforge@` (ex : `https://popforge@github.com/popforge/...`) pour GCM multi-comptes
- Installe le hook `pre-push` qui bloque toute poussée si l'email est incorrect

Pour un tout nouveau dépôt (sans script) : copier `.githooks/` et `scripts/setup-repo.ps1` depuis `Popforge.Auth` avant d'exécuter le script.

## Copilot instruction best practices
- If a copilot instruction file is more than 4 000 characters, split it into multiple files otherwise it will not be considered in code review by GitHub.
