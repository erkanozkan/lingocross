// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_teacher_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinTeacherControllerHash() =>
    r'75db350782e8ede53fc3a9d0431dc8abb18a17de';

/// "Öğretmene Katıl" akışının tek seferlik gönderim durumu.
///
/// Katılım **doğrudan Active** (onay/pending UI yok). API idempotent: zaten
/// kayıtlı (409) → repository başarı (mevcut kayıt) döndürür; burada da başarı
/// gibi ele alınır.
///
/// Copied from [JoinTeacherController].
@ProviderFor(JoinTeacherController)
final joinTeacherControllerProvider = AutoDisposeNotifierProvider<
  JoinTeacherController,
  AsyncValue<EnrollmentDto?>
>.internal(
  JoinTeacherController.new,
  name: r'joinTeacherControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$joinTeacherControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinTeacherController =
    AutoDisposeNotifier<AsyncValue<EnrollmentDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
