import 'package:lingo_cross_app/features/auth/data/auth_repository.dart';
import 'package:lingo_cross_app/features/auth/data/dtos/auth_dtos.dart';
import 'package:lingo_cross_app/features/auth/domain/user_role.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte auth repository.
///
/// `me()` yapılandırılabilir bir kullanıcı döndürür (açılış geri-yükleme akışı
/// için); `logout()` çağrı sayısını kaydeder.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({UserDto? user}) : user = user ?? sampleUser();

  final UserDto user;

  int logoutCount = 0;

  @override
  Future<UserDto> me() async => user;

  @override
  Future<void> logout({required String refreshToken}) async {
    logoutCount++;
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> forgotPassword({required String email}) =>
      throw UnimplementedError();

  @override
  Future<UserDto> updateProfile({
    required String displayName,
    String? preferredLocale,
  }) =>
      throw UnimplementedError();

  @override
  Future<AuthResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      throw UnimplementedError();
}

UserDto sampleUser({
  String id = 'u1',
  String email = 'ada@ornek.com',
  String displayName = 'Ada Lovelace',
  UserRole role = UserRole.student,
}) {
  return UserDto(
    id: id,
    email: email,
    displayName: displayName,
    role: role,
    preferredLocale: 'tr',
  );
}
