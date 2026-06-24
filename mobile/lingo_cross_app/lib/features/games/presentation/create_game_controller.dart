import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';
import '../domain/game_type.dart';

part 'create_game_controller.g.dart';

/// Öğretmen "Yeni Bulmaca Oluştur" akışı (`POST /lessons/{id}/games`).
///
/// Seçilen oyun türü ve ders için oyun oluşturup yayınlar. Başarıda dönen
/// [GameDto] döner; hata [state]'e `AsyncError` (GamesFailure) olarak taşınır —
/// ekran i18n metnine çevirir. Yetersiz kelime (400) →
/// [GamesFailure.insufficientWords].
@riverpod
class CreateGameController extends _$CreateGameController {
  @override
  AsyncValue<GameDto?> build() => const AsyncValue.data(null);

  /// [lessonId] dersinde [type] türünde bir bulmaca oluşturur ve yayınlar.
  /// Başarıda oluşan oyunu döner, aksi halde `null` (state `AsyncError`).
  Future<GameDto?> create({
    required String lessonId,
    required GameType type,
    String? title,
    List<String>? classIds,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(gamesRepositoryProvider);
      return repo.createGame(
        lessonId,
        CreateGameRequest(type: type, title: title, classIds: classIds),
      );
    });
    state = result;
    return result.valueOrNull;
  }
}
