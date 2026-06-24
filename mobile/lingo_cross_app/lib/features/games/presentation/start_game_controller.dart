import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';
import '../domain/games_failure.dart';

part 'start_game_controller.g.dart';

/// Atanan bir bulmaca için oturum başlatma akışı (öğrenci).
///
/// F2.2: oyunlar artık öğretmen tarafından açıkça oluşturulup yayınlanır; eski
/// "oynarken otomatik üretim" (lessonId → games) akışı kaldırıldı. Öğrenci bir
/// bulmacaya dokununca doğrudan `POST /games/{gameId}/sessions` ile oturum +
/// içerik alınır. Hata [GamesFailure] olarak `AsyncError`'a taşınır (UI i18n
/// metnine çevirir).
@riverpod
class StartGameController extends _$StartGameController {
  @override
  AsyncValue<StartGameSessionResponse?> build() =>
      const AsyncValue.data(null);

  /// [gameId] için oturum başlatır; başarıda oturum + içerik döner, aksi halde
  /// [state] `AsyncError` olur ve `null` döner.
  Future<StartGameSessionResponse?> start(String gameId) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(gamesRepositoryProvider);
      return repo.startSession(gameId);
    });
    state = result;
    return result.valueOrNull;
  }
}
