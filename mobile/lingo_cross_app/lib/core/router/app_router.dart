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

/// Uygulama route adları.
abstract final class AppRoutes {
  AppRoutes._();

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
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
      final onAuthRoute = loc == AppRoutes.welcome ||
          loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.forgotPassword;

      // Token yoksa korumalı route → welcome.
      if (!isAuthed && !onAuthRoute) return AppRoutes.welcome;

      // Girişliyken auth ekranlarında ise → home.
      if (isAuthed && onAuthRoute) return AppRoutes.home;

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
    ],
  );
});
