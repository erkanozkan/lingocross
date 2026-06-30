import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../games/domain/game_type.dart';
import '../../../results/presentation/result_date_format.dart';
import '../../../results/presentation/widgets/result_items_breakdown.dart';
import '../../data/dtos/tracking_dtos.dart';
import '../student_result_detail_notifier.dart';
import '../tracking_failure_messages.dart';

/// Kelime listesi filtresi (segmented control). Varsayılan [all].
enum _DetailFilter { all, correct, wrong }

/// Sonuç Detayı (Öğretmen) — F7.5 (Stitch `6403a42f…` birebir).
///
/// Öğretmen, bir öğrencinin paylaştığı sonuca tıklayınca hangi kelimeleri
/// doğru/yanlış yaptığını + öğrencinin verdiği cevabı görür. Üstte öğrenci
/// bağlam kartı + bento özet; segmented filtre (Tümü/Doğrular/Yanlışlar); kelime
/// listesi; öğrencinin KENDİ süresinden türeyen "Bölüm Analizi" (sınıf ortalaması
/// YOK). Eski sonuçlarda (items boş) kelime listesi yerine boş durum gösterilir.
class StudentResultDetailScreen extends ConsumerStatefulWidget {
  const StudentResultDetailScreen({
    super.key,
    required this.studentId,
    required this.resultId,
  });

  final String studentId;
  final String resultId;

  @override
  ConsumerState<StudentResultDetailScreen> createState() =>
      _StudentResultDetailScreenState();
}

class _StudentResultDetailScreenState
    extends ConsumerState<StudentResultDetailScreen> {
  _DetailFilter _filter = _DetailFilter.all;

  @override
  void initState() {
    super.initState();
    // DÜZELTME 3: ekrana girişte bir kez tazele (mevcut veri korunur).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(
            studentResultDetailNotifierProvider(
              widget.studentId,
              widget.resultId,
            ).notifier,
          )
          .refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(
      studentResultDetailNotifierProvider(widget.studentId, widget.resultId),
    );

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
          l10n.resultDetailTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: detailAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => _DetailError(
            message: trackingFailureMessage(error, l10n),
            onRetry: () => ref
                .read(
                  studentResultDetailNotifierProvider(
                    widget.studentId,
                    widget.resultId,
                  ).notifier,
                )
                .refresh(),
          ),
          data: (detail) => _DetailBody(
            detail: detail,
            filter: _filter,
            onFilterChanged: (f) => setState(() => _filter = f),
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.filter,
    required this.onFilterChanged,
  });

  final StudentResultDetailDto detail;
  final _DetailFilter filter;
  final ValueChanged<_DetailFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasItems = detail.hasItems;
    final visibleItems = switch (filter) {
      _DetailFilter.all => detail.items,
      _DetailFilter.correct => detail.items.where((i) => i.isCorrect).toList(),
      _DetailFilter.wrong => detail.items.where((i) => !i.isCorrect).toList(),
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        _StudentContextCard(detail: detail),
        const SizedBox(height: AppSpacing.lg),
        _BentoMetrics(detail: detail),
        if (hasItems) ...[
          const SizedBox(height: AppSpacing.lg),
          _SegmentedFilter(
            detail: detail,
            value: filter,
            onChanged: onFilterChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          ResultItemsBreakdown(
            items: [
              for (final item in visibleItems)
                ResultBreakdownItemData(
                  term: item.term,
                  expectedAnswer: item.expectedAnswer,
                  studentAnswer: item.studentAnswer,
                  isCorrect: item.isCorrect,
                ),
            ],
            labels: _teacherBreakdownLabels(l10n),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionAnalysis(detail: detail),
        ] else ...[
          const SizedBox(height: AppSpacing.lg),
          const _NoItemsCard(),
        ],
      ],
    );
  }
}

/// Öğretmen ekranı kelime kartı etiketleri ("Öğrencinin cevabı" dili).
ResultBreakdownLabels _teacherBreakdownLabels(AppLocalizations l10n) {
  return ResultBreakdownLabels(
    badgeCorrect: l10n.resultDetailBadgeCorrect,
    badgeWrong: l10n.resultDetailBadgeWrong,
    correctAnswer: l10n.resultDetailCorrectAnswer,
    studentAnswer: l10n.resultDetailStudentAnswer,
    studentAnswerEmpty: l10n.resultDetailStudentAnswerEmpty,
    itemCorrectA11y: l10n.resultDetailItemCorrectA11y,
    itemWrongA11y: l10n.resultDetailItemWrongA11y,
  );
}

