#Requires -Version 5.1
<#
.SYNOPSIS
    Initialise la configuration git locale d'un dépôt Popforge.

.DESCRIPTION
    À exécuter une fois après 'git init' ou 'git clone' pour un dépôt Popforge.
    Configure l'identité, la branche principale, l'URL remote et installe les hooks.

    Pour un nouveau dépôt : copier '.githooks/' et 'scripts/setup-repo.ps1'
    depuis un dépôt Popforge existant (ex : Popforge.Auth), puis exécuter ce script.

.PARAMETER UserName
    Nom d'auteur git local. Défaut : Poppy

.PARAMETER UserEmail
    Email git local. Doit être l'adresse noreply GitHub de Popforge.
    Défaut : 37725632+popforge@users.noreply.github.com

.PARAMETER GcmPrefix
    Préfixe intégré dans l'URL remote HTTPS pour forcer GCM à utiliser le bon compte.
    Défaut : popforge

.EXAMPLE
    cd C:\sources\rachellavoie\MonNouveauRepo
    .\scripts\setup-repo.ps1
#>
[CmdletBinding()]
param(
    [string]$UserName  = "Poppy",
    [string]$UserEmail = "37725632+popforge@users.noreply.github.com",
    [string]$GcmPrefix = "popforge"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step { param([string]$Msg) Write-Host "  $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  v $Msg" -ForegroundColor Green }
function Write-Skip { param([string]$Msg) Write-Host "  - $Msg" -ForegroundColor DarkGray }

Write-Host ""
Write-Host "=== Setup Git Popforge ===" -ForegroundColor Magenta

# --- 1. Identite locale ---------------------------------------------------
Write-Step "1. Identite git locale..."
git config user.name  $UserName
git config user.email $UserEmail
Write-Ok "user.name  = $UserName"
Write-Ok "user.email = $UserEmail"

# --- 2. Branche principale ------------------------------------------------
Write-Step "2. Branche principale..."
$branch = git branch --show-current 2>$null
if ($branch -eq "master") {
    git branch -m master main
    Write-Ok "Branche renommee : master -> main"
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        git push --set-upstream origin main
        git push origin --delete master 2>$null
        Write-Ok "Remote mis a jour : master supprime, main pousse"
    }
} else {
    Write-Skip "Branche courante : $branch (rien a faire)"
}

# --- 3. URL remote pour GCM multi-comptes --------------------------------
Write-Step "3. URL remote origin..."
$url = git remote get-url origin 2>$null
if ($url) {
    if ($url -notmatch "^https://$GcmPrefix@") {
        $newUrl = $url -replace "^https://github\.com/", "https://$GcmPrefix@github.com/"
        git remote set-url origin $newUrl
        Write-Ok "Remote URL : $newUrl"
    } else {
        Write-Skip "Remote URL deja correct : $url"
    }
} else {
    Write-Skip "Aucun remote 'origin' configure (a ajouter apres 'git remote add origin <url>')"
}

# --- 4. Installation des hooks git ----------------------------------------
Write-Step "4. Hooks git..."
$repoRoot    = git rev-parse --show-toplevel
$hooksSource = Join-Path $repoRoot ".githooks"
$hooksDest   = Join-Path $repoRoot ".git" "hooks"

if (Test-Path $hooksSource) {
    Get-ChildItem $hooksSource -File | ForEach-Object {
        $dest    = Join-Path $hooksDest $_.Name
        # Convertir en LF et sans BOM (requis pour les scripts bash sur tous les OS)
        $content = (Get-Content $_.FullName -Raw) -replace "`r`n", "`n"
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($dest, $content, $utf8NoBom)
        Write-Ok "Hook installe : $($_.Name)"
    }
} else {
    Write-Skip "Dossier .githooks introuvable — hooks non installes"
}

# --- Recapitulatif --------------------------------------------------------
Write-Host ""
Write-Host "  Configuration finale :" -ForegroundColor Magenta
Write-Host "    user.name  = $(git config user.name)"
Write-Host "    user.email = $(git config user.email)"
$finalUrl = git remote get-url origin 2>$null
Write-Host "    origin     = $($finalUrl ?? '(aucun)')"
Write-Host "    branche    = $(git branch --show-current)"
Write-Host ""
