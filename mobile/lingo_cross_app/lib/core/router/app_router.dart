import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/auth_state.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/classes/presentation/screens/class_detail_screen.dart';
import '../../features/classes/presentation/screens/classes_list_screen.dart';
import '../../features/classes/presentation/screens/create_class_screen.dart';
import '../../features/classes/presentation/screens/join_class_screen.dart';
import '../../features/enrollment/presentation/screens/student_dashboard_screen.dart';
import '../../features/enrollment/presentation/screens/teacher_students_screen.dart';
import '../../features/games/presentation/screens/create_game_screen.dart';
import '../../features/games/presentation/screens/game_launcher_screen.dart';
import '../../features/games/presentation/screens/my_puzzles_screen.dart';
import '../../features/lessons/presentation/screens/lesson_detail_screen.dart';
import '../../features/lessons/presentation/screens/lessons_list_screen.dart';
import '../../features/lessons/presentation/screens/lesson_form_screen.dart';
import '../../features/lessons/presentation/screens/ocr_capture_screen.dart';
import '../../features/lessons/presentation/screens/ocr_review_screen.dart';
import '../../features/lessons/presentation/screens/student_lesson_screen.dart';
import '../../features/lessons/presentation/screens/teacher_shell_screen.dart';
import '../../features/account/presentation/screens/account_settings_screen.dart';
import '../../features/account/presentation/screens/help_center_screen.dart';
import '../../features/account/presentation/screens/language_preference_screen.dart';
import '../../features/account/presentation/screens/notification_settings_screen.dart';
import '../../features/account/presentation/screens/privacy_policy_screen.dart';
import '../../features/lessons/presentation/screens/word_list_screen.dart';
import '../../features/profile/presentation/screens/student_profile_screen.dart';
import '../../features/results/data/dtos/result_dtos.dart';
import '../../features/results/presentation/screens/game_result_report_screen.dart';
import '../../features/results/presentation/screens/student_results_history_screen.dart';
import '../../features/tracking/presentation/screens/student_report_screen.dart';

/// Uygulama route adları.
abstract final class AppRoutes {
  AppRoutes._();

  // Birleşik karşılama + giriş ekranı (tek auth giriş noktası).
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  /// Hesap Ayarları (F4.2) — profilden push'lanır. `/account/...` prefix'i
  /// teacher/student'a uymadığı için her iki rol erişir (guard'da authed yeter).
  static const String accountSettings = '/account/settings';

  /// Hesap Ayarları'ndan push'lanan alt ekranlar (F7.3 — her iki rol).
  static const String accountNotifications = '/account/notifications';
  static const String accountLanguage = '/account/language';
  static const String accountHelp = '/account/help';
  static const String accountPrivacy = '/account/privacy';

  // Öğrenci (M3) — korumalı + yalnız Student.
  static const String student = '/student';
  static const String studentJoin = '/student/join';

  /// Öğrenci Profil ekranı (F3.1 — "Profil" alt-nav sekmesi). `/student` altında
  /// olduğu için yalnız öğrenci erişebilir (router guard).
  static const String profile = '/student/profile';

  /// Öğrenci geçmiş sonuçları (M5 — "Raporlar" sekmesi).
  static const String studentResults = '/student/results';

  static String studentLesson(String id) => '/student/lessons/$id';

  /// Atanan bir bulmacanın oturumunu başlatır (gameId üzerinden — F2.2).
  static String studentGame(String gameId) => '/student/games/$gameId';

  /// Oyun sonu raporu (resultId — M5; oyun-sonu seed veya geçmişten yükleme).
  static String studentResultDetail(String resultId) =>
      '/student/results/$resultId';

  // Öğretmen (M2) — korumalı + yalnız Teacher.
  static const String teacher = '/teacher';
  static const String teacherStudents = '/teacher/students';
  static const String lessonNew = '/teacher/lessons/new';

  /// Derslerim (F4.3 — "Sınıflar" sekmesi artık Sınıflarım olduğu için
  /// Derslerim'e Ana Sayfa/Profil'den erişilir).
  static const String lessons = '/teacher/lessons';

