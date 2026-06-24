using System.Text;
using LingoCross.Application.Games.Dtos;

namespace LingoCross.Application.Games;

/// <summary>
/// Saf (DB'siz, deterministik tohumlanabilir) crossword üreteci. Verilen (cevap, ipucu) çiftlerinden
/// greedy kesişim yerleştirmeyle bağlı bir bulmaca ızgarası kurar.
///
/// Tasarım kararı: cevaplar yalnız A–Z BÜYÜK harf olmalıdır (çağıran normalize/eleme yapar).
/// Algoritma:
///   1. Cevapları uzunluğa göre azalan sırala (eşitlikte alfabetik) — en uzun kelime omurga olur.
///   2. İlk (en uzun) kelimeyi (0,0)'dan başlayıp yatay (across) yerleştir.
///   3. Sonraki her kelime için, yerleştirilmiş kelimelerle ortak harf üzerinden DİK kesişecek
///      (across↔down) tüm aday konumları değerlendir; çakışmasız (kesişen hücrede harfler eşit,
///      komşu hücrelerde istenmeyen birleşme yok) ilk uygun konuma yerleştir. Uyan yer yoksa kelimeyi
///      atla (atlananlar sayılır/raporlanır).
///   4. Sonuç koordinatları normalize edilir (negatifler 0'a kaydırılır), ızgara yerleşime göre küçülür.
///   5. Başlangıç hücreleri satır-major numaralanır; aynı hücreden across+down başlıyorsa tek numara.
/// </summary>
public static class CrosswordGenerator
{
    /// <summary>Yerleşmiş tek bir kelime (mutlak koordinatlar; normalize edilmeden önce negatif olabilir).</summary>
    private sealed class Placed
    {
        public required string Answer { get; init; }
        public required string Clue { get; init; }
        public required int Row { get; init; }
        public required int Col { get; init; }
        public required CrosswordDirection Direction { get; init; }
        public int Length => Answer.Length;

        public (int Row, int Col) CellAt(int index) => Direction == CrosswordDirection.Across
            ? (Row, Col + index)
            : (Row + index, Col);
    }

    /// <summary>Üretim sonucu: bağlı içerik + kaç kelimenin atlandığı (yerleştirilemedi).</summary>
    public sealed record Result(CrosswordContent Content, int PlacedCount, int SkippedCount);

    /// <summary>
    /// Verilen aday cevap/ipucu çiftlerinden bir crossword üretir. <paramref name="answers"/> öğeleri
    /// yalnız A–Z BÜYÜK harf içermeli ve en az 2 harf olmalıdır (çağıran garanti eder).
    /// </summary>
    /// <param name="candidates">(answer=A–Z BÜYÜK, clue=Türkçe ipucu) çiftleri.</param>
    /// <param name="random">Determinizm için enjekte edilen Random.</param>
    /// <param name="maxWords">Izgaraya alınacak en fazla kelime (varsayılan 10).</param>
    public static Result Generate(
        IReadOnlyList<(string Answer, string Clue)> candidates,
        Random random,
        int maxWords = 10)
    {
        ArgumentNullException.ThrowIfNull(candidates);
        ArgumentNullException.ThrowIfNull(random);

        // Aynı cevabı tekrar etme (büyük harf duyarsız değil; zaten BÜYÜK). En uzun → en kısa.
        var ordered = candidates
            .Where(c => !string.IsNullOrEmpty(c.Answer))
            .GroupBy(c => c.Answer, StringComparer.Ordinal)
            .Select(g => g.First())
            .OrderByDescending(c => c.Answer.Length)
            .ThenBy(c => c.Answer, StringComparer.Ordinal)
            .Take(maxWords)
            .ToList();

        var placed = new List<Placed>();
        var skipped = 0;

        foreach (var candidate in ordered)
        {
            if (placed.Count == 0)
            {
                // İlk (en uzun) kelime: yatay, başlangıç (0,0).
                placed.Add(new Placed
                {
                    Answer = candidate.Answer,
                    Clue = candidate.Clue,
                    Row = 0,
                    Col = 0,
                    Direction = CrosswordDirection.Across,
                });
                continue;
            }

            var spot = FindPlacement(candidate.Answer, placed, random);
            if (spot is null)
            {
                skipped++;
                continue;
            }

            placed.Add(new Placed
            {
                Answer = candidate.Answer,
                Clue = candidate.Clue,
                Row = spot.Value.Row,
                Col = spot.Value.Col,
                Direction = spot.Value.Direction,
            });
        }

        return Normalize(placed, skipped);
    }

