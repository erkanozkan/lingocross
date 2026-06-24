import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_cross_app/core/l10n/gen/app_localizations.dart';
import 'package:lingo_cross_app/core/theme/app_theme.dart';
import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/classes/domain/classes_failure.dart';
import 'package:lingo_cross_app/features/classes/presentation/screens/class_detail_screen.dart';
import 'package:lingo_cross_app/features/classes/presentation/screens/classes_list_screen.dart';
import 'package:lingo_cross_app/features/classes/presentation/screens/join_class_screen.dart';

import 'helpers/fake_classes_repository.dart';

/// Ekranlar auth kullanıcı yoksa (varsayılan AuthNotifier) ad/avatarı zarifçe
/// boş gösterir; testler bu alanları doğrulamadığından auth override gerekmez.
Widget _wrap(Widget child, FakeClassesRepository repo) {
  final router = GoRouter(
    initialLocation: '/x',
    routes: [
      GoRoute(path: '/x', builder: (_, __) => child),
      GoRoute(
          path: '/student',
          builder: (_, __) => const Scaffold(body: Text('panel'))),
    ],
  );
  return ProviderScope(
    overrides: [
      classesRepositoryProvider.overrideWithValue(repo),
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

ClassDto _class({
  String id = 'c1',
  String name = '6-A Sınıfı',
  String? code = 'TRK90212',
  int students = 24,
}) {
  return ClassDto(
    id: id,
    name: name,
    inviteCode: code,
    studentCount: students,
    createdAt: DateTime(2026, 6, 23),
  );
}

void main() {
  testWidgets('Sınıflarım: hero + Toplam Öğrenci toplamı + sınıf kartı',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const ClassesListScreen(),
      FakeClassesRepository(classes: [
        _class(id: 'c1', name: '6-A Sınıfı', students: 24),
        _class(id: 'c2', name: '7-B Sınıfı', students: 18, code: 'LUM31499'),
      ]),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Sınıflarım'), findsWidgets);
    expect(find.text('6-A Sınıfı'), findsOneWidget);
    expect(find.text('7-B Sınıfı'), findsOneWidget);
    // Toplam Öğrenci = 24 + 18 = 42 (gerçek toplam).
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Yeni Sınıf Oluştur'), findsOneWidget);
    // Davet kodu chip.
    expect(find.text('TRK90212'), findsOneWidget);
  });

  testWidgets('Sınıflarım: boş durum CTA mesajı',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const ClassesListScreen(),
      FakeClassesRepository(classes: const []),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Henüz sınıfın yok'), findsOneWidget);
    expect(find.text('Yeni Sınıf Oluştur'), findsOneWidget);
  });

  testWidgets('Sınıf Detayı: davet kodu kartı + öğrenci satırları',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const ClassDetailScreen(classId: 'c1'),
      FakeClassesRepository(
        inviteCode: 'A1B2C3D4',
        detailValue: const ClassDetailDto(
          id: 'c1',
          name: '6-A Sınıfı',
          inviteCode: 'A1B2C3D4',
          studentCount: 2,
          students: [
            ClassMemberDto(
                studentId: 's1', displayName: 'Ahmet Erdemir', email: 'a@x.com'),
            ClassMemberDto(
                studentId: 's2', displayName: 'Buse Demir', email: 'b@x.com'),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('SINIF DAVET KODU'), findsOneWidget);
    expect(find.text('A1B2C3D4'), findsOneWidget);
    expect(find.text('Öğrenciler (2)'), findsOneWidget);
    expect(find.text('Ahmet Erdemir'), findsOneWidget);
    expect(find.text('Buse Demir'), findsOneWidget);
    expect(find.text('Bu Sınıfa Ödev Ata'), findsOneWidget);
  });

  testWidgets('Sınıf Detayı: öğrenci çöp ikonu → onay → removeStudent',
      (tester) async {
    final repo = FakeClassesRepository(
      detailValue: const ClassDetailDto(
        id: 'c1',
        name: '6-A',
        inviteCode: 'A1B2C3D4',
        studentCount: 1,
        students: [
          ClassMemberDto(
              studentId: 's1', displayName: 'Ahmet Erdemir', email: 'a@x.com'),
        ],
      ),
    );
    await tester.pumpWidget(_wrap(const ClassDetailScreen(classId: 'c1'), repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    // Onay diyalogu.
    await tester.tap(find.text('Çıkar'));
    await tester.pumpAndSettle();

    expect(repo.removeStudentCount, 1);
    expect(repo.lastRemovedStudentId, 's1');
  });

  testWidgets('Sınıfa Katıl: başlık + 8 hane sonrası Katıl çalışır',
      (tester) async {
    final repo = FakeClassesRepository(
      joinResult: const ClassMembershipDto(
        classId: 'c1',
        className: '6-A Sınıfı',
        teacherName: 'Öğretmenim',
      ),
    );
    await tester.pumpWidget(_wrap(const JoinClassScreen(), repo));
    await tester.pumpAndSettle();

    expect(find.text('Sınıfa Katıl'), findsWidgets);
    expect(find.text('Yeni Bir Sınıf'), findsOneWidget);
    expect(find.text('Kod Nerede?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'abc123xy');
    await tester.pumpAndSettle();
    final join = find.text('Katıl');
    await tester.ensureVisible(join);
    await tester.pumpAndSettle();
    await tester.tap(join);
    await tester.pumpAndSettle();

    expect(repo.joinCount, 1);
    // Otomatik büyük harf.
    expect(repo.lastJoinCode, 'ABC123XY');
  });

  testWidgets('Sınıfa Katıl: geçersiz kod (404) → hata mesajı',
      (tester) async {
    final repo = FakeClassesRepository(
      joinError: const ClassesFailure.notFound(),
    );
    await tester.pumpWidget(_wrap(const JoinClassScreen(), repo));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'WRONG123');
    await tester.pumpAndSettle();
    final join = find.text('Katıl');
    await tester.ensureVisible(join);
    await tester.pumpAndSettle();
    await tester.tap(join);
    await tester.pumpAndSettle();

    expect(find.text('Bu kod geçerli değil. Kontrol edip tekrar dene.'),
        findsOneWidget);
  });
}
