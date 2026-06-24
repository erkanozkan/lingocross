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
import 'package:lingo_cross_app/features/lessons/domain/language_option.dart';
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
      'Submit bar bottomNavigationBar yerine body içinde (klavye örtmesin)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.byType(PrimaryButton3D), findsOneWidget);

    // Asıl düzeltme: bottomNavigationBar klavyenin üstüne çıkmaz, klavye onu
    // örterdi. Bu yüzden submit bar body Column'una taşındı + gövde klavye
    // açılınca küçülsün diye resizeToAvoidBottomInset açık.
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.bottomNavigationBar, isNull,
        reason: 'Submit bar body içinde olmalı, bottomNavigationBar slotunda değil');
    expect(scaffold.resizeToAvoidBottomInset, isTrue);
  });

  // Dil seçiciler ListView'in alt kısmında; test viewport'una sığması için
  // önce kaydır.
  Future<void> revealLanguagePair(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('Hedef Dil'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
      'F9.2: kaynak + hedef dil seçici görünür, varsayılan en→tr (İngilizce→Türkçe)',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await revealLanguagePair(tester);

    // İki dil dropdown'ı (kaynak + hedef).
    expect(
      find.byType(DropdownButtonFormField<LanguageOption>),
      findsNWidgets(2),
    );

    // Alan etiketleri (tr).
    expect(find.text('Kaynak Dil'), findsOneWidget);
    expect(find.text('Hedef Dil'), findsOneWidget);

    // Varsayılan seçili değerler: kaynak İngilizce, hedef Türkçe.
    expect(find.text('İngilizce'), findsOneWidget);
    expect(find.text('Türkçe'), findsOneWidget);
  });

  testWidgets(
      'F9.2: kaynağı hedefle aynı dile (Türkçe) çevirince hedef otomatik farklı dile kayar',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await revealLanguagePair(tester);

    final dropdowns = find.byType(DropdownButtonFormField<LanguageOption>);
    // Kaynak dropdown'ı aç (ilk dropdown) ve "Türkçe" seç.
    await tester.tap(dropdowns.first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Türkçe').last);
    await tester.pumpAndSettle();

    // Kaynak artık Türkçe (iki tarafta aynı dil olamaz → hedef farklı dile
    // kaydı). Yani "Türkçe" yalnız bir kez (kaynakta) görünmeli; hedef başka
    // bir dile (İngilizce'ye) düşer.
    expect(find.text('Türkçe'), findsOneWidget);
    expect(find.text('İngilizce'), findsOneWidget);
  });

  testWidgets(
      'F9.2: hedef dropdown\'ında kaynakla aynı dil (İngilizce) öğe olarak listelenmez',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    await revealLanguagePair(tester);

    final dropdowns = find.byType(DropdownButtonFormField<LanguageOption>);
    // Hedef dropdown'ı aç (ikinci dropdown). Kaynak = İngilizce olduğundan
    // hedef menüsünde "İngilizce" öğesi bulunmamalı; ekranda yalnız kaynaktaki
    // tek "İngilizce" görünür (menüde ekstra bir kopya çıkmaz).
    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();

    expect(find.text('İngilizce'), findsOneWidget);
    // Menü diğer dilleri (örn. Almanca) öğe olarak içerir.
    expect(find.text('Almanca'), findsWidgets);
  });
}
