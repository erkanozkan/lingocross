namespace LingoCross.Domain.Enums;

/// <summary>
/// Bir oyunun türü. Sayısal değerler kalıcı olarak saklandığı için DEĞİŞTİRİLMEMELİDİR.
/// MVP'de yalnızca <see cref="WordMatching"/> kullanılır; diğerleri Faz 2 için rezervedir.
/// </summary>
public enum GameType
{
    /// <summary>Kelime eşleştirme (kaynak terim ↔ hedef çeviri). MVP.</summary>
    WordMatching = 1,

    /// <summary>Bulmaca (crossword). Faz 2 — rezerve.</summary>
    Crossword = 2,

    /// <summary>Çıkmış soru seti. Faz 2 — rezerve.</summary>
    QuestionSet = 3,

    /// <summary>Harf karıştırma (scrambled): kaynak terimin harfleri karışık verilir, öğrenci doğru sıraya dizer.</summary>
    Scrambled = 4,
}
