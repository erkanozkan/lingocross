import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';
import '../domain/classes_failure.dart';

part 'join_class_controller.g.dart';

/// "Sınıfa Katıl" (öğrenci) akışının tek seferlik gönderim durumu
/// (`POST /api/classes/join`).
///
/// Geçersiz/arşivli kod backend'de 404 döner; repository bunu
/// [ClassesFailure.notFound]'a indirger. Katılma bağlamında bu, kullanıcı
/// açısından "geçersiz kod"tur; ekran her ikisini de geçersiz kod olarak gösterir.
@riverpod
class JoinClassController extends _$JoinClassController {
  @override
  AsyncValue<ClassMembershipDto?> build() => const AsyncValue.data(null);

  /// Davet kodunu gönderir. Başarıda üyeliği döndürür; aksi halde [state]
  /// `AsyncError` ([ClassesFailure]) olur ve `null` döner.
  Future<ClassMembershipDto?> submit(String code) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).joinByCode(code.trim()),
    );
    state = result;
    return result.valueOrNull;
  }
}
