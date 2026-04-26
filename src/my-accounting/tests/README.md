# Tests — MyAccounting

Ce dossier contient tous les tests automatisés du cluster `my-accounting`.

---

## Structure

```
tests/
  e2e/                         # Tests E2E Playwright + playwright-bdd
    features/                  # Fichiers Gherkin .feature (fr-CA)
    steps/                     # Step definitions TypeScript
    support/
      fixtures/                # Fixtures Playwright (base.fixtures.ts)
      pages/                   # Page Objects (BasePage.ts, ...)
      helpers/                 # Helpers utilitaires
    playwright.config.ts
    package.json
    tsconfig.json
  unit/                        # Tests unitaires xUnit
    Services/                  # Tests des services métier
    Validators/                # Tests des validateurs
    Builders/                  # Builders de données de test
  integration/                 # Tests d'intégration xUnit
    Api/                       # Tests des controllers REST
    Repositories/              # Tests des repositories
    Support/                   # Fixtures (DatabaseFixture.cs)
  MyAccounting.Tests.csproj    # Projet xUnit (.NET 10)
```

---

## Prérequis

### Frontend E2E

```bash
cd tests/e2e
npm install
npx playwright install chromium
```

### Backend xUnit

```bash
# Depuis la racine du repo ou le dossier solution
dotnet restore
dotnet build
```

---

## Exécuter les tests

### E2E Playwright

```bash
cd tests/e2e

# Exécution complète (génère les step files + lance les tests)
npm run test:e2e

# Interface graphique Playwright UI
npm run test:e2e:ui

# Mode debug
npm run test:e2e:debug

# Avec navigateur visible
npm run test:e2e:headed
```

> ⚠️ `bddgen` doit toujours précéder `playwright test` — les scripts npm s'en chargent.

### xUnit Backend

```bash
# Tous les tests
dotnet test src/my-accounting/tests/MyAccounting.Tests.csproj

# Avec rapport de couverture
dotnet test src/my-accounting/tests/MyAccounting.Tests.csproj --collect:"XPlat Code Coverage"

# Filtrer par epic/story
dotnet test --filter "Epic=1&Story=1-0"
```

---

## Conventions

### Gherkin (frontend)

- Langue : `# language: fr` en première ligne de chaque `.feature`
- Tags obligatoires : `@acceptance @epic-<n> @story-<n>-<n> @area-* @component-*`
- Vocabulaire métier MyAccounting uniquement (Rachel, iCloud, classement, etc.)
- Voir : [testing-frontend.instructions.md](../../../.github/instructions/testing-frontend.instructions.md)

### xUnit (backend)

- Nommage méthodes : `{Méthode}_{Contexte}_{Résultat attendu}`
- Pattern AAA obligatoire (Arrange / Act / Assert)
- Assertions : FluentAssertions uniquement (`result.Should().Be(...)`)
- Traçabilité : `[Trait("Epic", "1")] [Trait("Story", "1-0")]`
- Voir : [testing-backend.instructions.md](../../../.github/instructions/testing-backend.instructions.md)

---

## Variables d'environnement E2E

| Variable | Valeur par défaut | Description |
|---|---|---|
| `BASE_URL` | `http://localhost:5173` | URL de l'application frontend |
| `API_URL` | `http://localhost:5000` | URL de l'API backend |

---

## Références

- [Plan de test Epic 1](_bmad-output/test-artifacts/test-design-epic-1.md)
- [Standard global de test](.github/instructions/testing.instructions.md)
- [Standard E2E frontend](.github/instructions/testing-frontend.instructions.md)
- [Standard backend xUnit](.github/instructions/testing-backend.instructions.md)