    /// <summary>
    /// Yeni bir kelime için, yerleştirilmiş kelimelerle ortak harf üzerinden dik kesişen ilk geçerli
    /// konumu döndürür; yoksa null. Aday konumlar deterministik (tohumlu Random) sırada denenir.
    /// </summary>
    private static (int Row, int Col, CrosswordDirection Direction)? FindPlacement(
        string answer, List<Placed> placed, Random random)
    {
        var candidates = new List<(int Row, int Col, CrosswordDirection Direction)>();

        foreach (var existing in placed)
        {
            for (var ei = 0; ei < existing.Length; ei++)
            {
                for (var ni = 0; ni < answer.Length; ni++)
                {
                    if (existing.Answer[ei] != answer[ni])
                    {
                        continue;
                    }

                    // Yeni kelime mevcut kelimeye DİK yerleşir.
                    var newDir = existing.Direction == CrosswordDirection.Across
                        ? CrosswordDirection.Down
                        : CrosswordDirection.Across;

                    var (cellRow, cellCol) = existing.CellAt(ei);

                    // Kesişen hücre yeni kelimenin ni. harfi olacak; başlangıcı geriye doğru hesapla.
                    int startRow, startCol;
                    if (newDir == CrosswordDirection.Across)
                    {
                        startRow = cellRow;
                        startCol = cellCol - ni;
                    }
                    else
                    {
                        startRow = cellRow - ni;
                        startCol = cellCol;
                    }

                    if (CanPlace(answer, startRow, startCol, newDir, placed))
                    {
                        candidates.Add((startRow, startCol, newDir));
                    }
                }
            }
        }

        if (candidates.Count == 0)
        {
            return null;
        }

        // Deterministik seçim: tohumlu Random ile bir aday seç.
        return candidates[random.Next(candidates.Count)];
    }

    /// <summary>
    /// Bir kelimenin verilen konuma çakışmadan yerleşip yerleşemeyeceği. Kurallar:
    ///  - Bir hücre zaten doluysa harf eşleşmeli (geçerli kesişim).
    ///  - Boş bir hücreye yazılıyorsa, o hücrenin yeni kelimeye dik komşuları (yanları) boş olmalı
    ///    (yan yana iki paralel kelimenin yanlışlıkla "yapışmasını" engeller).
    ///  - Kelimenin hemen önündeki ve sonrasındaki (yön ekseninde) hücreler boş olmalı (kelime uzaması yok).
    ///  - En az bir hücre mevcut bir kelimeyle kesişmeli (bağlılık).
    /// </summary>
    private static bool CanPlace(string answer, int row, int col, CrosswordDirection dir, List<Placed> placed)
    {
        var grid = BuildCharMap(placed);
        var intersections = 0;

        // Kelimenin yön ekseninde hemen öncesi/sonrası boş olmalı.
        var (beforeR, beforeC) = dir == CrosswordDirection.Across ? (row, col - 1) : (row - 1, col);
        var (afterR, afterC) = dir == CrosswordDirection.Across
            ? (row, col + answer.Length)
            : (row + answer.Length, col);
        if (grid.ContainsKey((beforeR, beforeC)) || grid.ContainsKey((afterR, afterC)))
        {
            return false;
        }

        for (var i = 0; i < answer.Length; i++)
        {
            var (r, c) = dir == CrosswordDirection.Across ? (row, col + i) : (row + i, col);

            if (grid.TryGetValue((r, c), out var existingChar))
            {
                if (existingChar != answer[i])
                {
                    return false; // çakışma: aynı hücrede farklı harf.
                }

                intersections++;
                continue; // kesişim hücresi: yan komşu kontrolünden muaf.
            }

            // Boş hücre: dik komşuları (yanları) boş olmalı.
            var (sideAR, sideAC) = dir == CrosswordDirection.Across ? (r - 1, c) : (r, c - 1);
            var (sideBR, sideBC) = dir == CrosswordDirection.Across ? (r + 1, c) : (r, c + 1);
            if (grid.ContainsKey((sideAR, sideAC)) || grid.ContainsKey((sideBR, sideBC)))
            {
                return false;
            }
        }

        return intersections >= 1;
    }

