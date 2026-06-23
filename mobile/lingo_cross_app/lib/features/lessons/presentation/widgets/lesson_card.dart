import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/lesson_dtos.dart';

/// Derslerim listesindeki ders kartı (teacher-dashboard.md §3.4).
///
/// Sol ikon kutusu (48×48, tertiary-container) + orta ad/meta + sağda yayın
/// durumu rozeti ve kelime sayısı. M2'de öğrenci/oyun verisi yok → öğrenci
/// sayısı "Henüz öğrenci yok"; başarı yüzdesi/progress gizli.
class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, required this.onTap});

  final LessonDto lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(
                  Icons.school,
                  color: AppColors.onTertiary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: AppTypography.labelLg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.teacherDashboardLessonNoStudents,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusBadge(isPublished: lesson.isPublished),
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    l10n.teacherDashboardWordCount(lesson.wordCount),
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isPublished});

  final bool isPublished;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg =
        isPublished ? AppColors.tertiaryFixed : AppColors.surfaceContainerHigh;
    final fg =
        isPublished ? AppColors.onTertiaryFixed : AppColors.onSurfaceVariant;
    final text = isPublished
        ? l10n.teacherDashboardLessonPublished
        : l10n.teacherDashboardLessonDraft;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(text, style: AppTypography.labelSm.copyWith(color: fg)),
    );
  }
}
