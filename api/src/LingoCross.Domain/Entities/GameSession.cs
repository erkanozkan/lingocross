using LingoCross.Domain.Common;
using LingoCross.Domain.Enums;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir öğrencinin bir oyunu oynama oturumu. Oturum başlatıldığında <see cref="Status"/>
/// InProgress olur. Sonuç/başarı/süre M5'te ayrı bir tabloda (game_results) tutulacaktır;
/// bu entity yalnızca oturumun yaşam döngüsünü izler.
/// </summary>
public class GameSession : Entity
{
    public Guid GameId { get; set; }

    public Game Game { get; set; } = null!;

    public Guid StudentId { get; set; }

    public User Student { get; set; } = null!;

    public GameSessionStatus Status { get; set; } = GameSessionStatus.InProgress;

    public DateTime StartedAt { get; set; }

    public DateTime? CompletedAt { get; set; }
}
