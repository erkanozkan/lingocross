using LingoCross.Application.Games;
using LingoCross.Application.Games.Dtos;

namespace LingoCross.Tests.Games;

/// <summary>
/// F2.4 — Saf crossword üreteci testleri: ızgara geçerliliği (çakışma yok, kesişen hücrelerde harfler
/// tutarlı, yerleşenler ilk kelimeye bağlı), numaralandırma doğruluğu, terim eleme (A–Z + uzunluk),
/// cevap normalizasyonu ve deterministik tohumla tekrarlanabilirlik.
/// </summary>
public class CrosswordGeneratorTests
{
    private static Random Seeded(int seed = 12345) => new(seed);

    private static IReadOnlyList<(string, string)> Sample() => new[]
    {
        ("APPLE", "elma"),
        ("PEAR", "armut"),
        ("PLATE", "tabak"),
        ("LEMON", "limon"),
        ("MELON", "kavun"),
        ("TABLE", "masa"),
    };

    // ---- Normalizasyon + eleme ----

    [Theory]
    [InlineData("apple", "APPLE")]
    [InlineData("Book Store", "BOOKSTORE")] // boşluk atılır → birleşir
    [InlineData("re-use", "REUSE")] // tire atılır → birleşir
    [InlineData("çiçek", "CICEK")] // ç→C, i→I, ç→C, e→E, k→K
    [InlineData("şeker", "SEKER")] // ş→S
    [InlineData("naïve", "NAIVE")] // ï→I
    [InlineData("schön", "SCHON")] // ö→O
    [InlineData("niño", "NINO")] // ñ→N
    [InlineData("ışık", "ISIK")] // ı→I, ş→S, ı→I, k→K (Türkçe-i bug kontrolü)
    [InlineData("İstanbul", "ISTANBUL")] // İ→I (Türkçe büyük noktalı I)
    public void NormalizeAnswer_FoldsAccents_StripsNonAZ_AndUppercases(string input, string expected)
    {
        Assert.Equal(expected, CrosswordGenerator.NormalizeAnswer(input));
    }

    [Theory]
    [InlineData("apple", true)]
    [InlineData("AB", true)]
    [InlineData("a", false)] // tek harf
    [InlineData("book store", false)] // boşluk → çok kelimeli, elenir
    [InlineData("re-use", false)] // tire → elenir
    [InlineData("çiçek", true)] // tek kelime aksanlı → CICEK (5 harf)
    [InlineData("şeker", true)] // SEKER
    [InlineData("naïve", true)] // NAIVE
    [InlineData("ışık", true)] // ISIK (tek kelime → eligible)
    [InlineData("İstanbul", true)] // ISTANBUL
    [InlineData("", false)]
    public void IsEligibleTerm_SingleWord_MinTwoAfterFold(string term, bool expected)
    {
        Assert.Equal(expected, CrosswordGenerator.IsEligibleTerm(term));
    }

    // ---- Izgara geçerliliği ----

    [Fact]
    public void Generate_ProducesConnected_NonConflicting_Grid()
    {
        var result = CrosswordGenerator.Generate(Sample(), Seeded());

        Assert.True(result.PlacedCount >= CrosswordGenerator.MinEligibleWords,
            $"yerleşen: {result.PlacedCount}");

        var content = result.Content;
        AssertGridValid(content);
        AssertConnected(content);
    }

    [Fact]
    public void Generate_Numbering_RowMajor_SharedCellSingleNumber()
    {
        var content = CrosswordGenerator.Generate(Sample(), Seeded()).Content;

        // Aynı başlangıç hücresinden başlayan girişler (across+down) aynı numarayı paylaşır.
        var byCell = content.Entries
            .GroupBy(e => (e.Row, e.Col))
            .ToList();
        foreach (var group in byCell)
        {
            Assert.Single(group.Select(e => e.Number).Distinct());
        }

        // Numaralar satır-major artan: küçük (row,col) → küçük numara.
        var distinctStarts = byCell
            .Select(g => (g.Key.Row, g.Key.Col, Number: g.First().Number))
            .OrderBy(s => s.Number)
            .ToList();
        for (var i = 1; i < distinctStarts.Count; i++)
        {
            var prev = distinctStarts[i - 1];
            var cur = distinctStarts[i];
            // numara sırası satır-major hücre sırasıyla aynı yönde olmalı.
            var prevKey = prev.Row * 100000 + prev.Col;
            var curKey = cur.Row * 100000 + cur.Col;
            Assert.True(prevKey < curKey, "numaralandırma satır-major değil");
        }

        // Numaralar 1..N ardışık.
        var numbers = byCell.Select(g => g.First().Number).OrderBy(n => n).ToList();
        for (var i = 0; i < numbers.Count; i++)
        {
            Assert.Equal(i + 1, numbers[i]);
        }
    }

