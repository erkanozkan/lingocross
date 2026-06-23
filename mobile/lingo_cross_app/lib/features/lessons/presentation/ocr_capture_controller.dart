import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ocr_service.dart';
import '../domain/ocr_line_parser.dart';

part 'ocr_capture_controller.g.dart';

/// Yakalama ekranı (Ekran A) durumu: seçilen foto + tarama durumu.
enum OcrCapturePhase { idle, scanning }

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

/// Ekran A iş akışını yönetir: foto seç → temizle → ML Kit tarama.
///
/// Tarama sonucu (kelime adayları) `scan()` döndürür; ekran sonucu Ekran B'ye
/// taşır. OCR tamamen cihaz-içidir.
@riverpod
class OcrCaptureController extends _$OcrCaptureController {
  @override
  OcrCaptureState build() => const OcrCaptureState();

  OcrService get _service => ref.read(ocrServiceProvider);

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

  /// Seçili fotoyu ML Kit ile tarar; adayları döndürür. Foto yoksa null.
  /// Hata fırlatırsa çağıran yakalar (ekran hata durumuna geçer); state idle'a döner.
  Future<List<OcrCandidate>?> scan() async {
    final path = state.imagePath;
    if (path == null) return null;
    state = state.copyWith(phase: OcrCapturePhase.scanning);
    try {
      final candidates = await _service.recognize(path);
      return candidates;
    } finally {
      state = state.copyWith(phase: OcrCapturePhase.idle);
    }
  }
}
