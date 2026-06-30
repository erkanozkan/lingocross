import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/ai_exam_dtos.dart';
import '../../domain/ai_question_type.dart';
import '../../domain/games_failure.dart';
import '../ai_exam_controller.dart';

/// Yapay Zeka ile Sınav Soruları — gözden geçir/ata ekranı (Stitch `exam_review`
/// birebir). Üst özet (üretilen soru sayısı + ders/grade/sınıf çipleri + Yeniden
/// Üret), her soru kartı (Soru N + sil, tür etiketi, kök, A–D şıklar — doğru
/// yeşil zemin+onay, "Açıklama:" satırı) ve alt 3D "Öğrencilere Ata" butonu.
///
/// Düzenleme ikonu bu fazda YOK (gizli) — yalnız soru silme + atama. Silinen
/// sorular önce sunucudan (`DELETE`), başarıda listeden düşer. Atama mevcut
/// `setTopicAssignments` ile yapılır; başarıda [onAssigned] çağrılır.
class AiExamReviewScreen extends ConsumerWidget {
  const AiExamReviewScreen({
    super.key,
    required this.result,
    required this.className,
    required this.classId,
    required this.onRegenerate,
    required this.onAssigned,
  });

  final AiExamResultDto result;
  final String className;
  final String classId;
  final VoidCallback onRegenerate;
  final VoidCallback onAssigned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final review = ref.watch(aiExamReviewControllerProvider(result));
    final questions = review.questions;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.aiExamReviewTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.md,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _SummaryCard(
            count: questions.length,
            title: result.title,
            grade: result.grade,
            className: className,
            onRegenerate: onRegenerate,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (questions.isEmpty)
            _EmptyState(message: l10n.aiExamReviewEmpty)
          else
            for (var i = 0; i < questions.length; i++) ...[
              _QuestionCard(
                index: i + 1,
                question: questions[i],
                onDelete: () => _deleteQuestion(
                  context,
                  ref,
                  questions[i].id,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
      bottomNavigationBar: _BottomBar(
        count: questions.length,
        className: className,
        enabled: questions.isNotEmpty,
        onAssign: () => _assign(context, ref),
      ),
    );
  }

  Future<void> _deleteQuestion(
    BuildContext context,
    WidgetRef ref,
    String questionId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(aiExamReviewControllerProvider(result).notifier)
          .deleteQuestion(questionId);
    } on GamesFailure {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.aiExamReviewDeleteError)),
      );
    }
  }

  Future<void> _assign(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(aiExamReviewControllerProvider(result).notifier)
          .assign([classId]);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.aiExamReviewAssignSuccess)),
      );
      onAssigned();
    } on GamesFailure {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.aiExamReviewAssignError)),
      );
    }
  }
}

/// Üst özet kartı (Stitch §Summary Bento): büyük sayı + "soru üretildi" +
/// ders/grade/sınıf çipleri + sağ üstte "Yeniden Üret".
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.count,
    required this.title,
    required this.grade,
    required this.className,
    required this.onRegenerate,
  });

  final int count;
  final String title;
  final int grade;
  final String className;
  final VoidCallback onRegenerate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onRegenerate,
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: AppSpacing.base),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.base),
                    Text(
                      l10n.aiExamReviewRegenerate,
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: AppTypography.displayLgMobile
                        .copyWith(color: AppColors.primary, height: 1),
                  ),
                  Text(
                    l10n.aiExamReviewCount(count),
                    style: AppTypography.labelSm
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _Chip(
                      label: title,
                      background: AppColors.primaryFixed,
                      foreground: AppColors.onPrimaryFixedVariant,
                    ),
                    _Chip(
                      label: l10n.aiExamReviewGradeChip(grade),
                      background: AppColors.surfaceContainerHigh,
                      foreground: AppColors.onSurface,
                    ),
                    if (className.isNotEmpty)
                      _Chip(
                        label: l10n.aiExamReviewClassChip(className),
                        background: AppColors.surfaceContainerHigh,
                        foreground: AppColors.onSurface,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.base),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: foreground),
      ),
    );
  }
}

/// Tek soru kartı (Stitch §Question Card): "Soru N" + sil ikonu, tür etiketi,
/// kök, A–D şıklar (doğru = yeşil zemin + onay), "Açıklama:" satırı.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.onDelete,
  });

  final int index;
  final AiGeneratedQuestion question;
  final VoidCallback onDelete;

  String? _typeLabel(AppLocalizations l10n) {
    final type = AiQuestionType.fromCode(question.type);
    return switch (type) {
      AiQuestionType.wordMeaning => l10n.aiExamTypeWordMeaning,
      AiQuestionType.fillBlank => l10n.aiExamTypeFillBlank,
      AiQuestionType.synonym => l10n.aiExamTypeSynonym,
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // A–D harf etiketleri için pozisyona göre sıralı şıklar.
    final options = [...question.options]
      ..sort((a, b) => a.position.compareTo(b.position));
    final typeLabel = _typeLabel(l10n);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.aiExamReviewQuestionLabel(index),
                style: AppTypography.labelLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Düzenleme ikonu bu fazda gizli; yalnız sil.
              Semantics(
                button: true,
                label: l10n.aiExamReviewDeleteA11y(index),
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: AppColors.error),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
          if (typeLabel != null) ...[
            _Chip(
              label: typeLabel,
              background: AppColors.surfaceContainerLow,
              foreground: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(question.stem, style: AppTypography.bodyMd),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < options.length; i++) ...[
            _OptionRow(
              letter: String.fromCharCode(65 + i), // A, B, C, D
              option: options[i],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          if (question.explanation != null &&
              question.explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            const Divider(height: 1, color: AppColors.outlineVariant),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiExamReviewExplanation,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Text(
                    question.explanation!,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Tek şık satırı (Stitch §Option): doğru → açık yeşil zemin + yeşil kenarlık +
/// onay; diğerleri → nötr zemin.
class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.letter, required this.option});

  final String letter;
  final AiGeneratedQuestionOption option;

  @override
  Widget build(BuildContext context) {
    final correct = option.isCorrect;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: correct
            ? AppColors.tertiary.withValues(alpha: 0.08)
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: correct ? AppColors.tertiary : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Text(
            '$letter)',
            style: AppTypography.bodyMd.copyWith(
              fontWeight: FontWeight.w700,
              color: correct ? AppColors.tertiary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              option.text,
              style: AppTypography.bodyMd.copyWith(
                color:
                    correct ? AppColors.tertiary : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          if (correct)
            const Icon(Icons.check_circle,
                size: 20, color: AppColors.tertiary),
        ],
      ),
    );
  }
}

/// Tüm sorular silindiğinde gösterilen boş durum.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

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
          const Icon(Icons.auto_awesome,
              color: AppColors.outline, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style:
                AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Alt aksiyon çubuğu (Stitch §Bottom Action Bar): atama özeti notu + 3D
/// "Öğrencilere Ata".
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.count,
    required this.className,
    required this.enabled,
    required this.onAssign,
  });

  final int count;
  final String className;
  final bool enabled;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (className.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.base),
                    Flexible(
                      child: Text(
                        l10n.aiExamReviewAssignNote(count, className),
                        style: AppTypography.labelSm
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton3D(
                label: l10n.aiExamReviewAssignButton,
                trailingIcon: Icons.group_add,
                enabled: enabled,
                onPressed: enabled ? onAssign : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
