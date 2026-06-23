import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/lesson_dtos.dart';
import '../data/lessons_repository.dart';

part 'lessons_notifier.g.dart';

/// Öğretmenin ders listesini yöneten async notifier (`GET /lessons`).
///
/// Ekran `AsyncValue` üzerinden loading/error/data durumlarını çözer.
/// Yaratma/güncelleme/silme sonrası [refresh] ile yeniden yüklenir.
@riverpod
class LessonsNotifier extends _$LessonsNotifier {
  @override
  Future<List<LessonDto>> build() {
    return ref.watch(lessonsRepositoryProvider).listLessons();
  }

  /// Pull-to-refresh / mutasyon sonrası listeyi yeniden yükler.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(lessonsRepositoryProvider).listLessons(),
    );
  }
}

/// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
@riverpod
Future<LessonDto> lesson(Ref ref, String lessonId) {
  return ref.watch(lessonsRepositoryProvider).getLesson(lessonId);
}
