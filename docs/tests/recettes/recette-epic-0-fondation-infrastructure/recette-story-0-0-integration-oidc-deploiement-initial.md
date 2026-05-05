# Recette — Story 0.0 — Intégration OIDC et déploiement initial

> **Référencé par :** `docs/product/stories/epic-0-fondation-et-infrastructure/story-0-0-integration-oidc-et-deploiement-initial.md`
> **Résumé épic :** [recette-epic-0-fondation-infrastructure.md](recette-epic-0-fondation-infrastructure.md)

**Environnement :** Beta (`https://my-accounting-beta.popsalon.app`)
**Cluster :** MyAccounting
**Story :** 0.0 — Intégration OIDC et déploiement initial

---

## Prérequis

- [ ] Application déployée en Beta (`https://my-accounting-beta.popsalon.app`)
- [ ] Compte Popforge Rachel actif sur `auth-beta.popsalon.app`
- [ ] Accès à un terminal pour le test curl (TC-0.0-04)
- [ ] Naviguer en mode navigation privée pour les tests d'accès sans session

---

## TC-0.0-01 — Accès sans session → redirection automatique vers Auth

> **AC couvert :** AC1 — Redirection automatique vers la connexion

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Ouvrir une fenêtre de navigation **privée** | Fenêtre vide, aucune session | ☑ | |
| 2 | Naviguer vers `https://my-accounting-beta.popsalon.app/` | Aucun contenu de l'application n'est affiché | ☑ | |
| 3 | Observer la redirection | Tu es automatiquement redirigée vers `auth-beta.popsalon.app` (page de connexion Popforge) | ☑ | |

**Résultat TC-0.0-01 :** ☑ Passe  ☐ Échoue

---

## TC-0.0-02 — Connexion avec le compte Popforge

> **AC couvert :** AC2 — Connexion avec son compte Popforge

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Sur la page de connexion `auth-beta.popsalon.app`, saisir ton identifiant et mot de passe Popforge | Champs remplis | ☑ | |
| 2 | Cliquer sur « Se connecter » | Redirection vers `my-accounting-beta.popsalon.app` | ☑ | |
| 3 | Observer l'accueil de l'application | L'application est accessible, tu peux naviguer normalement, aucun message d'erreur | ☑ | Page d'accueil affiche « My Accounting — Authentification OIDC active » |

**Résultat TC-0.0-02 :** ☑ Passe  ☐ Échoue

---

## TC-0.0-03 — Déconnexion et protection de session

> **AC couvert :** AC4 — Déconnexion

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Depuis l'application (session active), cliquer sur le bouton de déconnexion | — | ☑ | |
| 2 | Observer la redirection | Tu es redirigée vers `auth-beta.popsalon.app` (même expérience que le premier accès) | ☑ | |
| 3 | Tenter de revenir manuellement sur `https://my-accounting-beta.popsalon.app/` | Tu es à nouveau redirigée vers la page de connexion, aucun contenu n'est accessible | ☑ | |

**Résultat TC-0.0-03 :** ☑ Passe  ☐ Échoue

---

## TC-0.0-04 — API protégée — réponse 401 sans token

> **AC couvert :** AC3 — API protégée côté serveur

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Ouvrir un terminal | — | ☑ | |
| 2 | Exécuter : `curl.exe -i https://my-accounting-beta.popsalon.app/api/documents` | La réponse HTTP contient `401` dans le statut | ☑ | Utiliser `curl.exe` en PowerShell (alias curl → Invoke-WebRequest) |
| 3 | Vérifier qu'aucune donnée n'est retournée dans le corps de la réponse | Corps vide ou message `UserNotAuthenticated`, pas de données | ☑ | |

**Résultat TC-0.0-04 :** ☑ Passe  ☐ Échoue

---

## TC-0.0-05 — Swagger UI accessible ⚠️ Bonus

> **Hors AC story — vérification conformité plateforme**
> ⚠️ Le Swagger UI est servi à `/api-docs/` (RoutePrefix Swashbuckle), pas `/swagger/`.

| # | Action | Résultat attendu | ☐/☑ | Notes |
|---|--------|-----------------|-----|-------|
| 1 | Naviguer vers `https://my-accounting-beta.popsalon.app/api-docs/` | La page Swagger UI s'affiche (même sans session) | ☐ | Après prochain déploiement — bug nginx corrigé |

**Résultat TC-0.0-05 :** ☐ Passe  ☐ Échoue — ⏳ En attente du prochain déploiement

---

## Résultat Story 0.0

**Date de recette :** 2026-05-04
**Validée par :** Rachel Lavoie
**Environnement testé :** ☑ Beta  ☐ Production

| TC | Description | Résultat |
|----|-------------|----------|
| TC-0.0-01 | Accès sans session → redirection Auth | ☑ Passe  ☐ Échoue |
| TC-0.0-02 | Connexion compte Popforge | ☑ Passe  ☐ Échoue |
| TC-0.0-03 | Déconnexion + protection de session | ☑ Passe  ☐ Échoue |
| TC-0.0-04 | API 401 sans token (curl) | ☑ Passe  ☐ Échoue |
| TC-0.0-05 | Swagger UI accessible (bonus) | ☐ Passe  ☐ Échoue — ⏳ après déploiement |

- ☐ **Approuvée** — tous les TC passent, story marquée `Done`
- ☑ **Approuvée partiellement** — voir items bloqués ci-dessous
- ☐ **Rejetée** — retour en développement, voir notes ci-dessous

**Items bloqués :**
> TC-0.0-E2E (steps Gherkin `authentification.steps.ts`) — différé : fixture `auth-session` en attente secrets GitHub Actions. Non bloquant pour la recette manuelle.
>
> TC-0.0-05 (bonus hors AC) — page `/swagger/index.html` blanche : assets Swashbuckle non chargés en production (nginx ou middleware). Bug à corriger, non bloquant pour marquer la story Done (hors AC).

**Notes / Anomalies observées :**
> - Page d'accueil affiche « My Accounting — Authentification OIDC active » (message de placeholder — à remplacer par la vraie UI Epic 1)
> - En PowerShell, utiliser `curl.exe` et non `curl` (alias Invoke-WebRequest)
