using LingoCross.Infrastructure;
using Microsoft.Extensions.Configuration;

namespace LingoCross.Tests.Infrastructure;

public class ConnectionStringTests
{
    [Fact]
    public void ConvertDatabaseUrl_ParsesPostgresUrl_ToNpgsql()
    {
        var cs = DependencyInjection.ConvertDatabaseUrl(
            "postgresql://myuser:p%40ss@host.proxy.rlwy.net:5432/railway");

        Assert.Contains("Host=host.proxy.rlwy.net", cs);
        Assert.Contains("Port=5432", cs);
        Assert.Contains("Database=railway", cs);
        Assert.Contains("Username=myuser", cs);
        Assert.Contains("Password=p@ss", cs); // URL-decoded
        Assert.Contains("SSL Mode=Require", cs);
    }

    [Fact]
    public void ResolveConnectionString_PrefersConnectionStringsDefault()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["ConnectionStrings:Default"] = "Host=local;Database=db;Username=u;Password=p",
            ["DATABASE_URL"] = "postgresql://x:y@h:5432/d",
        }).Build();

        Assert.Equal("Host=local;Database=db;Username=u;Password=p",
            DependencyInjection.ResolveConnectionString(config));
    }

    [Fact]
    public void ResolveConnectionString_FallsBackToDatabaseUrl()
    {
        var config = new ConfigurationBuilder().AddInMemoryCollection(new Dictionary<string, string?>
        {
            ["DATABASE_URL"] = "postgresql://u:pw@db.rlwy.net:6543/railway",
        }).Build();

        var cs = DependencyInjection.ResolveConnectionString(config);
        Assert.Contains("Host=db.rlwy.net", cs);
        Assert.Contains("Port=6543", cs);
    }

    [Fact]
    public void ResolveConnectionString_ReturnsNull_WhenNothingSet()
    {
        var config = new ConfigurationBuilder().Build();
        Assert.Null(DependencyInjection.ResolveConnectionString(config));
    }
}
