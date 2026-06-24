// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_result_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentResultDetailNotifierHash() =>
    r'0612b3414ef6e15ad8012d957a3c50c1e3447f23';

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

abstract class _$StudentResultDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<StudentResultDetailDto> {
  late final String studentId;
  late final String resultId;

  FutureOr<StudentResultDetailDto> build(String studentId, String resultId);
}

/// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
/// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
///
/// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultDetailNotifier].
@ProviderFor(StudentResultDetailNotifier)
const studentResultDetailNotifierProvider = StudentResultDetailNotifierFamily();

/// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
/// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
///
/// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultDetailNotifier].
class StudentResultDetailNotifierFamily
    extends Family<AsyncValue<StudentResultDetailDto>> {
  /// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
  /// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
  ///
  /// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
  /// durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultDetailNotifier].
  const StudentResultDetailNotifierFamily();

  /// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
  /// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
  ///
  /// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
  /// durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultDetailNotifier].
  StudentResultDetailNotifierProvider call(String studentId, String resultId) {
    return StudentResultDetailNotifierProvider(studentId, resultId);
  }

  @override
  StudentResultDetailNotifierProvider getProviderOverride(
    covariant StudentResultDetailNotifierProvider provider,
  ) {
    return call(provider.studentId, provider.resultId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'studentResultDetailNotifierProvider';
}

/// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
/// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
///
/// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
/// durumları ekranda `AsyncValue` ile ele alınır.
///
/// Copied from [StudentResultDetailNotifier].
class StudentResultDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          StudentResultDetailNotifier,
          StudentResultDetailDto
        > {
  /// Bir öğrencinin tek bir sonucunun kelime-bazlı detayı (F7.5)
  /// (`GET /teachers/me/students/{studentId}/results/{resultId}`).
  ///
  /// `studentId` + `resultId` ile parametrelendirilir. Boş/yükleniyor/hata
  /// durumları ekranda `AsyncValue` ile ele alınır.
  ///
  /// Copied from [StudentResultDetailNotifier].
  StudentResultDetailNotifierProvider(String studentId, String resultId)
    : this._internal(
        () =>
            StudentResultDetailNotifier()
              ..studentId = studentId
              ..resultId = resultId,
        from: studentResultDetailNotifierProvider,
        name: r'studentResultDetailNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$studentResultDetailNotifierHash,
        dependencies: StudentResultDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            StudentResultDetailNotifierFamily._allTransitiveDependencies,
        studentId: studentId,
        resultId: resultId,
      );

  StudentResultDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
    required this.resultId,
  }) : super.internal();

  final String studentId;
  final String resultId;

  @override
  FutureOr<StudentResultDetailDto> runNotifierBuild(
    covariant StudentResultDetailNotifier notifier,
  ) {
    return notifier.build(studentId, resultId);
  }

  @override
  Override overrideWith(StudentResultDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: StudentResultDetailNotifierProvider._internal(
        () =>
            create()
              ..studentId = studentId
              ..resultId = resultId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
        resultId: resultId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    StudentResultDetailNotifier,
    StudentResultDetailDto
  >
  createElement() {
    return _StudentResultDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StudentResultDetailNotifierProvider &&
        other.studentId == studentId &&
        other.resultId == resultId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);
    hash = _SystemHash.combine(hash, resultId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StudentResultDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<StudentResultDetailDto> {
  /// The parameter `studentId` of this provider.
  String get studentId;

  /// The parameter `resultId` of this provider.
  String get resultId;
}

class _StudentResultDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          StudentResultDetailNotifier,
          StudentResultDetailDto
        >
    with StudentResultDetailNotifierRef {
  _StudentResultDetailNotifierProviderElement(super.provider);

  @override
  String get studentId =>
      (origin as StudentResultDetailNotifierProvider).studentId;
  @override
  String get resultId =>
      (origin as StudentResultDetailNotifierProvider).resultId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
