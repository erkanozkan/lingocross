import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/ocr_service.dart';
import '../../domain/language_option.dart';
import '../lessons_notifier.dart';
import '../ocr_capture_controller.dart';
import '../widgets/word_form_sheet.dart';
import 'ocr_review_screen.dart';

/// Ekran A — OCR Yakalama (ux-spec §2, Stitch ekranına birebir).
///
/// Kamera VEYA galeriden foto seç → cihaz-içi ML Kit ile "Kelimeleri Çıkart" →
/// Ekran B (gözden geçirme). Kamera emülatörde olmayabilir → galeri birinci
/// sınıf alternatif; izin/erişim hatasında graceful fallback (§5).
class OcrCaptureScreen extends ConsumerWidget {
  const OcrCaptureScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(ocrCaptureControllerProvider);
    final controller = ref.read(ocrCaptureControllerProvider.notifier);

    final lessonAsync = ref.watch(lessonProvider(lessonId));
    final sourceLang = lessonAsync.maybeWhen(
      data: (l) => l.sourceLanguage,
      orElse: () => LanguageOption.defaultSource,
    );
    final targetLang = lessonAsync.maybeWhen(
      data: (l) => l.targetLanguage,
      orElse: () => LanguageOption.defaultTarget,
    );
    final sourceLabel = LanguageOption.fromCode(sourceLang).label(l10n);
    final targetLabel = LanguageOption.fromCode(targetLang).label(l10n);

    Future<void> pick(OcrImageSource source) async {
      await controller.pick(source);
    }

    Future<void> openSourceSheet() async {
      final source = await _showSourceSheet(context, l10n);
      if (source != null) await pick(source);
    }

    Future<void> openManual() async {
      await WordFormSheet.show(
        context,
        lessonId: lessonId,
        sourceLangLabel: sourceLabel,
        targetLangLabel: targetLabel,
      );
    }

    Future<void> extract() async {
      OcrScanResult? result;
      var failed = false;
      try {
        result = await ref.read(ocrCaptureControllerProvider.notifier).scan(
              sourceLanguage: sourceLang,
              targetLanguage: targetLang,
            );
      } catch (_) {
        failed = true;
      }
      if (!context.mounted) return;
      await context.push(
        AppRoutes.lessonOcrReview(lessonId),
        extra: OcrReviewArgs(
          candidates: result?.candidates ?? const [],
          sourceLangLabel: sourceLabel,
          targetLangLabel: targetLabel,
          failed: failed,
          enriched: result?.enriched ?? false,
        ),
      );
    }

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
          l10n.ocrCaptureTitle,
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
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
          const _HowItWorksCard(),
          const SizedBox(height: AppSpacing.lg),
          if (state.permissionError) ...[
            const _PermissionCard(),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (state.hasImage)
            _PhotoPreview(
              path: state.imagePath!,
              onRemove: state.isBusy ? null : controller.clearImage,
            )
          else
            _CaptureTrigger(
              onTap: state.isBusy ? null : openSourceSheet,
            ),
          const SizedBox(height: AppSpacing.lg),
          _ExtractButton(
            enabled: state.hasImage && !state.isBusy,
            scanning: state.isScanning,
            enriching: state.isEnriching,
            onPressed: extract,
          ),
          const SizedBox(height: AppSpacing.md),
          const _OrDivider(),
          const SizedBox(height: AppSpacing.md),
          _ManualButton(
            onPressed: state.isBusy ? null : openManual,
          ),
        ],
      ),
    );
  }

  static Future<OcrImageSource?> _showSourceSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showModalBottomSheet<OcrImageSource>(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt,
                      color: AppColors.primary),
                  title: Text(l10n.ocrCaptureSourceCamera,
                      style: AppTypography.bodyMd),
                  // Kamera erişilemezse pick() PickImageException atar →
                  // controller permissionError'a geçer → _PermissionCard gösterilir
                  // ve kullanıcı galeriden devam edebilir (graceful fallback).
                  onTap: () =>
                      Navigator.of(sheetContext).pop(OcrImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library,
                      color: AppColors.primary),
                  title: Text(l10n.ocrCaptureSourceGallery,
                      style: AppTypography.bodyMd),
                  onTap: () =>
                      Navigator.of(sheetContext).pop(OcrImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: AppColors.onPrimary, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(l10n.ocrCaptureHowTitle,
                    style: AppTypography.headlineMd),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.ocrCaptureHowDesc,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Step(number: 1, label: l10n.ocrCaptureStep1),
              _Step(number: 2, label: l10n.ocrCaptureStep2),
              _Step(number: 3, label: l10n.ocrCaptureStep3),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Text('$number',
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.primary)),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelSm
                .copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CaptureTrigger extends StatelessWidget {
  const _CaptureTrigger({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.ocrCaptureTriggerTitle,
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.primaryContainer,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: AppColors.onPrimary, size: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.ocrCaptureTriggerTitle,
                  style: AppTypography.headlineMd
                      .copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.base),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Text(
                    l10n.ocrCaptureTriggerSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.file(File(path), fit: BoxFit.cover),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: Semantics(
              button: true,
              label: l10n.ocrCapturePhotoRemoveLabel,
              child: Material(
                color: AppColors.error,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.close, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtractButton extends StatelessWidget {
  const _ExtractButton({
    required this.enabled,
    required this.scanning,
    required this.enriching,
    required this.onPressed,
  });

  final bool enabled;
  final bool scanning;
  final bool enriching;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = scanning || enriching;
    final active = enabled && !busy;
    return Semantics(
      liveRegion: busy,
      button: true,
      enabled: active,
      child: GestureDetector(
        onTap: active ? onPressed : null,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: active
                ? [
                    const BoxShadow(
                      color: AppColors.primaryShadow,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: busy
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.onPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        enriching
                            ? l10n.ocrCaptureEnriching
                            : l10n.ocrCaptureScanning,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineMd
                            .copyWith(color: AppColors.onPrimary),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.data_exploration,
                      color: active
                          ? AppColors.onPrimary
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.ocrCaptureExtract,
                      style: AppTypography.headlineMd.copyWith(
                        color: active
                            ? AppColors.onPrimary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            l10n.ocrCaptureOr,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.outline,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.outlineVariant)),
      ],
    );
  }
}

class _ManualButton extends StatelessWidget {
  const _ManualButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
        icon: const Icon(Icons.keyboard),
        label: Text(l10n.ocrCaptureManual, style: AppTypography.headlineMd),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: AppColors.onErrorContainer),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.ocrCapturePermissionTitle,
                  style: AppTypography.headlineMd
                      .copyWith(color: AppColors.onErrorContainer),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.ocrCapturePermissionDesc,
            style: AppTypography.bodyMd
                .copyWith(color: AppColors.onErrorContainer),
          ),
        ],
      ),
    );
  }
}
