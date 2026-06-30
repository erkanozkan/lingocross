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
import '../../../classes/data/dtos/class_dtos.dart';
import '../../../classes/presentation/classes_notifier.dart';
import '../../../lessons/data/dtos/lesson_dtos.dart';
import '../../../lessons/presentation/lessons_notifier.dart';
import '../../data/dtos/ai_exam_dtos.dart';
import '../../domain/ai_question_type.dart';
import '../../domain/games_failure.dart';
import '../ai_exam_controller.dart';
import 'ai_exam_loading_screen.dart';
import 'ai_exam_review_screen.dart';

/// Yapay Zeka ile Sınav Soruları Oluştur — config ekranı (Stitch `exam_create`
/// birebir). Ekranın iç durum makinesi config → yükleme → review arasında geçer
/// (tek go_router rotası). Üretim/atama sonrası öğretmen ana sayfasına döner.
///
/// Config alanları: Ders Seç (dropdown), Sınıf Seç (tek seçim chip), Sınıf
/// Seviyesi (1–12 pill), Soru Türleri (Stitch'e EKLENEN çoklu-seçim chip —
/// en az 1 zorunlu), Soru Sayısı (1–10 stepper, vars. 10) + bilgi kutusu + 3D
/// "Yapay Zeka ile Soru Oluştur" butonu.
class AiExamCreateScreen extends ConsumerStatefulWidget {
  const AiExamCreateScreen({super.key, this.initialLessonId});

  /// Ders Detayı'ndan gelince ön-seçili ders (opsiyonel).
  final String? initialLessonId;

  @override
  ConsumerState<AiExamCreateScreen> createState() => _AiExamCreateScreenState();
}

/// İç akış aşamaları.
enum _Phase { config, loading, review }

class _AiExamCreateScreenState extends ConsumerState<AiExamCreateScreen> {
  static const int _gradeMin = 1;
  static const int _gradeMax = 12;
  static const int _countMin = 1;
  static const int _countMax = 10;

  _Phase _phase = _Phase.config;

  String? _selectedLessonId;
  String? _selectedClassId;
  int _grade = 6;
  int _count = 10;
  final Set<AiQuestionType> _types = {AiQuestionType.wordMeaning};

  // Üretim sonucu + seçilen sınıf adı (review özetinde gösterilir).
  AiExamResultDto? _result;
  String _selectedClassName = '';

  @override
  void initState() {
    super.initState();
    _selectedLessonId = widget.initialLessonId;
  }

  bool get _canGenerate => _selectedLessonId != null && _types.isNotEmpty;

  void _toggleType(AiQuestionType type) {
    setState(() {
      if (!_types.add(type)) _types.remove(type);
    });
  }

