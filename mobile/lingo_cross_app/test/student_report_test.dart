import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/tracking/data/tracking_repository.dart';
import 'package:lingo_cross_app/features/tracking/domain/tracking_failure.dart';
import 'package:lingo_cross_app/features/tracking/presentation/screens/student_report_screen.dart';

import 'helpers/fake_tracking_repository.dart';

Widget _wrap(FakeTrackingRepository repo, {String studentName = 'Ada'}) {
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
      home: StudentReportScreen(studentId: 's1', studentName: studentName),
    ),
  );
}

void main() {
  testWidgets('dolu liste: özet (ortalama + sayı) + sonuç kartı', (tester) async {
    final repo = FakeTrackingRepository(resultsByStudent: {
      's1': [
        sampleSharedResult(resultId: 'r1', lessonTitle: 'Ünite 3', score: 90),
        sampleSharedResult(resultId: 'r2', lessonTitle: 'Ünite 4', score: 70),
      ],
    });
    await tester.pumpWidget(_wrap(repo, studentName: 'Ada Yılmaz'));
    await tester.pumpAndSettle();

    // Başlık (appbar) + özet başlık.
    expect(find.text('Ada Yılmaz'), findsWidgets);
    expect(find.text('Ortalama Doğruluk'), findsOneWidget);
    expect(find.text('%80'), findsOneWidget); // (90+70)/2
    expect(find.text('2'), findsOneWidget); // paylaşılan sonuç sayısı
    expect(find.text('Ünite 3'), findsOneWidget);
    expect(find.text('Ünite 4'), findsOneWidget);
    expect(find.text('Kelime Eşleştirme'), findsWidgets); // oyun türü etiketi
  });

  testWidgets('boş: bu öğrenci paylaşım yapmadı', (tester) async {
    final repo = FakeTrackingRepository(resultsByStudent: const {'s1': []});
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Henüz paylaşılan sonuç yok'), findsOneWidget);
  });

  testWidgets('hata: tekrar dene', (tester) async {
    final repo =
        FakeTrackingRepository(resultsError: const TrackingFailure.network());
    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    expect(find.text('Sonuçlar yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar Dene'), findsOneWidget);
  });
}
