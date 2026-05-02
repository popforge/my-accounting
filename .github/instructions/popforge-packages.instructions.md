---
applyTo: "**"
---

# Packages Popforge — Standard d'intégration

## Règle absolue

Les packages `@popforge/*` se référencent **uniquement** depuis GitHub Packages.

**Ne jamais utiliser :**
- `"file:../..."` — chemin local
- `"file:../../../../Popforge.Components/popforge-components-*.tgz"` — `.tgz` local
- `npm link` — en dehors du dev local ponctuel (jamais committé)

## Standard dans `package.json`

```json
"@popforge/components": "^0.3.1"
```

Version avec `^` (compatible mineure) — pas de version fixe sauf contrainte explicite.

## Standard dans `.npmrc`

Le fichier `.npmrc` du projet Vue doit contenir :

```ini
@popforge:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NPM_TOKEN}
```

La variable `NPM_TOKEN` est :
- En dev local : `NUGET_AUTHTOKEN` (PAT GitHub `read:packages` — voir `dev-environment.instructions.md`)
- En CI GitHub Actions : secret `NPM_TOKEN` injecté dans le workflow

## Standard dans `main.ts`

Importer les styles une seule fois, en tête de `src/main.ts` :

```ts
import '@popforge/components/styles'
```

## Référence

La documentation complète d'installation est dans :
`Popforge.Components/docs/04-adoption-guide/01-installation.md`

## Quand implémenter un composant depuis Popforge.Components

1. Lire d'abord `Popforge.Components/README.md` et `docs/04-adoption-guide/01-installation.md`
2. Vérifier la version publiée sur GitHub Packages : `npm show @popforge/components version`
3. Utiliser `npm install @popforge/components@<version>` — jamais `npm pack` ni `.tgz`
4. Si le composant n'est pas encore publié (statut `placeholder` ou `draft` non publié), créer d'abord la story dans `Popforge.Components` et publier avant d'intégrer

## Variables d'environnement requises

| Contexte | Variable | Valeur |
|----------|----------|--------|
| Dev local | `NUGET_AUTHTOKEN` | PAT GitHub `read:packages` |
| CI/CD | `NPM_TOKEN` | Secret GitHub Actions `NPM_TOKEN` |
