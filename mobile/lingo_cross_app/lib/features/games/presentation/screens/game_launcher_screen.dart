import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../lessons/domain/language_option.dart';
import '../../../lessons/presentation/lessons_notifier.dart';
import '../../domain/game_type.dart';
import '../../domain/games_failure.dart';
import '../assigned_games_notifier.dart';
import '../games_failure_messages.dart';
import '../start_game_controller.dart';
import 'crossword_game_screen.dart';
import 'word_matching_game_screen.dart';

/// Oyun başlatma akışını yürüten launcher (`/student/games/:gameId`).
///
/// F2.2: atanan bulmacaya dokununca doğrudan `POST /games/{gameId}/sessions`
/// ile oturum + içerik alır; yükleniyor/hata durumlarını gösterir, başarıda
/// oyun ekranına geçer.
class GameLauncherScreen extends ConsumerStatefulWidget {
  const GameLauncherScreen({super.key, required this.gameId});

  final String gameId;

  @override
  ConsumerState<GameLauncherScreen> createState() =>
      _GameLauncherScreenState();
}

class _GameLauncherScreenState extends ConsumerState<GameLauncherScreen> {
  @override
  void initState() {
    super.initState();
    // İlk frame sonrası başlat (provider mutasyonu build sırasında olmasın).
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    ref.read(startGameControllerProvider.notifier).start(widget.gameId);
  }

  /// Oyunun ait olduğu dersin dil çiftini (ISO kodu) çözer (F9.2).
  ///
  /// Oturum başlatma yanıtı dil taşımadığından (DTO değişmiyor), atanan
  /// bulmacalar listesinden bu oyunun dersini (`lessonId`) bulup
  /// `lessonProvider` ile dersin kaynak/hedef dillerini okur. Liste/ders henüz
  /// yüklenmemişse veya oyun bulunamazsa güvenli varsayılan en→tr döner; sütun
  /// başlıkları yalnız etiket içindir, oyun verisini etkilemez.
  ({String source, String target}) _languagePair() {
    final lessonId = ref
        .watch(assignedGamesNotifierProvider)
        .maybeWhen(
          data: (games) {
            for (final g in games) {
              if (g.id == widget.gameId) return g.lessonId;
            }
            return null;
          },
          orElse: () => null,
        );
    if (lessonId == null) {
      return (
        source: LanguageOption.defaultSource,
        target: LanguageOption.defaultTarget,
      );
    }
    return ref.watch(lessonProvider(lessonId)).maybeWhen(
          data: (lesson) =>
              (source: lesson.sourceLanguage, target: lesson.targetLanguage),
          orElse: () => (
            source: LanguageOption.defaultSource,
            target: LanguageOption.defaultTarget,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(startGameControllerProvider);

    return state.when(
      data: (response) {
        if (response == null) {
          // Henüz başlatılmadı (post-frame öncesi) → yükleniyor görünümü.
          return const _LoadingScaffold();
        }
        // F2.4: oturum tipine göre dallan. WordMatching → eşleştirme ekranı,
        // Crossword → crossword ekranı. İlgili içerik alanı eksikse hata.
        switch (response.type) {
          case GameType.crossword:
            final crossword = response.crossword;
            if (crossword == null) {
              return _ErrorScaffold(
                error: const GamesFailure.unexpected(),
                isEmpty: false,
                onRetry: _start,
              );
            }
            return CrosswordGameScreen(
              sessionId: response.session.id,
              content: crossword,
            );
          case GameType.wordMatching:
          case GameType.questionSet:
            final wordMatching = response.wordMatching;
            if (wordMatching == null) {
              return _ErrorScaffold(
                error: const GamesFailure.unexpected(),
                isEmpty: false,
                onRetry: _start,
              );
            }
            final langs = _languagePair();
            return WordMatchingGameScreen(
              sessionId: response.session.id,
              content: wordMatching,
              sourceLanguage: langs.source,
              targetLanguage: langs.target,
            );
        }
      },
      loading: () => const _LoadingScaffold(),
      error: (error, _) => _ErrorScaffold(
        error: error,
        isEmpty: error is GamesFailure &&
            error.maybeWhen(
              insufficientWords: () => true,
              orElse: () => false,
            ),
        onRetry: _start,
      ),
    );
  }
}

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.gameMatchingTitle,
            style:
                AppTypography.headlineMd.copyWith(color: AppColors.primary)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.gameStarting,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({
    required this.error,
    required this.isEmpty,
    required this.onRetry,
  });

  final Object error;
  final bool isEmpty;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.gameMatchingTitle,
            style:
                AppTypography.headlineMd.copyWith(color: AppColors.primary)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isEmpty ? Icons.inventory_2 : Icons.cloud_off,
                  size: 40,
                  color: isEmpty ? AppColors.primary : AppColors.error,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isEmpty
                      ? l10n.gameMatchingEmptyTitle
                      : l10n.gameMatchingError,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMd,
                ),
                const SizedBox(height: AppSpacing.base),
                Text(
                  isEmpty
                      ? l10n.gameMatchingEmptyDesc
                      : gamesFailureMessage(error, l10n),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.md),
                if (isEmpty)
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.studentJoinBackToDashboard),
                  )
                else
                  OutlinedButton(
                    onPressed: onRetry,
                    child: Text(l10n.commonRetry),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
