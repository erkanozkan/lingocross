import 'package:lingo_cross_app/features/games/data/dtos/game_dtos.dart';
import 'package:lingo_cross_app/features/games/data/games_repository.dart';
import 'package:lingo_cross_app/features/games/domain/game_type.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte games repository.
class FakeGamesRepository implements GamesRepository {
  FakeGamesRepository({
    this.assigned = const [],
    this.assignedError,
    this.createValue,
    this.createError,
    this.previewValue,
    this.previewError,
    this.myPuzzles = const [],
    this.myPuzzlesError,
    this.shareError,
    this.startValue,
    this.startError,
  });

  final List<AssignedGameDto> assigned;
  final GamesFailure? assignedError;
  final GameDto? createValue;
  final GamesFailure? createError;
  final GamePreviewResponse? previewValue;
  final GamesFailure? previewError;
  final List<TeacherPuzzleDto> myPuzzles;
  final GamesFailure? myPuzzlesError;
  final GamesFailure? shareError;
  final StartGameSessionResponse? startValue;
  final GamesFailure? startError;

  int createCount = 0;
  CreateGameRequest? lastCreateRequest;
  String? lastCreateLessonId;
  int previewCount = 0;
  String? lastPreviewLessonId;
  GameType? lastPreviewType;
  int listMyPuzzlesCount = 0;
  int shareCount = 0;
  String? lastSharedGameId;
  int startCount = 0;
  String? lastStartGameId;

  @override
  Future<GameDto> createGame(String lessonId, CreateGameRequest request) async {
    createCount++;
    lastCreateLessonId = lessonId;
    lastCreateRequest = request;
    if (createError != null) throw createError!;
    return createValue ??
        GameDto(
          id: 'g-$lessonId',
          lessonId: lessonId,
          type: request.type,
          title: request.title ?? 'Bulmaca',
          isPublished: true,
          publishedAt: DateTime(2026, 6, 23),
          createdAt: DateTime(2026, 6, 23),
          updatedAt: DateTime(2026, 6, 23),
        );
  }

  @override
  Future<GamePreviewResponse> previewGame(
      String lessonId, GameType type) async {
    previewCount++;
    lastPreviewLessonId = lessonId;
    lastPreviewType = type;
    if (previewError != null) throw previewError!;
    return previewValue ??
        GamePreviewResponse(
          type: type,
          wordMatching: type == GameType.wordMatching
              ? const WordMatchingContent(pairs: [], distractors: [])
              : null,
          crossword: type == GameType.crossword
              ? const CrosswordContent(rows: 1, cols: 1, entries: [])
              : null,
        );
  }

  @override
  Future<List<GameDto>> listForLesson(String lessonId) async =>
      throw UnimplementedError();

  @override
  Future<List<TeacherPuzzleDto>> listMyPuzzles() async {
    listMyPuzzlesCount++;
    if (myPuzzlesError != null) throw myPuzzlesError!;
    return myPuzzles;
  }

  @override
  Future<GameDto> sharePuzzle(String gameId) async {
    shareCount++;
    lastSharedGameId = gameId;
    if (shareError != null) throw shareError!;
    return GameDto(
      id: gameId,
      lessonId: 'l-$gameId',
      type: GameType.crossword,
      title: 'Bulmaca',
      isPublished: true,
      publishedAt: DateTime(2026, 6, 23),
      createdAt: DateTime(2026, 6, 23),
      updatedAt: DateTime(2026, 6, 23),
    );
  }

  @override
  Future<List<AssignedGameDto>> listAssigned() async {
    if (assignedError != null) throw assignedError!;
    return assigned;
  }

  @override
  Future<StartGameSessionResponse> startSession(String gameId) async {
    startCount++;
    lastStartGameId = gameId;
    if (startError != null) throw startError!;
    return startValue ??
        StartGameSessionResponse(
          session: GameSessionDto(
            id: 'sess-$gameId',
            gameId: gameId,
            studentId: 's1',
            status: GameSessionStatus.inProgress,
            startedAt: DateTime(2026, 6, 23),
          ),
          type: GameType.wordMatching,
          wordMatching: const WordMatchingContent(pairs: [], distractors: []),
        );
  }

  @override
  Future<GameSessionDto> getSession(String sessionId) async =>
      throw UnimplementedError();
}
