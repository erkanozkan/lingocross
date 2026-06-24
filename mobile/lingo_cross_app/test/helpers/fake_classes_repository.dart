import 'package:lingo_cross_app/features/classes/data/classes_repository.dart';
import 'package:lingo_cross_app/features/classes/data/dtos/class_dtos.dart';
import 'package:lingo_cross_app/features/classes/domain/classes_failure.dart';

/// Testlerde gerçek Dio yerine kullanılan sahte classes repository.
class FakeClassesRepository implements ClassesRepository {
  FakeClassesRepository({
    this.classes = const [],
    this.classesError,
    this.detailValue,
    this.detailError,
    this.inviteCode = 'A1B2C3D4',
    this.inviteCodeError,
    this.createValue,
    this.createError,
    this.memberships = const [],
    this.joinResult,
    this.joinError,
  });

  final List<ClassDto> classes;
  final ClassesFailure? classesError;
  final ClassDetailDto? detailValue;
  final ClassesFailure? detailError;
  final String inviteCode;
  final ClassesFailure? inviteCodeError;
  final ClassDto? createValue;
  final ClassesFailure? createError;
  final List<ClassMembershipDto> memberships;
  final ClassMembershipDto? joinResult;
  final ClassesFailure? joinError;

  int createCount = 0;
  String? lastCreatedName;
  int regenerateCount = 0;
  int removeStudentCount = 0;
  String? lastRemovedStudentId;
  int joinCount = 0;
  String? lastJoinCode;

  @override
  Future<List<ClassDto>> listMine() async {
    if (classesError != null) throw classesError!;
    return classes;
  }

  @override
  Future<ClassDto> create(String name) async {
    createCount++;
    lastCreatedName = name;
    if (createError != null) throw createError!;
    return createValue ??
        ClassDto(
          id: 'c-new',
          name: name,
          inviteCode: 'NEWCODE1',
          studentCount: 0,
          createdAt: DateTime(2026, 6, 24),
        );
  }

  @override
  Future<ClassDetailDto> detail(String classId) async {
    if (detailError != null) throw detailError!;
    return detailValue ??
        ClassDetailDto(
          id: classId,
          name: 'Sınıf',
          inviteCode: inviteCode,
          studentCount: 0,
          students: const [],
        );
  }

  @override
  Future<ClassDto> rename(String classId, String name) async =>
      throw UnimplementedError();

  @override
  Future<void> archive(String classId) async {}

  @override
  Future<ClassInviteCodeDto> getInviteCode(String classId) async {
    if (inviteCodeError != null) throw inviteCodeError!;
    return ClassInviteCodeDto(code: inviteCode);
  }

  @override
  Future<ClassInviteCodeDto> regenerateInviteCode(String classId) async {
    regenerateCount++;
    return const ClassInviteCodeDto(code: 'REGEN123');
  }

  @override
  Future<void> removeStudent(String classId, String studentId) async {
    removeStudentCount++;
    lastRemovedStudentId = studentId;
  }

  @override
  Future<List<ClassMembershipDto>> listMemberships() async => memberships;

  @override
  Future<ClassMembershipDto> joinByCode(String code) async {
    joinCount++;
    lastJoinCode = code;
    if (joinError != null) throw joinError!;
    if (joinResult != null) return joinResult!;
    throw const ClassesFailure.invalidCode();
  }
}
