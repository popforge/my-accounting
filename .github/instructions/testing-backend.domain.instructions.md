---
applyTo: "src/**/*.{cs}"
---

## Tests backend — Domaine MyAccounting

> Ce fichier contient les conventions de test spécifiques au domaine MyAccounting.
> Il complète `testing-backend.instructions.md` (géré par `@popforge/sync`).
> Ne pas modifier sans raison — ce fichier ne sera PAS écrasé lors des syncs.

### Structure des tests MyAccounting

```text
src/my-accounting/tests/
  unit/
    Services/
      DocumentIndexServiceTests.cs
      ICloudSyncServiceTests.cs
    Validators/
      DocumentClassificationValidatorTests.cs
    Builders/
      DocumentBuilder.cs
  integration/
    Api/
      DocumentsControllerTests.cs
    Repositories/
      DocumentRepositoryTests.cs
    Support/
      IntegrationTestFixture.cs
      DatabaseFixture.cs
  MyAccounting.Tests.csproj
```

### Ce qu'il faut tester dans MyAccounting

Tester :
- les règles de classement et de nommage des documents iCloud ;
- les validations métier (format de nom, année valide, catégorie reconnue) ;
- les transformations de données (ancienne arborescence → structure cible) ;
- les cas d'erreur attendus (fichier introuvable, doublon, format invalide).

### Builders de données de test

```csharp
public class DocumentBuilder
{
    private string _nom = "2026-01-15_EDF_facture energie_45.00.pdf";
    private string _dossier = "!Facturette";
    private int _annee = 2026;

    public DocumentBuilder AvecNom(string nom) { _nom = nom; return this; }
    public DocumentBuilder AvecDossier(string dossier) { _dossier = dossier; return this; }
    public DocumentBuilder AvecAnnee(int annee) { _annee = annee; return this; }

    public Document Construire() => new Document(_nom, _dossier, _annee);
}
```

### Traçabilité (exemples MyAccounting)

```csharp
// Story 1.2 - Import des documents iCloud existants
// AC : Le service renomme les fichiers selon le format cible
[Trait("Epic", "1")]
[Trait("Story", "1-2")]
public class DocumentImportServiceTests { ... }
```