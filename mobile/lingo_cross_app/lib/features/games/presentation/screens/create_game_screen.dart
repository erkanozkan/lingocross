import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../../classes/data/dtos/class_dtos.dart';
import '../../../classes/presentation/classes_notifier.dart';
import '../../../classes/presentation/widgets/class_badge.dart';
import '../../../lessons/data/dtos/lesson_dtos.dart';
import '../../../lessons/domain/language_option.dart';
import '../../../lessons/presentation/lessons_notifier.dart';
import '../../domain/game_type.dart';
import '../../domain/games_failure.dart';
import '../create_game_controller.dart';
import '../game_preview_controller.dart';
import '../widgets/puzzle_preview.dart';

/// Yeni Bulmaca Oluştur — Adımlı (Stitch `3a196b09…` temelli).
///
/// Üstte ilerleme çubuğu (4 pill — Stitch 3-pill'den bilinçli sapma; kullanıcı
/// isteğiyle "Örnek Önizleme" adımı eklendi). Adım 1: oyun türü (Kelime
/// Eşleştirme / Çengel Bulmaca). Adım 2: ders seçimi. Adım 3 (YENİ): kaydetmeden
/// önce üretilecek bulmacanın salt-okunur örnek önizlemesi
/// (`POST /lessons/{id}/games/preview`). Adım 4: sınıf çoklu-seçimi. Son adımda
/// "Oluştur ve Yayınla" (≥1 sınıf seçili değilse pasif) → `POST /lessons/{id}/games`
/// + classIds. Create çağrısı önizlemeden etkilenmez (yine type+lesson+classIds).
class CreateGameScreen extends ConsumerStatefulWidget {
  const CreateGameScreen({super.key, this.initialLessonId});

  /// Ders Detayı / Sınıf Detayı "Ödev Ata"dan gelince ön-seçili ders.
  final String? initialLessonId;

  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  /// 1 = oyun türü, 2 = ders seçimi, 3 = örnek önizleme, 4 = sınıf seçimi.
  static const int _lastStep = 4;
  int _step = 1;
  GameType _selectedType = GameType.wordMatching;
  String? _selectedLessonId;
  final Set<String> _selectedClassIds = {};

  @override
  void initState() {
    super.initState();
    _selectedLessonId = widget.initialLessonId;
  }

  bool get _canSubmit => _selectedLessonId != null && _selectedClassIds.isNotEmpty;

  /// Bir adımdan SONRAKİ adıma geçilebilir mi? (1→2 her zaman; 2→3 ders seçili;
  /// 3→4 her zaman — önizleme yalnız görsel). Son adımda "Sonraki" yoktur.
  bool _canAdvanceFrom(int step) => switch (step) {
        2 => _selectedLessonId != null,
        _ => true,
      };

  void _goStep(int step) => setState(() => _step = step);

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l10n = AppLocalizations.of(context);
    final lessonId = _selectedLessonId!;
    final messenger = ScaffoldMessenger.of(context);
    final game = await ref.read(createGameControllerProvider.notifier).create(
          lessonId: lessonId,
          type: _selectedType,
          classIds: _selectedClassIds.toList(),
        );
    if (!mounted) return;

