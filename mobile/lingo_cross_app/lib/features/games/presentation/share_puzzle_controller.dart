import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/games_repository.dart';

part 'share_puzzle_controller.g.dart';

/// Tek bir bulmacayı (yeniden) paylaşan/yayınlayan controller
/// (`POST /api/games/{id}/share`, idempotent).
///
/// Hangi karttan tetiklendiğini ayırmaya gerek yok: sonuç bool olarak döner;
/// ekran başarıda snackbar gösterir + listeyi yeniler. Hata `state.error`'da
/// (GamesFailure) tutulur, ekran i18n mesajına çevirir.
@riverpod
class SharePuzzleController extends _$SharePuzzleController {
  @override
  FutureOr<void> build() {}

  /// Bulmacayı paylaşır. Başarıda `true`, hatada `false` döner (state.error dolu).
  Future<bool> share(String gameId) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(gamesRepositoryProvider).sharePuzzle(gameId),
    );
    state = result.when(
      data: (_) => const AsyncValue.data(null),
      error: AsyncValue.error,
      loading: () => const AsyncValue.loading(),
    );
    return !result.hasError;
  }
}
