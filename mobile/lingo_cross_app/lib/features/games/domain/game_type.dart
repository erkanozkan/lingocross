/// Oyun türü (API `GameType` enum'u ile birebir; sayısal değerler kalıcı).
///
/// MVP'de yalnız [wordMatching] kullanılır; diğerleri Faz 2 için rezerve.
enum GameType {
  wordMatching(1),
  crossword(2),
  questionSet(3);

  const GameType(this.value);

  final int value;

  static GameType fromValue(int value) => switch (value) {
        1 => GameType.wordMatching,
        2 => GameType.crossword,
        3 => GameType.questionSet,
        _ => GameType.wordMatching,
      };
}

/// Oyun oturumu durumu (API `GameSessionStatus` enum'u ile birebir).
enum GameSessionStatus {
  inProgress(1),
  completed(2),
  abandoned(3);

  const GameSessionStatus(this.value);

  final int value;

  static GameSessionStatus fromValue(int value) => switch (value) {
        1 => GameSessionStatus.inProgress,
        2 => GameSessionStatus.completed,
        3 => GameSessionStatus.abandoned,
        _ => GameSessionStatus.inProgress,
      };
}

/// Bulmaca kelime yönü (API `CrosswordDirection` enum'u ile birebir).
///
/// [across] (yatay) → harfler sütun artarak, [down] (dikey) → satır artarak yerleşir.
enum CrosswordDirection {
  across(0),
  down(1);

  const CrosswordDirection(this.value);

  final int value;

  static CrosswordDirection fromValue(int value) => switch (value) {
        0 => CrosswordDirection.across,
        1 => CrosswordDirection.down,
        _ => CrosswordDirection.across,
      };
}
