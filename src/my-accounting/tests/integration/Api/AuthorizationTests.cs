// Story 0.0 - Integration OIDC et deploiement initial
// AC : API protegee cote serveur - retourne 401 sans token

using System.Net;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace MyAccounting.Tests.Integration.Api;

[Trait("Epic", "0")]
[Trait("Story", "0-0")]
public sealed class AuthorizationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public AuthorizationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task GetDocuments_SansJeton_Retourne401()
    {
        // Arrange
        using var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/api/documents");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }
}
