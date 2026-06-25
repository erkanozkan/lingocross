import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/subscription/data/iap_providers.dart';
import 'package:lingo_cross_app/features/subscription/data/subscription_repository.dart';
import 'package:lingo_cross_app/features/subscription/domain/iap_products.dart';
import 'package:lingo_cross_app/features/subscription/presentation/screens/paywall_screen.dart';

import 'helpers/fake_iap_client.dart';
import 'helpers/fake_subscription_repository.dart';

Widget _wrap(
  FakeIapClient client,
  FakeSubscriptionRepository repo, {
  String? feature,
}) {
  final router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(
        path: '/start',
        builder: (_, __) => Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.push('/paywall'),
                child: const Text('OPEN'),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/paywall',
        builder: (_, __) => PaywallScreen(feature: feature),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      subscriptionRepositoryProvider.overrideWithValue(repo),
      iapClientProvider.overrideWithValue(client),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
    ),
  );
}

void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390 * 3, 1500 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Açılışta ürün fiyatları ProductDetails\'ten gösterilir',
      (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    final client = FakeIapClient();
    addTearDown(client.dispose);
    await tester.pumpWidget(_wrap(client, repo, feature: 'ocr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    // AI banner + iki plan kartı + gerçek fiyatlar.
    expect(find.text(l10n.paywallBannerOcr), findsOneWidget);
    expect(find.text(l10n.paywallPlanAnnualTitle), findsOneWidget);
    expect(find.text(l10n.paywallPlanMonthlyTitle), findsOneWidget);
    expect(find.text('₺399,99'), findsOneWidget); // yıllık
    expect(find.text('₺49,99'), findsOneWidget); // aylık
    // Geri yükleme butonu (Apple zorunlu) görünür.
    expect(find.text(l10n.paywallRestore), findsOneWidget);
  });

  testWidgets('Yükselt CTA → buyNonConsumable + purchased event → verify + pop',
      (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    final client = FakeIapClient();
    addTearDown(client.dispose);
    await tester.pumpWidget(_wrap(client, repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    // Varsayılan seçim Yıllık → CTA buy çağırır.
    await tester.tap(find.text(l10n.paywallCta));
    await tester.pump();
    expect(client.buyCount, 1);

    // Mağaza purchased olayını yayınlar → verify + complete + pop.
    client.emit([
      fakePurchase(
        productId: IapProducts.yearly,
        status: PurchaseStatus.purchased,
        receipt: 'receipt-xyz',
      ),
    ]);
    await tester.pumpAndSettle();

    expect(repo.verifyAppleCount, 1);
    expect(repo.lastReceiptData, 'receipt-xyz');
    expect(client.completeCount, 1);
    expect(find.text(l10n.paywallPurchaseSuccess), findsOneWidget);
    // Başarıda paywall pop edildi.
    expect(find.text('OPEN'), findsOneWidget);
  });

  testWidgets('canceled olayı → "iptal" mesajı, pop olmaz', (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    final client = FakeIapClient();
    addTearDown(client.dispose);
    await tester.pumpWidget(_wrap(client, repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    await tester.tap(find.text(l10n.paywallCta));
    await tester.pump();
    client.emit([
      fakePurchase(
        productId: IapProducts.yearly,
        status: PurchaseStatus.canceled,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(repo.verifyAppleCount, 0);
    expect(find.text(l10n.paywallPurchaseCanceled), findsOneWidget);
    expect(find.text(l10n.paywallCta), findsOneWidget); // paywall açık
  });

  testWidgets('Geri Yükle → restorePurchases çağrılır', (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    final client = FakeIapClient();
    addTearDown(client.dispose);
    await tester.pumpWidget(_wrap(client, repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    await tester.tap(find.text(l10n.paywallRestore));
    await tester.pump();

    expect(client.restoreCount, 1);
  });

  testWidgets('Mağaza yok → fiyat yer tutucu + uyarı mesajı', (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    final client = FakeIapClient(available: false);
    addTearDown(client.dispose);
    await tester.pumpWidget(_wrap(client, repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));
    expect(find.text(l10n.paywallProductsUnavailable), findsOneWidget);
  });
}
