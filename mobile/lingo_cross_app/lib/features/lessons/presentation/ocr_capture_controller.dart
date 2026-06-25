import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ocr_enrichment_repository.dart';
import '../data/ocr_service.dart';
import '../domain/ocr_line_parser.dart';

part 'ocr_capture_controller.g.dart';

/// Yakalama ekranı (Ekran A) durumu: seçilen foto + işleme durumu.
///
/// [reading] seçilen görüntünün base64'e kodlanıp bulut AI'ya gönderildiği ve
/// kelimelerin çıkarıldığı aşamadır (kullanıcıya "Görüntü yapay zeka ile
/// okunuyor…" gösterilir). Cihaz-içi metin tanıma kaldırıldı.
enum OcrCapturePhase { idle, reading }

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

  /// Bulut AI görüntüyü okuyor → ekran kilitli/yükleniyor.
  bool get isReading => phase == OcrCapturePhase.reading;

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

/// `scan()` sonucu: gözden geçirmeye taşınacak adaylar.
class OcrScanResult {
  const OcrScanResult({required this.candidates});

  final List<OcrCandidate> candidates;
}

/// Ekran A iş akışını yönetir: foto seç → temizle → görüntüyü bulut AI'ya
/// gönderip kelimeleri çıkar.
///
/// `scan()` görüntüyü base64'e kodlar ve `/api/ocr/enrich`'e gönderir; başarıda
/// kelime adaylarını döndürür. Hata/503/çevrimdışı/boş sonuç → çağıran taraf
/// hata/boş durumu gösterir.
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

  /// Seçili fotoyu base64'e kodlayıp bulut AI'ya gönderir ve çıkarılan kelime
  /// adaylarını döndürür. Foto yoksa null.
  ///
  /// AI okuyamazsa (hata/503/çevrimdışı/boş) `null` döner. Kodlama hatası
  /// fırlatırsa çağıran yakalar; state her durumda idle'a döner.
  ///
  /// [sourceLanguage]/[targetLanguage] ders dilleridir (ISO kodu); enrich
  /// isteğinin gövdesine konur.
  Future<OcrScanResult?> scan({
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final path = state.imagePath;
    if (path == null) return null;
    state = state.copyWith(phase: OcrCapturePhase.reading);
    try {
      final payload = await _service.encode(path);
      final words = await _enrichment.enrich(
        imageBase64: payload.base64,
        mediaType: payload.mediaType,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
      if (words == null) return null;
      return OcrScanResult(candidates: enrichedWordsToCandidates(words));
    } finally {
      state = state.copyWith(phase: OcrCapturePhase.idle);
    }
  }
}
