#Requires -Version 5.1
<#
.SYNOPSIS
    Initialise un nouveau depot GitHub personnel depuis un dossier non-git.

.DESCRIPTION
    Workflow cible et unique:
    - part d'un dossier avec des fichiers mais sans .git
    - propose des noms de depots
    - cree le depot distant avec gh
    - pousse le commit initial
    - installe les hooks locaux

.PARAMETER Public
    Cree le depot en public. Par defaut, le depot est prive.

.PARAMETER UserEmail
    Email noreply utilise par defaut pour les commits et le hook pre-push.
    Tu peux le laisser tel quel pour ton workflow personnel.

.EXAMPLE
    .\scripts\setup-repo.ps1
#>
[CmdletBinding()]
param(
    [switch]$Public,
    [string]$UserEmail = "37725632+popforge@users.noreply.github.com"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step { param([string]$Msg) Write-Host "  $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  v $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  ! $Msg" -ForegroundColor Yellow }

Write-Host ""
Write-Host "=== Setup GitHub Personnel ===" -ForegroundColor Magenta

# --- 0. Pre-checks --------------------------------------------------------
Write-Step "0. Verification des prerequis..."
if (Test-Path ".git") {
    throw "Ce dossier est deja un depot git. Le script attend un dossier non initialise."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git introuvable."
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "gh introuvable."
}

# --- 1. Compte GitHub -----------------------------------------------------
Write-Step "1. Lecture du compte GitHub..."
$ghLogin = (gh api user --jq ".login").Trim()
$ghName = (gh api user --jq ".name").Trim()

if (-not $ghLogin) {
    throw "Impossible de lire le login GitHub via gh api user."
}
if ([string]::IsNullOrWhiteSpace($ghName) -or $ghName -eq "null") {
    $ghName = $ghLogin
}

$expectedEmail = $UserEmail
Write-Ok "Compte detecte : $ghLogin"
Write-Ok "Email noreply attendu : $expectedEmail"

# --- 2. Suggestions de noms ----------------------------------------------
Write-Step "2. Proposition de noms de depot..."
$folderName = Split-Path -Leaf (Get-Location)
$base = $folderName.ToLowerInvariant()
$base = $base -replace "^popforge\.", ""
$base = $base -replace "[\._\s]+", "-"
$base = $base -replace "[^a-z0-9\-]", ""
$base = $base.Trim("-")

if ([string]::IsNullOrWhiteSpace($base)) {
    $base = "my-project"
}

$suggestions = @(
    $base,
    "my-$base",
    "$base-app",
    "$base-service"
) | Select-Object -Unique

Write-Host "  Choisis un nom :"
for ($i = 0; $i -lt $suggestions.Count; $i++) {
    Write-Host ("    [{0}] {1}" -f ($i + 1), $suggestions[$i])
}
Write-Host "    [0] Entrer un autre nom"

$choice = Read-Host "  Ton choix"
$repoName = $null

if ($choice -match "^\d+$") {
    $idx = [int]$choice
    if ($idx -eq 0) {
        $repoName = (Read-Host "  Nom personnalise").Trim().ToLowerInvariant()
    } elseif ($idx -ge 1 -and $idx -le $suggestions.Count) {
        $repoName = $suggestions[$idx - 1]
    }
}
if ([string]::IsNullOrWhiteSpace($repoName)) {
    throw "Choix invalide."
}

$repoName = ($repoName -replace "[\s_\.]+", "-") -replace "[^a-z0-9\-]", ""
$repoName = $repoName.Trim("-")
if ([string]::IsNullOrWhiteSpace($repoName)) {
    throw "Nom de depot invalide."
}

$fullRepo = "$ghLogin/$repoName"
Write-Ok "Depot cible : $fullRepo"

# --- 3. Initialisation git locale ----------------------------------------
Write-Step "3. Initialisation git locale..."
git init | Out-Null
git checkout -b main | Out-Null
git config user.name $ghName
git config user.email $expectedEmail
git config hooks.expectedEmail $expectedEmail

Write-Ok "Branche : main"
Write-Ok "user.name  = $ghName"
Write-Ok "user.email = $expectedEmail"

# --- 4. Installation des hooks -------------------------------------------
Write-Step "4. Installation des hooks..."
$repoRoot = (git rev-parse --show-toplevel).Trim()
$hooksSource = Join-Path $repoRoot ".githooks"
$hooksDest = Join-Path $repoRoot ".git" "hooks"

if (Test-Path $hooksSource) {
    Get-ChildItem $hooksSource -File | ForEach-Object {
        $dest = Join-Path $hooksDest $_.Name
        # LF + UTF-8 no BOM pour execution shell cross-platform.
        $content = (Get-Content $_.FullName -Raw) -replace "`r`n", "`n"
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($dest, $content, $utf8NoBom)
        Write-Ok "Hook installe : $($_.Name)"
    }
} else {
    Write-Warn "Dossier .githooks absent. Aucun hook installe."
}

# --- 5. Commit initial ----------------------------------------------------
Write-Step "5. Commit initial..."
git add .
$hasStaged = git diff --cached --name-only
if (-not $hasStaged) {
    Write-Warn "Aucun fichier a committer."
} else {
    git commit -m "Initial commit" | Out-Null
    Write-Ok "Commit initial cree."
}

# --- 6. Creation du repo distant + push ----------------------------------
Write-Step "6. Creation du depot distant..."
$visibilityArg = if ($Public) { "--public" } else { "--private" }
gh repo create $fullRepo $visibilityArg --source . --remote origin --push
Write-Ok "Depot cree et push effectue."

# --- Recapitulatif --------------------------------------------------------
Write-Host ""
Write-Host "  Configuration finale :" -ForegroundColor Magenta
Write-Host "    compte     = $ghLogin"
Write-Host "    repo       = https://github.com/$fullRepo"
Write-Host "    user.name  = $(git config user.name)"
Write-Host "    user.email = $(git config user.email)"
Write-Host "    origin     = $(git remote get-url origin)"
Write-Host "    branche    = $(git branch --show-current)"
Write-Host ""
