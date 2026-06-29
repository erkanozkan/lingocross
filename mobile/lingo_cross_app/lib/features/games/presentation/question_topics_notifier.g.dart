// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_topics_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$topicAssignmentsHash() => r'dcee5a17a38d548ce1807f1e0df82089b040fcfe';

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

/// Bir konunun mevcut sınıf atamalarını döndüren provider
/// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
/// ön-seçimi doldurmak için kullanılır.
///
/// Copied from [topicAssignments].
@ProviderFor(topicAssignments)
const topicAssignmentsProvider = TopicAssignmentsFamily();

/// Bir konunun mevcut sınıf atamalarını döndüren provider
/// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
/// ön-seçimi doldurmak için kullanılır.
///
/// Copied from [topicAssignments].
class TopicAssignmentsFamily extends Family<AsyncValue<GameAssignmentsDto>> {
  /// Bir konunun mevcut sınıf atamalarını döndüren provider
  /// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
  /// ön-seçimi doldurmak için kullanılır.
  ///
  /// Copied from [topicAssignments].
  const TopicAssignmentsFamily();

  /// Bir konunun mevcut sınıf atamalarını döndüren provider
  /// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
  /// ön-seçimi doldurmak için kullanılır.
  ///
  /// Copied from [topicAssignments].
  TopicAssignmentsProvider call(String topicId) {
    return TopicAssignmentsProvider(topicId);
  }

  @override
  TopicAssignmentsProvider getProviderOverride(
    covariant TopicAssignmentsProvider provider,
  ) {
    return call(provider.topicId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topicAssignmentsProvider';
}

/// Bir konunun mevcut sınıf atamalarını döndüren provider
/// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
/// ön-seçimi doldurmak için kullanılır.
///
/// Copied from [topicAssignments].
class TopicAssignmentsProvider
    extends AutoDisposeFutureProvider<GameAssignmentsDto> {
  /// Bir konunun mevcut sınıf atamalarını döndüren provider
  /// (`GET /api/question-topics/{topicId}/assignments`). Atama sayfası açılınca
  /// ön-seçimi doldurmak için kullanılır.
  ///
  /// Copied from [topicAssignments].
  TopicAssignmentsProvider(String topicId)
    : this._internal(
        (ref) => topicAssignments(ref as TopicAssignmentsRef, topicId),
        from: topicAssignmentsProvider,
        name: r'topicAssignmentsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$topicAssignmentsHash,
        dependencies: TopicAssignmentsFamily._dependencies,
        allTransitiveDependencies:
            TopicAssignmentsFamily._allTransitiveDependencies,
        topicId: topicId,
      );

  TopicAssignmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
  }) : super.internal();

  final String topicId;

  @override
  Override overrideWith(
    FutureOr<GameAssignmentsDto> Function(TopicAssignmentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicAssignmentsProvider._internal(
        (ref) => create(ref as TopicAssignmentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GameAssignmentsDto> createElement() {
    return _TopicAssignmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicAssignmentsProvider && other.topicId == topicId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicAssignmentsRef on AutoDisposeFutureProviderRef<GameAssignmentsDto> {
  /// The parameter `topicId` of this provider.
  String get topicId;
}

class _TopicAssignmentsProviderElement
    extends AutoDisposeFutureProviderElement<GameAssignmentsDto>
    with TopicAssignmentsRef {
  _TopicAssignmentsProviderElement(super.provider);

  @override
  String get topicId => (origin as TopicAssignmentsProvider).topicId;
}

String _$questionTopicsNotifierHash() =>
    r'705aa5298e9a6724814454bcc29c42074549cb13';

/// Öğretmenin atayabileceği Çıkmış Sorular konularını yöneten async notifier
/// (`GET /api/question-topics`).
///
/// Copied from [QuestionTopicsNotifier].
@ProviderFor(QuestionTopicsNotifier)
final questionTopicsNotifierProvider = AutoDisposeAsyncNotifierProvider<
  QuestionTopicsNotifier,
  List<QuestionTopicDto>
>.internal(
  QuestionTopicsNotifier.new,
  name: r'questionTopicsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$questionTopicsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuestionTopicsNotifier =
    AutoDisposeAsyncNotifier<List<QuestionTopicDto>>;
String _$setTopicAssignmentsControllerHash() =>
    r'467bc1cc4582ba7dea5ed4da04c31ad1ac3cad4e';

/// Bir konunun sınıf atamalarını kaydetme akışı (`POST .../assignments`).
///
/// Başarıda dönen [GameAssignmentsDto] döner; hata [state]'e `AsyncError`
/// (GamesFailure) olarak taşınır — ekran i18n metnine çevirir.
///
/// Copied from [SetTopicAssignmentsController].
@ProviderFor(SetTopicAssignmentsController)
final setTopicAssignmentsControllerProvider = AutoDisposeNotifierProvider<
  SetTopicAssignmentsController,
  AsyncValue<GameAssignmentsDto?>
>.internal(
  SetTopicAssignmentsController.new,
  name: r'setTopicAssignmentsControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$setTopicAssignmentsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SetTopicAssignmentsController =
    AutoDisposeNotifier<AsyncValue<GameAssignmentsDto?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
