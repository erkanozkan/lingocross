import 'package:lingo_cross_app/features/lessons/data/dtos/lesson_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/dtos/word_dtos.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte repository.
class FakeLessonsRepository implements LessonsRepository {
  FakeLessonsRepository({this.lessons = const [], this.words = const []});

  final List<LessonDto> lessons;
  final List<WordDto> words;

  @override
  Future<List<LessonDto>> listLessons() async => lessons;

  @override
  Future<LessonDto> getLesson(String id) async =>
      lessons.firstWhere((l) => l.id == id);

  @override
  Future<LessonDto> createLesson(CreateLessonRequest request) async =>
      throw UnimplementedError();

  @override
  Future<LessonDto> updateLesson(String id, UpdateLessonRequest request) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteLesson(String id) async {}

  @override
  Future<LessonDto> publishLesson(String id) async =>
      throw UnimplementedError();

  @override
  Future<LessonDto> unpublishLesson(String id) async =>
      throw UnimplementedError();

  @override
  Future<LessonDto> completeLesson(String id) async =>
      throw UnimplementedError();

  @override
  Future<List<WordDto>> listWords(String lessonId) async => words;

  @override
  Future<WordDto> addWord(String lessonId, AddWordRequest request) async =>
      throw UnimplementedError();

  @override
  Future<WordDto> updateWord(String wordId, UpdateWordRequest request) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteWord(String wordId) async {}
}
