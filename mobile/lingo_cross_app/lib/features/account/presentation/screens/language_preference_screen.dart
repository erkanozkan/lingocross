import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Dil Tercihi (Stitch `dba79a72…` — birebir). Hesap Ayarları'ndan push'lanır
/// (`/account/language`).
///
/// Radyo-liste: "Türkçe" (seçili, sağda dolu radio + check ikonu), "English"
/// (pasif + sağda "Yakında" rozeti). Info satırı + dekoratif "Global Öğrenim
/// Topluluğu" görsel kartı. Türkçe tek aktif dil — seçim değişmez.
class LanguagePreferenceScreen extends StatelessWidget {
  const LanguagePreferenceScreen({super.key});

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
          l10n.languagePreferenceTitle,
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
          // Dil seçici kart.
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: AppShadows.level2,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Aktif: Türkçe.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 24),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          l10n.languageOptionTurkish,
                          style: AppTypography.headlineMd,
                        ),
                      ),
                      // Dolu radio.
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  indent: AppSpacing.md,
                  endIndent: AppSpacing.md,
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
                // Pasif: English + "Yakında" rozeti.
                Opacity(
                  opacity: 0.4,
                  child: Container(
                    color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.radio_button_unchecked,
                            color: AppColors.outline, size: 24),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            l10n.languageOptionEnglish,
                            style: AppTypography.headlineMd,
                          ),
                        ),
                        _ComingSoonBadge(label: l10n.languageComingSoonBadge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Info satırı.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 16, color: AppColors.outline),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.languageInfo,
                    style:
                        AppTypography.labelSm.copyWith(color: AppColors.outline),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Dekoratif "Global Öğrenim Topluluğu" görsel kartı.
          _DecorationCard(caption: l10n.languageDecorationCaption),
        ],
      ),
    );
  }
}

/// Açık primary zeminli "Yakında" rozeti.
class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(color: AppColors.primary),
      ),
    );
  }
}

/// Gradient + ikon kümesi dekoratif hero kart (Stitch görselinin yerel karşılığı).
class _DecorationCard extends StatelessWidget {
  const _DecorationCard({required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.level2,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerHighest,
            AppColors.surfaceContainerLow,
          ],
        ),
      ),
      child: Stack(
        children: [
          // İkon kümesi (konuşma balonları + dil sembolleri).
          Positioned(
            top: 24,
            left: 28,
            child: Icon(Icons.translate,
                size: 40, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          Positioned(
            top: 56,
            right: 40,
            child: Icon(Icons.chat_bubble_outline,
                size: 32,
                color: AppColors.secondaryContainer.withValues(alpha: 0.7)),
          ),
          Positioned(
            top: 36,
            right: 96,
            child: Icon(Icons.language,
                size: 28, color: AppColors.tertiary.withValues(alpha: 0.5)),
          ),
          Positioned(
            bottom: 56,
            left: 64,
            child: Icon(Icons.forum_outlined,
                size: 30, color: AppColors.primary.withValues(alpha: 0.35)),
          ),
          // Alt gradient + başlık.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.surfaceContainerHighest,
                    AppColors.surfaceContainerHighest.withValues(alpha: 0),
                  ],
                ),
              ),
              child: Text(
                caption,
                style: AppTypography.labelLg
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
