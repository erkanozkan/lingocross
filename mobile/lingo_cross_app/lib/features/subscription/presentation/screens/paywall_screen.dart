import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_button_3d.dart';
import '../../data/iap_providers.dart';
import '../../data/iap_service.dart';
import '../../domain/iap_products.dart';

/// Seçilebilir abonelik planı.
enum _PaywallPlan { monthly, annual }

/// Paywall ekranı (F8.2 / S3) — Stitch "Premium (Paywall)" tasarımı birebir.
///
/// Sabit üst bar (Premium + kapat), ortalı hero, feature banner, fayda listesi,
/// seçilebilir plan kartları (varsayılan Yıllık), "Satın Alımları Geri Yükle"
/// metin butonu ve sabit alt footer (CTA + "Şimdilik geç"). İçerik AI wording'i
/// kullanır (OCR yerine "AI").
///
/// Gerçek Apple satın alması yapar: açılışta StoreKit'ten ürün fiyatları çekilir,
/// CTA seçili ürünü [IapService.buy] ile satın alır; sonuç `purchaseEvents`
/// üzerinden gelir (doğrulama backend'de). Başarı → bilgi + pop.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.feature});

  /// 402 / proaktif kilitten gelen özellik anahtarı ("ocr", "class_limit", ...).
  final String? feature;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  _PaywallPlan _selected = _PaywallPlan.annual;

  /// Satın alma / geri yükleme akışı sürerken footer spinner + kilit.
  bool _busy = false;

  IapProductsState _products = const IapProductsState(loading: true);
  StreamSubscription<IapProductsState>? _productsSub;
  StreamSubscription<IapPurchaseEvent>? _purchaseSub;

  IapService get _service => ref.read(iapServiceProvider);

  @override
  void initState() {
    super.initState();
    final service = _service;
    _products = service.productsState;
    _productsSub = service.productsStream.listen((s) {
      if (mounted) setState(() => _products = s);
    });
    _purchaseSub = service.purchaseEvents.listen(_onPurchaseEvent);
    // Açılışta ürünleri (yeniden) çek.
    unawaited(service.loadProducts());
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    _purchaseSub?.cancel();
    super.dispose();
  }

  String get _selectedProductId => switch (_selected) {
        _PaywallPlan.monthly => IapProducts.monthly,
        _PaywallPlan.annual => IapProducts.yearly,
      };

  ProductDetails? get _selectedProduct => _products.byId(_selectedProductId);

  void _onPurchaseEvent(IapPurchaseEvent event) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    switch (event.outcome) {
      case IapPurchaseOutcome.pending:
        setState(() => _busy = true);
      case IapPurchaseOutcome.success:
        setState(() => _busy = false);
        _showSuccess(l10n.paywallPurchaseSuccess);
        context.pop();
      case IapPurchaseOutcome.canceled:
        setState(() => _busy = false);
        _showError(l10n.paywallPurchaseCanceled);
      case IapPurchaseOutcome.error:
        setState(() => _busy = false);
        _showError(l10n.paywallPurchaseError);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.tertiary,
        content: Text(
          message,
          style: const TextStyle(color: AppColors.onTertiary),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.error,
        content: Text(
          message,
          style: const TextStyle(color: AppColors.onError),
        ),
      ),
    );
  }

  Future<void> _upgrade() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    final product = _selectedProduct;
    if (product == null) {
      _showError(l10n.paywallProductsError);
      return;
    }
    setState(() => _busy = true);
    try {
      await _service.buy(product);
      // Sonuç purchaseEvents üzerinden gelir; busy orada temizlenir.
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.paywallPurchaseError);
    }
  }

  Future<void> _restore() async {
    if (_busy) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await _service.restore();
      // Geri yüklenen işlemler purchaseStream → purchaseEvents üzerinden
      // doğrulanır; success olayı pop ettirir. Akış olay üretmezse spinner'ı
      // bir süre sonra serbest bırakmak için busy'i burada bırakmıyoruz —
      // ancak hiç olay gelmezse kullanıcı kapatabilir (footer "Şimdilik geç"
      // busy iken kilitli; bu nedenle restore sonrası kısa bekleme).
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(l10n.paywallPurchaseError);
    }
  }

  /// Banner metni; feature bilinmiyorsa null → banner gizlenir.
  String? _bannerText(AppLocalizations l10n) {
    return switch (widget.feature) {
      'ocr' => l10n.paywallBannerOcr,
      'class_limit' => l10n.paywallBannerClassLimit,
      'lesson_limit' => l10n.paywallBannerLessonLimit,
      'multi_teacher' => l10n.paywallBannerMultiTeacher,
      'puzzle_create' => l10n.paywallBannerPuzzleCreate,
      null => null,
      _ => l10n.paywallBannerDefault,
    };
  }

  /// Plan kartında gösterilecek fiyat: ürün yüklendiyse mağaza fiyatı, yoksa
  /// uygun yer tutucu/mesaj.
  String _priceFor(AppLocalizations l10n, String productId) {
    if (_products.loading) return l10n.paywallPriceUnavailable;
    if (_products.unavailable) return l10n.paywallPriceUnavailable;
    final product = _products.byId(productId);
    return product?.price ?? l10n.paywallPriceUnavailable;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final banner = _bannerText(l10n);

    // Ürünler hiç gelmedi (mağaza yok / sorgu hatası) → bilgilendirici not.
    final productsProblem = !_products.loading &&
        (_products.unavailable || _products.queryError);

    return Scaffold(
      backgroundColor: AppColors.surface,
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
            onPressed: _busy ? null : () => context.pop(),
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
            if (banner != null) ...[
              _Banner(text: banner),
              const SizedBox(height: AppSpacing.xl),
            ],
            _Benefit(text: l10n.paywallBenefitOcr),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitOcrHandwriting),
            const SizedBox(height: AppSpacing.md),
            _Benefit(text: l10n.paywallBenefitOcrReview),
            const SizedBox(height: AppSpacing.xl),
            _PlanCard(
              title: l10n.paywallPlanAnnualTitle,
              subtitle: l10n.paywallPlanAnnualSubtitle,
              price: _priceFor(l10n, IapProducts.yearly),
              period: l10n.paywallPlanAnnualPeriod,
              badge: l10n.paywallPlanBestValue,
              selected: _selected == _PaywallPlan.annual,
              onTap: _busy
                  ? null
                  : () => setState(() => _selected = _PaywallPlan.annual),
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              title: l10n.paywallPlanMonthlyTitle,
              subtitle: l10n.paywallPlanMonthlySubtitle,
              price: _priceFor(l10n, IapProducts.monthly),
              period: l10n.paywallPlanMonthlyPeriod,
              selected: _selected == _PaywallPlan.monthly,
              onTap: _busy
                  ? null
                  : () => setState(() => _selected = _PaywallPlan.monthly),
            ),
            if (productsProblem) ...[
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Text(
                  _products.unavailable
                      ? l10n.paywallProductsUnavailable
                      : l10n.paywallProductsError,
                  textAlign: TextAlign.center,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
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
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                l10n.paywallAutoRenewNote,
                textAlign: TextAlign.center,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _LegalLinks(),
          ],
        ),
      ),
      bottomNavigationBar: _Footer(
        ctaLabel: l10n.paywallCta,
        skipLabel: l10n.paywallSkip,
        restoreLabel: l10n.paywallRestore,
        busy: _busy,
        onUpgrade: _upgrade,
        onRestore: _busy ? null : _restore,
        onSkip: _busy ? null : () => context.pop(),
      ),
    );
  }
}

