import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';

part 'question_topics_notifier.g.dart';

/// Öğretmenin atayabileceği Çıkmış Sorular konularını yöneten async notifier
/// (`GET /api/question-topics`).
@riverpod
class QuestionTopicsNotifier extends _$QuestionTopicsNotifier {
  @override
  Future<List<QuestionTopicDto>> build() {
    return ref.watch(gamesRepositoryProvider).listQuestionTopics();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gamesRepositoryProvider).listQuestionTopics(),
    );
  }
}

/// Bir konunun mevcut sınıf atamalarını döndüren provider
/// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
/// ön-seçimi doldurmak için kullanılır.
@riverpod
Future<GameAssignmentsDto> topicAssignments(
  Ref ref,
  String topicId,
) {
  return ref.watch(gamesRepositoryProvider).getTopicAssignments(topicId);
}

/// Bir konunun sınıf atamalarını kaydetme akışı (`POST .../assignments`).
///
/// Başarıda dönen [GameAssignmentsDto] döner; hata [state]'e `AsyncError`
/// (GamesFailure) olarak taşınır — ekran i18n metnine çevirir.
@riverpod
class SetTopicAssignmentsController extends _$SetTopicAssignmentsController {
  @override
  AsyncValue<GameAssignmentsDto?> build() => const AsyncValue.data(null);

  /// [topicId] konusunu [classIds] sınıflarına atar (boş liste atamayı kaldırır).
  /// Başarıda atama özetini döner, aksi halde `null` (state `AsyncError`).
  Future<GameAssignmentsDto?> setAssignments({
    required String topicId,
    required List<String> classIds,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(gamesRepositoryProvider);
      return repo.setTopicAssignments(topicId, classIds);
    });
    state = result;
    return result.valueOrNull;
  }
}
