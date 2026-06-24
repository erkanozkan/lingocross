import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/tracking/data/dtos/tracking_dtos.dart';
import 'package:lingo_cross_app/features/tracking/data/tracking_repository.dart';
import 'package:lingo_cross_app/features/tracking/domain/tracking_failure.dart';
import 'package:lingo_cross_app/features/tracking/presentation/screens/student_result_detail_screen.dart';

import 'helpers/fake_tracking_repository.dart';

Widget _wrap(FakeTrackingRepository repo, {String resultId = 'r1'}) {
  return ProviderScope(
    overrides: [trackingRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: StudentResultDetailScreen(studentId: 's1', resultId: resultId),
    ),
  );
}

void main() {
  testWidgets('doğru + yanlış kart render; bento + öğrenci kartı', (tester) async {
    final repo = FakeTrackingRepository(
      detailByResultId: {'r1': sampleResultDetail()},
    );
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    // Başlık + öğrenci bağlamı.
    expect(find.text('Sonuç Detayı'), findsOneWidget);
    expect(find.text('Ahmet Erdemir'), findsOneWidget);
    expect(find.text('Unit 4: Food & Drinks'), findsOneWidget);

    // Bento: doğru / toplam.
    expect(find.text('2 / 3'), findsOneWidget);

    // Doğru kelime (bread/ekmek) + rozet.
    expect(find.text('bread'), findsOneWidget);
    expect(find.text('Doğru'), findsWidgets);

    // Yanlış kelime (apple) + doğru cevap + öğrenci cevabı.
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('Doğru cevap: elma'), findsOneWidget);
    expect(find.text('Öğrencinin cevabı: armut'), findsOneWidget);

    // Boş öğrenci cevabı (water → null).
    expect(find.text('Öğrencinin cevabı: — (boş)'), findsOneWidget);

    // Bölüm Analizi gösterilir (liste sonunda; görünüme kaydır).
    await tester.scrollUntilVisible(find.text('Bölüm Analizi'), 200);
    await tester.pumpAndSettle();
    expect(find.text('Bölüm Analizi'), findsOneWidget);
    expect(find.text('Hız Skoru'), findsOneWidget);
  });

  testWidgets('filtre: Yanlışlar seçilince doğru kelime gizlenir', (tester) async {
    final repo = FakeTrackingRepository(
      detailByResultId: {'r1': sampleResultDetail()},
    );
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    // Başlangıç = Tümü → hepsi görünür.
    expect(find.text('bread'), findsOneWidget);
    expect(find.text('apple'), findsOneWidget);

    // "Yanlışlar (2)" sekmesine dokun.
    await tester.tap(find.text('Yanlışlar (2)'));
    await tester.pumpAndSettle();

    // Doğru kelime (bread) gizlenir, yanlışlar kalır.
    expect(find.text('bread'), findsNothing);
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('water'), findsOneWidget);
  });

  testWidgets('boş durum: items yoksa "Kelime detayı yok"', (tester) async {
    final repo = FakeTrackingRepository(
      detailByResultId: {
        'r1': sampleResultDetail(items: const <ResultItemDto>[]),
      },
    );
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Kelime detayı yok'), findsOneWidget);
    // Segmented filtre + Bölüm Analizi gizli.
    expect(find.text('Bölüm Analizi'), findsNothing);
    expect(find.textContaining('Yanlışlar'), findsNothing);
    // Bento yine gösterilir.
    expect(find.text('Ahmet Erdemir'), findsOneWidget);
  });

  testWidgets('hata: tekrar dene', (tester) async {
    final repo =
        FakeTrackingRepository(detailError: const TrackingFailure.network());
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Sonuç detayı yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });
}
