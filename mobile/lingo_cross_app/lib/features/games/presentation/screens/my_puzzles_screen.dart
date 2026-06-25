import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../../results/presentation/result_date_format.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/game_type.dart';
import '../my_puzzles_notifier.dart';

/// Bulmacalarım (Öğretmen) — Stitch `5fc69fda…` birebir.
///
/// "+ Yeni Bulmaca Oluştur" CTA → mevcut create ekranı. Filtre çipleri
/// (Tümü / Aktif). Bulmaca kartları: tür rozeti + Aktif durumu + ders başlığı +
/// "Paylaşılan: {n} öğrenci" + oluşturma tarihi + Detayları Gör.
/// Alt istatistik: Toplam Bulmaca (liste uzunluğu) + Öğrenci Çözümü (solveCount
/// toplamı). Boş/yükleniyor (skeleton)/hata + pull-to-refresh.
///
/// Bulmacalar oluşturulduğunda otomatik yayımlanır; manuel "Paylaş" aksiyonu
/// yoktur (DÜZELTME 2). Ekrana girişte bir kez yenilenir (DÜZELTME 3).
///
/// Stitch'teki Taslak/Arşiv çipleri ve Word Search türü bu fazda yok (karar
/// gereği kalıcı taslak/Word Search kapsam dışı).
class MyPuzzlesScreen extends ConsumerStatefulWidget {
  const MyPuzzlesScreen({super.key});

  @override
  ConsumerState<MyPuzzlesScreen> createState() => _MyPuzzlesScreenState();
}

enum _PuzzleFilter { all, active }

class _MyPuzzlesScreenState extends ConsumerState<MyPuzzlesScreen> {
  _PuzzleFilter _filter = _PuzzleFilter.all;

  @override
  void initState() {
    super.initState();
    // DÜZELTME 3: ekrana girişte bir kez güncel veriyi çek (mevcut veri
    // gösterilmeye devam eder, boş ekran flaşı olmaz).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(myPuzzlesNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final puzzlesAsync = ref.watch(myPuzzlesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Text(
          l10n.myPuzzlesTitle,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(myPuzzlesNotifierProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            PrimaryButton3D(
              label: l10n.myPuzzlesCreateCta,
              trailingIcon: Icons.add,
              onPressed: () => context.push(AppRoutes.gameNew),
            ),
            const SizedBox(height: AppSpacing.lg),
            puzzlesAsync.when(
              loading: () => const SkeletonList(count: 3, height: 168),
              error: (_, __) => _PuzzlesError(
                onRetry: () =>
                    ref.read(myPuzzlesNotifierProvider.notifier).refresh(),
              ),
              data: (puzzles) => _PuzzlesBody(
                puzzles: puzzles,
                filter: _filter,
                onFilterChanged: (f) => setState(() => _filter = f),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filtre çipleri + liste/boş durum + alt istatistik (data dalı).
class _PuzzlesBody extends StatelessWidget {
  const _PuzzlesBody({
    required this.puzzles,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<TeacherPuzzleDto> puzzles;
  final _PuzzleFilter filter;
  final ValueChanged<_PuzzleFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final activeCount = puzzles.where((p) => p.isPublished).length;
    final visible = filter == _PuzzleFilter.active
        ? puzzles.where((p) => p.isPublished).toList()
        : puzzles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Filters(
          filter: filter,
          activeCount: activeCount,
          onChanged: onFilterChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        if (visible.isEmpty)
          _EmptyPuzzles(onCreate: () => context.push(AppRoutes.gameNew))
        else
          for (final puzzle in visible) ...[
            _PuzzleCard(puzzle: puzzle),
            const SizedBox(height: AppSpacing.md),
          ],
        const SizedBox(height: AppSpacing.lg),
        _StatsRow(
          totalPuzzles: puzzles.length,
          totalSolves: puzzles.fold<int>(0, (sum, p) => sum + p.solveCount),
        ),
      ],
    );
  }
}

/// Filtre çipleri (Tümü / Aktif). Taslak/Arşiv bu fazda yok.
class _Filters extends StatelessWidget {
  const _Filters({
    required this.filter,
    required this.activeCount,
    required this.onChanged,
  });

  final _PuzzleFilter filter;
  final int activeCount;
  final ValueChanged<_PuzzleFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: l10n.myPuzzlesFilterAll,
            selected: filter == _PuzzleFilter.all,
            onTap: () => onChanged(_PuzzleFilter.all),
          ),
          const SizedBox(width: AppSpacing.xs),
          _Chip(
            label: l10n.myPuzzlesFilterActive(activeCount),
            selected: filter == _PuzzleFilter.active,
            onTap: () => onChanged(_PuzzleFilter.active),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary : AppColors.surfaceContainer;
    final fg = selected ? AppColors.onPrimary : AppColors.onSurfaceVariant;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Text(label, style: AppTypography.labelLg.copyWith(color: fg)),
        ),
      ),
    );
  }
}

/// Tek bulmaca kartı (Stitch puzzle-card birebir).
class _PuzzleCard extends StatelessWidget {
  const _PuzzleCard({required this.puzzle});

