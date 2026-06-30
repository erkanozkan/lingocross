import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/results/data/dtos/result_dtos.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/domain/results_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte results repository.
class FakeResultsRepository implements ResultsRepository {
  FakeResultsRepository({
    this.submitResultValue,
    this.submitError,
    this.shareError,
    this.detailError,
    this.mine = const [],
    this.details = const {},
  });

  final GameResultDto? submitResultValue;
  final ResultsFailure? submitError;
  final ResultsFailure? shareError;
  final ResultsFailure? detailError;
  final List<GameResultDto> mine;

  /// resultId → detay (item'lar dahil). Yoksa [getResultDetail] notFound atar.
  final Map<String, GameResultDetailDto> details;

  int submitCount = 0;
  int shareCount = 0;
  int detailCount = 0;

  /// Son gönderilen sonuç isteğinin alanları (skorlama doğrulaması için).
  int? lastTotalItems;
  int? lastCorrectItems;
  int? lastDurationMs;

  @override
  Future<GameResultDto> submitResult(
    String sessionId,
    SubmitResultRequest request,
  ) async {
    submitCount++;
    lastTotalItems = request.totalItems;
    lastCorrectItems = request.correctItems;
    lastDurationMs = request.durationMs;
    if (submitError != null) throw submitError!;
    return submitResultValue ??
        sampleResult(
          id: 'r-$sessionId',
          sessionId: sessionId,
          totalItems: request.totalItems,
          correctItems: request.correctItems,
          durationMs: request.durationMs,
        );
  }

  @override
  Future<GameResultDto> share(String resultId) async {
    shareCount++;
    if (shareError != null) throw shareError!;
    final base = mine.where((r) => r.id == resultId).firstOrNull ??
        (submitResultValue?.id == resultId
            ? submitResultValue!
            : sampleResult(id: resultId));
    return base.copyWith(
      sharedWithTeacher: true,
      sharedAt: DateTime(2026, 6, 23, 10),
    );
  }

  @override
  Future<List<GameResultDto>> listMine() async {
    if (submitError != null) throw submitError!;
    return mine;
  }

  @override
  Future<GameResultDetailDto> getResultDetail(String resultId) async {
    detailCount++;
    if (detailError != null) throw detailError!;
    final detail = details[resultId];
    if (detail == null) throw const ResultsFailure.notFound();
    return detail;
  }
}

/// Test detay üretici (item'larla).
GameResultDetailDto sampleResultDetail({
  String id = 'r1',
  String lessonId = 'l1',
  String lessonTitle = 'Ünite 3',
  int totalItems = 3,
  int correctItems = 2,
  int durationMs = 252000,
  int score = 85,
  bool sharedWithTeacher = true,
  DateTime? createdAt,
  List<ResultItemModel>? items,
}) {
  return GameResultDetailDto(
    id: id,
    gameId: 'g1',
    gameType: GameType.wordMatching,
    lessonId: lessonId,
    lessonTitle: lessonTitle,
    durationMs: durationMs,
    totalItems: totalItems,
    correctItems: correctItems,
    score: score,
    sharedWithTeacher: sharedWithTeacher,
    sharedAt: sharedWithTeacher ? DateTime(2026, 6, 23, 9) : null,
    createdAt: createdAt ?? DateTime(2026, 6, 23, 8),
    items: items ??
        const [
          ResultItemModel(
            ordinal: 0,
            term: 'apple',
            expectedAnswer: 'elma',
            studentAnswer: 'elma',
            isCorrect: true,
          ),
          ResultItemModel(
            ordinal: 1,
            term: 'bread',
            expectedAnswer: 'ekmek',
            studentAnswer: 'su',
            isCorrect: false,
          ),
          ResultItemModel(
            ordinal: 2,
            term: 'water',
            expectedAnswer: 'su',
            studentAnswer: null,
            isCorrect: false,
          ),
        ],
  );
}

/// Test sonucu üretici.
GameResultDto sampleResult({
  String id = 'r1',
  String sessionId = 's1',
  String lessonId = 'l1',
  String lessonTitle = 'Ünite 3',
  int totalItems = 20,
  int correctItems = 17,
  int durationMs = 252000,
  int score = 85,
  bool sharedWithTeacher = false,
  DateTime? createdAt,
}) {
  return GameResultDto(
    id: id,
    sessionId: sessionId,
    gameId: 'g1',
    gameType: GameType.wordMatching,
    lessonId: lessonId,
    lessonTitle: lessonTitle,
    durationMs: durationMs,
    totalItems: totalItems,
    correctItems: correctItems,
    score: score,
    sharedWithTeacher: sharedWithTeacher,
    sharedAt: sharedWithTeacher ? DateTime(2026, 6, 23, 9) : null,
    createdAt: createdAt ?? DateTime(2026, 6, 23, 8),
  );
}
