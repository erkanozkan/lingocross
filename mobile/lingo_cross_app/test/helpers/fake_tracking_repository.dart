import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/tracking/data/dtos/tracking_dtos.dart';
import 'package:lingo_cross_app/features/tracking/data/tracking_repository.dart';
import 'package:lingo_cross_app/features/tracking/domain/tracking_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte tracking repository.
class FakeTrackingRepository implements TrackingRepository {
  FakeTrackingRepository({
    this.students = const [],
    this.studentsError,
    this.resultsByStudent = const {},
    this.resultsError,
  });

  final List<StudentSummaryDto> students;
  final TrackingFailure? studentsError;
  final Map<String, List<SharedResultDto>> resultsByStudent;
  final TrackingFailure? resultsError;

  int listStudentsCount = 0;
  String? lastResultsStudentId;

  @override
  Future<List<StudentSummaryDto>> listStudents() async {
    listStudentsCount++;
    if (studentsError != null) throw studentsError!;
    return students;
  }

  @override
  Future<List<SharedResultDto>> listStudentResults(String studentId) async {
    lastResultsStudentId = studentId;
    if (resultsError != null) throw resultsError!;
    return resultsByStudent[studentId] ?? const [];
  }
}

/// Test öğrenci özeti üretici. [lastActivityAt] doğrudan kullanılır; `null`
/// geçilirse "henüz yok" durumu test edilebilir (sentinel ile ayrılır).
const _noActivitySentinel = Object();

StudentSummaryDto sampleStudent({
  String studentId = 's1',
  String displayName = 'Ada',
  int sharedResultsCount = 3,
  int? averageScore = 80,
  Object? lastActivityAt = _noActivitySentinel,
}) {
  return StudentSummaryDto(
    studentId: studentId,
    displayName: displayName,
    sharedResultsCount: sharedResultsCount,
    averageScore: averageScore,
    lastActivityAt: identical(lastActivityAt, _noActivitySentinel)
        ? DateTime(2026, 6, 12, 10)
        : lastActivityAt as DateTime?,
  );
}

/// Test paylaşılan sonuç üretici.
SharedResultDto sampleSharedResult({
  String resultId = 'r1',
  String lessonTitle = 'Ünite 3',
  GameType gameType = GameType.wordMatching,
  int score = 85,
  int durationMs = 252000,
  int totalItems = 20,
  int correctItems = 17,
  DateTime? createdAt,
}) {
  return SharedResultDto(
    resultId: resultId,
    lessonTitle: lessonTitle,
    gameType: gameType,
    score: score,
    durationMs: durationMs,
    totalItems: totalItems,
    correctItems: correctItems,
    sharedAt: DateTime(2026, 6, 12, 11),
    createdAt: createdAt ?? DateTime(2026, 6, 12, 10),
  );
}
