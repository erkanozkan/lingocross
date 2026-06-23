import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/lesson_dtos.dart';
import '../data/lessons_repository.dart';
import 'lessons_notifier.dart';

part 'lesson_form_controller.g.dart';

/// Ders oluştur/güncelle/sil/yayınla mutasyonlarını yürüten controller.
///
/// State `AsyncValue<void>`: idle (`data`), submitting (`loading`), error.
/// Başarıda liste provider'ı invalidate edilerek dashboard tazelenir.
@riverpod
class LessonFormController extends _$LessonFormController {
  @override
  Future<void> build() async {}

  LessonsRepository get _repo => ref.read(lessonsRepositoryProvider);

  /// Yeni ders oluşturur; başarıda oluşturulan dersi döndürür (null = hata).
  Future<LessonDto?> create(CreateLessonRequest request) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.createLesson(request));
    state = result.whenData((_) {});
    if (result.hasError) return null;
    ref.invalidate(lessonsNotifierProvider);
    return result.value;
  }

  /// Mevcut dersi günceller; başarıda güncel dersi döndürür (null = hata).
  Future<LessonDto?> submitUpdate(String id, UpdateLessonRequest request) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.updateLesson(id, request));
    state = result.whenData((_) {});
    if (result.hasError) return null;
    ref.invalidate(lessonsNotifierProvider);
    ref.invalidate(lessonProvider(id));
    return result.value;
  }

  /// Dersi yayınlar (`POST /lessons/{id}/publish`).
  Future<LessonDto?> publish(String id) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.publishLesson(id));
    state = result.whenData((_) {});
    if (result.hasError) return null;
    ref.invalidate(lessonsNotifierProvider);
    ref.invalidate(lessonProvider(id));
    return result.value;
  }

  /// Dersi siler. true = başarı.
  Future<bool> delete(String id) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.deleteLesson(id));
    state = result.whenData((_) {});
    if (result.hasError) return false;
    ref.invalidate(lessonsNotifierProvider);
    return true;
  }
}
