// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_capture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrCaptureControllerHash() =>
    r'94ee482ee02cb7dc084fc793017fd62796c372af';

/// Ekran A iş akışını yönetir: foto seç → temizle → ML Kit tarama → AI zenginleştirme.
///
/// `scan()` önce bulut AI'yı dener; hata/503/çevrimdışı veya boş sonuçta yerel
/// ML Kit ayrıştırma sonucuna düşer (mevcut davranış korunur). OCR tanıma daima
/// cihaz-içidir; yalnızca zenginleştirme (anlam/eşanlam) buluttadır.
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
