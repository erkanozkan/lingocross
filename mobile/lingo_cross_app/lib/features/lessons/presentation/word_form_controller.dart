import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/word_dtos.dart';
import '../data/lessons_repository.dart';
import 'lessons_notifier.dart';
import 'words_notifier.dart';

part 'word_form_controller.g.dart';

/// Kelime ekle/güncelle/sil mutasyonları (manuel giriş, source=Manual).
///
/// State `AsyncValue<void>`: idle/submitting/error. Başarıda ilgili dersin
/// kelime listesi ve ders listesi (wordCount değişir) invalidate edilir.
@riverpod
class WordFormController extends _$WordFormController {
  @override
  Future<void> build() async {}

  LessonsRepository get _repo => ref.read(lessonsRepositoryProvider);

  void _invalidate(String lessonId) {
    ref.invalidate(wordsNotifierProvider(lessonId));
    ref.invalidate(lessonsNotifierProvider);
  }

  /// Yeni kelime ekler. Başarıda eklenen kelimeyi döndürür (null = hata).
  Future<WordDto?> add(String lessonId, AddWordRequest request) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.addWord(lessonId, request));
    state = result.whenData((_) {});
    if (result.hasError) return null;
    _invalidate(lessonId);
    return result.value;
  }

  /// Kelimeyi günceller. Başarıda güncel kelimeyi döndürür (null = hata).
  Future<WordDto?> submitUpdate(
    String lessonId,
    String wordId,
    UpdateWordRequest request,
  ) async {
    state = const AsyncValue.loading();
    final result =
        await AsyncValue.guard(() => _repo.updateWord(wordId, request));
    state = result.whenData((_) {});
    if (result.hasError) return null;
    _invalidate(lessonId);
    return result.value;
  }

  /// Kelimeyi siler. true = başarı.
  Future<bool> delete(String lessonId, String wordId) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _repo.deleteWord(wordId));
    state = result.whenData((_) {});
    if (result.hasError) return false;
    _invalidate(lessonId);
    return true;
  }
}
