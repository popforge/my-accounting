---
applyTo: "src/**/*.{cs}"
---

## Backend - Tests xUnit en C#

Les tests backend utilisent **xUnit** avec **FluentAssertions** pour valider la logique métier côté .NET 10.

### Portée

Ces instructions s'appliquent aux :

- classes de test xUnit (`*.Tests.cs`, `*Tests.cs`) ;
- builders et fixtures de données de test ;
- helpers d'intégration backend.

### Structure cible

Structure attendue par cluster :

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

### Nommage

- **Classe de test** : `{ClasseTestée}Tests` — ex. : `DocumentIndexServiceTests`.
- **Méthode de test** : `{Méthode}_{Contexte}_{Résultat attendu}` — ex. : `IndexDocument_QuandFichierInexistant_LeveDocumentNotFoundException`.
- Les noms peuvent être en français pour refléter le vocabulaire métier.
- Ne pas utiliser de préfixes `Test_` ni `Should_`.

### Niveau de test et isolation

| Niveau | Quand l'utiliser | Isolation |
|---|---|---|
| **Unitaire** | Logique métier pure, services, validateurs, transformations | Mocks (NSubstitute) ou InMemory EF |
| **Intégration** | Repositories, controllers, flux API complets | Base Neon dédiée aux tests |

- Les tests unitaires ne doivent pas toucher la base de données ni le réseau.
- Les tests d'intégration utilisent une base de données Neon de test distincte de la production et du développement.
- Ne jamais mocker EF Core pour simuler une vraie base en intégration — utiliser la vraie base de test.

### Assertions

Utiliser **FluentAssertions** pour toutes les assertions :

```csharp
// Préférer
result.Should().BeEquivalentTo(expected);
result.Documents.Should().HaveCount(3);
act.Should().Throw<DocumentNotFoundException>()
   .WithMessage("*2026*");

// Éviter
Assert.Equal(expected, result);
Assert.Throws<DocumentNotFoundException>(() => act());
```

### Builders de données de test

Créer un `Builder` pour chaque agrégat testé fréquemment, localisé dans `tests/unit/Builders/` :

```csharp
// Exemple
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

- Toujours partir de valeurs par défaut valides.
- Ne pas inliner des objets complexes directement dans `Arrange` — utiliser le builder.

### Ce qu'il faut tester

Tester :

- les règles de classement et de nommage des documents iCloud ;
- les validations métier (format de nom, année valide, catégorie reconnue) ;
- les transformations de données (ancienne arborescence → structure cible) ;
- les cas d'erreur attendus (fichier introuvable, doublon, format invalide).

Ne pas tester :

- le comportement intrinsèque d'EF Core ou d'ASP.NET ;
- le routage HTTP (préférer les tests d'intégration controllers) ;
- la sérialisation JSON sauf si une règle métier en dépend.

### Traçabilité

- Ajouter un commentaire de traçabilité en tête de chaque classe de test :

```csharp
// Story 1.2 - Import des documents iCloud existants
// AC : Le service renomme les fichiers selon le format cible
```

- Utiliser les traits xUnit pour filtrer par epic et story :

```csharp
[Trait("Epic", "1")]
[Trait("Story", "1-2")]
public class DocumentImportServiceTests { ... }
```

### Isolation des tests d'intégration

- Implémenter `IAsyncLifetime` sur les fixtures pour créer et nettoyer les données de test.
- Chaque test d'intégration doit laisser la base dans l'état initial (rollback ou suppression explicite).
- Regrouper les tests qui partagent une même fixture dans une `IClassFixture<DatabaseFixture>`.

### Règles générales

- Un test ne valide qu'un seul comportement observable.
- Le pattern AAA (Arrange / Act / Assert) est obligatoire et les trois sections doivent être identifiables.
- Aucune logique conditionnelle dans un test.
- Les données figées doivent être uniques ou isolées pour éviter les collisions entre tests parallèles.
- Les tests doivent passer en isolation et en exécution parallèle.

### Références

- Pour le standard global et la sélection du niveau de test, voir `testing.instructions.md`.
- Pour les tests E2E frontend, voir `testing-frontend.instructions.md`.