    if (game != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.createGameSuccess)));
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
    final classesAsync = ref.watch(classesNotifierProvider);
    final busy = ref.watch(createGameControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.createGameTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
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
          _ProgressPills(step: _step),
          const SizedBox(height: AppSpacing.xl),
          if (_step == 1)
            _StepGameType(
              selectedType: _selectedType,
              onSelect: (t) => setState(() => _selectedType = t),
            )
          else if (_step == 2)
            _StepLesson(
              lessonsAsync: lessonsAsync,
              selectedLessonId: _selectedLessonId,
              onChanged: (id) => setState(() => _selectedLessonId = id),
            )
          else if (_step == 3)
            _StepPreview(
              lessonsAsync: lessonsAsync,
              selectedLessonId: _selectedLessonId,
              selectedType: _selectedType,
              onBack: () => _goStep(2),
            )
          else
            _StepClasses(
              classesAsync: classesAsync,
              selectedClassIds: _selectedClassIds,
              onToggle: (id) => setState(() {
                if (!_selectedClassIds.add(id)) _selectedClassIds.remove(id);
              }),
            ),
          const SizedBox(height: AppSpacing.xl),
          _StepNav(
            canNext: _canAdvanceFrom(_step),
            onBack: _step > 1 ? () => _goStep(_step - 1) : null,
            onNext: _step < _lastStep ? () => _goStep(_step + 1) : null,
          ),
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
              enabled: _canSubmit && !busy,
              onPressed: (_canSubmit && !busy) ? _submit : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Adım ilerleme çubuğu (Stitch §progress pills).
class _ProgressPills extends StatelessWidget {
  const _ProgressPills({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 1; i <= 4; i++) ...[
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: i <= step
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          if (i != 4) const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}

/// Step başlık + alt açıklama (Stitch §step header).
class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Adım 1 — Oyun türü seçimi.
class _StepGameType extends StatelessWidget {
  const _StepGameType({required this.selectedType, required this.onSelect});

  final GameType selectedType;
  final ValueChanged<GameType> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          title: l10n.createGameStep1Title,
          subtitle: l10n.createGameStep1Subtitle,
        ),
        const SizedBox(height: AppSpacing.lg),
        _GameTypeCard(
          icon: Icons.extension,
          iconBg: AppColors.primaryContainer,
          title: l10n.createGameTypeMatchingTitle,
          desc: l10n.createGameTypeMatchingDesc,
          selected: selectedType == GameType.wordMatching,
          onTap: () => onSelect(GameType.wordMatching),
        ),
        const SizedBox(height: AppSpacing.lg),
        _GameTypeCard(
          icon: Icons.grid_view,
          iconBg: AppColors.tertiaryContainer,
          title: l10n.createGameTypeCrosswordTitle,
          desc: l10n.createGameTypeCrosswordDesc,
          selected: selectedType == GameType.crossword,
          onTap: () => onSelect(GameType.crossword),
        ),
      ],
    );
  }
}

class _GameTypeCard extends StatelessWidget {
  const _GameTypeCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected ? AppShadows.level2 : AppShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: AppColors.onPrimary, size: 30),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineMd),
                const SizedBox(height: AppSpacing.base),
                Text(
                  desc,
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _RadioDot(selected: selected),
        ],
      ),
    );
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

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, color: AppColors.onPrimary, size: 14)
          : null,
    );
  }
}