    /// <summary>Yerleştirilmiş kelimelerin tüm hücrelerini (mutlak koordinat → harf) haritasına döker.</summary>
    private static Dictionary<(int Row, int Col), char> BuildCharMap(List<Placed> placed)
    {
        var map = new Dictionary<(int, int), char>();
        foreach (var p in placed)
        {
            for (var i = 0; i < p.Length; i++)
            {
                var cell = p.CellAt(i);
                map[cell] = p.Answer[i];
            }
        }

        return map;
    }

    /// <summary>
    /// Mutlak koordinatları (0,0) köşesine kaydırır, ızgara boyutunu küçültür, başlangıç hücrelerini
    /// satır-major numaralar ve <see cref="CrosswordContent"/> üretir.
    /// </summary>
    private static Result Normalize(List<Placed> placed, int skipped)
    {
        if (placed.Count == 0)
        {
            return new Result(new CrosswordContent(0, 0, Array.Empty<CrosswordEntry>()), 0, skipped);
        }

        var minRow = placed.Min(p => p.Row);
        var minCol = placed.Min(p => p.Col);

        // (0,0)'a kaydır.
        var shifted = placed
            .Select(p => new Placed
            {
                Answer = p.Answer,
                Clue = p.Clue,
                Row = p.Row - minRow,
                Col = p.Col - minCol,
                Direction = p.Direction,
            })
            .ToList();

        var rows = shifted.Max(p => p.Direction == CrosswordDirection.Down ? p.Row + p.Length : p.Row + 1);
        var cols = shifted.Max(p => p.Direction == CrosswordDirection.Across ? p.Col + p.Length : p.Col + 1);

        // Başlangıç hücrelerini satır-major numaralandır (aynı hücre tek numara).
        var startCells = shifted
            .Select(p => (p.Row, p.Col))
            .Distinct()
            .OrderBy(c => c.Row)
            .ThenBy(c => c.Col)
            .ToList();

        var numberByCell = new Dictionary<(int, int), int>();
        var n = 1;
        foreach (var cell in startCells)
        {
            numberByCell[cell] = n++;
        }

        var entries = shifted
            .Select(p => new CrosswordEntry(
                numberByCell[(p.Row, p.Col)],
                p.Answer,
                p.Clue,
                p.Row,
                p.Col,
                p.Direction,
                p.Length))
            .OrderBy(e => e.Number)
            .ThenBy(e => e.Direction)
            .ToList();

        return new Result(new CrosswordContent(rows, cols, entries), shifted.Count, skipped);
    }

    /// <summary>
    /// Bir İngilizce terimi crossword cevabına normalize eder: harfleri BÜYÜK yapar, A–Z dışındaki tüm
    /// karakterleri (boşluk, tire, Türkçe karakterler dahil) atar. Sonuç A–Z dışı karakter içermez.
    /// </summary>
    public static string NormalizeAnswer(string term)
    {
        if (string.IsNullOrEmpty(term))
        {
            return string.Empty;
        }

        var sb = new StringBuilder(term.Length);
        foreach (var ch in term.ToUpperInvariant())
        {
            if (ch is >= 'A' and <= 'Z')
            {
                sb.Append(ch);
            }
        }

        return sb.ToString();
    }

    /// <summary>
    /// Bir terimin crossword'e uygun olup olmadığı: yalnız A–Z harfler, boşluk/tire/Türkçe karakter yok,
    /// ve en az 2 harf. (Türkçe karakterli veya çok-kelimeli terimler ELENİR.)
    /// </summary>
    public static bool IsEligibleTerm(string term)
    {
        if (string.IsNullOrWhiteSpace(term))
        {
            return false;
        }

        var trimmed = term.Trim();
        if (trimmed.Length < 2)
        {
            return false;
        }

        // Her karakter A–Z (büyük/küçük) olmalı; aksi (boşluk, tire, ç/ğ/ı/ö/ş/ü vs.) → uygunsuz.
        foreach (var ch in trimmed)
        {
            var upper = char.ToUpperInvariant(ch);
            if (upper is < 'A' or > 'Z')
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>Crossword için bir kelimenin oynanabilmesi için minimum uygun terim sayısı.</summary>
    public const int MinEligibleWords = 4;
}
