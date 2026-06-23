import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/user_role.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/auth_state.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/profile_placeholder_screen.dart';
import '../../features/lessons/presentation/screens/lesson_form_screen.dart';
import '../../features/lessons/presentation/screens/ocr_capture_screen.dart';
import '../../features/lessons/presentation/screens/ocr_review_screen.dart';
import '../../features/lessons/presentation/screens/teacher_dashboard_screen.dart';
import '../../features/lessons/presentation/screens/word_list_screen.dart';

/// Uygulama route adları.
abstract final class AppRoutes {
  AppRoutes._();

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';

  // Öğretmen (M2) — korumalı + yalnız Teacher.
  static const String teacher = '/teacher';
  static const String lessonNew = '/teacher/lessons/new';

  static String lessonDetail(String id) => '/teacher/lessons/$id';
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
    initialLocation: AppRoutes.welcome,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final loc = state.matchedLocation;

      // Açılış kontrolü tamamlanmadan yönlendirme yapma.
      if (auth.status == AuthStatus.unknown) return null;

      final isAuthed = auth.isAuthenticated;
      final isTeacher = auth.user?.role == UserRole.teacher;
      final onAuthRoute = loc == AppRoutes.welcome ||
          loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;
      final onTeacherRoute = loc.startsWith(AppRoutes.teacher);

      // Token yoksa korumalı route → welcome.
      if (!isAuthed && !onAuthRoute) return AppRoutes.welcome;

      // Girişliyken auth ekranlarında ise → role-bazlı ana ekran.
      if (isAuthed && onAuthRoute) {
        return isTeacher ? AppRoutes.teacher : AppRoutes.home;
      }

      // Öğretmen rotaları yalnız Teacher içindir; öğrenci/diğerleri → home.
      if (onTeacherRoute && !isTeacher) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          // Welcome rol kartları rolü query param ile geçer (öğrenci/öğretmen);
          // param yoksa Register varsayılan öğrenciyi ön-seçer.
          final role = state.uri.queryParameters['role'];
          return RegisterScreen(initialRole: UserRole.fromName(role));
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePlaceholderScreen(),
      ),
      // --- Öğretmen (M2) ---
      GoRoute(
        path: AppRoutes.teacher,
        builder: (context, state) => const TeacherDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.lessonNew,
        builder: (context, state) => const LessonFormScreen(),
      ),
      GoRoute(
        path: '/teacher/lessons/:id',
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
