using LingoCross.Domain.Common;

namespace LingoCross.Domain.Entities;

/// <summary>
/// Faz 2 — bir sorunun tek bir şıkkı. <see cref="Position"/> ÖSYM sırasıdır (0–4 → A–E) ve
/// KARIŞTIRILMAZ. Bir sorunun tam 5 şıkkı vardır ve tam biri <see cref="IsCorrect"/> = true'dur
/// (invariant import/app seviyesinde korunur).
/// </summary>
public class QuestionOption : Entity
{
    public Guid QuestionId { get; set; }

    public Question Question { get; set; } = null!;

    /// <summary>ÖSYM şık sırası: 0=A, 1=B, 2=C, 3=D, 4=E.</summary>
    public int Position { get; set; }

    public string Text { get; set; } = string.Empty;

    /// <summary>Doğru şık mı? Soru başına tam 1 true.</summary>
    public bool IsCorrect { get; set; }
}
