# PopSalon — Standardss UX-UI

> Document de référence pour l'IA. Dernière mise à jour : avril 2026.

---

## Approche

**Mobile-first.** Toutes les interfaces sont conçues en commençant par les petits écrans. Les ajustements desktop se font via `@media (min-width: 960px)`.

---

## Breakpoints supportés

| Catégorie | Largeur | Exemples |
|-----------|---------|---------|
| Mobile S | 375px | iPhone SE |
| Mobile M | 390px | iPhone 12/13/14 Pro |
| Mobile L | 412px | Samsung Galaxy A51/71, Pixel 7 |
| Tablette | 768px | iPad Mini |
| Desktop | ≥960px | Laptops, écrans Windows |

Règle : l'interface doit être **pleinement fonctionnelle et esthétique** à 375px sans scroll horizontal.

---

## Tokens de couleurs

```css
--bg:           #090916          /* fond page global */
--bg-card:      rgba(16,17,36,0.88)  /* fond card (semi-transparent) */
--border:       rgba(255,255,255,0.08)
--border-input: rgba(255,255,255,0.12)
--border-card:  rgba(160,170,255,0.16)
--border-focus: rgba(217,70,239,0.65)
--text-1:       #f1f5f9          /* texte principal */
--text-2:       #c4c4d8          /* texte secondaire */
--text-muted:   #64748b          /* texte discret */
--text-label:   #a0a0b8          /* labels de champs */
--grad-btn:     linear-gradient(135deg, #6d28d9, #c026d3)
--grad-text:    linear-gradient(90deg, #a855f7, #f97316)
--grad-text2:   linear-gradient(90deg, #a855f7, #ec4899)
--input-bg:     rgba(255,255,255,0.04)
--error:        #f87171
--r-md:         10px
--r-lg:         16px
--r-xl:         20px
```

---

## Typographie

- **Police** : `DM Sans` (Google Fonts) — poids 400, 500, 600, 700, 900
- Fallback : `system-ui, sans-serif`
- Taille inputs : **minimum 16px** (évite le zoom automatique iOS Safari)
- Hiérarchie : h1 `1.5rem` mobile / `1.625rem` desktop, body `0.9375rem`

---

## Fond de page

- **Mobile** : `bg-wave-mobile.png` — image portrait neon wave, `background-attachment: scroll`
- **Desktop** : `hero-login.jpg` — image paysage salon, `background-attachment: fixed`
- Fond de secours : `#090916`

---

## Effets visuels (Aurora)

Blobs animés en arrière-plan, `position: fixed`, `z-index: 0`, `pointer-events: none`.
Couleurs : violet `rgba(109,40,217)`, rose `rgba(192,38,211)`, orange `rgba(249,115,22)`, bleu `rgba(59,130,246)`, cyan `rgba(6,182,212)`.

---

## Card (conteneur principal)

```css
max-width: 370px (mobile) / 460px (desktop)
padding: 2rem 1.25rem (mobile) / 2.625rem 2.25rem (desktop)
background: rgba(16,17,36,0.88)
border: 1px solid rgba(160,170,255,0.16)
border-radius: 20px
backdrop-filter: blur(18px)
box-shadow: 0 30px 90px rgba(0,0,0,.48), 0 0 45px rgba(192,38,211,.10)
```

---

## Champs de formulaire

```css
padding: 0.6875rem 2.75rem 0.6875rem 2.625rem
background: rgba(255,255,255,0.045)
border: 1px solid rgba(255,255,255,0.12)
border-radius: 10px
font-size: 1rem (minimum — iOS anti-zoom)
focus: border rgba(217,70,239,.65) + box-shadow rgba(217,70,239,.12)
```

---

## Bouton principal

```css
background: linear-gradient(135deg, #6d28d9, #c026d3)
border-radius: 10px
font-size: 1rem; font-weight: 700
box-shadow: 0 4px 20px rgba(109,40,217,.4)
```

---

## Assets (wwwroot/images/)

| Fichier | Usage | Source |
|---------|-------|--------|
| `bg-wave-mobile.png` | Fond body mobile | `Assets/wave-background-mobile.png` |
| `hero-login.jpg` | Fond body desktop | `Assets/salon-background-windows.png` |
| `scissors-transparent.png` | Icône PopSalon (logo card) | `Assets/cisors-icon-2-removebg-preview.png` |
| `logo-popsalon.png` | Icône PopSalon petite | `Assets/cisors-mobile-icon.png` |
| `popforge-name.png` | Logo PopForge texte | `Assets/pop-forge-name-with-colors-transparent.png` |

> Les fichiers source originaux sont dans `docs/product/UX-UI/Assets/`. Les copies dans `wwwroot/images/` sont les assets de production.

---

## Règles CSS anti-bugs mobiles

- `html, body { overflow-x: hidden; }` — bloque débordement horizontal
- `.page { overflow: hidden; }` — contient les blobs aurora
- `flex: 1; min-width: 0` sur les flex children — permet rétrécissement correct
- `background-attachment: scroll` sur mobile (pas `fixed` — bug iOS Safari)
- `font-size: 1rem` minimum sur tous les `<input>` — évite zoom iOS

---

## Ligne décorative (CSS pur)

Remplace l'image `colored-line.png`. Implémentée en CSS avec `::before` (gradient) et `::after` (losange central avec glow).

---

## Demo visuelle

- Le standard actuel est représenté par `docs/product/UX-UI/ux-ui-demo.html`

## Images

- Les fichiers source originaux sont dans `docs/product/UX-UI/Assets/`.

