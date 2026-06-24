// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_class_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createClassControllerHash() =>
    r'02c116d6d984256a18f8bb5d440155159bd9edc0';

/// "Yeni Sınıf Oluştur" akışının tek seferlik gönderim durumu
/// (`POST /api/classes`).
///
/// Copied from [CreateClassController].
@ProviderFor(CreateClassController)
final createClassControllerProvider = AutoDisposeNotifierProvider<
  CreateClassController,
  AsyncValue<ClassDto?>
>.internal(
  CreateClassController.new,
  name: r'createClassControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createClassControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateClassController = AutoDisposeNotifier<AsyncValue<ClassDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
