import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/dtos/enrollment_dtos.dart';
import '../data/enrollment_repository.dart';
import '../domain/enrollment_failure.dart';

part 'join_teacher_controller.g.dart';

/// "Öğretmene Katıl" akışının tek seferlik gönderim durumu.
///
/// Katılım **doğrudan Active** (onay/pending UI yok). API idempotent: zaten
/// kayıtlı (409) → repository başarı (mevcut kayıt) döndürür; burada da başarı
/// gibi ele alınır.
@riverpod
class JoinTeacherController extends _$JoinTeacherController {
  @override
  AsyncValue<EnrollmentDto?> build() => const AsyncValue.data(null);

  /// Davet kodunu gönderir. Başarıda eşleşmeyi döndürür; aksi halde [state]
  /// `AsyncError` ([EnrollmentFailure]) olur ve `null` döner.
  Future<EnrollmentDto?> submit(String code) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(enrollmentRepositoryProvider).joinByCode(code.trim()),
    );
    state = result;
    return result.valueOrNull;
  }
}
