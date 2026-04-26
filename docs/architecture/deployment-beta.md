# Runbook de déploiement beta — Cluster `my-accounting`

> URL cible : `https://my-accounting-beta.popsalon.app`
> VM : Oracle Cloud `148.116.77.58` (même VM que tous les autres clusters)
> Port API interne : `8095` — Port App interne : `8096` (proxiés par nginx)

---

## État actuel du déploiement (26 avril 2026)

### ✅ Fait

- Workflows CI/CD créés et pushés sur `main` :
  - `.github/workflows/publish-images.yml` — build + push GHCR des deux images sur push `main`
  - `.github/workflows/deploy-beta.yml` — déploiement SSH sur Oracle VM après publish
- `docker-compose.deploy.yml` créé à la racine
- Dockerfiles placeholder créés :
  - `src/my-accounting/server/MyAccounting.Server/Dockerfile` — API .NET 10
  - `src/my-accounting/app/Dockerfile` — SPA Vue 3 + nginx

### ❌ Reste à faire

1. Créer le projet Neon (base de données)
2. Configurer l'environment `beta` dans GitHub (secrets + variables)
3. Créer le code source réel (remplacer les Dockerfiles placeholder)
4. Créer le DNS Cloudflare `my-accounting-beta.popsalon.app`
5. Configurer nginx sur la VM Oracle
6. Obtenir le certificat TLS Let's Encrypt
7. Premier déploiement

---

## Étape 1 — Créer le projet Neon (base de données)

```powershell
neonctl projects create --name popforge-my-accounting --region-id aws-us-east-1 --pg-version 17 --output json
```

Récupérer la connection string pooler depuis la sortie et la placer dans `docs/architecture/dev-secrets-setup.md` (gitignored).

Format attendu :
```
Host=<pooler-host>;Port=5432;Database=neondb;Username=neondb_owner;Password=<password>;SSL Mode=Require;Trust Server Certificate=true
```

---

## Étape 2 — Configurer l'environment `beta` dans GitHub

Dans `Settings > Environments > beta` du repo `popforge/my-accounting` :

| Secret / Variable | Type | Valeur |
|---|---|---|
| `MY_ACCOUNTING_DB_CONNECTION` | Secret | Connection string Neon complète (étape 1) |
| `ORACLE_SSH_HOST` | Variable | `148.116.77.58` |
| `ORACLE_SSH_USERNAME` | Variable | `ubuntu` |
| `ORACLE_SSH_KEY` | Secret | Clé privée SSH (`~/.ssh/id_ed25519`) — même clé que tous les autres clusters |
| `GHCR_READ_USERNAME` | Variable | Compte GitHub avec accès `read:packages` — même que les autres clusters |
| `GHCR_READ_TOKEN` | Secret | PAT GitHub `read:packages` — même que les autres clusters |

> Les variables `ORACLE_SSH_HOST`, `ORACLE_SSH_USERNAME`, `GHCR_READ_USERNAME` et les secrets `ORACLE_SSH_KEY`, `GHCR_READ_TOKEN` sont identiques à ceux de l'environment `beta` dans `popforge/auth` — réutiliser les mêmes valeurs.
> Voir `docs/architecture/dev-secrets-setup.md` (gitignored) pour les valeurs concrètes.

---

## Étape 3 — Créer le code source

Remplacer les Dockerfiles placeholder par le vrai code :

- API : `src/my-accounting/server/MyAccounting.Server/` (projet ASP.NET Core .NET 10)
- App : `src/my-accounting/app/` (projet Vue 3 + Vite + TypeScript)

L'App Dockerfile attend un `nginx.conf` dans `src/my-accounting/app/nginx.conf`.

---

## Étape 4 — Créer le DNS Cloudflare

Dans la zone `popsalon.app`, ajouter :

| Type | Nom | Contenu | Proxy |
|---|---|---|---|
| `A` | `my-accounting-beta` | `148.116.77.58` | DNS only ☁️ |

```powershell
# Via l'API Cloudflare (token + zone dans dev-secrets-setup.md)
$headers = @{ "Authorization" = "Bearer <CF_TOKEN>"; "Content-Type" = "application/json" }
$body = @{ type="A"; name="my-accounting-beta"; content="148.116.77.58"; ttl=1; proxied=$false } | ConvertTo-Json
Invoke-RestMethod -Method POST -Uri "https://api.cloudflare.com/client/v4/zones/<CF_ZONE_ID>/dns_records" -Headers $headers -Body $body
```

---

## Étape 5 — Configurer nginx sur la VM

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@148.116.77.58
sudo nano /etc/nginx/sites-available/my-accounting-beta.popsalon.app
```

Contenu initial (avant certbot) :

```nginx
server {
    listen 80;
    server_name my-accounting-beta.popsalon.app;

    # SPA Vue (port 8096)
    location / {
        proxy_pass http://127.0.0.1:8096;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API .NET (port 8095)
    location /api/ {
        proxy_pass http://127.0.0.1:8095;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/my-accounting-beta.popsalon.app /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

---

## Étape 6 — Obtenir le certificat TLS Let's Encrypt

```bash
sudo certbot --nginx -d my-accounting-beta.popsalon.app
sudo systemctl reload nginx
```

---

## Étape 7 — Déploiement automatique (GitHub Actions)

Le premier push sur `main` avec du vrai code déclenchera automatiquement :
1. `publish-images.yml` — build et push `ghcr.io/popforge/my-accounting-api` et `ghcr.io/popforge/my-accounting-app`
2. `deploy-beta.yml` — SSH sur la VM, `docker compose pull` + `up -d` dans `/opt/my-accounting`

Vérification après déploiement :
```powershell
# Santé de l'API
Invoke-RestMethod "https://my-accounting-beta.popsalon.app/api/health"

# Container en cours
ssh -i ~/.ssh/id_ed25519 ubuntu@148.116.77.58 "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
```

---

## Checklist DOR — Déploiement beta

- [ ] Projet Neon `popforge-my-accounting` créé (étape 1)
- [ ] GitHub Secrets `MY_ACCOUNTING_DB_CONNECTION`, `ORACLE_SSH_KEY`, `GHCR_READ_TOKEN` configurés
- [ ] GitHub Variables `ORACLE_SSH_HOST`, `ORACLE_SSH_USERNAME`, `GHCR_READ_USERNAME` configurées
- [ ] Code source réel (pas les Dockerfiles placeholder) pushé sur `main`
- [ ] DNS `my-accounting-beta.popsalon.app` → `148.116.77.58` créé dans Cloudflare
- [ ] Nginx `/etc/nginx/sites-available/my-accounting-beta.popsalon.app` créé et activé
- [ ] Certificat TLS Let's Encrypt obtenu via certbot
- [ ] `https://my-accounting-beta.popsalon.app/` → SPA Vue chargée ✅
- [ ] `https://my-accounting-beta.popsalon.app/api/health` → 200 OK ✅

---

## Référence des ports du cluster

| Cluster | API Port | App Port |
|---|---|---|
| popsalon | 8080–8083 | — |
| hub | — | — |
| auth | 8084 | — |
| **my-accounting** | **8095** | **8096** |
