import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
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

  LanguageOption _source = LanguageOption.en;
  LanguageOption _target = LanguageOption.tr;
  bool _published = false;

  bool _loaded = false;
  bool _dirty = false;
  // Edit modunda ilk yüklenen değerlere göre dirty-check.
  String _initialTitle = '';
  String _initialDescription = '';
  bool _initialPublished = false;
  LanguageOption _initialSource = LanguageOption.en;
  LanguageOption _initialTarget = LanguageOption.tr;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_recomputeDirty);
    _descriptionController.addListener(_recomputeDirty);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _hydrate(LessonDto lesson) {
    if (_loaded) return;
    _loaded = true;
    _titleController.text = lesson.title;
    _descriptionController.text = lesson.description ?? '';
    _source = LanguageOption.fromCode(lesson.sourceLanguage);
    _target = LanguageOption.fromCode(lesson.targetLanguage);
    _published = lesson.isPublished;
    _initialTitle = lesson.title;
    _initialDescription = lesson.description ?? '';
    _initialPublished = lesson.isPublished;
    _initialSource = _source;
    _initialTarget = _target;
    _recomputeDirty();
  }

  void _recomputeDirty() {
    final dirty = !widget.isEdit
        ? _titleController.text.trim().isNotEmpty
        : _titleController.text != _initialTitle ||
            _descriptionController.text != _initialDescription ||
            _published != _initialPublished ||
            _source != _initialSource ||
            _target != _initialTarget;
    if (dirty != _dirty) {
      setState(() => _dirty = dirty);
    }
  }

  bool get _titleValid => _titleController.text.trim().isNotEmpty;
  bool get _langValid => _source != _target;
  bool get _canSubmit => _titleValid && _langValid;

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
          label: widget.isEdit
              ? l10n.lessonFormSubmitEdit
              : l10n.lessonFormSubmitCreate,
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
            AppTextField(
              label: l10n.lessonFormFieldTitleLabel,
              controller: _titleController,
              hintText: l10n.lessonFormFieldTitlePlaceholder,
              enabled: !submitting,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.lessonFormFieldTitleRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.lessonFormFieldDescriptionLabel,
              controller: _descriptionController,
              hintText: l10n.lessonFormFieldDescriptionPlaceholder,
              enabled: !submitting,
            ),
            const SizedBox(height: AppSpacing.lg),
            _LanguageRow(
              source: _source,
              target: _target,
              enabled: !submitting,
              onSource: (v) {
                setState(() => _source = v);
                _recomputeDirty();
              },
              onTarget: (v) {
                setState(() => _target = v);
                _recomputeDirty();
              },
              sameError: !_langValid ? l10n.lessonFormFieldLangSameError : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _StatusSegment(
              published: _published,
              enabled: !submitting,
              onChanged: (v) {
                setState(() => _published = v);
                _recomputeDirty();
              },
            ),
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

    if (widget.isEdit) {
      final updated = await controller.submitUpdate(
        widget.lessonId!,
        UpdateLessonRequest(
          title: title,
          description: description,
          sourceLanguage: _source.code,
          targetLanguage: _target.code,
        ),
      );
      if (updated == null || !context.mounted) return;
      if (_published != _initialPublished && _published) {
        await controller.publish(updated.id);
      }
      if (!context.mounted) return;
      messenger.showSnackBar(_successSnack(l10n.lessonFormUpdatedSnack));
      context.pop();
    } else {
      final created = await controller.create(
        CreateLessonRequest(
          title: title,
          description: description,
          sourceLanguage: _source.code,
          targetLanguage: _target.code,
        ),
      );
      if (created == null || !context.mounted) return;
      if (_published) {
        await controller.publish(created.id);
      }
      if (!context.mounted) return;
      messenger.showSnackBar(_successSnack(l10n.lessonFormCreatedSnack));
      // Yeni ders kelimesiz anlamsız → kelime girişine geç (replace, geri = dashboard).
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

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.source,
    required this.target,
    required this.enabled,
    required this.onSource,
    required this.onTarget,
    this.sameError,
  });

  final LanguageOption source;
  final LanguageOption target;
  final bool enabled;
  final ValueChanged<LanguageOption> onSource;
  final ValueChanged<LanguageOption> onTarget;
  final String? sameError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _LangPicker(
                label: l10n.lessonFormFieldSourceLangLabel,
                value: source,
                enabled: enabled,
                onChanged: onSource,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Icon(Icons.swap_horiz, color: AppColors.onSurfaceVariant),
            ),
            Expanded(
              child: _LangPicker(
                label: l10n.lessonFormFieldTargetLangLabel,
                value: target,
                enabled: enabled,
                onChanged: onTarget,
              ),
            ),
          ],
        ),
        if (sameError != null) ...[
          const SizedBox(height: AppSpacing.base),
          Text(sameError!,
              style: AppTypography.labelSm.copyWith(color: AppColors.error)),
        ],
      ],
    );
  }
}

class _LangPicker extends StatelessWidget {
  const _LangPicker({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final LanguageOption value;
  final bool enabled;
  final ValueChanged<LanguageOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Text(label,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant)),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<LanguageOption>(
          value: value,
          onChanged: enabled ? (v) => v != null ? onChanged(v) : null : null,
          icon: const Icon(Icons.expand_more),
          style: AppTypography.bodyMd,
          items: [
            for (final opt in LanguageOption.values)
              DropdownMenuItem(value: opt, child: Text(opt.label(l10n))),
          ],
        ),
      ],
    );
  }
}

class _StatusSegment extends StatelessWidget {
  const _StatusSegment({
    required this.published,
    required this.enabled,
    required this.onChanged,
  });

  final bool published;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Text(l10n.lessonFormStatusLabel,
              style: AppTypography.labelLg
                  .copyWith(color: AppColors.onSurfaceVariant)),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            children: [
              _segment(l10n.lessonFormStatusDraft, !published,
                  enabled ? () => onChanged(false) : null),
              _segment(l10n.lessonFormStatusPublished, published,
                  enabled ? () => onChanged(true) : null),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Text(
            published
                ? l10n.lessonFormStatusPublishedHint
                : l10n.lessonFormStatusDraftHint,
            style: AppTypography.labelSm
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _segment(String label, bool active, VoidCallback? onTap) {
    return Expanded(
      child: Semantics(
        selected: active,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  active ? AppColors.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              label,
              style: AppTypography.labelLg.copyWith(
                color: active
                    ? AppColors.onPrimary
                    : AppColors.onSurfaceVariant,
                fontWeight: active ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
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
