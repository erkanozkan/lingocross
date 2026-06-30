import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../lessons/presentation/widgets/skeleton_card.dart';
import '../../data/dtos/game_dtos.dart';
import '../../domain/game_type.dart';
import '../assigned_games_notifier.dart';

/// Sınavlara Hazırlan (Çıkmış Sorular) — öğrenciye atanan `questionSet`
/// (çıkmış sorular) bulmacalarını liste halinde gösterir.
///
/// Öğrenci panelindeki "Sınavlara Hazırlan" kartından açılır (DÜZELTME 2):
/// atanan sınavları oyunlardan ayırır. Her satır başlık + soru sayısı +
/// (tamamlandıysa) skor gösterir; dokununca mevcut launcher/çözüm akışına
/// (`/student/games/:gameId`) gider. Boş durumda sade bir bilgilendirme.
class StudentExamsScreen extends ConsumerWidget {
  const StudentExamsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final gamesAsync = ref.watch(assignedGamesNotifierProvider);

    Future<void> refresh() =>
        ref.read(assignedGamesNotifierProvider.notifier).refresh();

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
          l10n.studentExamsTitle,
          style: AppTypography.headlineMd,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: gamesAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: const [SkeletonList(count: 4, height: 88)],
          ),
          error: (_, __) => ListView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            children: [
              _ExamsState(
                icon: Icons.cloud_off,
                iconColor: AppColors.error,
                title: l10n.studentDashboardError,
                action: OutlinedButton(
                  onPressed: refresh,
                  child: Text(l10n.commonRetry),
                ),
              ),
            ],
          ),
          data: (games) {
            final exams = games
                .where((g) => g.type == GameType.questionSet)
                .toList();

            if (exams.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                children: [
                  _ExamsState(
                    icon: Icons.menu_book,
                    iconColor: AppColors.primary,
                    title: l10n.studentExamsEmptyTitle,
                    desc: l10n.studentExamsEmptyDesc,
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              children: [
                Text(
                  l10n.studentExamsSubtitle,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final exam in exams) ...[
                  _ExamRow(
                    exam: exam,
                    // Tamamlanmış sınav tekrar oynanamaz (tek-sefer); dashboard'daki
                    // tamamlanmış bulmaca deseni gibi sonuç/rapor ekranına gider.
                    // Tamamlanmamışsa launcher ile çözüme başlar.
                    onTap: () {
                      final resultId = exam.resultId;
                      if (exam.isCompleted && resultId != null) {
                        context.push(AppRoutes.studentResultDetail(resultId));
                      } else {
                        context.push(AppRoutes.studentGame(exam.id));
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Tek bir sınav (questionSet) satırı: başlık + soru sayısı + skor/durum rozeti.
class _ExamRow extends StatelessWidget {
  const _ExamRow({required this.exam, required this.onTap});

  final AssignedGameDto exam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final score = exam.score;
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
            border: Border.all(color: AppColors.outlineVariant),
            boxShadow: AppShadows.soft,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.menu_book, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.studentExamsQuestionCount(exam.wordCount),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              if (exam.isCompleted && score != null)
                _ScorePill(percent: score)
              else if (exam.isCompleted)
                _DonePill(label: l10n.studentDashboardCompletedBadge)
              else
                const Icon(Icons.chevron_right,
                    color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        l10n.studentDashboardCompletedScore(percent),
        style: AppTypography.labelLg.copyWith(color: AppColors.tertiary),
      ),
    );
  }
}

class _DonePill extends StatelessWidget {
  const _DonePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
      ),
    );
  }
}

/// Boş/hata durumu için ortak kart.
class _ExamsState extends StatelessWidget {
  const _ExamsState({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.desc,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? desc;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
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
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(title,
              style: AppTypography.headlineMd, textAlign: TextAlign.center),
          if (desc != null) ...[
            const SizedBox(height: AppSpacing.base),
            Text(
              desc!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}