/// Öğrenci bağlam kartı: avatar + ad + ders, sağ üstte oyun türü chip, alt
/// satırda divider + tarih•saat.
class _StudentContextCard extends StatelessWidget {
  const _StudentContextCard({required this.detail});

  final StudentResultDetailDto detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = detail.studentDisplayName.trim();
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    final local = detail.createdAt.toLocal();
    final dateLabel = formatShortDate(
      detail.createdAt,
      localeCode: Localizations.localeOf(context).languageCode,
    );
    final timeLabel =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initial,
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      detail.lessonTitle,
                      style: AppTypography.bodyMd.copyWith(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _GameTypeChip(gameType: detail.gameType),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 16,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.resultDetailDateTime(dateLabel, timeLabel),
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameTypeChip extends StatelessWidget {
  const _GameTypeChip({required this.gameType});

  final GameType gameType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = switch (gameType) {
      GameType.wordMatching => l10n.gameTypeWordMatching,
      GameType.crossword => l10n.gameTypeCrossword,
      GameType.questionSet => l10n.gameTypeQuestionSet,
      GameType.scrambled => l10n.gameTypeScrambled,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: AppColors.onPrimaryFixedVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// 3 sütun bento özet: Başarı % / Doğru C-T / Süre.
class _BentoMetrics extends StatelessWidget {
  const _BentoMetrics({required this.detail});

  final StudentResultDetailDto detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _BentoTile(
              value: l10n.gameResultAccuracyValue(detail.accuracyPercent),
              valueColor: AppColors.primary,
              label: l10n.resultDetailMetricAccuracy,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _BentoTile(
              value: l10n.gameResultWordsValue(
                detail.correctItems,
                detail.totalItems,
              ),
              valueColor: AppColors.tertiary,
              label: l10n.resultDetailMetricCorrect,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: _BentoTile(
              value: detail.formattedDuration,
              valueColor: AppColors.onSurface,
              label: l10n.resultDetailMetricDuration,
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  const _BentoTile({
    required this.value,
    required this.valueColor,
    required this.label,
  });

  final String value;
  final Color valueColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              value,
              style: AppTypography.headlineLg.copyWith(color: valueColor),
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill segmented control: Tümü / Doğrular / Yanlışlar.
class _SegmentedFilter extends StatelessWidget {
  const _SegmentedFilter({
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final StudentResultDetailDto detail;
  final _DetailFilter value;
  final ValueChanged<_DetailFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.outlineVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: l10n.resultDetailFilterAll(detail.items.length),
              selected: value == _DetailFilter.all,
              onTap: () => onChanged(_DetailFilter.all),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: l10n.resultDetailFilterCorrect(detail.correctItemsCount),
              selected: value == _DetailFilter.correct,
              onTap: () => onChanged(_DetailFilter.correct),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: l10n.resultDetailFilterWrong(detail.wrongItemsCount),
              selected: value == _DetailFilter.wrong,
              onTap: () => onChanged(_DetailFilter.wrong),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelLg.copyWith(
              color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bölüm Analizi — öğrencinin KENDİ süresinden basit hız skoru (sınıf
/// ortalaması YOK). totalItems 0 ise gizlenir.
class _SectionAnalysis extends StatelessWidget {
  const _SectionAnalysis({required this.detail});

  final StudentResultDetailDto detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sec = detail.secondsPerWord;
    if (sec == null) return const SizedBox.shrink();

    final (String speedLabel, double fillFraction) = switch (sec) {
      < 4 => (l10n.resultDetailSpeedGreat, 0.92),
      < 8 => (l10n.resultDetailSpeedGood, 0.70),
      < 15 => (l10n.resultDetailSpeedFair, 0.45),
      _ => (l10n.resultDetailSpeedSlow, 0.20),
    };
    final secText = sec.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.resultDetailAnalysisTitle,
            style: AppTypography.bodyMd.copyWith(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.resultDetailSpeedScore,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                speedLabel,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: fillFraction.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.resultDetailSpeedDesc(secText),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// items boş (eski sonuç) — kelime listesi yerine tek bilgi kartı.
class _NoItemsCard extends StatelessWidget {
  const _NoItemsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.resultDetailNoItemsTitle,
            textAlign: TextAlign.center,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.resultDetailNoItemsDesc,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
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
              const Icon(Icons.cloud_off, size: 40, color: AppColors.error),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.resultDetailErrorTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineMd,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
