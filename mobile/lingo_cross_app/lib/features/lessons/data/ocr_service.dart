import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Görüntü kaynağı (yakalama ekranındaki kaynak seçici ile eşleşir).
enum OcrImageSource { camera, gallery }

/// Kamera/galeriden görüntü seçimini sarmalayan servis.
///
/// Metin tanıma artık cihazda yapılmaz; seçilen görüntü base64'e kodlanıp
/// bulut AI görüntü-okuma uç noktasına (`POST /api/ocr/enrich`) gönderilir.
/// Bu servis yalnız görüntü seçimi + küçültme + kodlamadan sorumludur.
/// Kamera emülatörde bulunmayabilir → galeri birinci sınıf alternatiftir.
class OcrService {
  OcrService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Seçilen görüntünün dosya yolunu döndürür; kullanıcı iptal ederse null.
  ///
  /// Payload'ı küçük tutmak için kaynakta küçültülür (maxWidth ~1600,
  /// imageQuality ~70). İzin reddi/donanım eksikliği [PickImageException]
  /// olarak fırlatılır.
  Future<String?> pickImage(OcrImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source == OcrImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 70,
      );
      return file?.path;
    } catch (e) {
      throw PickImageException(e.toString());
    }
  }

  /// Görüntü dosyasını okuyup base64'e kodlar (bulut AI görüntü isteğine konur).
  ///
  /// Dosya okunamazsa/boşsa [PickImageException] fırlatır.
  Future<OcrImagePayload> encode(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      if (bytes.isEmpty) {
        throw PickImageException('empty image');
      }
      return OcrImagePayload(
        base64: base64Encode(bytes),
        mediaType: _mediaTypeFor(imagePath),
      );
    } on PickImageException {
      rethrow;
    } catch (e) {
      throw PickImageException(e.toString());
    }
  }
}

/// Dosya uzantısından MIME tipini belirler (image_picker genelde jpg üretir).
String _mediaTypeFor(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
  return 'image/jpeg';
}

/// Bulut AI görüntü-okuma isteğine gönderilecek kodlanmış görüntü.
class OcrImagePayload {
  const OcrImagePayload({required this.base64, required this.mediaType});

  /// Görüntünün base64 (data: öneki olmadan) gösterimi.
  final String base64;

  /// `image/jpeg`, `image/png` gibi MIME tipi.
  final String mediaType;
}

/// Görüntü seçimi/kodlaması sırasında oluşan hata (izin reddi, kamera yok vb.).
class PickImageException implements Exception {
  PickImageException(this.message);

  final String message;

  @override
  String toString() => 'PickImageException: $message';
}

final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrService();
});
