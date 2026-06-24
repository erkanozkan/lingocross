import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/subscription/data/subscription_repository.dart';
import 'package:lingo_cross_app/features/subscription/domain/subscription_failure.dart';
import 'package:lingo_cross_app/features/subscription/presentation/screens/paywall_screen.dart';

import 'helpers/fake_subscription_repository.dart';

Widget _wrap(FakeSubscriptionRepository repo, {String? feature}) {
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

/// Paywall içeriği uzun + sabit footer var; tüm kartlar (Yıllık/Aylık) test
/// yüzeyinde aynı anda görünsün diye uzun bir görünüm boyutu kullanılır.
void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390 * 3, 1400 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Yükselt CTA → activate(period:2) çağrılır + başarıda pop',
      (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    await tester.pumpWidget(_wrap(repo, feature: 'ocr'));
    await tester.pumpAndSettle();

    // Paywall'ı aç.
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    // AI banner'ı görünür (feature=ocr → "AI ile kelime tarama Premium'da").
    expect(find.text(l10n.paywallBannerOcr), findsOneWidget);

    // Hero + alt başlık + AI fayda metni + iki plan kartı görünür.
    expect(find.text(l10n.paywallHeadline), findsOneWidget);
    expect(find.text(l10n.paywallSubtitle), findsOneWidget);
    expect(find.text(l10n.paywallBenefitOcr), findsOneWidget); // "AI ile kelime tarama"
    expect(find.text(l10n.paywallPlanAnnualTitle), findsOneWidget);
    expect(find.text(l10n.paywallPlanMonthlyTitle), findsOneWidget);

    // Varsayılan seçim Yıllık → period=2 ile activate.
    await tester.tap(find.text(l10n.paywallCta));
    await tester.pumpAndSettle();

    expect(repo.activateCount, 1);
    expect(repo.lastActivateRequest?.period, 2);
    expect(repo.lastActivateRequest?.trial, false);

    // Başarıda paywall pop edildi → başlangıç ekranı geri gelir.
    expect(find.text('OPEN'), findsOneWidget);
  });

  testWidgets('Aylık seçimi → activate(period:1)', (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription());
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    await tester.tap(find.text(l10n.paywallPlanMonthlyTitle));
    await tester.pump();
    await tester.tap(find.text(l10n.paywallCta));
    await tester.pumpAndSettle();

    expect(repo.lastActivateRequest?.period, 1);
  });

  testWidgets('503 (purchaseDisabled) → "satın alma kapalı" mesajı, pop olmaz',
      (tester) async {
    _useTallSurface(tester);
    final repo = FakeSubscriptionRepository(initial: freeSubscription())
      ..activateError = const SubscriptionFailure.purchaseDisabled();
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    await tester.tap(find.text(l10n.paywallCta));
    await tester.pumpAndSettle();

    expect(find.text(l10n.paywallPurchaseDisabled), findsOneWidget);
    // Hata → paywall açık kalır (CTA hâlâ görünür).
    expect(find.text(l10n.paywallCta), findsOneWidget);
  });
}
