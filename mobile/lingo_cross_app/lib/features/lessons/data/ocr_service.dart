import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/ocr_line_parser.dart';
import 'ocr_language_orienter.dart';

/// Görüntü kaynağı (yakalama ekranındaki kaynak seçici ile eşleşir).
enum OcrImageSource { camera, gallery }

/// Görüntü seçimi + cihaz-içi ML Kit metin tanımayı sarmalayan servis.
///
/// OCR tamamen istemci tarafında çalışır (ağ yok). Kamera emülatörde
/// bulunmayabilir → galeri birinci sınıf alternatiftir (ux-spec §5).
class OcrService {
  OcrService({
    ImagePicker? picker,
    TextRecognizer? recognizer,
    OcrLanguageOrienter? orienter,
  })  : _picker = picker ?? ImagePicker(),
        _recognizer =
            recognizer ?? TextRecognizer(script: TextRecognitionScript.latin),
        _orienter = orienter ?? OcrLanguageOrienter();

  final ImagePicker _picker;
  final TextRecognizer _recognizer;
  final OcrLanguageOrienter _orienter;

  /// Seçilen görüntünün dosya yolunu döndürür; kullanıcı iptal ederse null.
  ///
  /// İzin reddi/donanım eksikliği [PickImageException] olarak fırlatılır.
  Future<String?> pickImage(OcrImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source == OcrImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 90,
      );
      return file?.path;
    } catch (e) {
      throw PickImageException(e.toString());
    }
  }

  /// Verilen görüntü dosyasını cihaz-içi ML Kit ile tanır, ham satırlara böler,
  /// [parseOcrLines] ile kelime adaylarına dönüştürür ve son olarak cihaz-içi
  /// dil tespiti ([OcrLanguageOrienter]) ile terim/karşılık yönünü düzeltir.
  Future<List<OcrCandidate>> recognize(String imagePath) async {
    final input = InputImage.fromFile(File(imagePath));
    final result = await _recognizer.processImage(input);
    final rawLines = <String>[
      for (final block in result.blocks)
        for (final line in block.lines) line.text,
    ];
    final candidates = parseOcrLines(rawLines);
    return _orienter.orient(candidates);
  }

  void dispose() {
    _recognizer.close();
    _orienter.dispose();
  }
}

/// Görüntü seçimi sırasında oluşan hata (izin reddi, kamera yok vb.).
class PickImageException implements Exception {
  PickImageException(this.message);

  final String message;

  @override
  String toString() => 'PickImageException: $message';
}

final ocrServiceProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(service.dispose);
  return service;
});
