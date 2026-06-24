// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_class_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinClassControllerHash() =>
    r'85446f8502ad7d7ae8d486468fbe09659b100a15';

/// "Sınıfa Katıl" (öğrenci) akışının tek seferlik gönderim durumu
/// (`POST /api/classes/join`).
///
/// Geçersiz/arşivli kod backend'de 404 döner; repository bunu
/// [ClassesFailure.notFound]'a indirger. Katılma bağlamında bu, kullanıcı
/// açısından "geçersiz kod"tur; ekran her ikisini de geçersiz kod olarak gösterir.
///
/// Copied from [JoinClassController].
@ProviderFor(JoinClassController)
final joinClassControllerProvider = AutoDisposeNotifierProvider<
  JoinClassController,
  AsyncValue<ClassMembershipDto?>
>.internal(
  JoinClassController.new,
  name: r'joinClassControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$joinClassControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinClassController =
    AutoDisposeNotifier<AsyncValue<ClassMembershipDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
