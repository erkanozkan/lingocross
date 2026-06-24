using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Bir oyunun bir sınıfa atanması (F4.3). (game_id, class_id) çifti benzersizdir. Yayınlı bir oyun,
/// atandığı sınıfların aktif üyelerine görünür/oynanabilir olur.
/// </summary>
public class GameAssignment : Entity
{
    public Guid GameId { get; set; }

    public Game Game { get; set; } = null!;

    public Guid ClassId { get; set; }

    public Class Class { get; set; } = null!;
}
