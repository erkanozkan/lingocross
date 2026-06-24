import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Dil Tercihi (Lumina). Hesap Ayarları'ndan push'lanır (`/account/language`).
///
/// İki dil aktiftir: "Türkçe" ve "English". Seçili dil [localeControllerProvider]
/// state'ine bağlıdır; seçince [LocaleController.setLocale] çağrılır (cihazda
/// saklanır + best-effort backend'e yazılır). Info satırı + dekoratif kart.
class LanguagePreferenceScreen extends ConsumerWidget {
  const LanguagePreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(localeControllerProvider).languageCode;

    Future<void> select(String code) async {
      if (code == current) return;
      await ref.read(localeControllerProvider.notifier).setLocale(Locale(code));
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
          // Dil seçici kart (iki aktif seçenek).
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
                _LanguageRow(
                  label: l10n.languageOptionTurkish,
                  selected: current == 'tr',
                  onTap: () => select('tr'),
                ),
                Divider(
                  height: 1,
                  indent: AppSpacing.md,
                  endIndent: AppSpacing.md,
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                ),
                _LanguageRow(
                  label: l10n.languageOptionEnglish,
                  selected: current == 'en',
                  onTap: () => select('en'),
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

/// Tek dil satırı: seçili → dolu radio + check_circle; pasif → boş radio.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.outline,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTypography.headlineMd),
            ),
            // Sağda durum göstergesi: seçili → dolu radio, pasif → boş.
            if (selected)
              Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Gradient + ikon kümesi dekoratif hero kart (Lumina görselinin yerel karşılığı).
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