  Future<void> _generate(String className) async {
    if (!_canGenerate) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _selectedClassName = className;
      _phase = _Phase.loading;
    });

    final result = await ref.read(aiExamControllerProvider.notifier).generate(
          lessonId: _selectedLessonId!,
          grade: _grade,
          count: _count,
          types: _types.map((t) => t.code).toList(growable: false),
        );
    if (!mounted) return;

    if (result != null) {
      setState(() {
        _result = result;
        _phase = _Phase.review;
      });
    } else {
      final error = ref.read(aiExamControllerProvider).error;
      messenger.showSnackBar(
        SnackBar(content: Text(_errorMessage(error, l10n))),
      );
      setState(() => _phase = _Phase.config);
    }
  }

  String _errorMessage(Object? error, AppLocalizations l10n) {
    if (error is GamesFailure) {
      return error.maybeWhen(
        insufficientWords: () => l10n.aiExamErrorInsufficientWords,
        aiUnavailable: () => l10n.aiExamErrorAiUnavailable,
        network: () => l10n.aiExamErrorNetwork,
        orElse: () => l10n.aiExamErrorGeneric,
      );
    }
    return l10n.aiExamErrorGeneric;
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.loading) {
      return const AiExamLoadingScreen();
    }
    if (_phase == _Phase.review && _result != null) {
      return AiExamReviewScreen(
        result: _result!,
        className: _selectedClassName,
        classId: _selectedClassId!,
        // "Yeniden Üret": config'e dön (öğretmen parametreleri ayarlayıp
        // tekrar üretebilir). Mevcut seçim korunur.
        onRegenerate: () => setState(() {
          _result = null;
          _phase = _Phase.config;
        }),
        // Atama başarıyla bitince öğretmen ana sayfasına dön.
        onAssigned: () => context.go(AppRoutes.teacher),
      );
    }
    return _buildConfig(context);
  }

  Widget _buildConfig(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lessonsAsync = ref.watch(lessonsNotifierProvider);
    final classesAsync = ref.watch(classesNotifierProvider);

    // Seçili sınıf adı (üretirken review'a taşınır).
    final selectedClassName = classesAsync.maybeWhen(
      data: (classes) {
        for (final c in classes) {
          if (c.id == _selectedClassId) return c.name;
        }
        return '';
      },
      orElse: () => '',
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
          l10n.aiExamCreateTitle,
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
          const _IntroCard(),
          const SizedBox(height: AppSpacing.lg),
          _LessonSelect(
            lessonsAsync: lessonsAsync,
            selectedLessonId: _selectedLessonId,
            onChanged: (id) => setState(() => _selectedLessonId = id),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ClassSelect(
            classesAsync: classesAsync,
            selectedClassId: _selectedClassId,
            onSelect: (id) => setState(() => _selectedClassId = id),
          ),
          const SizedBox(height: AppSpacing.lg),
          _GradeSelect(
            grade: _grade,
            min: _gradeMin,
            max: _gradeMax,
            onSelect: (g) => setState(() => _grade = g),
          ),
          const SizedBox(height: AppSpacing.lg),
          _TypesSelect(
            selected: _types,
            onToggle: _toggleType,
          ),
          const SizedBox(height: AppSpacing.lg),
          _CountStepper(
            count: _count,
            min: _countMin,
            max: _countMax,
            onChanged: (c) => setState(() => _count = c),
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoBox(grade: _grade, count: _count),
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
              label: l10n.aiExamGenerateButton,
              trailingIcon: Icons.auto_awesome,
              enabled: _canGenerate,
              onPressed:
                  _canGenerate ? () => _generate(selectedClassName) : null,
            ),
          ),
        ),
      ),
    );
  }
}

