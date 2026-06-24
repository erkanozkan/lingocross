import '../../results/data/dtos/result_dtos.dart';
import '../data/dtos/game_dtos.dart';
import 'game_type.dart';

/// Bir ızgara hücresinin değişmez tanımı (statik yapı; harf girişi ayrı tutulur).
///
/// [isBlock] true ise hücre bulmacaya ait değildir ("siyah"/boş, doldurulamaz).
/// [solution] hücrenin doğru harfidir (kesişen hücrelerde tek harf paylaşılır).
/// [number] yalnız bir kelimenin başlangıç hücresinde dolu (köşe numarası), aksi
/// halde null. [acrossEntryIndex]/[downEntryIndex] bu hücrenin ait olduğu giriş(ler)in
/// [CrosswordEngine.entries] içindeki indeksidir; ait değilse null.
class CrosswordCell {
  const CrosswordCell({
    required this.row,
    required this.col,
    required this.isBlock,
    this.solution = '',
    this.number,
    this.acrossEntryIndex,
    this.downEntryIndex,
  });

  final int row;
  final int col;
  final bool isBlock;
  final String solution;
  final int? number;
  final int? acrossEntryIndex;
  final int? downEntryIndex;

  bool get isFillable => !isBlock;
}

/// Kullanıcının seçtiği aktif kelimenin yönü.
enum CrosswordAxis { across, down }

/// Bir kelimenin (giriş) anlık doğruluk durumu.
enum EntryStatus {
  /// En az bir hücresi boş.
  incomplete,

  /// Tüm hücreler dolu ve [CrosswordEntry.answer] ile birebir.
  correct,

  /// Tüm hücreler dolu ama cevap yanlış.
  wrong,
}

/// Crossword oyununun saf (UI'siz) durum makinesi.
///
/// İçerikten ([CrosswordContent]) `rows×cols` ızgara kurar; her giriş için
/// başlangıç hücresinden yönüne göre [CrosswordEntry.length] hücreyi işaretler.
/// Kullanıcı bir hücre seçer (aktif kelime + yön belirir), harf girer/siler.
/// Doğruluk: girilen harfler [CrosswordEntry.answer] ile karşılaştırılır.
///
/// Tüm mutasyonlar yeni bir [CrosswordEngine] döndürür (immutable); test edilebilir.
class CrosswordEngine {
  CrosswordEngine._({
    required this.rows,
    required this.cols,
    required this.cells,
    required this.entries,
    required this.letters,
    required this.activeRow,
    required this.activeCol,
    required this.axis,
  });

  /// İçerikten ızgara + giriş eşlemesini kurar; harf alanları boş başlar.
  factory CrosswordEngine.fromContent(CrosswordContent content) {
    final rows = content.rows;
    final cols = content.cols;
    final entries = List<CrosswordEntry>.unmodifiable(content.entries);

    // Mutable hücre meta verisi (sonra immutable'a dökülür).
    final block = List.generate(rows, (_) => List.filled(cols, true));
    final solution = List.generate(rows, (_) => List.filled(cols, ''));
    final number = List.generate(rows, (_) => List<int?>.filled(cols, null));
    final acrossIdx = List.generate(rows, (_) => List<int?>.filled(cols, null));
    final downIdx = List.generate(rows, (_) => List<int?>.filled(cols, null));

    for (var e = 0; e < entries.length; e++) {
      final entry = entries[e];
      final answer = entry.answer;
      for (var i = 0; i < entry.length; i++) {
        final r = entry.direction == CrosswordDirection.down
            ? entry.row + i
            : entry.row;
        final c = entry.direction == CrosswordDirection.across
            ? entry.col + i
            : entry.col;
        if (r < 0 || r >= rows || c < 0 || c >= cols) continue;
        block[r][c] = false;
        // Kesişmede harf tutarlı varsayılır; cevaptaki harfle doldur.
        if (i < answer.length) solution[r][c] = answer[i];
        if (entry.direction == CrosswordDirection.across) {
          acrossIdx[r][c] = e;
        } else {
          downIdx[r][c] = e;
        }
      }
      // Başlangıç hücresine köşe numarası (aynı hücreden iki yön başlarsa paylaşılır).
      final sr = entry.row;
      final sc = entry.col;
      if (sr >= 0 && sr < rows && sc >= 0 && sc < cols) {
        number[sr][sc] = entry.number;
      }
    }

    final cells = [
      for (var r = 0; r < rows; r++)
        [
          for (var c = 0; c < cols; c++)
            CrosswordCell(
              row: r,
              col: c,
              isBlock: block[r][c],
              solution: solution[r][c],
              number: number[r][c],
              acrossEntryIndex: acrossIdx[r][c],
              downEntryIndex: downIdx[r][c],
            ),
        ],
    ];

    final letters = List.generate(rows, (_) => List.filled(cols, ''));

    return CrosswordEngine._(
      rows: rows,
      cols: cols,
      cells: cells,
      entries: entries,
      letters: letters,
      activeRow: null,
      activeCol: null,
      axis: CrosswordAxis.across,
    );
  }

