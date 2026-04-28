using Popforge.AspNetCore.Extensions.Authentication;
using Popforge.AspNetCore.Extensions.Cors;
using Popforge.AspNetCore.Extensions.HealthChecks;
using Popforge.AspNetCore.Extensions.Logging;
using Popforge.AspNetCore.Extensions.Middleware;
using Popforge.AspNetCore.Extensions.OpenApi;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// ─── Logging structuré JSON ─────────────────────────────────────────────────
builder.AddClusterLogging();

builder.AddClusterAuthentication();
builder.AddClusterOpenApi("MyAccounting API", "v1");
builder.AddClusterHealth();
builder.AddClusterCors();
builder.Services.AddControllers();

var app = builder.Build();

app.UseClusterMiddleware();
app.UseRequestCorrelation();
app.UseCors(ClusterCorsExtensions.PolicyName);
app.UseAuthentication();
app.UseAuthorization();
app.UseClusterOpenApiUi();
app.UseClusterHealthEndpoints();
app.MapControllers();

app.Run();

[ApiController]
[Route("api/documents")]
[Authorize]
public sealed class DocumentsController : ControllerBase
{
    [HttpGet]
    public IActionResult Search()
    {
        var userId = User.FindFirst("sub")?.Value;

        return Ok(new
        {
            documents = Array.Empty<object>(),
            total = 0,
            userId,
        });
    }
}

public partial class Program;
