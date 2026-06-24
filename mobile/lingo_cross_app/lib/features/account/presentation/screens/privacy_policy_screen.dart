import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Gizlilik Politikası (Stitch `5140edef…` — birebir). Hesap Ayarları'ndan
/// push'lanır (`/account/privacy`).
///
/// Kaydırılabilir statik metin: başlık + "Son güncelleme" + giriş kartı +
/// 6 bölüm (3. bölüm güvenlik vurgulu kart, 6. bölüm iletişim kartı). Taslak
/// içerik (kullanıcı düzenler).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          l10n.privacyPolicyTitle,
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
          // Başlık + son güncelleme.
          Text(l10n.privacyPolicyTitle, style: AppTypography.displayLgMobile),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.privacyLastUpdated,
            style: AppTypography.labelSm.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Giriş kartı.
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.privacyIntro,
              style: AppTypography.bodyMd
                  .copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 1.
          _Section(
            title: l10n.privacySection1Title,
            body: l10n.privacySection1Body,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 2.
          _Section(
            title: l10n.privacySection2Title,
            body: l10n.privacySection2Body,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 3 — güvenlik vurgulu kart.
          _SecuritySection(
            title: l10n.privacySection3Title,
            body: l10n.privacySection3Body,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 4.
          _Section(
            title: l10n.privacySection4Title,
            body: l10n.privacySection4Body,
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 5 — haklar (madde listesi).
          _RightsSection(
            title: l10n.privacySection5Title,
            body: l10n.privacySection5Body,
            rights: [
              l10n.privacyRight1,
              l10n.privacyRight2,
              l10n.privacyRight3,
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Bölüm 6 — iletişim kartı.
          _ContactSection(
            title: l10n.privacySection6Title,
            body: l10n.privacySection6Body,
            email: l10n.privacyContactEmail,
            location: l10n.privacyContactLocation,
            emailSubject: l10n.privacyContactEmailSubject,
          ),
        ],
      ),
    );
  }
}

/// Standart bölüm (primary başlık + gövde).
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.md),
        Text(
          body,
          style: AppTypography.bodyMd
              .copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
        ),
      ],
    );
  }
}

/// 3. bölüm — surface-container-low zeminli güvenlik vurgu kartı + ikon.
class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: AppSpacing.md,
            right: AppSpacing.md,
            child: Icon(Icons.security,
                size: 64, color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTypography.headlineLg
                        .copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.md),
                Text(
                  body,
                  style: AppTypography.bodyMd
                      .copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 5. bölüm — haklar (check ikonlu madde listesi).
class _RightsSection extends StatelessWidget {
  const _RightsSection({
    required this.title,
    required this.body,
    required this.rights,
  });

  final String title;
  final String body;
  final List<String> rights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.md),
        Text(
          body,
          style: AppTypography.bodyMd
              .copyWith(color: AppColors.onSurfaceVariant, height: 1.6),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final right in rights)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.check_circle,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    right,
                    style: AppTypography.bodyMd
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 6. bölüm — primary-container zeminli iletişim kartı (mailto + konum).
class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.title,
    required this.body,
    required this.email,
    required this.location,
    required this.emailSubject,
  });

  final String title;
  final String body;
  final String email;
  final String location;
  final String emailSubject;

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': emailSubject},
    );
    final launched = await launchUrl(uri).catchError((_) => false);
    if (!launched && context.mounted) {
      await Clipboard.setData(ClipboardData(text: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.headlineLg.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
                style: AppTypography.bodyMd
                    .copyWith(color: AppColors.onPrimaryContainer),
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                onTap: () => _openEmail(context),
                child: Row(
                  children: [
                    const Icon(Icons.mail_outline,
                        size: 20, color: AppColors.onPrimaryContainer),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      email,
                      style: AppTypography.labelLg
                          .copyWith(color: AppColors.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 20, color: AppColors.onPrimaryContainer),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    location,
                    style: AppTypography.labelLg
                        .copyWith(color: AppColors.onPrimaryContainer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
