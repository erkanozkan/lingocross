import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_failure.freezed.dart';

/// Öğrenci profil verisi çekilirken oluşabilecek hata türleri.
@freezed
class ProfileFailure with _$ProfileFailure implements Exception {
  const factory ProfileFailure.network() = _Network;
  const factory ProfileFailure.forbidden() = _Forbidden;
  const factory ProfileFailure.unexpected() = _Unexpected;
}
