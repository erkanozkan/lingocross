import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/lesson_dtos.dart';
import '../../domain/language_option.dart';
import '../lesson_form_controller.dart';
import '../lessons_notifier.dart';
import '../widgets/skeleton_card.dart';

/// Ders Oluştur / Düzenle (lesson-create-edit.md). Aynı ekran iki moda hizmet
/// eder: [lessonId] null → create, dolu → edit (mevcut veriyle ön-dolu).
class LessonFormScreen extends ConsumerStatefulWidget {
  const LessonFormScreen({super.key, this.lessonId});

  final String? lessonId;

  bool get isEdit => lessonId != null;

  @override
  ConsumerState<LessonFormScreen> createState() => _LessonFormScreenState();
}

class _LessonFormScreenState extends ConsumerState<LessonFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scheduleController = TextEditingController();

  // Stitch'te ayrı dil seçici yok → EN→TR varsayılanı korunur, picker gizli.
  static const LanguageOption _source = LanguageOption.en;
  static const LanguageOption _target = LanguageOption.tr;

  bool _loaded = false;
  bool _dirty = false;
  // Edit modunda ilk yüklenen değerlere göre dirty-check.
  String _initialTitle = '';
  String _initialDescription = '';
  String _initialSchedule = '';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_recomputeDirty);
    _descriptionController.addListener(_recomputeDirty);
    _scheduleController.addListener(_recomputeDirty);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  void _hydrate(LessonDto lesson) {
    if (_loaded) return;
    _loaded = true;
    _titleController.text = lesson.title;
    _descriptionController.text = lesson.description ?? '';
    _scheduleController.text = lesson.scheduledLabel ?? '';
    _initialTitle = lesson.title;
    _initialDescription = lesson.description ?? '';
    _initialSchedule = lesson.scheduledLabel ?? '';
    _recomputeDirty();
  }

  void _recomputeDirty() {
    final dirty = !widget.isEdit
        ? _titleController.text.trim().isNotEmpty
        : _titleController.text != _initialTitle ||
            _descriptionController.text != _initialDescription ||
            _scheduleController.text != _initialSchedule;
    if (dirty != _dirty) {
      setState(() => _dirty = dirty);
    }
  }

  bool get _titleValid => _titleController.text.trim().isNotEmpty;
  bool get _canSubmit => _titleValid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Edit modunda mevcut dersi getir; create modunda doğrudan formu göster.
    if (widget.isEdit) {
      final async = ref.watch(lessonProvider(widget.lessonId!));
      return async.when(
        loading: () => _Scaffold(
          title: l10n.lessonFormTitleEdit,
          body: const Padding(
            padding: EdgeInsets.all(AppSpacing.marginMobile),
            child: SkeletonList(count: 4, height: 56),
          ),
          bottomBar: const SizedBox.shrink(),
        ),
        error: (_, __) => _Scaffold(
          title: l10n.lessonFormTitleEdit,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: ErrorBanner(message: l10n.teacherDashboardError),
            ),
          ),
          bottomBar: const SizedBox.shrink(),
        ),
        data: (lesson) {
          _hydrate(lesson);
          return _buildForm(context, l10n);
        },
      );
    }
    return _buildForm(context, l10n);
  }

  Widget _buildForm(BuildContext context, AppLocalizations l10n) {
    final controllerState = ref.watch(lessonFormControllerProvider);
    final submitting = controllerState.isLoading;
    final hasError = controllerState.hasError;

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmDiscard(context, l10n);
        if (leave == true && context.mounted) context.pop();
      },
      child: _Scaffold(
        title: widget.isEdit ? l10n.lessonFormTitleEdit : l10n.lessonFormTitleCreate,
        bottomBar: _SubmitBar(
          label: l10n.lessonFormSaveAndShare,
          submittingLabel: l10n.lessonFormSubmitting,
          enabled: _canSubmit,
          submitting: submitting,
          onSubmit: () => _submit(context, l10n),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.lg,
          ),
          children: [
            if (hasError) ...[
              ErrorBanner(message: l10n.lessonFormError),
              const SizedBox(height: AppSpacing.lg),
            ],
            const _Hero(),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.lessonFormFieldScheduleLabel,
              controller: _scheduleController,
              hintText: l10n.lessonFormFieldSchedulePlaceholder,
              enabled: !submitting,
              leadingIcon: Icons.calendar_today,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.lessonFormFieldUnitLabel,
              controller: _titleController,
              hintText: l10n.lessonFormFieldUnitPlaceholder,
              enabled: !submitting,
              leadingIcon: Icons.topic_outlined,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.lessonFormFieldTitleRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.lessonFormFieldTopicsLabel,
              controller: _descriptionController,
              hintText: l10n.lessonFormFieldTopicsPlaceholder,
              enabled: !submitting,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.lg),
            _VocabCard(
              enabled: !submitting,
              onTap: () {
                if (widget.isEdit) {
                  context.push(AppRoutes.lessonWords(widget.lessonId!));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.lessonFormVocabSaveFirst)),
                  );
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            const _InfoNote(),
            if (widget.isEdit) ...[
              const SizedBox(height: AppSpacing.xl),
              _DeleteButton(
                enabled: !submitting,
                onPressed: () => _delete(context, l10n),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context, AppLocalizations l10n) async {
    if (!_canSubmit) return;
    final controller = ref.read(lessonFormControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();
    final description = desc.isEmpty ? null : desc;
    final schedule = _scheduleController.text.trim();
    final scheduledLabel = schedule.isEmpty ? null : schedule;

    if (widget.isEdit) {
      final updated = await controller.submitUpdate(
        widget.lessonId!,
        UpdateLessonRequest(
          title: title,
          description: description,
          sourceLanguage: _source.code,
          targetLanguage: _target.code,
          scheduledLabel: scheduledLabel,
        ),
      );
      if (updated == null || !context.mounted) return;
      messenger.showSnackBar(_successSnack(l10n.lessonFormUpdatedSnack));
      context.pop();
    } else {
      final created = await controller.create(
        CreateLessonRequest(
          title: title,
          description: description,
          sourceLanguage: _source.code,
          targetLanguage: _target.code,
          scheduledLabel: scheduledLabel,
        ),
      );
      if (created == null || !context.mounted) return;
      messenger.showSnackBar(_successSnack(l10n.lessonFormCreatedSnack));
      // Yeni ders → Ders Detayı (kelime ekleme + yayınlama oradan; geri = liste).
      context.pushReplacement(AppRoutes.lessonDetail(created.id));
    }
  }

  Future<void> _delete(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.lessonFormDelete, style: AppTypography.headlineMd),
        content: Text(l10n.lessonFormDeleteConfirm, style: AppTypography.bodyMd),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.lessonFormDelete,
              style: AppTypography.labelLg.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(lessonFormControllerProvider.notifier)
        .delete(widget.lessonId!);
    if (!context.mounted) return;
    if (ok) {
      messenger.showSnackBar(_successSnack(l10n.lessonFormDeletedSnack));
      context.go(AppRoutes.teacher);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.lessonFormError)));
    }
  }

  Future<bool?> _confirmDiscard(BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.lessonFormDiscardTitle, style: AppTypography.headlineMd),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.lessonFormDiscardCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              l10n.lessonFormDiscardConfirm,
              style: AppTypography.labelLg.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _successSnack(String text) => SnackBar(
        backgroundColor: AppColors.tertiary,
        content: Text(text,
            style: AppTypography.labelLg.copyWith(color: AppColors.onTertiary)),
      );
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({
    required this.title,
    required this.body,
    required this.bottomBar,
  });

  final String title;
  final Widget body;
  final Widget bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(title,
            style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
      ),
      bottomNavigationBar: bottomBar,
      body: body,
    );
  }
}