  final int rows;
  final int cols;

  /// Izgara hücreleri (satır-major; `cells[r][c]`). Statik yapı.
  final List<List<CrosswordCell>> cells;

  /// Bulmaca girişleri (API sırası korunur).
  final List<CrosswordEntry> entries;

  /// Kullanıcının girdiği harfler (`letters[r][c]`); boş = girilmemiş.
  final List<List<String>> letters;

  /// Aktif (seçili) hücre; seçim yoksa null.
  final int? activeRow;
  final int? activeCol;

  /// Aktif kelimenin yönü (across/down). Seçim yoksa varsayılan across.
  final CrosswordAxis axis;

  CrosswordEngine _copy({
    List<List<String>>? letters,
    int? activeRow,
    int? activeCol,
    CrosswordAxis? axis,
    bool clearActive = false,
  }) {
    return CrosswordEngine._(
      rows: rows,
      cols: cols,
      cells: cells,
      entries: entries,
      letters: letters ?? this.letters,
      activeRow: clearActive ? null : (activeRow ?? this.activeRow),
      activeCol: clearActive ? null : (activeCol ?? this.activeCol),
      axis: axis ?? this.axis,
    );
  }

  CrosswordCell cellAt(int row, int col) => cells[row][col];

  /// Bir hücreye kullanıcının girdiği harf (boş = girilmemiş).
  String letterAt(int row, int col) => letters[row][col];

  bool get hasSelection => activeRow != null && activeCol != null;

  /// O an aktif olan giriş; seçim yoksa veya hücre kelimeye ait değilse null.
  CrosswordEntry? get activeEntry {
    final idx = activeEntryIndex;
    return idx == null ? null : entries[idx];
  }

  /// Aktif girişin [entries] içindeki indeksi (yoksa null).
  int? get activeEntryIndex {
    if (!hasSelection) return null;
    final cell = cells[activeRow!][activeCol!];
    final idx =
        axis == CrosswordAxis.across ? cell.acrossEntryIndex : cell.downEntryIndex;
    // Aktif eksende giriş yoksa diğer eksene düş (tek-yönlü hücreler için).
    if (idx != null) return idx;
    return cell.acrossEntryIndex ?? cell.downEntryIndex;
  }

