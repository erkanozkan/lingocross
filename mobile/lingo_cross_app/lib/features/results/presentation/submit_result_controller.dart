import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/result_dtos.dart';
import '../data/results_repository.dart';

part 'submit_result_controller.g.dart';

/// Oyun bitince sonuç gönderim akışı (öğrenci).
///
/// `POST /game-sessions/{sessionId}/result` ile süre + doğru/toplam gönderir;
/// başarıda hesaplanmış [GameResultDto] döner (rapor ekranına taşınır). Hata
/// [ResultsFailure] olarak `AsyncError`'a taşınır (UI i18n metnine çevirir, tekrar
/// dene sunar).
@riverpod
class SubmitResultController extends _$SubmitResultController {
  @override
  AsyncValue<GameResultDto?> build() => const AsyncValue.data(null);

  /// Oturum sonucunu gönderir; başarıda sonucu döndürür, aksi halde [state]
  /// `AsyncError` olur ve `null` döner.
  Future<GameResultDto?> submit({
    required String sessionId,
    required int durationMs,
    required int totalItems,
    required int correctItems,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(resultsRepositoryProvider);
      return repo.submitResult(
        sessionId,
        SubmitResultRequest(
          durationMs: durationMs,
          totalItems: totalItems,
          correctItems: correctItems,
        ),
      );
    });
    state = result;
    return result.valueOrNull;
  }
}
