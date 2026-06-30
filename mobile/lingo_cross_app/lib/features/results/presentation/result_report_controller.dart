import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/result_dtos.dart';
import '../data/results_repository.dart';
import '../domain/results_failure.dart';

part 'result_report_controller.freezed.dart';
part 'result_report_controller.g.dart';

/// Oyun Sonu Raporu ekranının durumu: özet rapor + kelime kırılımı.
///
/// Paylaşım artık otomatiktir (submit `sharedWithTeacher = true` döner); ekranda
/// elle "Öğretmene Gönder" akışı yoktur, yalnız bilgi notu gösterilir.
///
/// [result] özet (radyal/bento) için; [items] doğru/yanlış kırılımı. Kırılım
/// `GET /results/{id}`'den gelir; eski sonuçta boş döner → bölüm gizlenir.
/// Kırılımın yüklenmesi özeti BLOKLAMAZ (özet seed/listeden hemen gösterilir,
/// kırılım arka planda gelir; hata olursa bölüm sessizce gizli kalır).
@freezed
class ResultReportState with _$ResultReportState {
  const factory ResultReportState({
    required AsyncValue<GameResultDto> result,
    @Default(<ResultItemModel>[]) List<ResultItemModel> items,
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

  /// Oyun-sonu yolunda zaten elde olan sonucu yerleştirir (özet ağ çağrısı yok);
  /// kelime kırılımını arka planda `GET /results/{id}`'den çeker.
  void seed(GameResultDto result) {
    state = ResultReportState(result: AsyncValue.data(result));
    _loadBreakdown();
  }

  /// Geçmiş/tamamlanan yolunda: `GET /results/{id}` detayından özet + kırılımı
  /// birlikte yükler (detay ucu hem özeti hem item'ları döndürür). Detay ucu
  /// başarısız olursa özet için `GET /results/me` listesine düşülür (kırılımsız).
  Future<void> load() async {
    state = state.copyWith(result: const AsyncValue.loading());
    final repo = ref.read(resultsRepositoryProvider);
    final loaded = await AsyncValue.guard(() async {
      final detail = await repo.getResultDetail(resultId);
      return detail;
    });
    loaded.when(
      data: (detail) {
        state = state.copyWith(
          result: AsyncValue.data(detail.toSummary(sessionId: '')),
          items: detail.items,
        );
      },
      error: (error, st) => _loadSummaryFallback(error, st),
      loading: () {},
    );
  }

  /// Detay ucu (örn. 404/ağ) başarısızsa: özeti `GET /results/me`'den bul; yine
  /// bulunamazsa özgün hatayı yüzeye çıkar. Kırılım boş kalır (bölüm gizli).
  Future<void> _loadSummaryFallback(Object detailError, StackTrace st) async {
    final summary = await AsyncValue.guard(() async {
      final repo = ref.read(resultsRepositoryProvider);
      final all = await repo.listMine();
      final match = all.where((r) => r.id == resultId).firstOrNull;
      if (match == null) throw const ResultsFailure.notFound();
      return match;
    });
    state = summary.maybeWhen(
      data: (r) => state.copyWith(result: AsyncValue.data(r)),
      orElse: () => state.copyWith(result: AsyncValue.error(detailError, st)),
    );
  }

  /// Seed yolunda yalnız kelime kırılımını çeker; özeti etkilemez. Hata olursa
  /// kırılım boş kalır (bölüm gizlenir, özet bozulmaz).
  Future<void> _loadBreakdown() async {
    final loaded = await AsyncValue.guard(() async {
      final repo = ref.read(resultsRepositoryProvider);
      final detail = await repo.getResultDetail(resultId);
      return detail.items;
    });
    state = state.copyWith(items: loaded.valueOrNull ?? const []);
  }
}
