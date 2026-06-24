import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/result_dtos.dart';
import '../data/results_repository.dart';
import '../domain/results_failure.dart';

part 'result_report_controller.freezed.dart';
part 'result_report_controller.g.dart';

/// "Öğretmene Gönder" paylaşım durumu (game-result-report.md §6).
enum ShareStatus { idle, sending, shared, error }

/// Oyun Sonu Raporu ekranının durumu: rapor verisi + paylaşım alt-durumu.
@freezed
class ResultReportState with _$ResultReportState {
  const factory ResultReportState({
    required AsyncValue<GameResultDto> result,
    @Default(ShareStatus.idle) ShareStatus shareStatus,
  }) = _ResultReportState;
}

/// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
///
/// İki giriş yolu:
/// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz).
/// - **Geçmiş:** ekran yalnız `resultId` ile açılır; rapor `GET /results/me`'den
///   bulunur (ayrı `GET /results/{id}` ucu yok — M5 sözleşmesi).
///
/// Paylaşım tek-yön kilitlidir: `sharedWithTeacher` true ise doğrudan
/// [ShareStatus.shared] gösterilir; başarılı paylaşımdan sonra geri alınamaz.
@riverpod
class ResultReportController extends _$ResultReportController {
  @override
  ResultReportState build(String resultId) {
    // Varsayılan: rapor henüz yok → yükleniyor (ekran seed eder ya da yükler).
    return const ResultReportState(result: AsyncValue.loading());
  }

  /// Oyun-sonu yolunda zaten elde olan sonucu yerleştirir (ağ çağrısı yok).
  void seed(GameResultDto result) {
    state = ResultReportState(
      result: AsyncValue.data(result),
      shareStatus:
          result.sharedWithTeacher ? ShareStatus.shared : ShareStatus.idle,
    );
  }

  /// Geçmiş yolunda: `GET /results/me`'den `resultId`'yi bulup yükler.
  Future<void> load() async {
    state = state.copyWith(result: const AsyncValue.loading());
    final loaded = await AsyncValue.guard(() async {
      final repo = ref.read(resultsRepositoryProvider);
      final all = await repo.listMine();
      final match = all.where((r) => r.id == resultId).firstOrNull;
      if (match == null) throw const ResultsFailure.notFound();
      return match;
    });
    state = state.copyWith(
      result: loaded,
      shareStatus:
          loaded.valueOrNull?.sharedWithTeacher == true
              ? ShareStatus.shared
              : state.shareStatus,
    );
  }

  /// "Öğretmene Gönder" — paylaşımı tetikler. Tek-yön kilit: paylaşılmışsa veya
  /// gönderim sürüyorsa no-op. Hata → [ShareStatus.error] (idle'a dönüp tekrar
  /// denenebilir; ekran kısa toast gösterir).
  Future<void> share() async {
    final current = state.result.valueOrNull;
    if (current == null) return;
    if (state.shareStatus == ShareStatus.sending ||
        state.shareStatus == ShareStatus.shared) {
      return;
    }

    state = state.copyWith(shareStatus: ShareStatus.sending);
    try {
      final repo = ref.read(resultsRepositoryProvider);
      final updated = await repo.share(current.id);
      state = ResultReportState(
        result: AsyncValue.data(updated),
        shareStatus: ShareStatus.shared,
      );
    } on ResultsFailure {
      // Tekrar denenebilir → idle'a dön, ekran error toast gösterir.
      state = state.copyWith(shareStatus: ShareStatus.error);
    }
  }

  /// Hata toast'ı gösterildikten sonra paylaş butonunu yeniden idle yapar.
  void acknowledgeShareError() {
    if (state.shareStatus == ShareStatus.error) {
      state = state.copyWith(shareStatus: ShareStatus.idle);
    }
  }
}
