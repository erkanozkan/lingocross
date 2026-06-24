// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_results_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentResultsNotifierHash() =>
    r'8b9ceda423eb826afef2154587904fa727878481';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$StudentResultsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<SharedResultDto>> {
  late final String studentId;

  FutureOr<List<SharedResultDto>> build(String studentId);
}

/// Bir öğrencinin öğretmenle paylaştığı sonuçlar
/// (`GET /teachers/me/students/{studentId}/results`).
///
/// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
/// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultsNotifier].
@ProviderFor(StudentResultsNotifier)
const studentResultsNotifierProvider = StudentResultsNotifierFamily();

/// Bir öğrencinin öğretmenle paylaştığı sonuçlar
/// (`GET /teachers/me/students/{studentId}/results`).
///
/// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
/// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultsNotifier].
class StudentResultsNotifierFamily
    extends Family<AsyncValue<List<SharedResultDto>>> {
  /// Bir öğrencinin öğretmenle paylaştığı sonuçlar
  /// (`GET /teachers/me/students/{studentId}/results`).
  ///
  /// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
  /// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultsNotifier].
  const StudentResultsNotifierFamily();

  /// Bir öğrencinin öğretmenle paylaştığı sonuçlar
  /// (`GET /teachers/me/students/{studentId}/results`).
  ///
  /// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
  /// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultsNotifier].
  StudentResultsNotifierProvider call(String studentId) {
    return StudentResultsNotifierProvider(studentId);
  }

  @override
  StudentResultsNotifierProvider getProviderOverride(
    covariant StudentResultsNotifierProvider provider,
  ) {
    return call(provider.studentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'studentResultsNotifierProvider';
}

/// Bir öğrencinin öğretmenle paylaştığı sonuçlar
/// (`GET /teachers/me/students/{studentId}/results`).
///
/// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
/// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultsNotifier].
class StudentResultsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          StudentResultsNotifier,
          List<SharedResultDto>
        > {
  /// Bir öğrencinin öğretmenle paylaştığı sonuçlar
  /// (`GET /teachers/me/students/{studentId}/results`).
  ///
  /// `studentId` ile parametrelendirilir. En yeni → en eski sıralı (repository
  /// sıralar). Boş/yükleniyor/hata durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultsNotifier].
  StudentResultsNotifierProvider(String studentId)
    : this._internal(
        () => StudentResultsNotifier()..studentId = studentId,
        from: studentResultsNotifierProvider,
        name: r'studentResultsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$studentResultsNotifierHash,
        dependencies: StudentResultsNotifierFamily._dependencies,
        allTransitiveDependencies:
            StudentResultsNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  StudentResultsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
  }) : super.internal();

  final String studentId;

  @override
  FutureOr<List<SharedResultDto>> runNotifierBuild(
    covariant StudentResultsNotifier notifier,
  ) {
    return notifier.build(studentId);
  }

  @override
  Override overrideWith(StudentResultsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StudentResultsNotifierProvider._internal(
        () => create()..studentId = studentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    StudentResultsNotifier,
    List<SharedResultDto>
  >
  createElement() {
    return _StudentResultsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentResultsNotifierProvider &&
        other.studentId == studentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StudentResultsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<SharedResultDto>> {
  /// The parameter `studentId` of this provider.
  String get studentId;
}

class _StudentResultsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          StudentResultsNotifier,
          List<SharedResultDto>
        >
    with StudentResultsNotifierRef {
  _StudentResultsNotifierProviderElement(super.provider);

  @override
  String get studentId => (origin as StudentResultsNotifierProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
