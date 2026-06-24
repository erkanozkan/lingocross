import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';
import '../domain/game_type.dart';
import '../domain/games_failure.dart';

part 'start_game_controller.g.dart';

/// Ders için oyun başlatma akışı (öğrenci).
///
/// `GET /lessons/{lessonId}/games` ile WordMatching oyununu bulur, ardından
/// `POST /games/{gameId}/sessions` ile oturum + içerik alır. Hata
/// [GamesFailure] olarak `AsyncError`'a taşınır (UI i18n metnine çevirir).
@riverpod
class StartGameController extends _$StartGameController {
  @override
  AsyncValue<StartGameSessionResponse?> build() =>
      const AsyncValue.data(null);

  /// Ders için oyunu başlatır; başarıda oturum + içerik döner, aksi halde
  /// [state] `AsyncError` olur ve `null` döner.
  Future<StartGameSessionResponse?> start(String lessonId) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(gamesRepositoryProvider);
      final games = await repo.listForLesson(lessonId);
      final game = games
          .where((g) => g.type == GameType.wordMatching)
          .firstOrNull;
      if (game == null) throw const GamesFailure.insufficientWords();
      return repo.startSession(game.id);
    });
    state = result;
    return result.valueOrNull;
  }
}