/// Adım 2 — Ders seçimi (mevcut dropdown deseni korunur).
class _StepLesson extends StatelessWidget {
  const _StepLesson({
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
        _StepHeading(
          title: l10n.createGameStep2Title,
          subtitle: l10n.createGameStep2Subtitle,
        ),
        const SizedBox(height: AppSpacing.lg),
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
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
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

/// Adım 3 (YENİ) — Örnek önizleme. Kaydetmeden önce seçilen ders + tür için
/// `previewGame` çağrılır; yükleniyor / hata (yetersiz kelime → net mesaj + geri)
/// / data durumları gösterilir. Salt-okunur (interaktif değil). Kullanılan dil
/// başlıkları seçilen dersin kaynak/hedef kodundan türetilir (F9.2).
class _StepPreview extends ConsumerWidget {
  const _StepPreview({
    required this.lessonsAsync,
    required this.selectedLessonId,
    required this.selectedType,
    required this.onBack,
  });

  final AsyncValue<List<LessonDto>> lessonsAsync;
  final String? selectedLessonId;
  final GameType selectedType;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonId = selectedLessonId;
    // Seçilen dersin dil kodları (sütun başlıkları için); bulunamazsa varsayılan.
    final LessonDto? lesson = lessonsAsync.maybeWhen(
      data: (lessons) {
        for (final l in lessons) {
          if (l.id == lessonId) return l;
        }
        return null;
      },
      orElse: () => null,
    );
    final sourceLanguage = lesson?.sourceLanguage ?? LanguageOption.defaultSource;
    final targetLanguage = lesson?.targetLanguage ?? LanguageOption.defaultTarget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          title: l10n.createGamePreviewTitle,
          subtitle: l10n.createGamePreviewSubtitle,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (lessonId == null)
          _Box(
            child: Text(
              l10n.createGamePreviewEmpty,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          )
        else
          ref.watch(gamePreviewProvider(lessonId, selectedType)).when(
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
                      Text(
                        l10n.createGamePreviewLoading,
                        style: AppTypography.bodyMd
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                error: (error, _) => _PreviewError(
                  message: _previewErrorMessage(error, l10n),
                  onBack: onBack,
                ),
                data: (preview) => PuzzlePreview(
                  preview: preview,
                  sourceLanguage: sourceLanguage,
                  targetLanguage: targetLanguage,
                ),
              ),
      ],
    );
  }

  String _previewErrorMessage(Object? error, AppLocalizations l10n) {
    if (error is GamesFailure) {
      return error.maybeWhen(
        insufficientWords: () => l10n.createGameErrorInsufficientWords,
        network: () => l10n.createGameErrorNetwork,
        orElse: () => l10n.createGamePreviewError,
      );
    }
    return l10n.createGamePreviewError;
  }
}

/// Önizleme hatası kutusu: net mesaj (örn. yetersiz kelime) + "Geri Dön".
class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline,
                  size: 20, color: AppColors.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
              onPressed: onBack,
              child: Text(l10n.createGameStepBack),
            ),
          ),
        ],
      ),
    );
  }
}

/// Adım 4 — Sınıf seçimi (çoklu seçim).
class _StepClasses extends StatelessWidget {
  const _StepClasses({
    required this.classesAsync,
    required this.selectedClassIds,
    required this.onToggle,
  });

  final AsyncValue<List<ClassDto>> classesAsync;
  final Set<String> selectedClassIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          title: l10n.createGameStep3Title,
          subtitle: l10n.createGameStep3Subtitle,
        ),
        const SizedBox(height: AppSpacing.lg),
        classesAsync.when(
          loading: () => const _Box(
            child: SizedBox(
              height: 24,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
              ),
            ),
          ),
          error: (_, __) => _Box(
            child: Text(
              l10n.createGameClassesError,
              style: AppTypography.bodyMd.copyWith(color: AppColors.error),
            ),
          ),
          data: (classes) {
            if (classes.isEmpty) {
              return _Box(
                child: Text(
                  l10n.createGameClassesEmpty,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              );
            }
            return Column(
              children: [
                for (final c in classes) ...[
                  _ClassSelectRow(
                    classDto: c,
                    selected: selectedClassIds.contains(c.id),
                    onTap: () => onToggle(c.id),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ClassSelectRow extends StatelessWidget {
  const _ClassSelectRow({
    required this.classDto,
    required this.selected,
    required this.onTap,
  });

  final ClassDto classDto;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  classBadgeLabel(classDto.name),
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSecondary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classDto.name,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.classesStudentCount(classDto.studentCount),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              _Checkbox(checked: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: checked ? AppColors.primary : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, color: AppColors.onPrimary, size: 16)
          : null,
    );
  }
}

/// Adımlar arası "Geri Dön" / "Sonraki Adım" navigasyonu.
class _StepNav extends StatelessWidget {
  const _StepNav({
    required this.canNext,
    required this.onBack,
    required this.onNext,
  });

  final bool canNext;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        if (onBack != null) ...[
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                side: const BorderSide(color: AppColors.outlineVariant),
              ),
              onPressed: onBack,
              child: Text(l10n.createGameStepBack),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        if (onNext != null)
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              onPressed: canNext ? onNext : null,
              child: Text(l10n.createGameStepNext),
            ),
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: child,
    );
  }
}
