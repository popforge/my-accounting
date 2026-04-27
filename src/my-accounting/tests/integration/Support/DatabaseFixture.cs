// Fixture de base pour les tests d'intégration MyAccounting.
// Référence : testing-backend.instructions.md — section Isolation des tests d'intégration
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
using Xunit;

namespace MyAccounting.Tests.Integration.Support;

/// <summary>
/// Fixture partagée pour les tests d'intégration nécessitant une base de données Neon de test.
/// Implémenter IAsyncLifetime pour la création et le nettoyage des données.
/// </summary>
public class DatabaseFixture : IAsyncLifetime
{
    // TODO : injecter le DbContext réel une fois le projet serveur référencé

    public Task InitializeAsync()
    {
        // Initialisation de la base de test (migrations, seed minimal)
        return Task.CompletedTask;
    }

    public Task DisposeAsync()
    {
        // Nettoyage : rollback ou suppression des données de test
        // Utiliser Respawn pour réinitialiser les tables rapidement
        return Task.CompletedTask;
    }
}
