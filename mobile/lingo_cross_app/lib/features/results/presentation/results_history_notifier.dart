import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/result_dtos.dart';
import '../data/results_repository.dart';

part 'results_history_notifier.g.dart';

/// Öğrencinin geçmiş sonuçları (`GET /results/me`).
///
/// En yeni → en eski sıralı liste (repository sıralar). Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` üzerinden ele alınır.
@riverpod
class ResultsHistoryNotifier extends _$ResultsHistoryNotifier {
  @override
  Future<List<GameResultDto>> build() async {
    final repo = ref.read(resultsRepositoryProvider);
    return repo.listMine();
  }

  /// Listeyi yeniden yükler (pull-to-refresh / tekrar dene).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(resultsRepositoryProvider);
      return repo.listMine();
    });
  }
}
