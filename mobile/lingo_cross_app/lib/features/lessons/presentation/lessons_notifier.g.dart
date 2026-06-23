// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessons_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lessonHash() => r'c8fd54596d33e60df14f6463045329973c059007';

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

/// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
///
/// Copied from [lesson].
@ProviderFor(lesson)
const lessonProvider = LessonFamily();

/// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
///
/// Copied from [lesson].
class LessonFamily extends Family<AsyncValue<LessonDto>> {
  /// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
  ///
  /// Copied from [lesson].
  const LessonFamily();

  /// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
  ///
  /// Copied from [lesson].
  LessonProvider call(String lessonId) {
    return LessonProvider(lessonId);
  }

  @override
  LessonProvider getProviderOverride(covariant LessonProvider provider) {
    return call(provider.lessonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lessonProvider';
}

/// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
///
/// Copied from [lesson].
class LessonProvider extends AutoDisposeFutureProvider<LessonDto> {
  /// Tek bir dersi getiren provider (`GET /lessons/{id}`) — düzenleme/detay için.
  ///
  /// Copied from [lesson].
  LessonProvider(String lessonId)
    : this._internal(
        (ref) => lesson(ref as LessonRef, lessonId),
        from: lessonProvider,
        name: r'lessonProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$lessonHash,
        dependencies: LessonFamily._dependencies,
        allTransitiveDependencies: LessonFamily._allTransitiveDependencies,
        lessonId: lessonId,
      );

  LessonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
  }) : super.internal();

  final String lessonId;

  @override
  Override overrideWith(
    FutureOr<LessonDto> Function(LessonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonProvider._internal(
        (ref) => create(ref as LessonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LessonDto> createElement() {
    return _LessonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonProvider && other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LessonRef on AutoDisposeFutureProviderRef<LessonDto> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LessonProviderElement extends AutoDisposeFutureProviderElement<LessonDto>
    with LessonRef {
  _LessonProviderElement(super.provider);

  @override
  String get lessonId => (origin as LessonProvider).lessonId;
}

String _$lessonsNotifierHash() => r'4562b00f5655720c881ac937d800986076ff1d1d';

/// Öğretmenin ders listesini yöneten async notifier (`GET /lessons`).
///
/// Ekran `AsyncValue` üzerinden loading/error/data durumlarını çözer.
/// Yaratma/güncelleme/silme sonrası [refresh] ile yeniden yüklenir.
///
/// Copied from [LessonsNotifier].
@ProviderFor(LessonsNotifier)
final lessonsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LessonsNotifier, List<LessonDto>>.internal(
      LessonsNotifier.new,
      name: r'lessonsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$lessonsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LessonsNotifier = AutoDisposeAsyncNotifier<List<LessonDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
