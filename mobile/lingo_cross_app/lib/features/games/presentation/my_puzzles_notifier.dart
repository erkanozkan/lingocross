import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';

part 'my_puzzles_notifier.g.dart';

/// Öğretmenin "Bulmacalarım" listesini yöneten async notifier
/// (`GET /api/teachers/me/games`).
///
/// Ekran `AsyncValue` üzerinden loading/error/data durumlarını çözer.
/// Paylaşım sonrası [refresh] ile yeniden yüklenir (solveCount/atama güncel).
@riverpod
class MyPuzzlesNotifier extends _$MyPuzzlesNotifier {
  @override
  Future<List<TeacherPuzzleDto>> build() {
    return ref.watch(gamesRepositoryProvider).listMyPuzzles();
  }

  /// Pull-to-refresh / paylaşım sonrası listeyi yeniden yükler.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(gamesRepositoryProvider).listMyPuzzles(),
    );
  }
}
