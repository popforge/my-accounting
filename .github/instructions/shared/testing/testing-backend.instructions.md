---
applyTo: "src/**/*.{cs}"
---

# Tests backend — Popforge Platform

## Nommage

- **Classe de test** : `{ClasseTestée}Tests` — ex. : `UserServiceTests`.
- **Méthode de test** : `{Méthode}_{Contexte}_{Résultat attendu}` — ex. : `CreateUser_QuandEmailDupliqué_LeveConflictException`.
- Les noms peuvent être en français pour refléter le vocabulaire du domaine.
- Ne pas utiliser de préfixes `Test_` ni `Should_`.

## Traçabilité

Ajouter un commentaire de traçabilité en tête de chaque classe de test :

```csharp
// Story {PREFIX}<N>-<Y> - [Titre de la story]
// AC : [Critère d'acceptation couvert]
```

Utiliser les traits xUnit pour filtrer par epic et story :

```csharp
[Trait("Epic", "{PREFIX}<N>")]
[Trait("Story", "{PREFIX}<N>-<Y>")]
public class MonServiceTests { ... }
```

> **{PREFIX}** = la lettre du cluster concerné. Voir le tableau dans `epic-and-stories.instructions.md`.

## Assertions — FluentAssertions

Utiliser **FluentAssertions** pour toutes les assertions :

```csharp
// Préférer
response.StatusCode.Should().Be(HttpStatusCode.OK);
user.Should().NotBeNull();
act.Should().ThrowAsync<InvalidOperationException>();

// Éviter
Assert.Equal(HttpStatusCode.OK, response.StatusCode);
Assert.NotNull(user);
```

## Isolation

| Niveau | Isolation recommandée |
|---|---|
| **Unitaire** | Mocks (NSubstitute) ou InMemory EF — aucun accès réseau ni base de données |
| **Intégration** | WebApplicationFactory + base de test dédiée (Neon ou SQLite selon le cluster) |

- Les tests unitaires ne doivent **jamais** toucher la base de données ni le réseau.
- Ne jamais mocker EF Core pour simuler une vraie base en intégration — utiliser la vraie base de test.

## Isolation des tests d'intégration

- Implémenter `IAsyncLifetime` pour créer et nettoyer les données de test.
- Chaque test d'intégration doit laisser la base dans l'état initial (suppression explicite).
- Regrouper les tests qui partagent une factory dans une `IClassFixture<TFactory>`.

## Séquencement par story

1. **E2E Gherkin en premier** — scénarios `.feature` qui couvrent les comportements observables.
2. **Tests backend ensuite** — pour chaque AC marqué `Unit` ou `Intégration`, écrire le test après les E2E.
3. Les tests backend **complètent** les E2E sur la logique interne — ils ne les remplacent pas.

## Règles générales

- Un test ne valide qu'un seul comportement observable.
- Le pattern AAA (Arrange / Act / Assert) est obligatoire et les trois sections doivent être identifiables.
- Aucune logique conditionnelle dans un test.
- Les données créées doivent être uniques ou nettoyées pour éviter les collisions entre tests.
- Les tests doivent passer en isolation et en exécution parallèle.

## Références

- Pour le standard global de sélection du niveau, voir `testing.instructions.md`.
- Pour les scénarios Gherkin E2E, voir `testing-frontend.instructions.md`.
