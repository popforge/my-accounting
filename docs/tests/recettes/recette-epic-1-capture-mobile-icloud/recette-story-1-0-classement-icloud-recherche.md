# Recette — Story 1.0 — Classement iCloud et recherche multi-critères

> **Référencé par :** `docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-0-classement-icloud-et-recherche-multi-criteres.md`
> **Résumé épic :** [recette-epic-1-capture-mobile-icloud.md](recette-epic-1-capture-mobile-icloud.md)

**Environnement :** Beta (`https://my-accounting-beta.popsalon.app`)
**Cluster :** MyAccounting
**Story :** 1.0 — Classement iCloud et recherche multi-critères

---

## Prérequis

- [ ] Story 0.0 approuvée (session OIDC opérationnelle)
- [ ] Être connectée avec ton compte Popforge sur `my-accounting-beta.popsalon.app`
- [ ] Au moins 2-3 documents déjà indexés dans la base (sinon utiliser TC-1.0-01 pour en créer un)

---

## TC-1.0-01 — Classement iCloud standardisé à l'enregistrement d'un document

> **AC couvert :** AC1 — Classement iCloud standardisé

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Naviguer vers la page d'ajout/classement de document | Le formulaire de classement est affiché | ☐ | |
| 2 | Remplir : Année `2026`, Fournisseur `EDF`, Type `Débit`, Montant `45.00`, Catégorie `Énergie` | Champs remplis | ☐ | |
| 3 | Enregistrer le document | Confirmation de sauvegarde visible | ☐ | |
| 4 | Vérifier le classement affiché | Le document apparaît avec les 5 critères cohérents : année, fournisseur, type, montant, catégorie | ☐ | |
| 5 | Ajouter un deuxième document (fournisseur différent, même année) et vérifier | Le classement suit la même structure — cohérence d'un document à l'autre | ☐ | |

**Résultat TC-1.0-01 :** ☐ Passe  ☐ Échoue

---

## TC-1.0-02 — Recherche multi-critères combinée

> **AC couvert :** AC2 — Recherche multi-critères combinée

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Naviguer vers la page « Mes documents » | L'écran de recherche avec filtres est affiché | ☐ | |
| 2 | Filtrer par Année `2026` uniquement | La liste affiche uniquement les documents de 2026 | ☐ | |
| 3 | Ajouter le filtre Catégorie `Énergie` en combinaison | La liste est réduite aux documents 2026 + catégorie Énergie | ☐ | |
| 4 | Ajouter un filtre Montant min `40` et max `50` | La liste est réduite aux documents correspondant aux 3 critères combinés | ☐ | |
| 5 | Retirer tous les filtres | La liste complète réapparaît | ☐ | |

**Résultat TC-1.0-02 :** ☐ Passe  ☐ Échoue

---

## TC-1.0-03 — Résultats clairs et exploitables

> **AC couvert :** AC3 — Résultats clairs et exploitables

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Lancer une recherche avec critères | Les cards de résultats affichent : `nomFichier`, `fournisseur`, `annee`, `categorieDepense`, `montant` | ☐ | |
| 2 | Lancer une recherche avec critères ne correspondant à aucun document | Message « Aucun document ne correspond à vos filtres. » affiché | ☐ | |

**Résultat TC-1.0-03 :** ☐ Passe  ☐ Échoue

---

## TC-1.0-04 — Modification du classement d'un document

> **AC couvert :** AC4 — Modification de classement

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Cliquer sur un document dans les résultats de recherche | La fiche document s'ouvre avec les informations de classement actuelles | ☐ | |
| 2 | Modifier la catégorie de dépense (ex. : `Énergie` → `Chauffage`) et enregistrer | Toast « Classement mis à jour. » apparaît | ☐ | |
| 3 | Retourner à la recherche et filtrer par la nouvelle catégorie `Chauffage` | Le document apparaît dans les résultats de la nouvelle catégorie | ☐ | |
| 4 | Filtrer par l'ancienne catégorie `Énergie` | Le document n'apparaît plus dans cette catégorie | ☐ | |

**Résultat TC-1.0-04 :** ☐ Passe  ☐ Échoue

---

## Résultat Story 1.0

**Date de recette :** _______________
**Validée par :** Rachel Lavoie
**Environnement testé :** ☐ Beta  ☐ Production

| TC | Description | Résultat |
|----|-------------|----------|
| TC-1.0-01 | Classement iCloud standardisé | ☐ Passe  ☐ Échoue |
| TC-1.0-02 | Recherche multi-critères combinée | ☐ Passe  ☐ Échoue |
| TC-1.0-03 | Résultats clairs — liste vide | ☐ Passe  ☐ Échoue |
| TC-1.0-04 | Modification de classement | ☐ Passe  ☐ Échoue |

- ☐ **Approuvée** — tous les TC passent, story marquée `Done`
- ☐ **Approuvée partiellement** — voir items bloqués ci-dessous
- ☐ **Rejetée** — retour en développement, voir notes ci-dessous

**Items bloqués :**
>

**Notes / Anomalies observées :**
>
