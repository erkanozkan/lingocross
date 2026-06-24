import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/result_dtos.dart';
import '../data/results_repository.dart';
import '../domain/results_failure.dart';

part 'result_report_controller.freezed.dart';
part 'result_report_controller.g.dart';

/// Oyun Sonu Raporu ekranının durumu: rapor verisi.
///
/// Paylaşım artık otomatiktir (submit `sharedWithTeacher = true` döner); ekranda
/// elle "Öğretmene Gönder" akışı yoktur, yalnız bilgi notu gösterilir.
@freezed
class ResultReportState with _$ResultReportState {
  const factory ResultReportState({
    required AsyncValue<GameResultDto> result,
  }) = _ResultReportState;
}

/// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
///
/// İki giriş yolu:
/// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
/// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
///   sözleşmesi).
@riverpod
class ResultReportController extends _$ResultReportController {
  @override
  ResultReportState build(String resultId) {
    // Varsayılan: rapor henüz yok → yükleniyor (ekran seed eder ya da yükler).
    return const ResultReportState(result: AsyncValue.loading());
  }

  /// Oyun-sonu yolunda zaten elde olan sonucu yerleştirir (ağ çağrısı yok).
  void seed(GameResultDto result) {
    state = ResultReportState(result: AsyncValue.data(result));
  }

  /// Geçmiş/tamamlanan yolunda: `GET /results/me`'den `resultId`'yi bulup yükler.
  Future<void> load() async {
    state = state.copyWith(result: const AsyncValue.loading());
    final loaded = await AsyncValue.guard(() async {
      final repo = ref.read(resultsRepositoryProvider);
      final all = await repo.listMine();
      final match = all.where((r) => r.id == resultId).firstOrNull;
      if (match == null) throw const ResultsFailure.notFound();
      return match;
    });
    state = state.copyWith(result: loaded);
  }
}
