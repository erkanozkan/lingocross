import 'package:lingo_cross_app/features/games/data/ai_exam_repository.dart';
import 'package:lingo_cross_app/features/games/data/dtos/ai_exam_dtos.dart';
import 'package:lingo_cross_app/features/games/domain/games_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte AI sınav repository.
class FakeAiExamRepository implements AiExamRepository {
  FakeAiExamRepository({
    this.generateValue,
    this.generateError,
    this.deleteError,
  });

  final AiExamResultDto? generateValue;
  final GamesFailure? generateError;
  final GamesFailure? deleteError;

  int generateCount = 0;
  String? lastLessonId;
  AiExamGenerateRequest? lastRequest;

  int deleteCount = 0;
  String? lastDeleteTopicId;
  String? lastDeleteQuestionId;

  @override
  Future<AiExamResultDto> generate(
    String lessonId,
    AiExamGenerateRequest request,
  ) async {
    generateCount++;
    lastLessonId = lessonId;
    lastRequest = request;
    if (generateError != null) throw generateError!;
    return generateValue ??
        AiExamResultDto(
          topicId: 'topic-$lessonId',
          title: 'Ünite 4',
          grade: request.grade,
          lessonId: lessonId,
          questions: const [],
        );
  }

  @override
  Future<void> deleteQuestion(String topicId, String questionId) async {
    deleteCount++;
    lastDeleteTopicId = topicId;
    lastDeleteQuestionId = questionId;
    if (deleteError != null) throw deleteError!;
  }
}
