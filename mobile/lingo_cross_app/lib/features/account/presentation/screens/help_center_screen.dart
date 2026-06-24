import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Yardım Merkezi (Stitch `5597b93…` — birebir). Hesap Ayarları'ndan
/// push'lanır (`/account/help`).
///
/// Üstte arama çubuğu (yerel filtre) + SSS akordiyon listesi (tek seferde bir
/// açık) + "Hâlâ yardıma mı ihtiyacın var?" iletişim kartı + "Bize Ulaşın"
/// (mailto:, başarısızsa adresi panoya kopyalar).
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  static const String _supportEmail = 'destek@lingocross.app';

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int? _openIndex;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<(String, String)> _faqs(AppLocalizations l10n) => [
        (l10n.helpFaqQ1, l10n.helpFaqA1),
        (l10n.helpFaqQ2, l10n.helpFaqA2),
        (l10n.helpFaqQ3, l10n.helpFaqA3),
        (l10n.helpFaqQ4, l10n.helpFaqA4),
        (l10n.helpFaqQ5, l10n.helpFaqA5),
        (l10n.helpFaqQ6, l10n.helpFaqA6),
      ];

  Future<void> _contact(AppLocalizations l10n) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': l10n.helpContactEmailSubject},
    );
    final launched = await launchUrl(uri).catchError((_) => false);
    if (!launched && mounted) {
      await Clipboard.setData(const ClipboardData(text: _supportEmail));
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(l10n.helpContactCopied(_supportEmail)),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allFaqs = _faqs(l10n);
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? List.generate(allFaqs.length, (i) => i)
        : [
            for (var i = 0; i < allFaqs.length; i++)
              if (allFaqs[i].$1.toLowerCase().contains(q) ||
                  allFaqs[i].$2.toLowerCase().contains(q))
                i,
          ];

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
          l10n.helpCenterTitle,
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
          // Arama bölümü.
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.soft,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.outline),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: AppTypography.bodyMd,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm),
                        border: InputBorder.none,
                        hintText: l10n.helpSearchPlaceholder,
                        hintStyle: AppTypography.bodyMd
                            .copyWith(color: AppColors.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // SSS bölümü.
          Text(
            l10n.helpFaqSectionTitle,
            style: AppTypography.headlineMd,
          ),
          const SizedBox(height: AppSpacing.md),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text(
                l10n.helpFaqEmpty,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            )
          else
            for (final i in filtered) ...[
              _FaqItem(
                question: allFaqs[i].$1,
                answer: allFaqs[i].$2,
                expanded: _openIndex == i,
                onTap: () =>
                    setState(() => _openIndex = _openIndex == i ? null : i),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.lg),
          // İletişim kartı.
          _ContactCard(
            title: l10n.helpContactTitle,
            desc: l10n.helpContactDesc,
            cta: l10n.helpContactCta,
            onTap: () => _contact(l10n),
          ),
        ],
      ),
    );
  }
}

/// SSS akordiyon öğesi (soru + chevron; dokununca cevap açılır).
class _FaqItem extends StatelessWidget {
  const _FaqItem({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: AppTypography.labelLg.copyWith(
                        color: expanded
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more,
                        color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      answer,
                      style: AppTypography.bodyMd
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// "Hâlâ yardıma mı ihtiyacın var?" iletişim kartı + "Bize Ulaşın" butonu.
class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.title,
    required this.desc,
    required this.cta,
    required this.onTap,
  });

  final String title;
  final String desc;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -32,
            top: -32,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            left: -16,
            bottom: -16,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.mail_outline, size: 20),
                  label: Text(cta, style: AppTypography.labelLg),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
