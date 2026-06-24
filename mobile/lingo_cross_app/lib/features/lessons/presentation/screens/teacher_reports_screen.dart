import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../results/presentation/result_date_format.dart';
import '../../../tracking/data/dtos/tracking_dtos.dart';
import '../../../tracking/presentation/students_notifier.dart';
import '../../../tracking/presentation/tracking_failure_messages.dart';
import '../widgets/skeleton_card.dart';

/// Raporlar sekmesi — F2.3 Öğretmen Takip (öğrenci listesi).
///
/// NOT: Stitch'te bu ekranın ayrı bir tasarımı YOK. Lumina Learning token'larına
/// ve mevcut kart/durum desenlerine (öğrenci listesi: avatar + meta satırı, bkz.
/// `teacher_students_screen.dart`; sonuç özeti: bkz. `student_results_history_screen.dart`)
/// sadık kalınarak tasarlandı.
///
/// `GET /teachers/me/students` listesi: her kartta ad (avatar baş harfi),
/// paylaşılan sonuç sayısı, ortalama skor (% rozeti veya "—") ve son aktivite.
/// Karta dokununca öğrenci detayına (`/teacher/students/:id/results`) gider.
/// Boş/yükleniyor/hata durumları + pull-to-refresh. Alt nav'ı [TeacherShellScreen]
/// sağlar; bu ekran kendi bottomNavigationBar'ını eklemez.
class TeacherReportsScreen extends ConsumerWidget {
  const TeacherReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final studentsAsync = ref.watch(studentsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.marginMobile,
        title: Text(
          l10n.reportsTitle,
          style: AppTypography.headlineLg.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.read(studentsNotifierProvider.notifier).refresh(),
          child: studentsAsync.when(
            loading: () => const _StudentsLoading(),
            error: (error, _) => _StudentsStateScroll(
              child: _StudentsError(
                message: trackingFailureMessage(error, l10n),
                onRetry: () =>
                    ref.read(studentsNotifierProvider.notifier).refresh(),
              ),
            ),
            data: (students) => students.isEmpty
                ? _StudentsStateScroll(child: const _StudentsEmpty())
                : _StudentsList(students: students),
          ),
        ),
      ),
    );
  }
}

class _StudentsList extends StatelessWidget {
  const _StudentsList({required this.students});

  final List<StudentSummaryDto> students;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.marginMobile,
        AppSpacing.md,
        AppSpacing.marginMobile,
        AppSpacing.xl,
      ),
      children: [
        Text(l10n.trackingStudentsTitle, style: AppTypography.headlineLg),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.trackingStudentsSubtitle,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.trackingStudentsListTitle, style: AppTypography.headlineMd),
        const SizedBox(height: AppSpacing.sm),
        for (final s in students) ...[
          _StudentCard(
            student: s,
            onTap: () => context.push(
              AppRoutes.teacherStudentResults(s.studentId),
              extra: s.displayName,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Öğrenci özet kartı — avatar + ad + paylaşılan sonuç sayısı + son aktivite +
/// ortalama skor rozeti (varsa % rozeti, yoksa "—").
class _StudentCard extends StatelessWidget {
  const _StudentCard({required this.student, required this.onTap});

  final StudentSummaryDto student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = student.displayName;
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';
    final avg = student.averagePercent;
    final lastActivity = student.lastActivityAt == null
        ? l10n.trackingLastActivityNone
        : l10n.trackingLastActivityLabel(
            formatShortDate(student.lastActivityAt!),
          );

    return Semantics(
      button: true,
      label: l10n.trackingStudentRowA11y(name, student.sharedResultsCount),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
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
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initial,
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTypography.headlineMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          l10n.trackingSharedCountLabel(
                            student.sharedResultsCount,
                          ),
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastActivity,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _AveragePill(percent: avg),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ortalama skor rozeti — varsa % (primary tonlu), yoksa "—" (nötr).
class _AveragePill extends StatelessWidget {
  const _AveragePill({required this.percent});

  final int? percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasValue = percent != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.base,
          ),
          decoration: BoxDecoration(
            color: hasValue
                ? AppColors.primaryFixed
                : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            hasValue
                ? l10n.gameResultAccuracyValue(percent!)
                : l10n.trackingAverageNone,
            style: AppTypography.labelLg.copyWith(
              color: hasValue ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.trackingAverageLabel,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Yükleniyor — başlık skeleton + birkaç kart.
class _StudentsLoading extends StatelessWidget {
  const _StudentsLoading();

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
        SkeletonCard(height: 28),
        SizedBox(height: AppSpacing.lg),
        SkeletonList(count: 4, height: 80),
      ],
    );
  }
}

/// Boş/hata durumlarını RefreshIndicator için kaydırılabilir hale getirir.
class _StudentsStateScroll extends StatelessWidget {
  const _StudentsStateScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
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

/// Boş — hiç paylaşılan sonuç / öğrenci yok.
class _StudentsEmpty extends StatelessWidget {
  const _StudentsEmpty();

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
          child: const Icon(
            Icons.assessment_outlined,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.trackingStudentsEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTypography.headlineMd,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          l10n.trackingStudentsEmptyDesc,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Hata kartı + Tekrar Dene.
class _StudentsError extends StatelessWidget {
  const _StudentsError({required this.message, required this.onRetry});

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
            l10n.trackingStudentsErrorTitle,
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