/// Giriş bilgi kartı (Stitch §Intro Card): psychology ikon + açıklama.
class _IntroCard extends StatelessWidget {
  const _IntroCard();

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(Icons.psychology, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.aiExamIntro,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alan etiketi (Stitch primary label).
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.base, bottom: AppSpacing.xs),
      child: Text(
        text,
        style: AppTypography.labelLg.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// Ders Seç (Stitch §Ders Seç — dropdown).
class _LessonSelect extends StatelessWidget {
  const _LessonSelect({
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
        _FieldLabel(l10n.aiExamLessonLabel),
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
                Text(l10n.aiExamLessonHint,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.outline)),
              ],
            ),
          ),
          error: (_, __) => _Box(
            child: Text(l10n.aiExamLessonsError,
                style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
          ),
          data: (lessons) {
            if (lessons.isEmpty) {
              return _Box(
                child: Text(l10n.aiExamLessonsEmpty,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant)),
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
                  icon: const Icon(Icons.expand_more, color: AppColors.outline),
                  hint: Text(
                    l10n.aiExamLessonHint,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.outline),
                  ),
                  style:
                      AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
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

/// Sınıf Seç (Stitch §Sınıf Seç — yatay tek-seçim chip listesi).
class _ClassSelect extends StatelessWidget {
  const _ClassSelect({
    required this.classesAsync,
    required this.selectedClassId,
    required this.onSelect,
  });

  final AsyncValue<List<ClassDto>> classesAsync;
  final String? selectedClassId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(l10n.aiExamClassLabel),
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
            child: Text(l10n.aiExamClassesError,
                style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
          ),
          data: (classes) {
            if (classes.isEmpty) {
              return _Box(
                child: Text(l10n.aiExamClassesEmpty,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant)),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: AppSpacing.base),
              child: Row(
                children: [
                  for (final c in classes) ...[
                    _Pill(
                      label: c.name,
                      selected: c.id == selectedClassId,
                      onTap: () => onSelect(c.id),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Sınıf Seviyesi (Stitch §Sınıf Seviyesi — 1–12 yatay pill, tek seçim).
class _GradeSelect extends StatelessWidget {
  const _GradeSelect({
    required this.grade,
    required this.min,
    required this.max,
    required this.onSelect,
  });

  final int grade;
  final int min;
  final int max;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(l10n.aiExamGradeLabel),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: AppSpacing.base),
          child: Row(
            children: [
              for (var g = min; g <= max; g++) ...[
                SizedBox(
                  width: 56,
                  child: _Pill(
                    label: '$g',
                    selected: g == grade,
                    onTap: () => onSelect(g),
                    height: 48,
                    center: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Soru Türleri (Stitch'te YOK — eklenen çoklu-seçim chip grubu; pill stilinde).
class _TypesSelect extends StatelessWidget {
  const _TypesSelect({required this.selected, required this.onToggle});

  final Set<AiQuestionType> selected;
  final ValueChanged<AiQuestionType> onToggle;

  String _label(AiQuestionType type, AppLocalizations l10n) => switch (type) {
        AiQuestionType.wordMeaning => l10n.aiExamTypeWordMeaning,
        AiQuestionType.fillBlank => l10n.aiExamTypeFillBlank,
        AiQuestionType.synonym => l10n.aiExamTypeSynonym,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(l10n.aiExamTypesLabel),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in AiQuestionType.values)
              _Pill(
                label: _label(type, l10n),
                selected: selected.contains(type),
                onTap: () => onToggle(type),
              ),
          ],
        ),
        if (selected.isEmpty)
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.xs, left: AppSpacing.base),
            child: Text(
              l10n.aiExamTypesHint,
              style: AppTypography.labelSm.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}

/// Yatay seçilebilir pill (sınıf/seviye/tür chip'leri için ortak — Stitch pill).
class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.height,
    this.center = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? height;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final child = Text(
      label,
      style: AppTypography.labelLg.copyWith(
        color: selected ? AppColors.onPrimary : AppColors.outline,
      ),
    );
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          height: height,
          alignment: center ? Alignment.center : null,
          padding: height == null
              ? const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.xs)
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          child: center
              ? child
              : Row(mainAxisSize: MainAxisSize.min, children: [child]),
        ),
      ),
    );
  }
}

/// Soru Sayısı (Stitch §Soru Sayısı — kart içinde -/sayı/+ stepper).
class _CountStepper extends StatelessWidget {
  const _CountStepper({
    required this.count,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int count;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.aiExamCountLabel,
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSurface)),
              const SizedBox(height: AppSpacing.base),
              Text(l10n.aiExamCountMax,
                  style: AppTypography.labelSm
                      .copyWith(color: AppColors.outline)),
            ],
          ),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove,
                enabled: count > min,
                onTap: count > min ? () => onChanged(count - 1) : null,
              ),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(
                width: 40,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: AppTypography.displayLgMobile
                      .copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              _StepButton(
                icon: Icons.add,
                enabled: count < max,
                onTap: count < max ? () => onChanged(count + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.primary),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
        ),
      ),
    );
  }
}

/// Bilgi kutusu (Stitch §Info Box — tertiary tonlu; grade/count vurgulu).
class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.grade, required this.count});

  final int grade;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.tertiary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.aiExamInfoBox(grade, count),
              style: AppTypography.labelLg.copyWith(color: AppColors.tertiary),
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: child,
    );
  }
}
