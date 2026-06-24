// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_invite_code_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$classInviteCodeNotifierHash() =>
    r'955827dac59cc39a3a1b5144e4152b3e2b6915b1';

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

abstract class _$ClassInviteCodeNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ClassInviteCodeDto> {
  late final String classId;

  FutureOr<ClassInviteCodeDto> build(String classId);
}

/// Bir sınıfın davet kodunu yöneten async notifier
/// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
/// [regenerate] yeni kod üretir ve state'i günceller.
///
/// Copied from [ClassInviteCodeNotifier].
@ProviderFor(ClassInviteCodeNotifier)
const classInviteCodeNotifierProvider = ClassInviteCodeNotifierFamily();

/// Bir sınıfın davet kodunu yöneten async notifier
/// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
/// [regenerate] yeni kod üretir ve state'i günceller.
///
/// Copied from [ClassInviteCodeNotifier].
class ClassInviteCodeNotifierFamily
    extends Family<AsyncValue<ClassInviteCodeDto>> {
  /// Bir sınıfın davet kodunu yöneten async notifier
  /// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
  /// [regenerate] yeni kod üretir ve state'i günceller.
  ///
  /// Copied from [ClassInviteCodeNotifier].
  const ClassInviteCodeNotifierFamily();

  /// Bir sınıfın davet kodunu yöneten async notifier
  /// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
  /// [regenerate] yeni kod üretir ve state'i günceller.
  ///
  /// Copied from [ClassInviteCodeNotifier].
  ClassInviteCodeNotifierProvider call(String classId) {
    return ClassInviteCodeNotifierProvider(classId);
  }

  @override
  ClassInviteCodeNotifierProvider getProviderOverride(
    covariant ClassInviteCodeNotifierProvider provider,
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
  String? get name => r'classInviteCodeNotifierProvider';
}

/// Bir sınıfın davet kodunu yöneten async notifier
/// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
/// [regenerate] yeni kod üretir ve state'i günceller.
///
/// Copied from [ClassInviteCodeNotifier].
class ClassInviteCodeNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ClassInviteCodeNotifier,
          ClassInviteCodeDto
        > {
  /// Bir sınıfın davet kodunu yöneten async notifier
  /// (`GET /api/classes/{id}/invite-code`), classId'ye göre family.
  /// [regenerate] yeni kod üretir ve state'i günceller.
  ///
  /// Copied from [ClassInviteCodeNotifier].
  ClassInviteCodeNotifierProvider(String classId)
    : this._internal(
        () => ClassInviteCodeNotifier()..classId = classId,
        from: classInviteCodeNotifierProvider,
        name: r'classInviteCodeNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$classInviteCodeNotifierHash,
        dependencies: ClassInviteCodeNotifierFamily._dependencies,
        allTransitiveDependencies:
            ClassInviteCodeNotifierFamily._allTransitiveDependencies,
        classId: classId,
      );

  ClassInviteCodeNotifierProvider._internal(
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
  FutureOr<ClassInviteCodeDto> runNotifierBuild(
    covariant ClassInviteCodeNotifier notifier,
  ) {
    return notifier.build(classId);
  }

  @override
  Override overrideWith(ClassInviteCodeNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClassInviteCodeNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    ClassInviteCodeNotifier,
    ClassInviteCodeDto
  >
  createElement() {
    return _ClassInviteCodeNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClassInviteCodeNotifierProvider && other.classId == classId;
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
mixin ClassInviteCodeNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ClassInviteCodeDto> {
  /// The parameter `classId` of this provider.
  String get classId;
}

class _ClassInviteCodeNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ClassInviteCodeNotifier,
          ClassInviteCodeDto
        >
    with ClassInviteCodeNotifierRef {
  _ClassInviteCodeNotifierProviderElement(super.provider);

  @override
  String get classId => (origin as ClassInviteCodeNotifierProvider).classId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
