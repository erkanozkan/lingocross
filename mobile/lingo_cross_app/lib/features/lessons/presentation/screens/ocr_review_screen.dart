import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/word_dtos.dart';
import '../../domain/ocr_line_parser.dart';
import '../../domain/word_source.dart';
import '../word_form_controller.dart';

/// Ekran B'ye taşınan argümanlar (go_router `extra`).
class OcrReviewArgs {
  const OcrReviewArgs({
    required this.candidates,
    required this.sourceLangLabel,
    required this.targetLangLabel,
    this.failed = false,
  });

  final List<OcrCandidate> candidates;

  /// Dersin KAYNAK dili (terim etiketi için), lokalize ad.
  final String sourceLangLabel;

  /// Dersin HEDEF dili (karşılık etiketi için), lokalize ad.
  final String targetLangLabel;

  /// Bulut AI görüntüyü okuyamadıysa (hata/503/çevrimdışı) true → hata boş
  /// durumu gösterilir.
  final bool failed;
}

/// Bir gözden geçirme satırının düzenlenebilir durumu.
class _ReviewRow {
  _ReviewRow({
    required String term,
    String meaning = '',
    List<String> synonyms = const [],
  })  : termController = TextEditingController(text: term),
        meaningController = TextEditingController(text: meaning),
        synonyms = List<String>.from(synonyms);

  final TextEditingController termController;
  final TextEditingController meaningController;
  final TextEditingController synonymController = TextEditingController();
  final List<String> synonyms;
  bool included = true;

  bool get isValid =>
      termController.text.trim().isNotEmpty &&
      meaningController.text.trim().isNotEmpty;

  void dispose() {
    termController.dispose();
    meaningController.dispose();
    synonymController.dispose();
  }
}

/// Ekran B — Gözden Geçirme & Düzenleme (ux-spec §3).
///
/// Bulut AI'dan dönen adaylar kelime kartlarına dönüşür; öğretmen terim +
/// Türkçe karşılık (+ opsiyonel eşanlam) doldurur, satırları seçer/siler/ekler
/// ve seçilenleri Words API'ye `source = Ocr` olarak batch kaydeder.
class OcrReviewScreen extends ConsumerStatefulWidget {
  const OcrReviewScreen({
    super.key,
    required this.lessonId,
    required this.args,
  });

  final String lessonId;
  final OcrReviewArgs args;

