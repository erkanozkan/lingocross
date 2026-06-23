// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_capture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrCaptureControllerHash() =>
    r'6ebbab568e27a9c61ab0b24f5e9bae6d219052e2';

/// Ekran A iş akışını yönetir: foto seç → temizle → ML Kit tarama.
///
/// Tarama sonucu (kelime adayları) `scan()` döndürür; ekran sonucu Ekran B'ye
/// taşır. OCR tamamen cihaz-içidir.
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
