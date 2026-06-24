import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ocr_enrichment_repository.dart';
import '../data/ocr_service.dart';
import '../domain/ocr_line_parser.dart';

part 'ocr_capture_controller.g.dart';

/// Yakalama ekranı (Ekran A) durumu: seçilen foto + tarama durumu.
///
/// [scanning] ML Kit cihaz-içi tanıma; [enriching] bulut AI zenginleştirmesi
/// (kullanıcıya "Yapay zeka ile düzeltiliyor…" gösterilir).
enum OcrCapturePhase { idle, scanning, enriching }

class OcrCaptureState {
  const OcrCaptureState({
    this.imagePath,
    this.phase = OcrCapturePhase.idle,
    this.permissionError = false,
  });

  /// Seçilmiş fotoğrafın yolu; yoksa idle tetikleyici gösterilir.
  final String? imagePath;
  final OcrCapturePhase phase;

  /// Görüntü seçimi izin/erişim hatası ile başarısız oldu.
  final bool permissionError;

  bool get hasImage => imagePath != null;
  bool get isScanning => phase == OcrCapturePhase.scanning;
  bool get isEnriching => phase == OcrCapturePhase.enriching;

  /// ML Kit tarama VEYA AI zenginleştirme sürüyor → ekran kilitli/yükleniyor.
  bool get isBusy => phase != OcrCapturePhase.idle;

  OcrCaptureState copyWith({
    String? imagePath,
    bool clearImage = false,
    OcrCapturePhase? phase,
    bool? permissionError,
  }) {
    return OcrCaptureState(
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      phase: phase ?? this.phase,
      permissionError: permissionError ?? this.permissionError,
    );
  }
}

/// `scan()` sonucu: gözden geçirmeye taşınacak adaylar + AI kullanılıp
/// kullanılmadığı (UI bilgi metni için).
class OcrScanResult {
  const OcrScanResult({required this.candidates, required this.enriched});

  final List<OcrCandidate> candidates;

  /// true → bulut AI zenginleştirmesi başarıyla uygulandı; false → yerel fallback.
  final bool enriched;
}

/// Ekran A iş akışını yönetir: foto seç → temizle → ML Kit tarama → AI zenginleştirme.
///
/// `scan()` önce bulut AI'yı dener; hata/503/çevrimdışı veya boş sonuçta yerel
/// ML Kit ayrıştırma sonucuna düşer (mevcut davranış korunur). OCR tanıma daima
/// cihaz-içidir; yalnızca zenginleştirme (anlam/eşanlam) buluttadır.
@riverpod
class OcrCaptureController extends _$OcrCaptureController {
  @override
  OcrCaptureState build() => const OcrCaptureState();

  OcrService get _service => ref.read(ocrServiceProvider);

  OcrEnrichmentRepository get _enrichment =>
      ref.read(ocrEnrichmentRepositoryProvider);

  /// Kamera/galeriden foto seçer. Başarıda state'e yazar; iptal no-op.
  /// İzin/erişim hatasında [OcrCaptureState.permissionError] true olur.
  Future<void> pick(OcrImageSource source) async {
    state = state.copyWith(permissionError: false);
    try {
      final path = await _service.pickImage(source);
      if (path != null) {
        state = state.copyWith(imagePath: path, permissionError: false);
      }
    } on PickImageException {
      state = state.copyWith(permissionError: true);
    }
  }

  void clearImage() {
    state = state.copyWith(clearImage: true, phase: OcrCapturePhase.idle);
  }

  /// Seçili fotoyu tarar; önce bulut AI ile zenginleştirmeyi dener, başarısızsa
  /// yerel ML Kit adaylarına düşer. Foto yoksa null.
  ///
  /// ML Kit tanıma hata fırlatırsa çağıran yakalar (ekran hata durumuna geçer);
  /// state her durumda idle'a döner.
  ///
  /// [sourceLanguage]/[targetLanguage] ders dilleridir (ISO kodu); enrich
  /// isteğinin gövdesine konur.
  Future<OcrScanResult?> scan({
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final path = state.imagePath;
    if (path == null) return null;
    state = state.copyWith(phase: OcrCapturePhase.scanning);
    try {
      // 1) Cihaz-içi ML Kit tanıma (her zaman çalışır; yerel fallback adayları).
      // Dil-yönü düzeltmesi dersin kaynak/hedef çiftine göre yapılır (F9.2).
      final recognition = await _service.recognize(
        path,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );

      // 2) Bulut AI zenginleştirme dene. Hata/503/boş → null → yerel fallback.
      state = state.copyWith(phase: OcrCapturePhase.enriching);
      final enrichedWords = await _enrichment.enrich(
        rawText: recognition.rawText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );

      if (enrichedWords != null) {
        return OcrScanResult(
          candidates: enrichedWordsToCandidates(enrichedWords),
          enriched: true,
        );
      }
      // Yerel fallback (mevcut davranış aynen).
      return OcrScanResult(
        candidates: recognition.candidates,
        enriched: false,
      );
    } finally {
      state = state.copyWith(phase: OcrCapturePhase.idle);
    }
  }
}
