import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Bir kelime dökümü kartının ihtiyaç duyduğu alanlar (model-bağımsız).
///
/// Hem öğretmen (`ResultItemDto`) hem öğrenci (`ResultItemModel`) DTO'ları bu
/// görünüme eşlenir; böylece kart UI'sı tek yerde paylaşılır (Sonuç Detayı ↔
/// Oyun Sonu Raporu). [studentAnswer] boş bırakıldıysa null/boş.
class ResultBreakdownItemData {
  const ResultBreakdownItemData({
    required this.term,
    required this.expectedAnswer,
    required this.studentAnswer,
    required this.isCorrect,
  });

  final String term;
  final String expectedAnswer;
  final String? studentAnswer;
  final bool isCorrect;
}

/// Cevap dökümü kart listesinin paylaşılan etiketleri.
///
/// "Senin cevabın" (öğrenci) ↔ "Öğrencinin cevabı" (öğretmen) gibi bağlama göre
/// değişen metinler dışarıdan verilir; görsel desen aynıdır.
class ResultBreakdownLabels {
  const ResultBreakdownLabels({
    required this.badgeCorrect,
    required this.badgeWrong,
    required this.correctAnswer,
    required this.studentAnswer,
    required this.studentAnswerEmpty,
    required this.itemCorrectA11y,
    required this.itemWrongA11y,
  });

  final String badgeCorrect;
  final String badgeWrong;

  /// `(expectedAnswer) -> "Doğru cevap: …"`.
  final String Function(String expected) correctAnswer;

  /// `(givenAnswer) -> "Senin cevabın: …"`.
  final String Function(String given) studentAnswer;

  /// "Senin cevabın: — (boş)" gibi boş cevap etiketi.
  final String studentAnswerEmpty;

  /// `(term, expected) -> a11y` (doğru).
  final String Function(String term, String expected) itemCorrectA11y;

  /// `(term, expected, given) -> a11y` (yanlış).
  final String Function(String term, String expected, String given)
  itemWrongA11y;
}

/// Doğru/yanlış kırılım kartları (Sonuç Detayı F7.5 görsel deseni — yeşil/kırmızı
/// sol şerit + tik/çarpı rozeti). Listeyi inline `Column` olarak döker (parent
/// `ListView`/`Column` içine gömülür). Boş liste → `SizedBox.shrink`.
class ResultItemsBreakdown extends StatelessWidget {
  const ResultItemsBreakdown({
    super.key,
    required this.items,
    required this.labels,
    this.itemSpacing = AppSpacing.xs,
  });

  final List<ResultBreakdownItemData> items;
  final ResultBreakdownLabels labels;
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          ResultBreakdownItemCard(item: items[i], labels: labels),
          if (i != items.length - 1) SizedBox(height: itemSpacing),
        ],
      ],
    );
  }
}

/// Tek bir kelime kartı — doğru (yeşil) veya yanlış (kırmızı). Sonuç Detayı
/// (öğretmen) ekranındaki kartla birebir görsel desen.
class ResultBreakdownItemCard extends StatelessWidget {
  const ResultBreakdownItemCard({
    super.key,
    required this.item,
    required this.labels,
  });

  final ResultBreakdownItemData item;
  final ResultBreakdownLabels labels;

  @override
  Widget build(BuildContext context) {
    final correct = item.isCorrect;
    final stripe = correct ? AppColors.tertiary : AppColors.error;
    final bg =
        correct ? AppColors.onTertiaryContainer : AppColors.errorContainer;

    final a11y =
        correct
            ? labels.itemCorrectA11y(item.term, item.expectedAnswer)
            : labels.itemWrongA11y(
              item.term,
              item.expectedAnswer,
              item.studentAnswer ?? '',
            );

    return Semantics(
      label: a11y,
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border(left: BorderSide(color: stripe, width: 4)),
            boxShadow: AppShadows.level2,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: stripe, shape: BoxShape.circle),
                child: Icon(
                  correct ? Icons.check : Icons.close,
                  size: 20,
                  color: correct ? AppColors.onTertiary : AppColors.onError,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child:
                    correct
                        ? _CorrectBody(item: item)
                        : _WrongBody(item: item, labels: labels),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ResultBadge(
                label: correct ? labels.badgeCorrect : labels.badgeWrong,
                bg: stripe,
                fg: correct ? AppColors.onTertiary : AppColors.onError,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CorrectBody extends StatelessWidget {
  const _CorrectBody({required this.item});

  final ResultBreakdownItemData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.term,
          style: AppTypography.headlineMd.copyWith(
            fontSize: 16,
            color: AppColors.onSurface,
          ),
        ),
        Text(
          item.expectedAnswer,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _WrongBody extends StatelessWidget {
  const _WrongBody({required this.item, required this.labels});

  final ResultBreakdownItemData item;
  final ResultBreakdownLabels labels;

  @override
  Widget build(BuildContext context) {
    final answer = item.studentAnswer;
    final hasAnswer = answer != null && answer.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.term,
          style: AppTypography.headlineMd.copyWith(
            fontSize: 16,
            color: AppColors.onSurface,
          ),
        ),
        Text(
          labels.correctAnswer(item.expectedAnswer),
          style: AppTypography.labelSm.copyWith(color: AppColors.tertiary),
        ),
        if (hasAnswer)
          Text(
            labels.studentAnswer(answer),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.error,
              decoration: TextDecoration.lineThrough,
            ),
          )
        else
          Text(
            labels.studentAnswerEmpty,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.error,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
