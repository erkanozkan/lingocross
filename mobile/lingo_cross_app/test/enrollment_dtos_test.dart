import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_cross_app/features/enrollment/data/dtos/enrollment_dtos.dart';
import 'package:lingo_cross_app/features/enrollment/domain/enrollment_status.dart';

void main() {
  group('EnrollmentStatus eşlemesi (API int 1/2/3)', () {
    test('pending=1, active=2, rejected=3', () {
      expect(EnrollmentStatus.pending.value, 1);
      expect(EnrollmentStatus.active.value, 2);
      expect(EnrollmentStatus.rejected.value, 3);
      expect(EnrollmentStatus.fromValue(2), EnrollmentStatus.active);
      expect(EnrollmentStatus.active.isActive, true);
    });
  });

  group('JoinByCodeRequest JSON (API sözleşmesi)', () {
    test('code alanı serileşir', () {
      const req = JoinByCodeRequest(code: 'K7P2QX');
      expect(req.toJson(), {'code': 'K7P2QX'});
    });
  });

  group('EnrollmentDto JSON çözme (API yanıtı)', () {
    test('status int → enum, counterpart alanları parse edilir', () {
      final dto = EnrollmentDto.fromJson({
        'id': 'e1',
        'teacherId': 't1',
        'studentId': 's1',
        'status': 2, // Active
        'counterpartUserId': 't1',
        'counterpartDisplayName': 'Ayşe Öğretmen',
        'counterpartEmail': 'ayse@ornek.com',
        'createdAt': '2026-06-23T10:00:00Z',
        'updatedAt': '2026-06-23T10:00:00Z',
      });

      expect(dto.status, EnrollmentStatus.active);
      expect(dto.counterpartDisplayName, 'Ayşe Öğretmen');
      expect(dto.teacherId, 't1');
    });
  });

  group('InviteCodeDto JSON çözme', () {
    test('code alanı parse edilir', () {
      final dto = InviteCodeDto.fromJson({'code': 'ABC123'});
      expect(dto.code, 'ABC123');
    });
  });
}
