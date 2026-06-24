import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../games/domain/game_type.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../../results/presentation/result_date_format.dart';
import '../../data/dtos/tracking_dtos.dart';
import '../student_results_notifier.dart';
import '../tracking_failure_messages.dart';

/// Öğrenci Raporu (detay) — F2.3 Öğretmen Takip.
///
/// NOT: Stitch'te ayrı bir tasarımı YOK. Lumina Learning token'larına ve mevcut
/// "Sonuçlarım" (öğrenci geçmişi) ekranının özet-şerit + sonuç-kartı desenine
/// sadık kalınarak tasarlandı.
///
/// `GET /teachers/me/students/{studentId}/results`: özet (öğrenci adı + ortalama
/// + paylaşılan sonuç sayısı) + sonuç kartları (ders başlığı, oyun türü, skor%,
/// süre, doğru/toplam, tarih) — yeniden eskiye. Boş/yükleniyor/hata + pull-to-refresh.
class StudentReportScreen extends ConsumerWidget {
  const StudentReportScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  final String studentId;

  /// Liste ekranından taşınan görünen ad (özet başlığı için). Boşsa generik başlık.
  final String studentName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final resultsAsync = ref.watch(studentResultsNotifierProvider(studentId));

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
          studentName.isNotEmpty ? studentName : l10n.trackingDetailTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh:
              () =>
                  ref
                      .read(studentResultsNotifierProvider(studentId).notifier)
                      .refresh(),
          child: resultsAsync.when(
            loading: () => const _ReportLoading(),
            error:
                (error, _) => _ReportStateScroll(
                  child: _ReportError(
                    message: trackingFailureMessage(error, l10n),
                    onRetry:
                        () =>
                            ref
                                .read(
                                  studentResultsNotifierProvider(
                                    studentId,
                                  ).notifier,
                                )
                                .refresh(),
                  ),
                ),
            data:
                (results) =>
                    results.isEmpty
                        ? _ReportStateScroll(child: const _ReportEmpty())
                        : _ReportList(
                          studentId: studentId,
                          studentName: studentName,
                          results: results,
                        ),
          ),
        ),
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  const _ReportList({
    required this.studentId,
    required this.studentName,
    required this.results,
  });

  final String studentId;
  final String studentName;
  final List<SharedResultDto> results;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = results.length;
    final avg =
        total == 0
            ? 0
            : (results.fold<int>(0, (s, r) => s + r.accuracyPercent) / total)
                .round();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        if (studentName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Text(studentName, style: AppTypography.headlineLg),
          ),
        // Özet şeridi: ortalama doğruluk + paylaşılan sonuç sayısı.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SummaryCard(
                  icon: Icons.track_changes,
                  iconColor: AppColors.secondary,
                  label: l10n.trackingDetailAverageLabel,
                  value: l10n.gameResultAccuracyValue(avg),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _SummaryCard(
                  icon: Icons.analytics,
                  iconColor: AppColors.primary,
                  label: l10n.trackingDetailResultsLabel,
                  value: '$total',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.trackingDetailResultsTitle, style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.sm),
        for (final r in results) ...[
          _ResultCard(studentId: studentId, result: r),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(value, style: AppTypography.headlineMd),
        ],
      ),
    );
  }
}

/// Sonuç kartı — ders adı + oyun türü + meta (süre, doğru/toplam, tarih) + skor%.
///
/// F7.5: tıklanınca o sonucun kelime-bazlı "Sonuç Detayı" ekranına gider.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.studentId, required this.result});

  final String studentId;
  final SharedResultDto result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateLabel = formatShortDate(
      result.createdAt,
      localeCode: Localizations.localeOf(context).languageCode,
    );

    return Semantics(
      button: true,
      label: l10n.trackingResultA11y(
        result.lessonTitle,
        result.accuracyPercent,
        result.formattedDuration,
        result.correctItems,
        result.totalItems,
        dateLabel,
      ),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap:
              () => context.push(
                AppRoutes.teacherStudentResultDetail(
                  studentId,
                  result.resultId,
                ),
              ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.level2,
            ),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.lessonTitle,
                          style: AppTypography.headlineMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          _gameTypeLabel(l10n, result.gameType),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: AppSpacing.sm,
                          children: [
                            _Meta(
                              icon: Icons.schedule,
                              text: result.formattedDuration,
                            ),
                            _Meta(
                              icon: Icons.menu_book,
                              text: l10n.gameResultWordsValue(
                                result.correctItems,
                                result.totalItems,
                              ),
                            ),
                            Text(
                              dateLabel,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.gameResultAccuracyValue(result.accuracyPercent),
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _gameTypeLabel(AppLocalizations l10n, GameType type) => switch (type) {
    GameType.wordMatching => l10n.gameTypeWordMatching,
    GameType.crossword => l10n.gameTypeCrossword,
    GameType.questionSet => l10n.gameTypeQuestionSet,
  };
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.base),
        Text(
          text,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ReportLoading extends StatelessWidget {
  const _ReportLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: const [
        Row(
          children: [
            Expanded(child: SkeletonCard(height: 88)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: SkeletonCard(height: 88)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        SkeletonList(count: 4, height: 96),
      ],
    );
  }
}

class _ReportStateScroll extends StatelessWidget {
  const _ReportStateScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Center(child: child),
              ),
            ),
          ),
    );
  }
}

class _ReportEmpty extends StatelessWidget {
  const _ReportEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.inbox, size: 36, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.trackingDetailEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTypography.headlineMd,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.trackingDetailEmptyDesc,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ReportError extends StatelessWidget {
  const _ReportError({required this.message, required this.onRetry});

  final String message;
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40, color: AppColors.error),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.trackingDetailErrorTitle,
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
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
