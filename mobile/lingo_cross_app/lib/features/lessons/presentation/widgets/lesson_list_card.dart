import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/dtos/lesson_dtos.dart';
import 'lesson_status_badge.dart';

/// Derslerim listesindeki ders kartı (Stitch `930ab2e6…` "lesson-card").
///
/// Üstte tarih (`scheduledLabel`, takvim ikonu), ortada ünite adı (title), altta
/// kelime sayısı + durum rozeti; sağda chevron. Level-2 yumuşak gölge.
class LessonListCard extends StatelessWidget {
  const LessonListCard({super.key, required this.lesson, required this.onTap});

  final LessonDto lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateText = (lesson.scheduledLabel?.trim().isNotEmpty ?? false)
        ? lesson.scheduledLabel!.trim()
        : l10n.lessonsListNoDate;

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
            boxShadow: AppShadows.level2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: AppSpacing.base),
                        Expanded(
                          child: Text(
                            dateText,
                            style: AppTypography.labelSm
                                .copyWith(color: AppColors.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      lesson.title,
                      style: AppTypography.headlineMd,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.translate,
                            size: 18, color: AppColors.tertiary),
                        const SizedBox(width: AppSpacing.base),
                        Text(
                          l10n.lessonsListWordCount(lesson.wordCount),
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.tertiary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        LessonStatusBadge(status: lesson.status),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
