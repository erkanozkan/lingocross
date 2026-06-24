import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_banner.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/word_dtos.dart';
import '../../domain/word_source.dart';
import '../word_form_controller.dart';

/// Manuel Ekle / Düzenle bottom-sheet (word-list-entry.md §3.4).
///
/// Terim + ≥1 Türkçe karşılık (tam olarak biri primary — star toggle) +
/// opsiyonel eşanlam. Kaydet → Words API (source=Manual). Ekle modunda
/// "Kaydet ve Yeni Ekle" hızlı toplu girişi destekler.
class WordFormSheet extends ConsumerStatefulWidget {
  const WordFormSheet({
    super.key,
    required this.lessonId,
    required this.sourceLangLabel,
    required this.targetLangLabel,
    this.word,
  });

  final String lessonId;

  /// Dersin KAYNAK dili (terim etiketi için), lokalize ad.
  final String sourceLangLabel;

  /// Dersin HEDEF dili (karşılık etiketi için), lokalize ad.
  final String targetLangLabel;

  /// null → ekle, dolu → düzenle.
  final WordDto? word;

  bool get isEdit => word != null;

  /// Sheet'i açar; başarıda `true` döner (liste tazelemesi notifier üzerinden).
  static Future<bool?> show(
    BuildContext context, {
    required String lessonId,
    required String sourceLangLabel,
    required String targetLangLabel,
    WordDto? word,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (_) => WordFormSheet(
        lessonId: lessonId,
        sourceLangLabel: sourceLangLabel,
        targetLangLabel: targetLangLabel,
        word: word,
      ),
    );
  }

  @override
  ConsumerState<WordFormSheet> createState() => _WordFormSheetState();
}

class _MeaningRow {
  _MeaningRow({String text = '', this.isPrimary = false})
      : controller = TextEditingController(text: text);

  final TextEditingController controller;
  bool isPrimary;
}

class _WordFormSheetState extends ConsumerState<WordFormSheet> {
  final _termController = TextEditingController();
  final _synonymController = TextEditingController();
  final List<_MeaningRow> _meanings = [];
  final List<String> _synonyms = [];

  bool _termError = false;
  bool _meaningError = false;

  @override
  void initState() {
    super.initState();
    final word = widget.word;
    if (word != null) {
      _termController.text = word.term;
      for (final t in word.translations) {
        _meanings.add(_MeaningRow(text: t.text, isPrimary: t.isPrimary));
      }
      _synonyms.addAll(word.synonyms.map((s) => s.text));
    }
    if (_meanings.isEmpty) {
      _meanings.add(_MeaningRow(isPrimary: true));
    }
    _ensureSinglePrimary();
  }

  @override
  void dispose() {
    _termController.dispose();
    _synonymController.dispose();
    for (final m in _meanings) {
      m.controller.dispose();
    }
    super.dispose();
  }

  void _ensureSinglePrimary() {
    if (_meanings.isEmpty) return;
    if (!_meanings.any((m) => m.isPrimary)) {
      _meanings.first.isPrimary = true;
    }
  }

  void _setPrimary(int index) {
    setState(() {
      for (var i = 0; i < _meanings.length; i++) {
        _meanings[i].isPrimary = i == index;
      }
    });
  }

  void _addMeaning() {
    setState(() => _meanings.add(_MeaningRow()));
  }

  void _removeMeaning(int index) {
    final row = _meanings[index];
    // Primary satır, başka primary yokken silinemez (UX §3.4).
    if (row.isPrimary && _meanings.length > 1) {
      // Primary'yi bir sonraki/önceki satıra taşı.
      final next = index == 0 ? 1 : 0;
      _meanings[next].isPrimary = true;
    }
    setState(() {
      row.controller.dispose();
      _meanings.removeAt(index);
      _ensureSinglePrimary();
    });
  }

