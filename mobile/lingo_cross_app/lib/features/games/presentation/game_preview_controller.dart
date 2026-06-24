import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/game_dtos.dart';
import '../data/games_repository.dart';
import '../domain/game_type.dart';

part 'game_preview_controller.g.dart';

/// Öğretmen "Yeni Bulmaca Oluştur" sihirbazının önizleme adımını besler.
///
/// Seçilen ders + oyun türü için `POST /lessons/{id}/games/preview` çağırır ve
/// üretilecek örnek içeriği ([GamePreviewResponse]) döndürür. Kalıcı değildir.
/// Hata (yetersiz kelime → 400) [AsyncError] (GamesFailure) olarak taşınır;
/// ekran i18n metnine çevirir. Aynı (ders, tür) için tekrar dinlenince cache'lenir.
@riverpod
Future<GamePreviewResponse> gamePreview(
  Ref ref,
  String lessonId,
  GameType type,
) {
  final repo = ref.watch(gamesRepositoryProvider);
  return repo.previewGame(lessonId, type);
}
