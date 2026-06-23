import 'package:lingo_cross_app/features/enrollment/data/dtos/enrollment_dtos.dart';
import 'package:lingo_cross_app/features/enrollment/data/enrollment_repository.dart';
import 'package:lingo_cross_app/features/enrollment/domain/enrollment_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte enrollment repository.
class FakeEnrollmentRepository implements EnrollmentRepository {
  FakeEnrollmentRepository({
    this.enrollments = const [],
    this.inviteCode = 'K7P2QX',
    this.joinResult,
    this.joinError,
  });

  final List<EnrollmentDto> enrollments;
  final String inviteCode;
  final EnrollmentDto? joinResult;
  final EnrollmentFailure? joinError;

  @override
  Future<EnrollmentDto> joinByCode(String code) async {
    if (joinError != null) throw joinError!;
    if (joinResult != null) return joinResult!;
    throw const EnrollmentFailure.invalidCode();
  }

  @override
  Future<List<EnrollmentDto>> listMine() async => enrollments;

  @override
  Future<InviteCodeDto> getInviteCode() async => InviteCodeDto(code: inviteCode);

  @override
  Future<InviteCodeDto> regenerateInviteCode() async =>
      const InviteCodeDto(code: 'NEW123');
}
