// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_preview_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamePreviewHash() => r'2eb7f287fb2db154829e6cd95633097c487c1bc6';

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

/// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
///
/// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
/// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
/// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
/// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
///
/// Copied from [gamePreview].
@ProviderFor(gamePreview)
const gamePreviewProvider = GamePreviewFamily();

/// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
///
/// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
/// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
/// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
/// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
///
/// Copied from [gamePreview].
class GamePreviewFamily extends Family<AsyncValue<GamePreviewResponse>> {
  /// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
  ///
  /// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
  /// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
  /// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
  /// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
  ///
  /// Copied from [gamePreview].
  const GamePreviewFamily();

  /// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
  ///
  /// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
  /// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
  /// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
  /// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
  ///
  /// Copied from [gamePreview].
  GamePreviewProvider call(String lessonId, GameType type) {
    return GamePreviewProvider(lessonId, type);
  }

  @override
  GamePreviewProvider getProviderOverride(
    covariant GamePreviewProvider provider,
  ) {
    return call(provider.lessonId, provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gamePreviewProvider';
}

/// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
///
/// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
/// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
/// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
/// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
///
/// Copied from [gamePreview].
class GamePreviewProvider
    extends AutoDisposeFutureProvider<GamePreviewResponse> {
  /// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
  ///
  /// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
  /// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
  /// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
  /// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
  ///
  /// Copied from [gamePreview].
  GamePreviewProvider(String lessonId, GameType type)
    : this._internal(
        (ref) => gamePreview(ref as GamePreviewRef, lessonId, type),
        from: gamePreviewProvider,
        name: r'gamePreviewProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gamePreviewHash,
        dependencies: GamePreviewFamily._dependencies,
        allTransitiveDependencies: GamePreviewFamily._allTransitiveDependencies,
        lessonId: lessonId,
        type: type,
      );

  GamePreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
    required this.type,
  }) : super.internal();

  final String lessonId;
  final GameType type;

  @override
  Override overrideWith(
    FutureOr<GamePreviewResponse> Function(GamePreviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GamePreviewProvider._internal(
        (ref) => create(ref as GamePreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GamePreviewResponse> createElement() {
    return _GamePreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GamePreviewProvider &&
        other.lessonId == lessonId &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GamePreviewRef on AutoDisposeFutureProviderRef<GamePreviewResponse> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;

  /// The parameter `type` of this provider.
  GameType get type;
}

class _GamePreviewProviderElement
    extends AutoDisposeFutureProviderElement<GamePreviewResponse>
    with GamePreviewRef {
  _GamePreviewProviderElement(super.provider);

  @override
  String get lessonId => (origin as GamePreviewProvider).lessonId;
  @override
  GameType get type => (origin as GamePreviewProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
