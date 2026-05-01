---
applyTo: "src/**/*.{cs}"
---

## Backend - Tests xUnit en C# — MyAccounting

Les tests backend utilisent **xUnit** avec **FluentAssertions** pour valider la logique métier côté .NET 10.

### Portée

Ces instructions s'appliquent aux :

- classes de test xUnit (`*.Tests.cs`, `*Tests.cs`) ;
- builders et fixtures de données de test ;
- helpers d'intégration backend.

### Structure cible

```text
src/my-accounting/tests/
  unit/
    Services/
    Validators/
    Builders/
  integration/
    Api/
    Repositories/
    Support/
      IntegrationTestFixture.cs
      DatabaseFixture.cs
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
result.Items.Should().HaveCount(3);
act.Should().ThrowAsync<InvalidOperationException>()
   .WithMessage("*attendu*");

// Éviter
Assert.Equal(expected, result);
Assert.Throws<InvalidOperationException>(() => act());
```

### Builders de données de test

Créer un `Builder` pour chaque agrégat testé fréquemment, localisé dans `tests/unit/Builders/` :

```csharp
public class ExempleBuilder
{
    private string _nom = "valeur-par-defaut";

    public ExempleBuilder AvecNom(string nom) { _nom = nom; return this; }

    public Exemple Construire() => new Exemple(_nom);
}
```

- Toujours partir de valeurs par défaut valides.
- Ne pas inliner des objets complexes directement dans `Arrange` — utiliser le builder.

### Traçabilité

- Ajouter un commentaire de traçabilité en tête de chaque classe de test :

```csharp
// Story m1-2 - <titre de la story>
// AC : <critère d'acceptation couvert>
```

- Utiliser les traits xUnit pour filtrer par epic et story :

```csharp
[Trait("Epic", "m1")]
[Trait("Story", "m1-2")]
public class ExempleServiceTests { ... }
```

### Isolation des tests d'intégration

- Implémenter `IAsyncLifetime` sur les fixtures pour créer et nettoyer les données de test.
- Chaque test d'intégration doit laisser la base dans l'état initial (rollback ou suppression explicite).
- Regrouper les tests qui partagent une même fixture dans une `IClassFixture<DatabaseFixture>`.

### Règle de dérivation AC → artefact de test

Pour chaque AC du story spec, le type de test indiqué crée une **obligation de livraison** :

| Type dans l'AC | Artefact obligatoire |
|---|---|
| `Acceptance Gherkin` | Scénario dans le fichier `.feature` correspondant |
| `Unit (xUnit)` | Méthode de test dans `{Classe}Tests.cs` sous `tests/unit/` |
| `Intégration (xUnit)` | Méthode de test dans `{Classe}Tests.cs` sous `tests/integration/` |
| `Manuel` | Scénario dans la section « Validation manuelle — Recette » de la story |

Un AC marqué `Unit (xUnit)` ou `Intégration (xUnit)` sans test correspondant écrit et passant en CI est un **blocage DOD**.

### Séquencement des tests par story

1. **E2E Gherkin en premier** — écrire et valider les scénarios `.feature` qui couvrent les comportements observables (flux utilisateur, états visibles)
2. **xUnit ensuite** — pour chaque AC marqué `Unit` ou `Intégration`, écrire le test xUnit correspondant après les E2E
3. Les tests xUnit **complètent** les E2E sur la logique interne (validations, règles métier, cas d'erreur backend) — ils ne les remplacent pas

### Règles générales

- Un test ne valide qu'un seul comportement observable.
- Le pattern AAA (Arrange / Act / Assert) est obligatoire et les trois sections doivent être identifiables.
- Aucune logique conditionnelle dans un test.
- Les données créées doivent être uniques ou nettoyées pour éviter les collisions entre tests parallèles.
- Les tests doivent passer en isolation et en exécution parallèle.

### Ce qu'il faut tester

Tester :
- les règles métier et validations du domaine ;
- les transformations et calculs (entrée → sortie) ;
- les cas d'erreur attendus (ressource introuvable, doublon, format invalide) ;
- les controllers REST : autorisations, codes HTTP, corps de réponse.

### Ne pas tester

- Le comportement intrinsèque d'EF Core ou d'ASP.NET.
- Le routage HTTP pur (préférer les tests d'intégration controllers).
- La sérialisation JSON sauf si une règle métier en dépend.

### Références

- Pour le standard global et la sélection du niveau de test, voir `testing.instructions.md`.
- Pour les tests E2E frontend, voir `testing-frontend.instructions.md`.