  void _addSynonymFromInput() {
    final raw = _synonymController.text.trim();
    if (raw.isEmpty) return;
    setState(() {
      for (final part in raw.split(',')) {
        final v = part.trim();
        if (v.isNotEmpty && !_synonyms.contains(v)) _synonyms.add(v);
      }
      _synonymController.clear();
    });
  }

  bool _validate() {
    final termOk = _termController.text.trim().isNotEmpty;
    final meaningsOk =
        _meanings.any((m) => m.controller.text.trim().isNotEmpty);
    setState(() {
      _termError = !termOk;
      _meaningError = !meaningsOk;
    });
    return termOk && meaningsOk;
  }

  Future<void> _save({required bool keepOpen}) async {
    if (!_validate()) return;
    final controller = ref.read(wordFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final translations = <TranslationPayload>[];
    final nonEmpty =
        _meanings.where((m) => m.controller.text.trim().isNotEmpty).toList();
    // Primary garantisi: hiçbiri primary değilse ilkini primary yap.
    final hasPrimary = nonEmpty.any((m) => m.isPrimary);
    for (var i = 0; i < nonEmpty.length; i++) {
      final m = nonEmpty[i];
      translations.add(TranslationPayload(
        text: m.controller.text.trim(),
        isPrimary: hasPrimary ? m.isPrimary : i == 0,
      ));
    }
    final synonyms = _synonyms.isEmpty ? null : List<String>.from(_synonyms);
    final term = _termController.text.trim();

    if (widget.isEdit) {
      final ok = await controller.submitUpdate(
        widget.lessonId,
        widget.word!.id,
        UpdateWordRequest(
          term: term,
          source: WordSource.manual,
          translations: translations,
          synonyms: synonyms,
        ),
      );
      if (!mounted) return;
      if (ok != null) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.wordsFormUpdatedSnack)));
        Navigator.of(context).pop(true);
      }
      return;
    }

    final added = await controller.add(
      widget.lessonId,
      AddWordRequest(
        term: term,
        source: WordSource.manual,
        translations: translations,
        synonyms: synonyms,
      ),
    );
    if (!mounted) return;
    if (added != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.wordsFormAddedSnack)));
      if (keepOpen) {
        setState(() {
          _termController.clear();
          _synonymController.clear();
          for (final m in _meanings) {
            m.controller.dispose();
          }
          _meanings
            ..clear()
            ..add(_MeaningRow(isPrimary: true));
          _synonyms.clear();
          _termError = false;
          _meaningError = false;
        });
      } else {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(wordFormControllerProvider);
    final submitting = state.isLoading;
    final hasError = state.hasError;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  children: [
                    Text(
                      widget.isEdit
                          ? l10n.wordsFormTitleEdit
                          : l10n.wordsFormTitleAdd,
                      style: AppTypography.headlineMd,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (hasError) ...[
                      ErrorBanner(message: l10n.wordsFormError),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    _Label(l10n.wordsFormTermLabel(widget.sourceLangLabel)),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _termController,
                      enabled: !submitting,
                      style: AppTypography.bodyMd,
                      // Dil terimleri için otomatik düzeltme/öneri kapalı.
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        hintText: l10n.wordsFormTermPlaceholder,
                        errorText:
                            _termError ? l10n.wordsFormTermRequired : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _Label(l10n.wordsFormMeaningLabel(widget.targetLangLabel)),
                    const SizedBox(height: AppSpacing.xs),
                    for (var i = 0; i < _meanings.length; i++)
                      _MeaningField(
                        index: i,
                        row: _meanings[i],
                        enabled: !submitting,
                        canRemove: _meanings.length > 1,
                        onPrimary: () => _setPrimary(i),
                        onRemove: () => _removeMeaning(i),
                      ),
                    if (_meaningError)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.base),
                        child: Text(
                          l10n.wordsFormMeaningRequired,
                          style: AppTypography.labelSm
                              .copyWith(color: AppColors.error),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: submitting ? null : _addMeaning,
                        icon: const Icon(Icons.add, color: AppColors.primary),
                        label: Text(
                          l10n.wordsFormMeaningAddMore,
                          style: AppTypography.labelLg
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _Label(l10n.wordsFormSynonymsLabel),
                    const SizedBox(height: AppSpacing.base),
                    Text(
                      l10n.wordsFormSynonymsHint,
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _SynonymInput(
                      controller: _synonymController,
                      enabled: !submitting,
                      synonyms: _synonyms,
                      onSubmit: _addSynonymFromInput,
                      onRemove: (s) => setState(() => _synonyms.remove(s)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
              _Actions(
                isEdit: widget.isEdit,
                submitting: submitting,
                onSave: () => _save(keepOpen: false),
                onSaveAndNew: () => _save(keepOpen: true),
                onCancel: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.base),
      child: Text(text,
          style: AppTypography.labelLg
              .copyWith(color: AppColors.onSurfaceVariant)),
    );
  }
}

class _MeaningField extends StatelessWidget {
  const _MeaningField({
    required this.index,
    required this.row,
    required this.enabled,
    required this.canRemove,
    required this.onPrimary,
    required this.onRemove,
  });

  final int index;
  final _MeaningRow row;
  final bool enabled;
  final bool canRemove;
  final VoidCallback onPrimary;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: row.controller,
              enabled: enabled,
              style: AppTypography.bodyMd,
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(hintText: l10n.wordsFormMeaningPlaceholder),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Semantics(
            selected: row.isPrimary,
            label: l10n.wordsFormMeaningPrimaryLabel,
            button: true,
            child: IconButton(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: enabled ? onPrimary : null,
              icon: Icon(
                row.isPrimary ? Icons.star : Icons.star_border,
                color: row.isPrimary
                    ? AppColors.secondaryContainer
                    : AppColors.outline,
              ),
            ),
          ),
          Semantics(
            label: l10n.wordsFormMeaningRemoveLabel(index + 1),
            button: true,
            child: IconButton(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: (enabled && canRemove) ? onRemove : null,
              icon: Icon(
                Icons.close,
                color: canRemove ? AppColors.error : AppColors.outlineVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SynonymInput extends StatelessWidget {
  const _SynonymInput({
    required this.controller,
    required this.enabled,
    required this.synonyms,
    required this.onSubmit,
    required this.onRemove,
  });

  final TextEditingController controller;
  final bool enabled;
  final List<String> synonyms;
  final VoidCallback onSubmit;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          style: AppTypography.bodyMd,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            // Virgül ile chip ekleme tetiklenir.
            FilteringTextInputFormatter.deny(
              RegExp('\n'),
              replacementString: '',
            ),
          ],
          onChanged: (v) {
            if (v.endsWith(',')) onSubmit();
          },
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(hintText: l10n.wordsFormSynonymsPlaceholder),
        ),
        if (synonyms.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final s in synonyms)
                Chip(
                  label: Text(s, style: AppTypography.labelSm),
                  backgroundColor: AppColors.surfaceContainer,
                  onDeleted: enabled ? () => onRemove(s) : null,
                  deleteIcon: const Icon(Icons.close, size: 16),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.isEdit,
    required this.submitting,
    required this.onSave,
    required this.onSaveAndNew,
    required this.onCancel,
  });

  final bool isEdit;
  final bool submitting;
  final VoidCallback onSave;
  final VoidCallback onSaveAndNew;
  final VoidCallback onCancel;

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
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            children: [
              PrimaryButton3D(
                label: submitting ? l10n.wordsFormSaving : l10n.wordsFormSave,
                isLoading: submitting,
                onPressed: onSave,
              ),
              if (!isEdit) ...[
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: submitting ? null : onSaveAndNew,
                  child: Text(
                    l10n.wordsFormSaveAndNew,
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
              TextButton(
                onPressed: submitting ? null : onCancel,
                child: Text(
                  l10n.wordsFormCancel,
                  style: AppTypography.labelLg
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
