import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ai_exam_repository.dart';
import '../data/dtos/ai_exam_dtos.dart';
import '../data/games_repository.dart';

part 'ai_exam_controller.g.dart';

/// Yapay zekâ ile sınav soruları üretme akışının üretim durumu
/// (`POST /lessons/{id}/ai-questions`).
///
/// Yükleme ekranı [AsyncValue.loading]'i; review ekranı başarıda dönen
/// [AiExamResultDto]'yu gösterir. Hata [AsyncError] (GamesFailure) olarak
/// taşınır; config ekranı i18n metnine çevirir (yetersiz kelime / AI kapalı /
/// ağ). Başlangıç durumu `data(null)`.
@riverpod
class AiExamController extends _$AiExamController {
  @override
  AsyncValue<AiExamResultDto?> build() => const AsyncValue.data(null);

  /// [lessonId] dersinden [grade] seviyesinde [count] adet [types] türünde soru
  /// üretir. Başarıda sonucu döner, aksi halde `null` (state `AsyncError`).
  Future<AiExamResultDto?> generate({
    required String lessonId,
    required int grade,
    required int count,
    required List<String> types,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(aiExamRepositoryProvider);
      return repo.generate(
        lessonId,
        AiExamGenerateRequest(grade: grade, count: count, types: types),
      );
    });
    state = result;
    return result.valueOrNull;
  }
}

/// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
/// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
/// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
/// yapılır.
@riverpod
class AiExamReviewController extends _$AiExamReviewController {
  /// Review ekranı, üretim sonucunu [seed] ile besler.
  @override
  AiExamResultDto build(AiExamResultDto seed) => seed;

  /// Bir soruyu sunucudan siler ve başarıda listeden düşürür. Hata fırlatırsa
  /// (GamesFailure) ekran yakalar; liste değişmez.
  Future<void> deleteQuestion(String questionId) async {
    final repo = ref.read(aiExamRepositoryProvider);
    await repo.deleteQuestion(state.topicId, questionId);
    state = state.copyWith(
      questions:
          state.questions.where((q) => q.id != questionId).toList(growable: false),
    );
  }

  /// Konuyu (üretilen seti) [classIds] sınıflarına atar.
  Future<void> assign(List<String> classIds) async {
    final repo = ref.read(gamesRepositoryProvider);
    await repo.setTopicAssignments(state.topicId, classIds);
  }
}
