import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/word_dtos.dart';
import '../data/lessons_repository.dart';

part 'words_notifier.g.dart';

/// Bir dersin kelime listesini yöneten async notifier
/// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
@riverpod
class WordsNotifier extends _$WordsNotifier {
  @override
  Future<List<WordDto>> build(String lessonId) {
    return ref.watch(lessonsRepositoryProvider).listWords(lessonId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(lessonsRepositoryProvider).listWords(lessonId),
    );
  }
}