    [Fact]
    public void Generate_Deterministic_SameSeed_SameResult()
    {
        var a = CrosswordGenerator.Generate(Sample(), Seeded(999)).Content;
        var b = CrosswordGenerator.Generate(Sample(), Seeded(999)).Content;

        Assert.Equal(a.Rows, b.Rows);
        Assert.Equal(a.Cols, b.Cols);
        Assert.Equal(a.Entries.Count, b.Entries.Count);
        for (var i = 0; i < a.Entries.Count; i++)
        {
            Assert.Equal(a.Entries[i], b.Entries[i]);
        }
    }

    [Fact]
    public void Generate_BackboneIsLongest_PlacedAcross()
    {
        var content = CrosswordGenerator.Generate(Sample(), Seeded()).Content;

        // Omurga: ilk (en uzun = 5 harf) kelime yatay yerleştirilir. Numaralandırma satır-major
        // olduğu için numara 1 olması garanti değildir; en uzun kelimenin across olarak var olması yeterli.
        var maxLen = content.Entries.Max(e => e.Answer.Length);
        Assert.Equal(5, maxLen);
        Assert.Contains(content.Entries, e => e.Answer.Length == maxLen && e.Direction == CrosswordDirection.Across);
    }

    [Fact]
    public void Generate_RespectsMaxWords()
    {
        var many = new List<(string, string)>
        {
            ("ALPHA", "a"), ("BETA", "b"), ("GAMMA", "c"), ("DELTA", "d"),
            ("EPSILON", "e"), ("ZETA", "f"), ("THETA", "g"), ("IOTA", "h"),
            ("KAPPA", "i"), ("LAMBDA", "j"), ("OMEGA", "k"), ("SIGMA", "l"),
        };

        var result = CrosswordGenerator.Generate(many, Seeded(), maxWords: 6);
        // En fazla 6 kelime değerlendirilir → yerleşen + atlanan ≤ 6.
        Assert.True(result.PlacedCount + result.SkippedCount <= 6);
    }

    [Fact]
    public void Generate_NoEligible_ReturnsEmpty()
    {
        var result = CrosswordGenerator.Generate(Array.Empty<(string, string)>(), Seeded());
        Assert.Equal(0, result.PlacedCount);
        Assert.Empty(result.Content.Entries);
    }

    // ---- yardımcılar ----

    /// <summary>Tüm girişleri ızgaraya basar; kesişen hücrelerde harf çakışması olmamalı, sınır taşmamalı.</summary>
    private static void AssertGridValid(CrosswordContent content)
    {
        var grid = new Dictionary<(int, int), char>();
        foreach (var e in content.Entries)
        {
            Assert.Equal(e.Answer.Length, e.Length);
            for (var i = 0; i < e.Answer.Length; i++)
            {
                var r = e.Direction == CrosswordDirection.Across ? e.Row : e.Row + i;
                var c = e.Direction == CrosswordDirection.Across ? e.Col + i : e.Col;

                // Sınır içinde.
                Assert.InRange(r, 0, content.Rows - 1);
                Assert.InRange(c, 0, content.Cols - 1);

                if (grid.TryGetValue((r, c), out var existing))
                {
                    // Kesişim: harfler tutarlı olmalı.
                    Assert.Equal(existing, e.Answer[i]);
                }
                else
                {
                    grid[(r, c)] = e.Answer[i];
                }
            }
        }
    }

    /// <summary>Yerleşen kelimeler bağlı bir bileşen oluşturmalı (hepsi birbirine kesişimlerle bağlı).</summary>
    private static void AssertConnected(CrosswordContent content)
    {
        if (content.Entries.Count <= 1)
        {
            return;
        }

        // Her giriş bir düğüm; iki giriş ortak hücre paylaşıyorsa kenar var.
        var cellsByEntry = content.Entries
            .Select(e => Enumerable.Range(0, e.Length)
                .Select(i => e.Direction == CrosswordDirection.Across ? (e.Row, e.Col + i) : (e.Row + i, e.Col))
                .ToHashSet())
            .ToList();

        var n = cellsByEntry.Count;
        var adj = new List<int>[n];
        for (var i = 0; i < n; i++)
        {
            adj[i] = new List<int>();
        }

        for (var i = 0; i < n; i++)
        {
            for (var j = i + 1; j < n; j++)
            {
                if (cellsByEntry[i].Overlaps(cellsByEntry[j]))
                {
                    adj[i].Add(j);
                    adj[j].Add(i);
                }
            }
        }

        // BFS düğüm 0'dan; hepsi erişilebilir olmalı (ilk kelimeye bağlı).
        var visited = new bool[n];
        var queue = new Queue<int>();
        queue.Enqueue(0);
        visited[0] = true;
        var seen = 1;
        while (queue.Count > 0)
        {
            var cur = queue.Dequeue();
            foreach (var next in adj[cur])
            {
                if (!visited[next])
                {
                    visited[next] = true;
                    seen++;
                    queue.Enqueue(next);
                }
            }
        }

        Assert.Equal(n, seen);
    }
}
