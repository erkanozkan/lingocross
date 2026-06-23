import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/dtos/auth_dtos.dart';

part 'auth_state.freezed.dart';

/// Uygulamanın oturum durumu (router guard ve ekranlar bunu izler).
enum AuthStatus { unknown, authenticated, unauthenticated }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.unknown) AuthStatus status,
    UserDto? user,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
