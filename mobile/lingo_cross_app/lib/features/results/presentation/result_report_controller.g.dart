// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_report_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$resultReportControllerHash() =>
    r'22e9e94616516159cd96fd64d4b5df0759c19655';

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

abstract class _$ResultReportController
    extends BuildlessAutoDisposeNotifier<ResultReportState> {
  late final String resultId;

  ResultReportState build(String resultId);
}

/// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
///
/// İki giriş yolu:
/// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
/// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
///   sözleşmesi).
///
/// Copied from [ResultReportController].
@ProviderFor(ResultReportController)
const resultReportControllerProvider = ResultReportControllerFamily();

/// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
///
/// İki giriş yolu:
/// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
/// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
///   sözleşmesi).
///
/// Copied from [ResultReportController].
class ResultReportControllerFamily extends Family<ResultReportState> {
  /// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
  ///
  /// İki giriş yolu:
  /// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
  ///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
  ///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
  /// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
  ///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
  ///   sözleşmesi).
  ///
  /// Copied from [ResultReportController].
  const ResultReportControllerFamily();

  /// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
  ///
  /// İki giriş yolu:
  /// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
  ///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
  ///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
  /// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
  ///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
  ///   sözleşmesi).
  ///
  /// Copied from [ResultReportController].
  ResultReportControllerProvider call(String resultId) {
    return ResultReportControllerProvider(resultId);
  }

  @override
  ResultReportControllerProvider getProviderOverride(
    covariant ResultReportControllerProvider provider,
  ) {
    return call(provider.resultId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'resultReportControllerProvider';
}

/// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
///
/// İki giriş yolu:
/// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
/// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
///   sözleşmesi).
///
/// Copied from [ResultReportController].
class ResultReportControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          ResultReportController,
          ResultReportState
        > {
  /// Oyun Sonu Raporu denetleyicisi (resultId ile anahtarlanır).
  ///
  /// İki giriş yolu:
  /// - **Oyun sonu:** sonuç [SubmitResultController]'dan gelir; ekran onu
  ///   [seed] ile yerleştirir (ağ çağrısı tekrarlanmaz). Submit'ten dönen sonuç
  ///   zaten `sharedWithTeacher = true`'dur (otomatik paylaşım).
  /// - **Geçmiş / tamamlanan bulmaca:** ekran yalnız `resultId` ile açılır; rapor
  ///   `GET /results/me`'den bulunur (ayrı `GET /results/{id}` ucu yok — M5
  ///   sözleşmesi).
  ///
  /// Copied from [ResultReportController].
  ResultReportControllerProvider(String resultId)
    : this._internal(
        () => ResultReportController()..resultId = resultId,
        from: resultReportControllerProvider,
        name: r'resultReportControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$resultReportControllerHash,
        dependencies: ResultReportControllerFamily._dependencies,
        allTransitiveDependencies:
            ResultReportControllerFamily._allTransitiveDependencies,
        resultId: resultId,
      );

  ResultReportControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.resultId,
  }) : super.internal();

  final String resultId;

  @override
  ResultReportState runNotifierBuild(
    covariant ResultReportController notifier,
  ) {
    return notifier.build(resultId);
  }

  @override
  Override overrideWith(ResultReportController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ResultReportControllerProvider._internal(
        () => create()..resultId = resultId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        resultId: resultId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ResultReportController, ResultReportState>
  createElement() {
    return _ResultReportControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResultReportControllerProvider &&
        other.resultId == resultId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, resultId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ResultReportControllerRef
    on AutoDisposeNotifierProviderRef<ResultReportState> {
  /// The parameter `resultId` of this provider.
  String get resultId;
}

class _ResultReportControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          ResultReportController,
          ResultReportState
        >
    with ResultReportControllerRef {
  _ResultReportControllerProviderElement(super.provider);

  @override
  String get resultId => (origin as ResultReportControllerProvider).resultId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
