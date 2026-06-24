import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/core/widgets/app_text_field.dart';
import 'package:lingo_cross_app/core/widgets/primary_button_3d.dart';
import 'package:lingo_cross_app/features/lessons/data/lessons_repository.dart';
import 'package:lingo_cross_app/features/lessons/presentation/screens/lesson_form_screen.dart';

import 'helpers/fake_lessons_repository.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/teacher/lessons/new',
    routes: [
      GoRoute(
        path: '/teacher/lessons/new',
        builder: (_, __) => const LessonFormScreen(),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      lessonsRepositoryProvider.overrideWithValue(FakeLessonsRepository()),
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

void main() {
  testWidgets(
      'Ders Oluşturma create modunda form alanları görünür (buton ekranı kaplamaz)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Regresyon: PrimaryButton3D bottomNavigationBar yuvasında tüm yüksekliği
    // doldurursa gövde (ListView) 0 yükseklik kalır ve alanlar hiç oluşmaz.
    // 3 alan: tarih/hafta, ünite adı, konular.
    expect(find.byType(AppTextField), findsNWidgets(3));

    // Submit butonu var ve makul yükseklikte (ekranı kaplamıyor).
    expect(find.byType(PrimaryButton3D), findsOneWidget);
    final btnSize = tester.getSize(find.byType(PrimaryButton3D));
    final screenH = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(btnSize.height, lessThan(screenH / 2));
  });

  testWidgets(
      'Klavye açıkken (viewInsets) form kaydırılabilir kalır ve submit bar görünür',
      (tester) async {
    // F4.1: klavye yüksekliği viewInsets.bottom olarak simüle edilir.
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    // Klavye altında dahi alanlar oluşur (ListView alt padding'ine viewInsets
    // eklendiği için 0-yükseklik gövde regresyonu olmaz).
    expect(find.byType(AppTextField), findsNWidgets(3));
    // Submit bar (klavye üstünde, bottomNavigationBar yuvasında) görünür kalır.
    expect(find.byType(PrimaryButton3D), findsOneWidget);
  });
}