  /// Bir hücreyi seçer. Doldurulamaz hücre → no-op.
  ///
  /// Aynı hücreye tekrar dokunulursa ve hücre iki kelimeye aitse yön değişir
  /// (across ↔ down). Aksi halde hücrenin desteklediği yöne göre eksen ayarlanır.
  CrosswordEngine selectCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) return this;
    final cell = cells[row][col];
    if (!cell.isFillable) return this;

    final sameCell = activeRow == row && activeCol == col;
    final hasAcross = cell.acrossEntryIndex != null;
    final hasDown = cell.downEntryIndex != null;

    CrosswordAxis nextAxis;
    if (sameCell && hasAcross && hasDown) {
      // Kesişen hücrede tekrar dokunuş → yön değiştir.
      nextAxis = axis == CrosswordAxis.across
          ? CrosswordAxis.down
          : CrosswordAxis.across;
    } else if (hasAcross && hasDown) {
      // Mevcut ekseni koru (her ikisi de geçerli).
      nextAxis = axis;
    } else {
      nextAxis = hasAcross ? CrosswordAxis.across : CrosswordAxis.down;
    }

    return _copy(activeRow: row, activeCol: col, axis: nextAxis);
  }

  /// Bir girişe odaklanır (ipucuna dokununca): başlangıç hücresini aktif yapar,
  /// ekseni girişin yönüne ayarlar.
  CrosswordEngine focusEntry(int entryIndex) {
    if (entryIndex < 0 || entryIndex >= entries.length) return this;
    final entry = entries[entryIndex];
    return _copy(
      activeRow: entry.row,
      activeCol: entry.col,
      axis: entry.direction == CrosswordDirection.down
          ? CrosswordAxis.down
          : CrosswordAxis.across,
    );
  }

  /// Aktif hücreye [letter] yazar (tek karakter, büyük harfe normalize edilir)
  /// ve imleci aktif kelime içinde bir sonraki doldurulabilir hücreye taşır.
  /// Seçim yoksa veya hücre dolu değilse no-op.
  CrosswordEngine enterLetter(String letter) {
    if (!hasSelection || letter.isEmpty) return this;
    final r = activeRow!;
    final c = activeCol!;
    if (!cells[r][c].isFillable) return this;

    final ch = letter.substring(0, 1).toUpperCase();
    final newLetters = _cloneLetters();
    newLetters[r][c] = ch;

    final next = _nextCell(r, c);
    return _copy(
      letters: newLetters,
      activeRow: next?.$1 ?? r,
      activeCol: next?.$2 ?? c,
    );
  }

  /// Geri silme: aktif hücre doluysa onu temizler; boşsa önceki hücreye geçip
  /// onu temizler (klasik bulmaca davranışı). Seçim yoksa no-op.
  CrosswordEngine deleteLetter() {
    if (!hasSelection) return this;
    final r = activeRow!;
    final c = activeCol!;
    final newLetters = _cloneLetters();

    if (newLetters[r][c].isNotEmpty) {
      newLetters[r][c] = '';
      return _copy(letters: newLetters);
    }
    final prev = _prevCell(r, c);
    if (prev == null) return _copy(letters: newLetters);
    newLetters[prev.$1][prev.$2] = '';
    return _copy(
      letters: newLetters,
      activeRow: prev.$1,
      activeCol: prev.$2,
    );
  }

  /// Bir girişin doğruluk durumu.
  EntryStatus statusOf(int entryIndex) {
    final entry = entries[entryIndex];
    final buffer = StringBuffer();
    var anyEmpty = false;
    for (var i = 0; i < entry.length; i++) {
      final r = entry.direction == CrosswordDirection.down
          ? entry.row + i
          : entry.row;
      final c = entry.direction == CrosswordDirection.across
          ? entry.col + i
          : entry.col;
      final l = letters[r][c];
      if (l.isEmpty) anyEmpty = true;
      buffer.write(l);
    }
    if (anyEmpty) return EntryStatus.incomplete;
    return buffer.toString() == entry.answer
        ? EntryStatus.correct
        : EntryStatus.wrong;
  }

  /// Doğru çözülmüş kelime sayısı — yalnız "Bitir" anında skorlama için
  /// (correctItems). Oyun sırasında doğruluk gösterilmez.
  int get correctCount {
    var n = 0;
    for (var i = 0; i < entries.length; i++) {
      if (statusOf(i) == EntryStatus.correct) n++;
    }
    return n;
  }

  /// Bir girişin o an girilmiş harfleri (boş hücreler atlanır, büyük harf).
  String _enteredAnswer(CrosswordEntry entry) {
    final buffer = StringBuffer();
    for (var i = 0; i < entry.length; i++) {
      final r = entry.direction == CrosswordDirection.down
          ? entry.row + i
          : entry.row;
      final c = entry.direction == CrosswordDirection.across
          ? entry.col + i
          : entry.col;
      buffer.write(letters[r][c]);
    }
    return buffer.toString();
  }

  /// "Bitir" anında her kelime için kelime-bazlı sonuç dökümü (F7.5).
  ///
  /// - [SubmitResultItem.ordinal] = girişin [entries] içindeki sırası (0-tabanlı).
  /// - [SubmitResultItem.term] = ipucu (clue); ipucu boşsa cevabın kendisi.
  /// - [SubmitResultItem.expectedAnswer] = doğru cevap (kelime).
  /// - [SubmitResultItem.studentAnswer] = öğrencinin doldurduğu harfler; hiç harf
  ///   girilmediyse null.
  /// - [SubmitResultItem.isCorrect] = giriş tam ve doğru mu.
  ///
  /// Mevcut skorlama mantığı korunur; bu yalnız bitişte çağrılan türetimdir.
  List<SubmitResultItem> resultItems() {
    final items = <SubmitResultItem>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final entered = _enteredAnswer(entry);
      final term = entry.clue.trim().isNotEmpty ? entry.clue : entry.answer;
      items.add(SubmitResultItem(
        ordinal: i,
        term: term,
        expectedAnswer: entry.answer,
        studentAnswer: entered.isEmpty ? null : entered,
        isCorrect: statusOf(i) == EntryStatus.correct,
      ));
    }
    return items;
  }

  /// Tüm hücreleri DOLU girişlerin sayısı (doğru/yanlış ayırt etmeden).
  /// İlerleme bunun üzerinden gösterilir (doğruluk gizli kalır).
  int get filledCount {
    var n = 0;
    for (var i = 0; i < entries.length; i++) {
      if (statusOf(i) != EntryStatus.incomplete) n++;
    }
    return n;
  }

  /// Toplam kelime sayısı (totalItems).
  int get totalCount => entries.length;

  /// İlerleme oranı (0–1) — dolu kelime / toplam (doğruluk içermez).
  double get progress => totalCount == 0 ? 0 : filledCount / totalCount;

  /// Tüm doldurulabilir hücreler dolu mu (kullanıcı "bitirebilir" mi).
  bool get allCellsFilled {
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (cells[r][c].isFillable && letters[r][c].isEmpty) return false;
      }
    }
    return true;
  }

  /// Tüm kelimeler doğru mu (oyun tamamlandı).
  bool get isComplete => totalCount > 0 && correctCount == totalCount;

  /// Bir hücrenin aktif kelimeye ait olup olmadığı (vurgu için).
  bool isInActiveWord(int row, int col) {
    final idx = activeEntryIndex;
    if (idx == null) return false;
    final entry = entries[idx];
    for (var i = 0; i < entry.length; i++) {
      final r = entry.direction == CrosswordDirection.down
          ? entry.row + i
          : entry.row;
      final c = entry.direction == CrosswordDirection.across
          ? entry.col + i
          : entry.col;
      if (r == row && c == col) return true;
    }
    return false;
  }

  /// across (soldan sağa) girişlerin [entries] indeksleri, numara sırasında.
  List<int> get acrossIndices => _indicesFor(CrosswordDirection.across);

  /// down (yukarıdan aşağı) girişlerin [entries] indeksleri, numara sırasında.
  List<int> get downIndices => _indicesFor(CrosswordDirection.down);

  List<int> _indicesFor(CrosswordDirection dir) {
    final list = [
      for (var i = 0; i < entries.length; i++)
        if (entries[i].direction == dir) i,
    ];
    list.sort((a, b) => entries[a].number.compareTo(entries[b].number));
    return list;
  }

  List<List<String>> _cloneLetters() =>
      [for (final row in letters) [...row]];

  /// Aktif kelime içinde (r,c)'den bir sonraki doldurulabilir hücre.
  (int, int)? _nextCell(int r, int c) {
    final idx = activeEntryIndex;
    if (idx == null) return null;
    final entry = entries[idx];
    final pos = _posInEntry(entry, r, c);
    if (pos == null || pos + 1 >= entry.length) return null;
    final nr =
        entry.direction == CrosswordDirection.down ? entry.row + pos + 1 : entry.row;
    final nc = entry.direction == CrosswordDirection.across
        ? entry.col + pos + 1
        : entry.col;
    return (nr, nc);
  }

  /// Aktif kelime içinde (r,c)'den önceki hücre.
  (int, int)? _prevCell(int r, int c) {
    final idx = activeEntryIndex;
    if (idx == null) return null;
    final entry = entries[idx];
    final pos = _posInEntry(entry, r, c);
    if (pos == null || pos - 1 < 0) return null;
    final pr =
        entry.direction == CrosswordDirection.down ? entry.row + pos - 1 : entry.row;
    final pc = entry.direction == CrosswordDirection.across
        ? entry.col + pos - 1
        : entry.col;
    return (pr, pc);
  }

  int? _posInEntry(CrosswordEntry entry, int r, int c) {
    if (entry.direction == CrosswordDirection.across) {
      if (r != entry.row) return null;
      final pos = c - entry.col;
      return (pos >= 0 && pos < entry.length) ? pos : null;
    } else {
      if (c != entry.col) return null;
      final pos = r - entry.row;
      return (pos >= 0 && pos < entry.length) ? pos : null;
    }
  }
}