/// App Review 3.1.2(c) zorunlu yasal bağlantılar: Gizlilik Politikası ve
/// Kullanım Koşulları (EULA). Küçük, soluk, dokunulabilir metin bağlantıları;
/// harici tarayıcıda açılır.
class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  static final Uri _privacyUrl =
      Uri.parse('https://lingocross.pages.dev/privacy-policy.html');
  static final Uri _termsUrl = Uri.parse(
    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/',
  );

  Future<void> _open(Uri url) async {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final linkStyle = AppTypography.labelSm.copyWith(
      color: AppColors.onSurfaceVariant,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.onSurfaceVariant,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _open(_privacyUrl),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Text(l10n.paywallPrivacyLink, style: linkStyle),
          ),
        ),
        Text(
          '·',
          style: AppTypography.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        InkWell(
          onTap: () => _open(_termsUrl),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Text(l10n.paywallTermsLink, style: linkStyle),
          ),
        ),
      ],
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
  final VoidCallback? onTap;
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
/// gölge, tam genişlik CTA + "Geri Yükle" + "Şimdilik geç" metin butonları.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.ctaLabel,
    required this.skipLabel,
    required this.restoreLabel,
    required this.busy,
    required this.onUpgrade,
    required this.onRestore,
    required this.onSkip,
  });

  final String ctaLabel;
  final String skipLabel;
  final String restoreLabel;
  final bool busy;
  final VoidCallback onUpgrade;
  final VoidCallback? onRestore;
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
                isLoading: busy,
                onPressed: onUpgrade,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: onRestore,
                child: Text(
                  restoreLabel,
                  style: AppTypography.labelLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
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
