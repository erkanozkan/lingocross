// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_capture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrCaptureControllerHash() =>
    r'95dcf0c38021baf87e559967c3d708fd81ad9aaf';

/// Ekran A iş akışını yönetir: foto seç → temizle → görüntüyü bulut AI'ya
/// gönderip kelimeleri çıkar.
///
/// `scan()` görüntüyü base64'e kodlar ve `/api/ocr/enrich`'e gönderir; başarıda
/// kelime adaylarını döndürür. Hata/503/çevrimdışı/boş sonuç → çağıran taraf
/// hata/boş durumu gösterir.
///
/// Copied from [OcrCaptureController].
@ProviderFor(OcrCaptureController)
final ocrCaptureControllerProvider =
    AutoDisposeNotifierProvider<OcrCaptureController, OcrCaptureState>.internal(
      OcrCaptureController.new,
      name: r'ocrCaptureControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ocrCaptureControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OcrCaptureController = AutoDisposeNotifier<OcrCaptureState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