  /// Adlandırılmış sınıflar (F4.3 — "Sınıflar" sekmesi gövdesi + alt ekranlar).
  static const String classes = '/teacher/classes';
  static const String classNew = '/teacher/classes/new';

  static String classDetail(String id) => '/teacher/classes/$id';

  /// Yeni Bulmaca Oluştur (F2.2). Opsiyonel `?lessonId=` ile ön-seçili ders.
  static const String gameNew = '/teacher/games/new';

  /// Bulmacalarım (F3.2 — öğretmenin tüm bulmacaları).
  static const String teacherPuzzles = '/teacher/puzzles';

  static String gameNewForLesson(String lessonId) =>
      '/teacher/games/new?lessonId=$lessonId';

  /// Öğretmen takip: bir öğrencinin paylaştığı sonuçlar (F2.3). Görünen ad
  /// `extra` (String) ile taşınır; doğrudan derin-bağlantıda boş başlık olur.
  static String teacherStudentResults(String studentId) =>
      '/teacher/students/$studentId/results';

  static String lessonDetail(String id) => '/teacher/lessons/$id';
  static String lessonWords(String id) => '/teacher/lessons/$id/words';
  static String lessonEdit(String id) => '/teacher/lessons/$id/edit';

  // OCR akışı (M2 #18): yakalama (Ekran A) + gözden geçirme (Ekran B).
  static String lessonOcrCapture(String id) => '/teacher/lessons/$id/ocr';
  static String lessonOcrReview(String id) => '/teacher/lessons/$id/ocr/review';
}

