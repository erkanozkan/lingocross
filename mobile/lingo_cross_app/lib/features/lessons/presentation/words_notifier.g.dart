// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordsNotifierHash() => r'346546de84e567b6db48efb202f613fc22e3b8c6';

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

abstract class _$WordsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<WordDto>> {
  late final String lessonId;

  FutureOr<List<WordDto>> build(String lessonId);
}

/// Bir dersin kelime listesini yöneten async notifier
/// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
///
/// Copied from [WordsNotifier].
@ProviderFor(WordsNotifier)
const wordsNotifierProvider = WordsNotifierFamily();

/// Bir dersin kelime listesini yöneten async notifier
/// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
///
/// Copied from [WordsNotifier].
class WordsNotifierFamily extends Family<AsyncValue<List<WordDto>>> {
  /// Bir dersin kelime listesini yöneten async notifier
  /// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
  ///
  /// Copied from [WordsNotifier].
  const WordsNotifierFamily();

  /// Bir dersin kelime listesini yöneten async notifier
  /// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
  ///
  /// Copied from [WordsNotifier].
  WordsNotifierProvider call(String lessonId) {
    return WordsNotifierProvider(lessonId);
  }

  @override
  WordsNotifierProvider getProviderOverride(
    covariant WordsNotifierProvider provider,
  ) {
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
  String? get name => r'wordsNotifierProvider';
}

/// Bir dersin kelime listesini yöneten async notifier
/// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
///
/// Copied from [WordsNotifier].
class WordsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<WordsNotifier, List<WordDto>> {
  /// Bir dersin kelime listesini yöneten async notifier
  /// (`GET /lessons/{id}/words`). lessonId ile aileye ayrılır.
  ///
  /// Copied from [WordsNotifier].
  WordsNotifierProvider(String lessonId)
    : this._internal(
        () => WordsNotifier()..lessonId = lessonId,
        from: wordsNotifierProvider,
        name: r'wordsNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$wordsNotifierHash,
        dependencies: WordsNotifierFamily._dependencies,
        allTransitiveDependencies:
            WordsNotifierFamily._allTransitiveDependencies,
        lessonId: lessonId,
      );

  WordsNotifierProvider._internal(
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
  FutureOr<List<WordDto>> runNotifierBuild(covariant WordsNotifier notifier) {
    return notifier.build(lessonId);
  }

  @override
  Override overrideWith(WordsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordsNotifierProvider._internal(
        () => create()..lessonId = lessonId,
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
  AutoDisposeAsyncNotifierProviderElement<WordsNotifier, List<WordDto>>
  createElement() {
    return _WordsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordsNotifierProvider && other.lessonId == lessonId;
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
mixin WordsNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<WordDto>> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _WordsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<WordsNotifier, List<WordDto>>
    with WordsNotifierRef {
  _WordsNotifierProviderElement(super.provider);

  @override
  String get lessonId => (origin as WordsNotifierProvider).lessonId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
