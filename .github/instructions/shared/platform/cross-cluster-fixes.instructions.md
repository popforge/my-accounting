---
applyTo: "**"
---

# Corrections trans-clusters

## Règle

Lorsqu'une erreur, un bug ou un comportement défectueux est identifié dans un des clusters Popforge, vérifier **systématiquement** si les autres clusters ont le même problème — même si l'utilisateur ne le demande pas explicitement.

## Procédure

1. **Diagnostiquer** la cause racine sur le cluster où le bug a été observé.
2. **Inspecter** les autres clusters pour le même pattern défectueux.
3. **Corriger** le code dans tous les clusters affectés, avec le même message de commit (adapté au cluster).
4. **Committer** localement dans chaque cluster affecté.
5. **Ne pousser que** le cluster sur lequel l'utilisateur travaille activement. Les autres clusters restent committés localement, prêts à être poussés au prochain cycle de travail dessus.
6. **Mentionner** dans la réponse les autres clusters qui ont reçu un fix local non poussé, pour que l'utilisateur sache quoi pousser plus tard.

## Exemples de patterns à vérifier trans-clusters

- Configuration `UseNpgsql` (retry, command timeout)
- Healthchecks Kamal (path, retries, start-period)
- Versions des packages `Popforge.*` (Shared)
- Pipeline middleware (ordre `UseAuthentication`/`UseAuthorization`)
- Configuration CORS, OIDC, JWT
- Variables d'environnement requises (`appsettings.json` keys)
- Workflows GitHub Actions (`deploy-beta.yml`, `publish-image.yml`)

## Références repos

- `C:\sources\rachellavoie\Popforge.Auth`
- `C:\sources\rachellavoie\Popforge.Hub`
- `C:\sources\rachellavoie\Popforge.MyAccounting`
- `C:\sources\rachellavoie\Popforge.PopSalon`
- `C:\sources\rachellavoie\Popforge.Shared` (mutualisation — préférer un fix ici si le pattern est commun)
- `C:\sources\rachellavoie\Popforge.Components`
- `C:\sources\rachellavoie\popsalon-infra`