/// AuthState değişimlerini go_router'a [Listenable] olarak köprüler.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this.ref) {
    _sub = ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
  }

  final Ref ref;
  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _AuthListenable(ref);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final loc = state.matchedLocation;

      // Açılış kontrolü tamamlanmadan yönlendirme yapma.
      if (auth.status == AuthStatus.unknown) return null;

      final isAuthed = auth.isAuthenticated;
      final isTeacher = auth.user?.role == UserRole.teacher;
      final homeForRole = isTeacher ? AppRoutes.teacher : AppRoutes.student;
      final onAuthRoute = loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;
      final onTeacherRoute = loc.startsWith(AppRoutes.teacher);
      final onStudentRoute = loc.startsWith(AppRoutes.student);

      // Token yoksa korumalı route → birleşik giriş ekranı.
      if (!isAuthed && !onAuthRoute) return AppRoutes.login;

      // Girişliyken auth ekranlarında ise → role-bazlı ana ekran.
      if (isAuthed && onAuthRoute) return homeForRole;

      // Öğretmen rotaları yalnız Teacher; öğrenci rotaları yalnız Student.
      if (onTeacherRoute && !isTeacher) return AppRoutes.student;
      if (onStudentRoute && isTeacher) return AppRoutes.teacher;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          // Rol query param ile geçilebilir (öğrenci/öğretmen); param yoksa
          // Register varsayılan öğrenciyi ön-seçer.
          final role = state.uri.queryParameters['role'];
          return RegisterScreen(initialRole: UserRole.fromName(role));
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Hesap Ayarları (F4.2) — her iki rol için ortak (authed yeterli).
      GoRoute(
        path: AppRoutes.accountSettings,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      // Hesap Ayarları alt ekranları (F7.3) — her iki rol için ortak.
      GoRoute(
        path: AppRoutes.accountNotifications,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountLanguage,
        builder: (context, state) => const LanguagePreferenceScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountHelp,
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountPrivacy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      // --- Öğrenci (M3) ---
      GoRoute(
        path: AppRoutes.student,
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      // Öğrenci Profil (F3.1 — "Profil" alt-nav sekmesi).
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const StudentProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.studentJoin,
        builder: (context, state) => const JoinClassScreen(),
      ),
      GoRoute(
        path: '/student/lessons/:id',
        builder: (context, state) =>
            StudentLessonScreen(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/student/games/:gameId',
        builder: (context, state) =>
            GameLauncherScreen(gameId: state.pathParameters['gameId']!),
      ),
      // Geçmiş sonuçlar listesi (M5 — "Raporlar" sekmesi).
      GoRoute(
        path: AppRoutes.studentResults,
        builder: (context, state) => const StudentResultsHistoryScreen(),
      ),
      // Oyun sonu raporu (resultId). Oyun-sonu yolunda sonuç `extra` ile
      // seed edilir; geçmişten gelince de `extra` ile taşınır, yoksa
      // resultId ile GET /results/me'den yüklenir.
      GoRoute(
        path: '/student/results/:resultId',
        builder: (context, state) => GameResultReportScreen(
          resultId: state.pathParameters['resultId']!,
          seedResult: state.extra as GameResultDto?,
        ),
      ),
      // --- Öğretmen (F2.1: 4 sekmeli kabuk) ---
      GoRoute(
        path: AppRoutes.teacher,
        builder: (context, state) => const TeacherShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.teacherStudents,
        builder: (context, state) => const TeacherStudentsScreen(),
      ),
      // Adlandırılmış sınıflar (F4.3). Liste shell sekmesi gövdesi; ayrıca
      // doğrudan derin-bağlantı için route.
      GoRoute(
        path: AppRoutes.classes,
        builder: (context, state) => const ClassesListScreen(),
      ),
      GoRoute(
        path: AppRoutes.classNew,
        builder: (context, state) => const CreateClassScreen(),
      ),
      GoRoute(
        path: '/teacher/classes/:id',
        builder: (context, state) =>
            ClassDetailScreen(classId: state.pathParameters['id']!),
      ),
      // Öğretmen takip: bir öğrencinin paylaştığı sonuçlar (F2.3). Görünen ad
      // liste ekranından `extra` (String) ile taşınır.
      GoRoute(
        path: '/teacher/students/:id/results',
        builder: (context, state) => StudentReportScreen(
          studentId: state.pathParameters['id']!,
          studentName: state.extra is String ? state.extra as String : '',
        ),
      ),
      // Derslerim (F4.3) — Ana Sayfa/Profil'den erişilir (Sınıflar sekmesi
      // artık Sınıflarım). `/teacher/lessons/new` ve `/:id` ayrı route'lar.
      GoRoute(
        path: AppRoutes.lessons,
        builder: (context, state) => const LessonsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.lessonNew,
        builder: (context, state) => const LessonFormScreen(),
      ),
      // Yeni Bulmaca Oluştur (F2.2). Opsiyonel `?lessonId=` ön-seçili ders.
      GoRoute(
        path: AppRoutes.gameNew,
        builder: (context, state) => CreateGameScreen(
          initialLessonId: state.uri.queryParameters['lessonId'],
        ),
      ),
      // Bulmacalarım (F3.2) — öğretmenin tüm bulmacaları.
      GoRoute(
        path: AppRoutes.teacherPuzzles,
        builder: (context, state) => const MyPuzzlesScreen(),
      ),
      // Ders Detayı (F2.1) — Derslerim listesinden açılır.
      GoRoute(
        path: '/teacher/lessons/:id',
        builder: (context, state) =>
            LessonDetailScreen(lessonId: state.pathParameters['id']!),
      ),
      // Ünite Kelime Listesi (detay/form "Tümünü Gör" → kelime ekranı).
      GoRoute(
        path: '/teacher/lessons/:id/words',
        builder: (context, state) =>
            WordListScreen(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/lessons/:id/edit',
        builder: (context, state) =>
            LessonFormScreen(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/lessons/:id/ocr',
        builder: (context, state) =>
            OcrCaptureScreen(lessonId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/teacher/lessons/:id/ocr/review',
        builder: (context, state) => OcrReviewScreen(
          lessonId: state.pathParameters['id']!,
          // Yakalama ekranı taramayı yaptıktan sonra adayları extra ile taşır.
          // Doğrudan derin-bağlantı (extra yok) durumunda boş hata ekranı.
          args: state.extra as OcrReviewArgs? ??
              const OcrReviewArgs(
                candidates: [],
                sourceLangLabel: '',
                failed: true,
              ),
        ),
      ),
    ],
  );
});
