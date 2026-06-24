// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$classDetailNotifierHash() =>
    r'08624532c1d9f7a96e240c42e9d326b6fe48e597';

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

abstract class _$ClassDetailNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ClassDetailDto> {
  late final String classId;

  FutureOr<ClassDetailDto> build(String classId);
}

/// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
/// (`GET /api/classes/{id}`), classId'ye göre family.
///
/// Copied from [ClassDetailNotifier].
@ProviderFor(ClassDetailNotifier)
const classDetailNotifierProvider = ClassDetailNotifierFamily();

/// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
/// (`GET /api/classes/{id}`), classId'ye göre family.
///
/// Copied from [ClassDetailNotifier].
class ClassDetailNotifierFamily extends Family<AsyncValue<ClassDetailDto>> {
  /// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
  /// (`GET /api/classes/{id}`), classId'ye göre family.
  ///
  /// Copied from [ClassDetailNotifier].
  const ClassDetailNotifierFamily();

  /// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
  /// (`GET /api/classes/{id}`), classId'ye göre family.
  ///
  /// Copied from [ClassDetailNotifier].
  ClassDetailNotifierProvider call(String classId) {
    return ClassDetailNotifierProvider(classId);
  }

  @override
  ClassDetailNotifierProvider getProviderOverride(
    covariant ClassDetailNotifierProvider provider,
  ) {
    return call(provider.classId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'classDetailNotifierProvider';
}

/// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
/// (`GET /api/classes/{id}`), classId'ye göre family.
///
/// Copied from [ClassDetailNotifier].
class ClassDetailNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ClassDetailNotifier,
          ClassDetailDto
        > {
  /// Bir sınıfın detayını (öğrenci listesi dâhil) yöneten async notifier
  /// (`GET /api/classes/{id}`), classId'ye göre family.
  ///
  /// Copied from [ClassDetailNotifier].
  ClassDetailNotifierProvider(String classId)
    : this._internal(
        () => ClassDetailNotifier()..classId = classId,
        from: classDetailNotifierProvider,
        name: r'classDetailNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$classDetailNotifierHash,
        dependencies: ClassDetailNotifierFamily._dependencies,
        allTransitiveDependencies:
            ClassDetailNotifierFamily._allTransitiveDependencies,
        classId: classId,
      );

  ClassDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.classId,
  }) : super.internal();

  final String classId;

  @override
  FutureOr<ClassDetailDto> runNotifierBuild(
    covariant ClassDetailNotifier notifier,
  ) {
    return notifier.build(classId);
  }

  @override
  Override overrideWith(ClassDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClassDetailNotifierProvider._internal(
        () => create()..classId = classId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        classId: classId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ClassDetailNotifier, ClassDetailDto>
  createElement() {
    return _ClassDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClassDetailNotifierProvider && other.classId == classId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClassDetailNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ClassDetailDto> {
  /// The parameter `classId` of this provider.
  String get classId;
}

class _ClassDetailNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ClassDetailNotifier,
          ClassDetailDto
        >
    with ClassDetailNotifierRef {
  _ClassDetailNotifierProviderElement(super.provider);

  @override
  String get classId => (origin as ClassDetailNotifierProvider).classId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
