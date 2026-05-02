# Recette manuelle — Story X.Y — [Titre de la story]

> **Usage :** Un fichier par story. Une story n'est `Done` que lorsque Rachel a rempli et signé ce document.
>
> **Emplacement :** `docs/tests/recettes/recette-epic-<N>-<slug>/recette-story-<X.Y>-<slug>.md`
> **Référencé par :** la story spec dans la section « Validation manuelle — Recette »
> **Résumé épic :** `recette-epic-<N>-<slug>.md` (même dossier)

**Environnement :** Beta (`my-accounting-beta.popsalon.app`)
**Cluster :** MyAccounting
**Story :** [X.Y] — [Titre de la story]
**Sprint :** Sprint NN

---

## Prérequis

- [ ] Story X.A déployée en Beta (si dépendance)
- [ ] Être connecté en tant que [persona] dans Beta
- [ ] [Autre prérequis]

---

## TC-X.Y-01 — [Titre du cas de test — chemin nominal]

> **AC couvert :** AC1 — [libellé de l'AC]

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | [Action utilisateur — URL, bouton, saisie] | [Résultat visible à l'écran] | ☐ | |
| 2 | [Action utilisateur] | [Résultat visible] | ☐ | |

**Résultat TC-X.Y-01 :** ☐ Passe  ☐ Échoue

---

## TC-X.Y-02 — [Titre du cas de test — cas d'erreur ou cas limite]

> **AC couvert :** AC2 — [libellé de l'AC]

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | [Action qui provoque l'erreur ou le cas limite] | [Message d'erreur ou comportement attendu] | ☐ | |

**Résultat TC-X.Y-02 :** ☐ Passe  ☐ Échoue

---

## Résultat Story X.Y

**Date de recette :** _______________
**Validée par :** Rachel Lavoie
**Environnement testé :** ☐ Beta  ☐ Production

| TC | Description | Résultat |
|----|-------------|----------|
| TC-X.Y-01 | [Titre TC-01] | ☐ Passe  ☐ Échoue |
| TC-X.Y-02 | [Titre TC-02] | ☐ Passe  ☐ Échoue |

- ☐ **Approuvée** — tous les TC testables passent, story marquée `Done`
- ☐ **Approuvée partiellement** — voir items bloqués ci-dessous
- ☐ **Rejetée** — retour en développement, voir notes ci-dessous

**Items bloqués :**
>

**Notes / Anomalies observées :**
>
