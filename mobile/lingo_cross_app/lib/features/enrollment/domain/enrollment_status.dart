/// Öğretmen-öğrenci eşleşmesinin durumu. Sayısal değerler API ile birebir
/// eşleşir ve DEĞİŞTİRİLMEZ (bkz. LingoCross.Domain.Enums.EnrollmentStatus):
/// Pending = 1, Active = 2, Rejected = 3.
///
/// Ürün kararı (kullanıcı onaylı): katılım **doğrudan Active**; pending/onay
/// akışı UI'da gösterilmez. Enum yine de ileriye dönük dikiş olarak korunur.
enum EnrollmentStatus {
  pending(1),
  active(2),
  rejected(3);

  const EnrollmentStatus(this.value);

  final int value;

  static EnrollmentStatus fromValue(int value) {
    return switch (value) {
      1 => EnrollmentStatus.pending,
      2 => EnrollmentStatus.active,
      3 => EnrollmentStatus.rejected,
      _ => EnrollmentStatus.active,
    };
  }

  bool get isActive => this == EnrollmentStatus.active;
}
