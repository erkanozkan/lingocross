// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollments_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$enrollmentsNotifierHash() =>
    r'02b1ebe46ae702aad9eee94d8bc37a2b4e26b328';

/// Oturum açan kullanıcının eşleşmelerini yöneten async notifier
/// (`GET /api/enrollments`). Öğrenci dalında counterpart = öğretmen.
///
/// Yalnız **Active** eşleşmeler ürün açısından anlamlıdır (doğrudan-Active
/// kararı). [activeTeacherIds] / [teacherNameById] türetilmiş yardımcılarla
/// öğrenci panelinde ders ↔ öğretmen adı eşlemesi yapılır.
///
/// Copied from [EnrollmentsNotifier].
@ProviderFor(EnrollmentsNotifier)
final enrollmentsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  EnrollmentsNotifier,
  List<EnrollmentDto>
>.internal(
  EnrollmentsNotifier.new,
  name: r'enrollmentsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$enrollmentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EnrollmentsNotifier = AutoDisposeAsyncNotifier<List<EnrollmentDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
