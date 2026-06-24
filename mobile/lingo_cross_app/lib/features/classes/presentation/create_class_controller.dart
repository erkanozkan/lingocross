import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/classes_repository.dart';
import '../data/dtos/class_dtos.dart';

part 'create_class_controller.g.dart';

/// "Yeni Sınıf Oluştur" akışının tek seferlik gönderim durumu
/// (`POST /api/classes`).
@riverpod
class CreateClassController extends _$CreateClassController {
  @override
  AsyncValue<ClassDto?> build() => const AsyncValue.data(null);

  /// Sınıfı oluşturur. Başarıda oluşan sınıfı döner; aksi halde [state]
  /// `AsyncError` ([ClassesFailure]) olur ve `null` döner.
  Future<ClassDto?> create(String name) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => ref.read(classesRepositoryProvider).create(name.trim()),
    );
    state = result;
    return result.valueOrNull;
  }
}
