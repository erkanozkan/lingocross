import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../../lessons/data/dtos/lesson_dtos.dart';
import '../../../lessons/presentation/lessons_notifier.dart';
import '../../domain/game_type.dart';
import '../../domain/games_failure.dart';
import '../create_game_controller.dart';

/// Yeni Bulmaca Oluştur (Stitch `73fefb56…` birebir).
///
/// Adım 1 "Oyun Türünü Seç": iki kart — Kelime Eşleştirme (aktif) ve Crossword
/// (pasif/"Yakında", F2.4). Adım 2 "Ders Seçimi": öğretmenin dersleri dropdown.
/// Önizleme placeholder. Alt sabit "Bulmacayı Oluştur ve Yayınla" →
/// `POST /lessons/{id}/games`. Başarı → snackbar + geri; hata: yetersiz kelime
/// (400) "ders en az 4 kelime içermeli", ağ/diğer → uygun mesaj.
class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key, this.initialLessonId});

  /// Ders Detayı "Ödev Ataması Yap"tan gelince ön-seçili ders.
  final String? initialLessonId;

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  GameType _selectedType = GameType.wordMatching;
  String? _selectedLessonId;

  @override
  void initState() {
    super.initState();
    _selectedLessonId = widget.initialLessonId;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final lessonId = _selectedLessonId;
    if (lessonId == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final game = await ref.read(createGameControllerProvider.notifier).create(
          lessonId: lessonId,
          type: _selectedType,
        );
    if (!mounted) return;

    if (game != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.createGameSuccess)),
      );
      context.pop();
    } else {
      final error = ref.read(createGameControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(content: Text(_errorMessage(error, l10n))),
      );
    }
  }

  String _errorMessage(Object? error, AppLocalizations l10n) {
    if (error is GamesFailure) {
      return error.maybeWhen(
        insufficientWords: () => l10n.createGameErrorInsufficientWords,
        network: () => l10n.createGameErrorNetwork,
        orElse: () => l10n.createGameErrorGeneric,
      );
    }
    return l10n.createGameErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final busy = ref.watch(createGameControllerProvider).isLoading;
    final canSubmit = _selectedLessonId != null && !busy;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.createGameTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.lg,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _StepHeader(number: 1, title: l10n.createGameStep1Title),
          const SizedBox(height: AppSpacing.md),
          _GameTypeCard(
            icon: Icons.sports_esports,
            title: l10n.createGameTypeMatchingTitle,
            desc: l10n.createGameTypeMatchingDesc,
            selected: _selectedType == GameType.wordMatching,
            enabled: true,
            onTap: () =>
                setState(() => _selectedType = GameType.wordMatching),
          ),
          const SizedBox(height: AppSpacing.md),
          _GameTypeCard(
            icon: Icons.extension,
            title: l10n.createGameTypeCrosswordTitle,
            desc: l10n.createGameTypeCrosswordDesc,
            selected: false,
            enabled: false,
            badge: l10n.createGameTypeComingSoon,
            onTap: null,
          ),
          const SizedBox(height: AppSpacing.xl),
          _StepHeader(number: 2, title: l10n.createGameStep2Title),
          const SizedBox(height: AppSpacing.md),
          _LessonDropdown(
            lessonsAsync: lessonsAsync,
            selectedLessonId: _selectedLessonId,
            onChanged: (id) => setState(() => _selectedLessonId = id),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _PreviewPlaceholder(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PrimaryButton3D(
              label: l10n.createGameSubmit,
              trailingIcon: Icons.rocket_launch,
              isLoading: busy,
              enabled: canSubmit,
              onPressed: canSubmit ? _submit : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Adım başlığı: numaralı daire + başlık (Stitch §step header).
class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: AppTypography.labelLg.copyWith(color: AppColors.onPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(title, style: AppTypography.headlineMd),
      ],
    );
  }
}

/// Oyun türü kartı. Seçili → primary çerçeve + tonal zemin + dolgulu ikon.
/// Pasif (enabled=false) → soluk + "Yakında" rozeti, dokunulamaz.
class _GameTypeCard extends StatelessWidget {
  const _GameTypeCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.selected,
    required this.enabled,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String desc;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final Color border =
        selected ? AppColors.primary : AppColors.outlineVariant;
    final Color background =
        selected ? AppColors.surfaceContainerLow : AppColors.surface;
    final Color iconBoxColor =
        selected ? AppColors.primary : AppColors.surfaceContainerHighest;
    final Color iconColor =
        selected ? AppColors.onPrimary : AppColors.primary;

    final card = Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: border, width: selected ? 2 : 1),
          boxShadow: selected ? AppShadows.level2 : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBoxColor,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(title, style: AppTypography.headlineMd),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: AppSpacing.xs),
                        _ComingSoonBadge(label: badge!),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    desc,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!enabled || onTap == null) {
      return Semantics(enabled: false, button: true, child: card);
    }
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: card,
      ),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

/// Ders seçim dropdown'u (Stitch §step 2). Boş/hata durumlarını anlamlı
/// mesajla gösterir.
class _LessonDropdown extends StatelessWidget {
  const _LessonDropdown({
    required this.lessonsAsync,
    required this.selectedLessonId,
    required this.onChanged,
  });

  final AsyncValue<List<LessonDto>> lessonsAsync;
  final String? selectedLessonId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Text(
            l10n.createGameLessonLabel,
            style: AppTypography.labelLg
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        lessonsAsync.when(
          loading: () => _Box(
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.createGameLessonHint,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          error: (_, __) => _Box(
            child: Text(
              l10n.createGameLessonsError,
              style: AppTypography.bodyMd.copyWith(color: AppColors.error),
            ),
          ),
          data: (lessons) {
            if (lessons.isEmpty) {
              return _Box(
                child: Text(
                  l10n.createGameLessonsEmpty,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              );
            }
            // Ön-seçili ders artık listede yoksa hint'e düş.
            final valid = lessons.any((l) => l.id == selectedLessonId)
                ? selectedLessonId
                : null;
            return _Box(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: valid,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.onSurfaceVariant),
                  hint: Text(
                    l10n.createGameLessonHint,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurface),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onChanged: onChanged,
                  items: [
                    for (final lesson in lessons)
                      DropdownMenuItem(
                        value: lesson.id,
                        child: Text(
                          lesson.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Dropdown / durum kutusu çerçevesi (Stitch select stili).
class _Box extends StatelessWidget {
  const _Box({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: child,
    );
  }
}

/// Önizleme placeholder (Stitch §preview): dashed kutu + ikon + metin.
class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              shape: BoxShape.circle,
              boxShadow: AppShadows.soft,
            ),
            child:
                const Icon(Icons.auto_awesome, color: AppColors.outline, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.createGamePreviewTitle,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.createGamePreviewDesc,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
