namespace LingoCross.Domain.Common;

/// <summary>
/// Tüm kalıcı entity'ler için ortak temel: Guid PK ve created_at/updated_at zaman damgaları.
/// Framework bağımsızdır.
/// </summary>
public abstract class Entity
{
    public Guid Id { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }
}
