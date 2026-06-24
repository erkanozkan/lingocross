import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';

part 'assigned_games_notifier.g.dart';

/// Öğrenciye atanmış (yayımlanmış) bulmacaları yöneten async notifier
/// (`GET /games/assigned`).
///
/// Öğrenci panelindeki "atanan bulmacalar" bölümünü besler; pull-to-refresh ve
/// öğretmen-yayını sonrası [refresh] ile yeniden yüklenir.
@riverpod
class AssignedGamesNotifier extends _$AssignedGamesNotifier {
  @override
  Future<List<AssignedGameDto>> build() {
    return ref.watch(gamesRepositoryProvider).listAssigned();
  }

  /// Pull-to-refresh / yeni atama sonrası listeyi yeniden yükler.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gamesRepositoryProvider).listAssigned(),
    );
  }
}
