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
    this.startValue,
    this.startError,
  });

  final List<AssignedGameDto> assigned;
  final GamesFailure? assignedError;
  final GameDto? createValue;
  final GamesFailure? createError;
  final StartGameSessionResponse? startValue;
  final GamesFailure? startError;

  int createCount = 0;
  CreateGameRequest? lastCreateRequest;
  String? lastCreateLessonId;
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
  Future<List<GameDto>> listForLesson(String lessonId) async =>
      throw UnimplementedError();

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
          content: const WordMatchingContent(pairs: [], distractors: []),
        );
  }

  @override
  Future<GameSessionDto> getSession(String sessionId) async =>
      throw UnimplementedError();
}