  @override
  ConsumerState<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends ConsumerState<OcrReviewScreen> {
  final List<_ReviewRow> _rows = [];
  bool _saving = false;
  bool _showInvalidWarning = false;

  @override
  void initState() {
    super.initState();
    for (final c in widget.args.candidates) {
      _rows.add(_ReviewRow(
        term: c.term,
        meaning: c.meaning ?? '',
        synonyms: c.synonyms,
      ));
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  int get _selectedCount => _rows.where((r) => r.included).length;

  void _addRow() {
    setState(() => _rows.add(_ReviewRow(term: '')));
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      for (final r in _rows) {
        r.dispose();
      }
      _rows.clear();
    });
  }

  void _swapRow(_ReviewRow row) {
    final term = row.termController.text;
    final meaning = row.meaningController.text;
    setState(() {
      row.termController.text = meaning;
      row.meaningController.text = term;
    });
  }

  void _addSynonym(_ReviewRow row) {
    final raw = row.synonymController.text.trim();
    if (raw.isEmpty) return;
    setState(() {
      for (final part in raw.split(',')) {
        final v = part.trim();
        if (v.isNotEmpty && !row.synonyms.contains(v)) row.synonyms.add(v);
      }
      row.synonymController.clear();
    });
  }

  Future<void> _save() async {
    final selected = _rows.where((r) => r.included).toList();
    if (selected.isEmpty) return;

    final invalid = selected.where((r) => !r.isValid).toList();
    if (invalid.isNotEmpty) {
      setState(() => _showInvalidWarning = true);
      return;
    }

    setState(() {
      _showInvalidWarning = false;
      _saving = true;
    });

    final controller = ref.read(wordFormControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    var savedCount = 0;
    final failedRows = <_ReviewRow>[];

    for (final row in selected) {
      final request = AddWordRequest(
        term: row.termController.text.trim(),
        source: WordSource.ocr,
        translations: [
          TranslationPayload(
            text: row.meaningController.text.trim(),
            isPrimary: true,
          ),
        ],
        synonyms: row.synonyms.isEmpty ? null : List<String>.from(row.synonyms),
      );
      final added = await controller.add(widget.lessonId, request);
      if (added != null) {
        savedCount++;
      } else {
        failedRows.add(row);
      }
    }

    if (!mounted) return;

    // Başarılı satırları listeden çıkar; başarısızlar kalır (kısmi hata).
    setState(() {
      for (final r in selected) {
        if (!failedRows.contains(r)) {
          r.dispose();
          _rows.remove(r);
        }
      }
      _saving = false;
    });

    if (savedCount > 0) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.ocrReviewSavedSnack(savedCount)),
          backgroundColor: AppColors.tertiary,
        ),
      );
    }

    if (failedRows.isEmpty) {
      // Tümü kaydedildi → kelime listesine dön.
      router.pop();
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.ocrReviewPartialError(failedRows.length))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Boş / hata durumu (ux-spec §5): hiç aday yok ya da tarama hata verdi.
    if (_rows.isEmpty) {
      return _EmptyOrErrorScreen(
        failed: widget.args.failed,
        onRetry: () => context.pop(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: _saving ? null : () => context.pop(),
        ),
        title: Text(
          l10n.ocrReviewTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: AppColors.onSurfaceVariant),
            enabled: !_saving,
            onSelected: (v) {
              if (v == 'clear') _clearAll();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'clear',
                child: Text(l10n.ocrReviewClearAll),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.marginMobile,
          AppSpacing.md,
          AppSpacing.marginMobile,
          AppSpacing.xl,
        ),
        children: [
          _SummaryStrip(
            recognized: widget.args.candidates.length,
            selected: _selectedCount,
          ),
          if (_showInvalidWarning) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.ocrReviewInvalidRows,
              style: AppTypography.labelSm.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < _rows.length; i++) ...[
            _CandidateCard(
              row: _rows[i],
              index: i,
              sourceLangLabel: widget.args.sourceLangLabel,
              targetLangLabel: widget.args.targetLangLabel,
              enabled: !_saving,
              highlightInvalid:
                  _showInvalidWarning && _rows[i].included && !_rows[i].isValid,
              onChanged: () => setState(() {}),
              onToggle: () =>
                  setState(() => _rows[i].included = !_rows[i].included),
              onSwap: () => _swapRow(_rows[i]),
              onRemove: () => _removeRow(i),
              onAddSynonym: () => _addSynonym(_rows[i]),
              onRemoveSynonym: (s) =>
                  setState(() => _rows[i].synonyms.remove(s)),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _saving ? null : _addRow,
              icon: const Icon(Icons.add, color: AppColors.primary),
              label: Text(
                l10n.ocrReviewAddRow,
                style:
                    AppTypography.labelLg.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _SaveBar(
        count: _selectedCount,
        saving: _saving,
        onSave: _selectedCount > 0 ? _save : null,
        onCancel: _saving ? null : () => context.pop(),
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.recognized, required this.selected});

  final int recognized;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.ocrReviewSummary(recognized),
                  style: AppTypography.bodyMd),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs, vertical: AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                l10n.ocrReviewSelected(selected),
                style: AppTypography.labelSm.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.ocrReviewConfidenceNote,
          style: AppTypography.labelSm
              .copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.row,
    required this.index,
    required this.sourceLangLabel,
    required this.targetLangLabel,
    required this.enabled,
    required this.highlightInvalid,
    required this.onChanged,
    required this.onToggle,
    required this.onSwap,
    required this.onRemove,
    required this.onAddSynonym,
    required this.onRemoveSynonym,
  });

  final _ReviewRow row;
  final int index;
  final String sourceLangLabel;
  final String targetLangLabel;
  final bool enabled;
  final bool highlightInvalid;
  final VoidCallback onChanged;
  final VoidCallback onToggle;
  final VoidCallback onSwap;
  final VoidCallback onRemove;
  final VoidCallback onAddSynonym;
  final ValueChanged<String> onRemoveSynonym;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: highlightInvalid ? AppColors.error : AppColors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Semantics(
                label: row.included
                    ? l10n.ocrReviewIncludeLabel
                    : l10n.ocrReviewExcludeLabel,
                checked: row.included,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Checkbox(
                    value: row.included,
                    onChanged: enabled ? (_) => onToggle() : null,
                    activeColor: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: row.termController,
                  enabled: enabled,
                  style: AppTypography.headlineMd,
                  onChanged: (_) => onChanged(),
                  decoration: InputDecoration(
                    labelText: l10n.ocrReviewTermLabel(sourceLangLabel),
                    hintText: l10n.ocrReviewTermPlaceholder,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.ocrReviewSwap,
                child: IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  tooltip: l10n.ocrReviewSwap,
                  onPressed: enabled ? onSwap : null,
                  icon: const Icon(Icons.swap_horiz, color: AppColors.primary),
                ),
              ),
              Semantics(
                button: true,
                label: l10n.ocrReviewRowRemoveLabel(index + 1),
                child: IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  onPressed: enabled ? onRemove : null,
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: row.meaningController,
            enabled: enabled,
            style: AppTypography.bodyMd,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              labelText: l10n.wordsFormMeaningLabel(targetLangLabel),
              hintText: l10n.wordsFormMeaningPlaceholder,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: row.synonymController,
            enabled: enabled,
            style: AppTypography.bodyMd,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp('\n'),
                replacementString: '',
              ),
            ],
            onChanged: (v) {
              if (v.endsWith(',')) onAddSynonym();
            },
            onSubmitted: (_) => onAddSynonym(),
            decoration: InputDecoration(
              labelText: l10n.wordsFormSynonymsLabel,
              hintText: l10n.wordsFormSynonymsPlaceholder,
            ),
          ),
          if (row.synonyms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final s in row.synonyms)
                  Chip(
                    label: Text(s, style: AppTypography.labelSm),
                    backgroundColor: AppColors.surfaceContainer,
                    onDeleted: enabled ? () => onRemoveSynonym(s) : null,
                    deleteIcon: const Icon(Icons.close, size: 16),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.count,
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  final int count;
  final bool saving;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton3D(
                label: saving
                    ? l10n.ocrReviewSaving
                    : l10n.ocrReviewSave(count),
                isLoading: saving,
                enabled: onSave != null,
                onPressed: onSave ?? () {},
              ),
              TextButton(
                onPressed: onCancel,
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

class _EmptyOrErrorScreen extends StatelessWidget {
  const _EmptyOrErrorScreen({required this.failed, required this.onRetry});

  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          l10n.ocrReviewTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                failed ? Icons.error : Icons.image_search,
                size: 48,
                color: failed
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                failed ? l10n.ocrReviewError : l10n.ocrReviewEmptyTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineMd,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.ocrReviewEmptyDesc,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(l10n.ocrReviewRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
