/// Kullanıcı rolü. Sayısal değerler API ile birebir eşleşir ve DEĞİŞTİRİLMEZ:
/// Teacher = 1, Student = 2 (bkz. LingoCross.Domain.Enums.UserRole).
enum UserRole {
  teacher(1),
  student(2);

  const UserRole(this.value);

  final int value;

  static UserRole fromValue(int value) {
    return switch (value) {
      1 => UserRole.teacher,
      2 => UserRole.student,
      _ => UserRole.student,
    };
  }

  bool get isTeacher => this == UserRole.teacher;
  bool get isStudent => this == UserRole.student;
}