/// Stitch hero banner: primary-container zemin + başlık/alt metin.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      height: 128,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lessonFormHeroTitle,
            style:
                AppTypography.headlineMd.copyWith(color: AppColors.onPrimaryContainer),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            l10n.lessonFormHeroDesc,
            style: AppTypography.labelLg.copyWith(
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Ünite Kelime Listesi" erişim kartı — kelime ekranına bağlanır.
class _VocabCard extends StatelessWidget {
  const _VocabCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: AppColors.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: enabled ? onTap : null,
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
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.menu_book, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.lessonFormVocabTitle,
                        style: AppTypography.headlineMd),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.lessonFormVocabDesc,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
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

/// Bilgilendirme notu (tertiary tint).
class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
            color: AppColors.tertiaryContainer.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.tertiary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.lessonFormInfoNote,
              style: AppTypography.labelSm
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: TextButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.delete_outline, color: AppColors.error),
        label: Text(
          l10n.lessonFormDelete,
          style: AppTypography.labelLg.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

class _SubmitBar extends StatelessWidget {
  const _SubmitBar({
    required this.label,
    required this.submittingLabel,
    required this.enabled,
    required this.submitting,
    required this.onSubmit,
  });

  final String label;
  final String submittingLabel;
  final bool enabled;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.sm,
            AppSpacing.marginMobile,
            AppSpacing.sm,
          ),
          child: PrimaryButton3D(
            label: submitting ? submittingLabel : label,
            enabled: enabled,
            isLoading: submitting,
            onPressed: onSubmit,
          ),
        ),
      ),
    );
  }
}
