import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/classes/presentation/screens/classes_list_screen.dart';
import 'package:lingo_cross_app/features/subscription/data/subscription_repository.dart';

import 'helpers/fake_classes_repository.dart';
import 'helpers/fake_subscription_repository.dart';

ClassDto _class(String id) => ClassDto(
      id: id,
      name: 'Sınıf $id',
      inviteCode: 'CODE$id',
      studentCount: 5,
      createdAt: DateTime(2026, 6, 24),
    );

void main() {
  testWidgets(
      'Free + sınıf limiti dolu → "Yeni Sınıf" kilitli + tıkla → /paywall?feature=class_limit',
      (tester) async {
    final pushedRoutes = <String>[];

    // Free maxClasses=2; mevcut 2 sınıf → canCreateClass(2)=false (limit dolu).
    final router = GoRouter(
      initialLocation: '/x',
      routes: [
        GoRoute(path: '/x', builder: (_, __) => const ClassesListScreen()),
        GoRoute(
          path: '/paywall',
          builder: (context, state) {
            pushedRoutes.add(state.uri.toString());
            return const Scaffold(body: Text('PAYWALL'));
          },
        ),
        GoRoute(
          path: '/teacher/classes/new',
          builder: (_, __) => const Scaffold(body: Text('CREATE')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          classesRepositoryProvider.overrideWithValue(
            FakeClassesRepository(classes: [_class('c1'), _class('c2')]),
          ),
          subscriptionRepositoryProvider.overrideWithValue(
            FakeSubscriptionRepository(initial: freeSubscription()),
          ),
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
      ),
    );

    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('tr'));

    // Oluştur butonunu görünür kıl.
    final createButton = find.text(l10n.classesCreateButton);
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();

    // Kilit ikonu görünür (oluştur butonunda trailing lock).
    expect(find.byIcon(Icons.lock), findsWidgets);

    // "Yeni Sınıf Oluştur" butonuna tıkla → paywall'a yönlendirilir.
    await tester.tap(createButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(pushedRoutes, isNotEmpty);
    expect(pushedRoutes.single, contains('feature=class_limit'));
    expect(find.text('PAYWALL'), findsOneWidget);
    // Oluşturma ekranına gitmedi.
    expect(find.text('CREATE'), findsNothing);
  });
}
