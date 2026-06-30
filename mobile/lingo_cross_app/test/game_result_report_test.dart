import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/results/data/dtos/result_dtos.dart';
import 'package:lingo_cross_app/features/results/data/results_repository.dart';
import 'package:lingo_cross_app/features/results/presentation/screens/game_result_report_screen.dart';

import 'helpers/fake_results_repository.dart';

Widget _wrap({
  required GameResultDto seed,
  required FakeResultsRepository repo,
}) {
  final router = GoRouter(
    initialLocation: '/report',
    routes: [
      GoRoute(
        path: '/report',
        builder: (_, __) => GameResultReportScreen(
          resultId: seed.id,
          seedResult: seed,
        ),
      ),
      GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/student/results', builder: (_, __) => const Scaffold()),
      GoRoute(
          path: '/student/games/:gameId',
          builder: (_, state) =>
              Scaffold(body: Text('OYUN ${state.pathParameters['gameId']}'))),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(
    overrides: [
      resultsRepositoryProvider.overrideWithValue(repo),
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

/// Rapor içeriği uzundur (radyal + bento + iki buton); test yüzeyini büyüt ki
/// alttaki aksiyon butonları lazy ListView'da inşa edilsin.
void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets(
      'skor/süre/doğru-toplam gösterilir; "Tekrar Oyna"/"Öğretmene Gönder" YOK, '
      '"paylaşıldı" notu VAR', (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(
      score: 85,
      durationMs: 252000, // 04:12
      totalItems: 20,
      correctItems: 17,
      sharedWithTeacher: true, // submit otomatik paylaştı
    );
    await tester.pumpWidget(
      _wrap(seed: seed, repo: FakeResultsRepository()),
    );
    await tester.pump(); // seed (post-frame)
    await tester.pump();

    // İstatistikler aynen kalır.
    expect(find.text('Oyun Özeti'), findsOneWidget);
    expect(find.text('%85'), findsOneWidget); // doğruluk radyali
    expect(find.text('04:12'), findsOneWidget); // geçen süre
    expect(find.text('17 / 20'), findsOneWidget); // bulunan kelime

    // Butonlar kaldırıldı.
    expect(find.text('Öğretmene Gönder'), findsNothing);
    expect(find.text('Tekrar Oyna'), findsNothing);
    expect(find.text('Öğretmene Gönderildi'), findsNothing);

    // Paylaşıldı bilgi notu var.
    expect(find.text('Öğretmeninle paylaşıldı'), findsOneWidget);
  });

  testWidgets('share repo metodu hiç çağrılmaz (otomatik paylaşım)',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'r5', sharedWithTeacher: true);
    final repo = FakeResultsRepository(mine: [seed]);
    await tester.pumpWidget(_wrap(seed: seed, repo: repo));
    await tester.pump();
    await tester.pump();

    // Ekranda elle paylaşım yok → repo.share çağrılmamalı.
    expect(repo.shareCount, 0);
    expect(find.text('Öğretmeninle paylaşıldı'), findsOneWidget);
  });

  testWidgets(
      'items dolu → "Cevap Dökümü" + doğru/yanlış satırları görünür; özet kalır',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'rb1', sharedWithTeacher: true);
    final repo = FakeResultsRepository(
      mine: [seed],
      details: {'rb1': sampleResultDetail(id: 'rb1')},
    );
    await tester.pumpWidget(_wrap(seed: seed, repo: repo));
    await tester.pump(); // seed (post-frame)
    await tester.pump(); // _loadBreakdown future
    await tester.pumpAndSettle();

    // Özet hâlâ görünür.
    expect(find.text('Oyun Özeti'), findsOneWidget);
    expect(find.text('Öğretmeninle paylaşıldı'), findsOneWidget);

    // Kırılım bölümü açıldı.
    expect(find.text('Cevap Dökümü'), findsOneWidget);
    // Terimler listelendi (3 item).
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('bread'), findsOneWidget);
    expect(find.text('water'), findsOneWidget);
    // Doğru/yanlış rozetleri (1 doğru, 2 yanlış).
    expect(find.text('Doğru'), findsOneWidget);
    expect(find.text('Yanlış'), findsNWidgets(2));
    // Boş bırakılan cevap etiketi (öğrenci dili).
    expect(find.text('Senin cevabın: — (boş)'), findsOneWidget);
    // Verilen yanlış cevap (öğrenci dili).
    expect(find.text('Senin cevabın: su'), findsOneWidget);
    // Öğretmen dilindeki etiket bu ekranda KULLANILMAZ.
    expect(find.textContaining('Öğrencinin cevabı'), findsNothing);
  });

  testWidgets('items boş (eski sonuç) → kırılım bölümü gizli; özet görünür',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'rb2', sharedWithTeacher: true);
    final repo = FakeResultsRepository(
      mine: [seed],
      details: {
        'rb2': sampleResultDetail(id: 'rb2', items: const []),
      },
    );
    await tester.pumpWidget(_wrap(seed: seed, repo: repo));
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Oyun Özeti'), findsOneWidget);
    // Kırılım bölümü gizli.
    expect(find.text('Cevap Dökümü'), findsNothing);
  });

  testWidgets(
      'detay ucu hata verirse kırılım gizli kalır ama özet (seed) bozulmaz',
      (tester) async {
    _tallSurface(tester);
    final seed = sampleResult(id: 'rb3', sharedWithTeacher: true);
    // details boş → getResultDetail notFound atar; seed özeti etkilenmez.
    final repo = FakeResultsRepository(mine: [seed]);
    await tester.pumpWidget(_wrap(seed: seed, repo: repo));
    await tester.pump();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Oyun Özeti'), findsOneWidget);
    expect(find.text('Öğretmeninle paylaşıldı'), findsOneWidget);
    expect(find.text('Cevap Dökümü'), findsNothing);
  });

  testWidgets('geçmişten (seed yok) yüklenince de paylaşıldı notu görünür',
      (tester) async {
    _tallSurface(tester);
    final stored = sampleResult(id: 'r6', sharedWithTeacher: true);
    final repo = FakeResultsRepository(mine: [stored]);
    // seedResult vermeden, yalnız resultId ile aç → load() GET /results/me.
    final router = GoRouter(
      initialLocation: '/report',
      routes: [
        GoRoute(
          path: '/report',
          builder: (_, __) => const GameResultReportScreen(resultId: 'r6'),
        ),
        GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/student/results', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [resultsRepositoryProvider.overrideWithValue(repo)],
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
      ),
    );
    await tester.pump(); // load (post-frame)
    await tester.pumpAndSettle();

    expect(find.text('Öğretmeninle paylaşıldı'), findsOneWidget);
    expect(find.text('Öğretmene Gönder'), findsNothing);
    expect(find.text('Tekrar Oyna'), findsNothing);
  });

  testWidgets(
      'geçmişten (seed yok) detay ucundan özet + kırılım birlikte yüklenir',
      (tester) async {
    _tallSurface(tester);
    final repo = FakeResultsRepository(
      details: {'r7': sampleResultDetail(id: 'r7')},
    );
    final router = GoRouter(
      initialLocation: '/report',
      routes: [
        GoRoute(
          path: '/report',
          builder: (_, __) => const GameResultReportScreen(resultId: 'r7'),
        ),
        GoRoute(path: '/student', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/student/results', builder: (_, __) => const Scaffold()),
        GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [resultsRepositoryProvider.overrideWithValue(repo)],
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
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    // Özet detaydan geldi.
    expect(find.text('Oyun Özeti'), findsOneWidget);
    expect(find.text('%85'), findsOneWidget);
    // Kırılım da geldi.
    expect(find.text('Cevap Dökümü'), findsOneWidget);
    expect(find.text('apple'), findsOneWidget);
    // listMine'a düşmedi (detay başarılı).
    expect(repo.detailCount, 1);
  });
}