  final TeacherPuzzleDto puzzle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailEnabled = puzzle.isPublished;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TypeBadge(type: puzzle.type),
              const Spacer(),
              if (puzzle.isPublished) const _ActiveBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            puzzle.lessonTitle,
            style: AppTypography.headlineMd,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            icon: Icons.calendar_today,
            text: l10n.myPuzzlesCreatedAt(
              formatShortDate(
                puzzle.createdAt,
                localeCode: Localizations.localeOf(context).languageCode,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          _MetaRow(
            icon: Icons.groups,
            text: l10n.myPuzzlesSharedWith(puzzle.assignedStudentCount),
            emphasize: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: _DetailsLink(
              enabled: detailEnabled,
              onTap: detailEnabled
                  ? () => context.push(AppRoutes.lessonDetail(puzzle.lessonId))
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tür rozeti: 1 → Kelime Eşleştirme (secondary), 2 → Crossword (primary).
class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final GameType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isCrossword = type == GameType.crossword;
    final Color color = isCrossword ? AppColors.primary : AppColors.secondary;
    final Color bg = isCrossword
        ? AppColors.surfaceContainerHighest
        : AppColors.secondaryContainer;
    final IconData icon = isCrossword ? Icons.grid_on : Icons.extension;
    final String label = isCrossword
        ? l10n.myPuzzlesTypeCrossword
        : l10n.myPuzzlesTypeWordMatching;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.base),
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Aktif" durum rozeti (tertiary).
class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        l10n.myPuzzlesStatusActive,
        style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.text,
    this.emphasize = false,
  });

  final IconData icon;
  final String text;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppTypography.labelSm.copyWith(
              color: emphasize ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: emphasize ? FontWeight.w600 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// "Detayları Gör" alt bağlantısı (ders detayına gider).
class _DetailsLink extends StatelessWidget {
  const _DetailsLink({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color =
        enabled ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.5);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.myPuzzlesSeeDetails,
              style: AppTypography.labelLg.copyWith(color: color),
            ),
            Icon(Icons.chevron_right, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}

/// Alt istatistik: Toplam Bulmaca + Öğrenci Çözümü (Stitch bento hint).
class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.totalPuzzles, required this.totalSolves});

  final int totalPuzzles;
  final int totalSolves;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '$totalPuzzles',
            label: l10n.myPuzzlesStatTotal,
            background: AppColors.primaryContainer,
            foreground: AppColors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            value: '$totalSolves',
            label: l10n.myPuzzlesStatSolves,
            background: AppColors.secondaryContainer,
            foreground: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String value;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.displayLg.copyWith(color: foreground)),
          const SizedBox(height: AppSpacing.base),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSm
                .copyWith(color: foreground.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}

/// Boş durum: "Henüz bulmaca yok — Yeni Bulmaca Oluştur".
class _EmptyPuzzles extends StatelessWidget {
  const _EmptyPuzzles({required this.onCreate});

  final VoidCallback onCreate;

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
          const Icon(Icons.extension, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myPuzzlesEmptyTitle,
            style: AppTypography.headlineMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.myPuzzlesEmptyDesc,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onCreate,
            child: Text(l10n.myPuzzlesCreateCta),
          ),
        ],
      ),
    );
  }
}

/// Hata durumu + Tekrar Dene.
class _PuzzlesError extends StatelessWidget {
  const _PuzzlesError({required this.onRetry});

  final VoidCallback onRetry;

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
          const Icon(Icons.cloud_off, color: AppColors.error, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.myPuzzlesErrorTitle,
            style: AppTypography.headlineMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
