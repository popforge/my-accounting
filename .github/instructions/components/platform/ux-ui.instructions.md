---
applyTo: "src/**/*.{ts,vue,css},docs/product/UX-UI/**"
---

## Standards UX — Popforge

> **Source de vérité :** `Popforge.Components/docs/`
> Toute évolution des standards visuels doit être proposée dans `Popforge.Components`, pas dans un cluster.

### Avant de créer ou modifier un composant UI

1. Lire `Popforge.Components/docs/01-ux-standards/` — tokens, typo, breakpoints, accessibilité, anti-patterns.
2. Vérifier si une primitive ou un pattern existe dans `docs/03-components/` avant d'en créer un.
3. Utiliser uniquement les tokens CSS de `src/styles/design-tokens.css` — jamais de valeurs en dur.

### Aurora universelle

L'aurora est présente dans **tous** les clusters Popforge — c'est la signature visuelle. La variante change selon le contexte (voir `AuroraBackground` dans `@popforge/components`).

- Tokens CSS obligatoires — jamais de valeurs hex en dur.
- `font-size` ≥ `1rem`sur tout `<input>`, `<textarea>`, `<select>` — iOS Safari zoome sur tout champ < 16px.
- **`background-attachment: scroll`** sur mobile — `fixed` est buggué sur iOS Safari.
- **Cibles tactiles ≥ 44px** — accessibilité WCAG AA.
- **Messages d'erreur** — inline sous le champ concerné, jamais dans un toast seul.
- **Confirmations destructives** — toujours via dialogue modal (suppression, changement de rôle).
- **États de chargement** — indicateur visible pour toute requête réseau > 300ms.
- **Messages de succès** — inline, disparaissent après 3 secondes.
- **Ne jamais utiliser la couleur seule** pour distinguer des états — toujours accompagner d'un texte (WCAG AA).

### Breakpoints de référence

| Catégorie | Largeur  | Exemples                        |
|-----------|----------|---------------------------------|
| Mobile S  | 375px    | iPhone SE                       |
| Mobile M  | 390px    | iPhone 12/13/14 Pro             |
| Mobile L  | 412px    | Samsung Galaxy A51/71, Pixel 7  |
| Tablette  | 768px    | iPad Mini                       |
| Desktop   | ≥ 960px  | Laptops, écrans Windows         |

### Mise à jour des standards

Si un standard visuel change, mettre à jour `Popforge.Components/docs/` en premier.
Ne jamais diverger du design system dans un cluster sans ouvrir une PR dans Components.
