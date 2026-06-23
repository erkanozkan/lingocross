// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordFormControllerHash() =>
    r'dfda3e10f020c1c94e1bc5e67f2608ed9a74a80f';

/// Kelime ekle/güncelle/sil mutasyonları (manuel giriş, source=Manual).
///
/// State `AsyncValue<void>`: idle/submitting/error. Başarıda ilgili dersin
/// kelime listesi ve ders listesi (wordCount değişir) invalidate edilir.
///
/// Copied from [WordFormController].
@ProviderFor(WordFormController)
final wordFormControllerProvider =
    AutoDisposeAsyncNotifierProvider<WordFormController, void>.internal(
      WordFormController.new,
      name: r'wordFormControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$wordFormControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WordFormController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
