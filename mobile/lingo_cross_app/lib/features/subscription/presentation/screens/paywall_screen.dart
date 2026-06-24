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

/// Seçilebilir abonelik planı (placeholder; fiyatlar henüz yok).
enum _PaywallPlan { monthly, annual, trial }

/// Placeholder Paywall ekranı (F8.2).
///
/// NİHAİ görsel ayrı bir Stitch tasarımıyla gelecek; bu ekran çalışan ama sade
/// bir yer tutucudur — kodu temiz/izole tutulur ki birebir tasarımla rahatça
/// değiştirilebilsin. Lumina token'larına uyar.
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

  String _bannerText(AppLocalizations l10n) {
    return switch (widget.feature) {
      'ocr' => l10n.paywallBannerOcr,
      'class_limit' => l10n.paywallBannerClassLimit,
      'lesson_limit' => l10n.paywallBannerLessonLimit,
      'multi_teacher' => l10n.paywallBannerMultiTeacher,
      _ => l10n.paywallBannerDefault,
    };
  }

  ActivateStubRequest _request() {
    return switch (_selected) {
      _PaywallPlan.monthly => const ActivateStubRequest(period: 1),
      _PaywallPlan.annual => const ActivateStubRequest(period: 2),
      _PaywallPlan.trial => const ActivateStubRequest(trial: true),
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.paywallTitle,
          style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.marginMobile,
            AppSpacing.md,
            AppSpacing.marginMobile,
            AppSpacing.xl,
          ),
          children: [
            _Banner(text: _bannerText(l10n)),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.paywallHeadline,
              style: AppTypography.headlineLg.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitUnlimitedClasses),
            _Benefit(text: l10n.paywallBenefitOcr),
            _Benefit(text: l10n.paywallBenefitMultiTeacher),
            const SizedBox(height: AppSpacing.lg),
            _PlanCard(
              title: l10n.paywallPlanMonthlyTitle,
              price: l10n.paywallPlanPriceComingSoon,
              selected: _selected == _PaywallPlan.monthly,
              onTap: () => setState(() => _selected = _PaywallPlan.monthly),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              title: l10n.paywallPlanAnnualTitle,
              price: l10n.paywallPlanPriceComingSoon,
              selected: _selected == _PaywallPlan.annual,
              onTap: () => setState(() => _selected = _PaywallPlan.annual),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              title: l10n.paywallPlanTrialTitle,
              price: l10n.paywallPlanTrialSubtitle,
              selected: _selected == _PaywallPlan.trial,
              onTap: () => setState(() => _selected = _PaywallPlan.trial),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton3D(
              label: l10n.paywallCta,
              isLoading: _submitting,
              onPressed: _upgrade,
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: TextButton(
                onPressed: _submitting ? null : () => context.pop(),
                child: Text(
                  l10n.paywallSkip,
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSecondaryFixedVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.tertiary, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? AppShadows.level2 : null,
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.outline,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Text(
              price,
              style: AppTypography.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
