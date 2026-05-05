# Recette — Story 1.2 — Capture mobile et stockage iCloud rapide

> **Référencé par :** `docs/product/stories/epic-1-capture-mobile-et-classement-icloud/story-1-2-capture-mobile-et-stockage-icloud.md`
> **Résumé épic :** [recette-epic-1-capture-mobile-icloud.md](recette-epic-1-capture-mobile-icloud.md)

**Environnement :** Beta (`https://my-accounting-beta.popsalon.app`)
**Cluster :** MyAccounting
**Story :** 1.2 — Capture mobile et stockage iCloud rapide

> ⚠️ **Cette recette doit être exécutée depuis ton iPhone** — c'est le critère de succès #1 du product brief.

---

## Prérequis

- [ ] Story 1.0 approuvée (classement et index PostgreSQL opérationnels)
- [ ] Être connectée avec ton compte Popforge sur `my-accounting-beta.popsalon.app` **depuis ton iPhone**
- [ ] Avoir un document papier à photographier sous la main
- [ ] iCloud Drive actif et synchronisé sur le téléphone

---

## TC-1.2-01 — Capture mobile en quelques opérations

> **AC couvert :** AC1 — Capture mobile en quelques opérations
>
> 🎯 **Critère de succès critique** : si ce flux n'est pas simple et rapide, l'application ne sera pas utilisée.

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Ouvrir `my-accounting-beta.popsalon.app` sur ton iPhone | L'application se charge et tu es connectée | ☐ | |
| 2 | Accéder à la fonctionnalité de capture (bouton visible depuis l'accueil) | Le bouton/accès à la capture est immédiatement visible sans navigation profonde | ☐ | |
| 3 | Prendre une photo d'un document papier | L'appareil photo s'ouvre, tu prends la photo | ☐ | |
| 4 | Remplir le formulaire de classement : Année, Fournisseur, Type de paiement, Montant, Catégorie | Le formulaire est utilisable à 375px, saisie sans zoom iOS | ☐ | |
| 5 | Enregistrer | Confirmation de succès visible à l'écran | ☐ | |
| 6 | Évaluer le nombre total d'opérations | Le flux complet (ouvrir → photo → classer → sauvegarder) est court et intuitif | ☐ | Critique : noter le nb d'opérations |

**Résultat TC-1.2-01 :** ☐ Passe  ☐ Échoue

---

## TC-1.2-02 — Stockage iCloud fiable après fermeture

> **AC couvert :** AC2 — Stockage iCloud fiable

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Après la capture (TC-1.2-01), fermer complètement l'application | — | ☐ | |
| 2 | Rouvrir `my-accounting-beta.popsalon.app` | L'application se charge normalement | ☐ | |
| 3 | Naviguer vers la liste des documents et chercher le document que tu viens de capturer | Le document est toujours présent dans l'index avec ses informations de classement | ☐ | |
| 4 | Ouvrir l'app iCloud sur ton iPhone et vérifier le dossier de destination | Le fichier est présent dans iCloud Drive au bon emplacement | ☐ | |

**Résultat TC-1.2-02 :** ☐ Passe  ☐ Échoue

---

## TC-1.2-03 — Classement obligatoire à l'enregistrement

> **AC couvert :** AC3 — Classement obligatoire

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Tenter de sauvegarder un document sans remplir tous les champs obligatoires | L'application empêche la sauvegarde et indique les champs manquants | ☐ | |
| 2 | Remplir tous les champs et sauvegarder | La fiche du document affiche les 5 critères de classement renseignés | ☐ | |

**Résultat TC-1.2-03 :** ☐ Passe  ☐ Échoue

---

## TC-1.2-04 — Retrouvabilité par filtres

> **AC couvert :** AC4 — Retrouvabilité par filtres

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Naviguer vers « Mes documents » | L'écran de recherche est affiché | ☐ | |
| 2 | Filtrer par le fournisseur du document que tu viens de capturer | Le document apparaît dans les résultats | ☐ | |
| 3 | Ajouter un filtre de catégorie pour affiner | Le document reste dans les résultats si les critères correspondent | ☐ | |

**Résultat TC-1.2-04 :** ☐ Passe  ☐ Échoue

---

## Résultat Story 1.2

**Date de recette :** _______________
**Validée par :** Rachel Lavoie
**Environnement testé :** ☐ Beta  ☐ Production
**Appareil utilisé :** _______________ (ex. : iPhone 14 Pro)

| TC | Description | Résultat |
|----|-------------|----------|
| TC-1.2-01 | Capture mobile — nombre d'opérations | ☐ Passe  ☐ Échoue |
| TC-1.2-02 | Stockage iCloud fiable après fermeture | ☐ Passe  ☐ Échoue |
| TC-1.2-03 | Classement obligatoire + validation | ☐ Passe  ☐ Échoue |
| TC-1.2-04 | Retrouvabilité par filtres | ☐ Passe  ☐ Échoue |

- ☐ **Approuvée** — tous les TC passent, story marquée `Done`
- ☐ **Approuvée partiellement** — voir items bloqués ci-dessous
- ☐ **Rejetée** — retour en développement, voir notes ci-dessous

**Items bloqués :**
>

**Notes / Anomalies observées :**
>
