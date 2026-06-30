// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_exam_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiExamControllerHash() => r'faf6ee0ff589cb334b1c9eb49d1fde07ce29b9e8';

/// Yapay zekâ ile sınav soruları üretme akışının üretim durumu
/// (`POST /lessons/{id}/ai-questions`).
///
/// Yükleme ekranı [AsyncValue.loading]'i; review ekranı başarıda dönen
/// [AiExamResultDto]'yu gösterir. Hata [AsyncError] (GamesFailure) olarak
/// taşınır; config ekranı i18n metnine çevirir (yetersiz kelime / AI kapalı /
/// ağ). Başlangıç durumu `data(null)`.
///
/// Copied from [AiExamController].
@ProviderFor(AiExamController)
final aiExamControllerProvider = AutoDisposeNotifierProvider<
  AiExamController,
  AsyncValue<AiExamResultDto?>
>.internal(
  AiExamController.new,
  name: r'aiExamControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiExamControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiExamController = AutoDisposeNotifier<AsyncValue<AiExamResultDto?>>;
String _$aiExamReviewControllerHash() =>
    r'59c321b45a7eca86a51a9363e38434cd8e78d902';

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

abstract class _$AiExamReviewController
    extends BuildlessAutoDisposeNotifier<AiExamResultDto> {
  late final AiExamResultDto seed;

  AiExamResultDto build(AiExamResultDto seed);
}

/// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
/// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
/// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
/// yapılır.
///
/// Copied from [AiExamReviewController].
@ProviderFor(AiExamReviewController)
const aiExamReviewControllerProvider = AiExamReviewControllerFamily();

/// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
/// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
/// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
/// yapılır.
///
/// Copied from [AiExamReviewController].
class AiExamReviewControllerFamily extends Family<AiExamResultDto> {
  /// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
  /// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
  /// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
  /// yapılır.
  ///
  /// Copied from [AiExamReviewController].
  const AiExamReviewControllerFamily();

  /// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
  /// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
  /// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
  /// yapılır.
  ///
  /// Copied from [AiExamReviewController].
  AiExamReviewControllerProvider call(AiExamResultDto seed) {
    return AiExamReviewControllerProvider(seed);
  }

  @override
  AiExamReviewControllerProvider getProviderOverride(
    covariant AiExamReviewControllerProvider provider,
  ) {
    return call(provider.seed);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aiExamReviewControllerProvider';
}

/// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
/// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
/// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
/// yapılır.
///
/// Copied from [AiExamReviewController].
class AiExamReviewControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          AiExamReviewController,
          AiExamResultDto
        > {
  /// Review ekranının düzenlenebilir durumu: üretilen [AiExamResultDto] + halen
  /// duran sorular. Soru silindiğinde önce sunucudan (`DELETE`), başarıda
  /// listeden düşürülür. Atama mevcut `GamesRepository.setTopicAssignments` ile
  /// yapılır.
  ///
  /// Copied from [AiExamReviewController].
  AiExamReviewControllerProvider(AiExamResultDto seed)
    : this._internal(
        () => AiExamReviewController()..seed = seed,
        from: aiExamReviewControllerProvider,
        name: r'aiExamReviewControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$aiExamReviewControllerHash,
        dependencies: AiExamReviewControllerFamily._dependencies,
        allTransitiveDependencies:
            AiExamReviewControllerFamily._allTransitiveDependencies,
        seed: seed,
      );

  AiExamReviewControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.seed,
  }) : super.internal();

  final AiExamResultDto seed;

  @override
  AiExamResultDto runNotifierBuild(covariant AiExamReviewController notifier) {
    return notifier.build(seed);
  }

  @override
  Override overrideWith(AiExamReviewController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AiExamReviewControllerProvider._internal(
        () => create()..seed = seed,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        seed: seed,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AiExamReviewController, AiExamResultDto>
  createElement() {
    return _AiExamReviewControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiExamReviewControllerProvider && other.seed == seed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, seed.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AiExamReviewControllerRef
    on AutoDisposeNotifierProviderRef<AiExamResultDto> {
  /// The parameter `seed` of this provider.
  AiExamResultDto get seed;
}

class _AiExamReviewControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          AiExamReviewController,
          AiExamResultDto
        >
    with AiExamReviewControllerRef {
  _AiExamReviewControllerProviderElement(super.provider);

  @override
  AiExamResultDto get seed => (origin as AiExamReviewControllerProvider).seed;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
