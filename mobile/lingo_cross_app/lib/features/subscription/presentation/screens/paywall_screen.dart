import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/dtos/subscription_dtos.dart';
import '../../domain/subscription_failure.dart';
import '../subscription_notifier.dart';

/// Seçilebilir abonelik planı (fiyatlar henüz yer tutucu).
enum _PaywallPlan { monthly, annual }

/// Paywall ekranı (F8.2) — Stitch "Premium (Paywall)" tasarımı birebir.
///
/// Sabit üst bar (Premium + kapat), ortalı hero, feature banner, fayda listesi,
/// seçilebilir plan kartları (varsayılan Yıllık) ve sabit alt footer (CTA +
/// "Şimdilik geç"). İçerik AI wording'i kullanır (OCR yerine "AI").
///
/// CTA seçilen plana göre [SubscriptionNotifier.activate] (stub) çağırır; başarı
/// → bilgi + pop, 503 → "satın alma kapalı (test)" mesajı.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.feature});

  /// 402 / proaktif kilitten gelen özellik anahtarı ("ocr", "class_limit", ...).
  final String? feature;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  _PaywallPlan _selected = _PaywallPlan.annual;
  bool _submitting = false;

  /// Banner metni; feature bilinmiyorsa null → banner gizlenir.
  String? _bannerText(AppLocalizations l10n) {
    return switch (widget.feature) {
      'ocr' => l10n.paywallBannerOcr,
      'class_limit' => l10n.paywallBannerClassLimit,
      'lesson_limit' => l10n.paywallBannerLessonLimit,
      'multi_teacher' => l10n.paywallBannerMultiTeacher,
      null => null,
      _ => l10n.paywallBannerDefault,
    };
  }

  ActivateStubRequest _request() {
    return switch (_selected) {
      _PaywallPlan.monthly => const ActivateStubRequest(period: 1),
      _PaywallPlan.annual => const ActivateStubRequest(period: 2),
    };
  }

  Future<void> _upgrade() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(subscriptionNotifierProvider.notifier)
          .activate(_request());
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.tertiary,
          content: Text(
            l10n.paywallActivateSuccess,
            style: const TextStyle(color: AppColors.onTertiary),
          ),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final message = e is SubscriptionFailure
          ? e.maybeWhen(
              purchaseDisabled: () => l10n.paywallPurchaseDisabled,
              orElse: () => l10n.paywallActivateError,
            )
          : l10n.paywallActivateError;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(
            message,
            style: const TextStyle(color: AppColors.onError),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final banner = _bannerText(l10n);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Sabit üst bar: sol "Premium", sağ kapat (X).
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: AppSpacing.marginMobile,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.paywallTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary, size: 28),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.xl,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            // Hero.
            const _Hero(),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.paywallHeadline,
              textAlign: TextAlign.center,
              style: AppTypography.displayLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.paywallSubtitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Feature banner (feature bilinmiyorsa gizli).
            if (banner != null) ...[
              _Banner(text: banner),
              const SizedBox(height: AppSpacing.xl),
            ],
            // Fayda listesi.
            _Benefit(text: l10n.paywallBenefitUnlimitedClasses),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitOcr),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitMultiTeacher),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitReports),
            const SizedBox(height: AppSpacing.xl),
            // Plan kartları.
            _PlanCard(
              title: l10n.paywallPlanAnnualTitle,
              subtitle: l10n.paywallPlanAnnualSubtitle,
              price: l10n.paywallPlanPriceComingSoon,
              period: l10n.paywallPlanAnnualPeriod,
              badge: l10n.paywallPlanBestValue,
              selected: _selected == _PaywallPlan.annual,
              onTap: () => setState(() => _selected = _PaywallPlan.annual),
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              title: l10n.paywallPlanMonthlyTitle,
              subtitle: l10n.paywallPlanMonthlySubtitle,
              price: l10n.paywallPlanPriceComingSoon,
              period: l10n.paywallPlanMonthlyPeriod,
              selected: _selected == _PaywallPlan.monthly,
              onTap: () => setState(() => _selected = _PaywallPlan.monthly),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                l10n.paywallTrialNote,
                textAlign: TextAlign.center,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      // Sabit alt footer: CTA + "Şimdilik geç".
      bottomNavigationBar: _Footer(
        ctaLabel: l10n.paywallCta,
        skipLabel: l10n.paywallSkip,
        submitting: _submitting,
        onUpgrade: _upgrade,
        onSkip: _submitting ? null : () => context.pop(),
      ),
    );
  }
}

/// 96px secondary-container daire + beyaz dolu workspace_premium ikonu.
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: AppColors.secondaryContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4DFEA619), // rgba(254,166,25,0.3)
              offset: Offset(0, 8),
              blurRadius: 24,
            ),
          ],
        ),
        child: const Icon(
          Icons.workspace_premium,
          color: AppColors.onSecondary,
          size: 48,
        ),
      ),
    );
  }
}

/// primary-fixed zemin + küçük primary-container ikon kutusu + metin.
class _Banner extends StatelessWidget {
  const _Banner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onPrimaryFixedVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 24px tertiary daire + beyaz check + fayda metni.
class _Benefit extends StatelessWidget {
  const _Benefit({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.tertiary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.onTertiary,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}

/// Seçilebilir plan kartı; seçili → 2px secondaryContainer kenarlık + dolu
/// radyo + soft shadow. İsteğe bağlı "En Avantajlı" rozeti (üst-offset).
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.period,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String price;
  final String period;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final card = Material(
      color: selected
          ? AppColors.surfaceContainerLowest
          : AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: selected
                  ? AppColors.secondaryContainer
                  : AppColors.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected ? AppShadows.soft : null,
          ),
          child: Row(
            children: [
              _Radio(selected: selected),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    period,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (badge == null) return card;

    // Rozet üst kenardan taşar → Stack + clip kapalı.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(padding: const EdgeInsets.only(top: AppSpacing.xs), child: card),
        Positioned(
          top: 0,
          right: AppSpacing.md,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              badge!.toUpperCase(),
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 24px radyo; seçili → primary kenarlık + içi dolu primary daire.
class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.outlineVariant,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

/// Sabit alt footer: surface-container-lowest zemin + üst kenarlık + soft
/// gölge, tam genişlik CTA + "Şimdilik geç" metin butonu.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.ctaLabel,
    required this.skipLabel,
    required this.submitting,
    required this.onUpgrade,
    required this.onSkip,
  });

  final String ctaLabel;
  final String skipLabel;
  final bool submitting;
  final VoidCallback onUpgrade;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            offset: Offset(0, -8),
            blurRadius: 32,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton3D(
                label: ctaLabel,
                isLoading: submitting,
                onPressed: onUpgrade,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: onSkip,
                child: Text(
                  skipLabel,
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
