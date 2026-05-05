# Recette — Story 1.1 — Import des documents existants iCloud

> **Référencé par :** `docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-1-import-documents-existants-icloud.md`
> **Résumé épic :** [recette-epic-1-capture-mobile-icloud.md](recette-epic-1-capture-mobile-icloud.md)

**Environnement :** Beta (`https://my-accounting-beta.popsalon.app`)
**Cluster :** MyAccounting
**Story :** 1.1 — Import des documents existants iCloud

---

## Prérequis

- [ ] Story 1.0 approuvée (classement et index PostgreSQL opérationnels)
- [ ] Être connectée avec ton compte Popforge sur `my-accounting-beta.popsalon.app`
- [ ] Ton iCloud Drive contient des documents dans `iCloud Drive/Documents/Classeur/Finance/{année}/{TypeDeDocument}`
- [ ] Des fichiers nommés selon le format `{Date}_{Fournisseur}_{description}_{Montant}` existent (ex. : `2026-02-15_Nessrin Elhadary_pers Rachel_39,40$.pdf`)

---

## TC-1.1-01 — Lecture de l'arborescence iCloud et résumé par année/type

> **AC couvert :** AC1 — Lecture de l'arborescence iCloud existante

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Naviguer vers la fonctionnalité « Import iCloud » dans l'application | L'écran d'import est affiché avec un bouton de lancement | ☐ | |
| 2 | Lancer l'import depuis la racine `iCloud Drive/Documents/Classeur/Finance/` | L'application parcourt l'arborescence | ☐ | |
| 3 | Observer le résultat | Un résumé confirme le nombre de documents trouvés par année et par type de document | ☐ | |

**Résultat TC-1.1-01 :** ☐ Passe  ☐ Échoue

---

## TC-1.1-02 — Support des dossiers `!Facturette` et `Releves - X`

> **AC couvert :** AC2 — Support des deux types prioritaires

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Après l'import, filtrer les documents indexés par type `!Facturette` | Les documents du dossier `!Facturette` sont présents dans l'index | ☐ | |
| 2 | Filtrer les documents indexés par type `Releves - X` | Les relevés bancaires du dossier correspondant sont présents | ☐ | |

**Résultat TC-1.1-02 :** ☐ Passe  ☐ Échoue

---

## TC-1.1-03 — Reconnaissance des sous-dossiers `!Facturette`

> **AC couvert :** AC3 — Prise en compte de la structure !Facturette

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Vérifier les documents du sous-dossier `!Argent Comptant` | Ils sont indexés avec type de paiement `argent_comptant` | ☐ | |
| 2 | Vérifier les documents du dossier fournisseur `Bureau en gros` | Ils sont indexés avec `fournisseur = Bureau en gros` | ☐ | |
| 3 | Vérifier les documents du dossier `Virements interact` | Ils sont indexés correctement | ☐ | |
| 4 | Vérifier les documents sans sous-dossier (taxes municipales, pièces annuelles) | Ils sont indexés dans la catégorie racine de l'année | ☐ | |

**Résultat TC-1.1-03 :** ☐ Passe  ☐ Échoue

---

## TC-1.1-04 — Interprétation du nommage existant

> **AC couvert :** AC4 — Interprétation du format de nom actuel

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Ouvrir la fiche d'un document importé dont le nom est `2026-02-15_Nessrin Elhadary_pers Rachel_39,40$.pdf` | La fiche affiche : date `2026-02-15`, fournisseur `Nessrin Elhadary`, montant `39.40` | ☐ | |
| 2 | Vérifier que la description `pers Rachel` est aussi extraite | La description est visible dans la fiche | ☐ | |

**Résultat TC-1.1-04 :** ☐ Passe  ☐ Échoue

---

## TC-1.1-05 — Import non destructif

> **AC couvert :** AC6 — Import non destructif

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Après l'import, ouvrir l'app iCloud sur ton iPhone et naviguer dans `Classeur/Finance/` | Tous tes fichiers originaux sont encore présents, aucun n'a été déplacé ni supprimé | ☐ | |
| 2 | Rejouer l'import une deuxième fois | Aucun doublon dans l'index — le résumé indique `0 nouveau document` ou ignore les existants | ☐ | |

**Résultat TC-1.1-05 :** ☐ Passe  ☐ Échoue

---

## Résultat Story 1.1

**Date de recette :** _______________
**Validée par :** Rachel Lavoie
**Environnement testé :** ☐ Beta  ☐ Production

| TC | Description | Résultat |
|----|-------------|----------|
| TC-1.1-01 | Lecture arborescence — résumé par année/type | ☐ Passe  ☐ Échoue |
| TC-1.1-02 | Support !Facturette et Releves | ☐ Passe  ☐ Échoue |
| TC-1.1-03 | Sous-dossiers !Facturette reconnus | ☐ Passe  ☐ Échoue |
| TC-1.1-04 | Interprétation nommage existant | ☐ Passe  ☐ Échoue |
| TC-1.1-05 | Import non destructif + anti-doublon | ☐ Passe  ☐ Échoue |

- ☐ **Approuvée** — tous les TC passent, story marquée `Done`
- ☐ **Approuvée partiellement** — voir items bloqués ci-dessous
- ☐ **Rejetée** — retour en développement, voir notes ci-dessous

**Items bloqués :**
>

**Notes / Anomalies observées :**
>
