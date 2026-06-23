// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'LingoCross';

  @override
  String get authFooterCopyright => '© 2026 LingoCross';

  @override
  String get authFooterPrivacy => 'Gizlilik Politikası';

  @override
  String get authFooterTerms => 'Kullanım Koşulları';

  @override
  String get authWelcomeTitle => 'LingoCross\'a Hoş Geldiniz';

  @override
  String get authWelcomeSubtitle => 'Dil yolculuğuna bugün başla, sınırları ortadan kaldır.';

  @override
  String get authWelcomeBadgeHi => 'Hi!';

  @override
  String get authWelcomeBadgeMerhaba => 'Merhaba!';

  @override
  String get authLoginEmailLabel => 'E-posta Adresi';

  @override
  String get authLoginEmailPlaceholder => 'isim@ornek.com';

  @override
  String get authLoginPasswordLabel => 'Şifre';

  @override
  String get authLoginPasswordPlaceholder => '••••••••';

  @override
  String get authLoginForgotPassword => 'Şifremi Unuttum?';

  @override
  String get authLoginSubmit => 'Giriş Yap';

  @override
  String get authLoginNoAccount => 'Hesabın yok mu?';

  @override
  String get authLoginSignupCta => 'Ücretsiz kayıt ol';

  @override
  String get authLoginErrorInvalidCredentials => 'E-posta veya şifre hatalı.';

  @override
  String get authLoginErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get authRegisterAppbarLogin => 'Giriş Yap';

  @override
  String get authRegisterTitle => 'Yolculuğuna Başla';

  @override
  String get authRegisterSubtitle => 'Binlerce dil öğrenicisine hemen katıl.';

  @override
  String get authRegisterRoleStudent => 'Öğrenci';

  @override
  String get authRegisterRoleTeacher => 'Öğretmen';

  @override
  String get authRegisterRoleGroupLabel => 'Rol';

  @override
  String get authRegisterFullNameLabel => 'Ad Soyad';

  @override
  String get authRegisterFullNamePlaceholder => 'Alex Rivera';

  @override
  String get authRegisterEmailLabel => 'E-posta Adresi';

  @override
  String get authRegisterEmailPlaceholder => 'alex@ornek.com';

  @override
  String get authRegisterPasswordLabel => 'Şifre Oluştur';

  @override
  String get authRegisterPasswordPlaceholder => '••••••••';

  @override
  String get authRegisterTermsPrefix => 'Kabul ediyorum:';

  @override
  String get authRegisterTermsTerms => 'Kullanım Koşulları';

  @override
  String get authRegisterTermsAnd => 've';

  @override
  String get authRegisterTermsPrivacy => 'Gizlilik Politikası';

  @override
  String get authRegisterSubmit => 'Hesap Oluştur';

  @override
  String get authRegisterHaveAccount => 'Zaten bir hesabın var mı?';

  @override
  String get authRegisterLoginCta => 'Giriş Yap';

  @override
  String get authRegisterErrorEmailTaken => 'Bu e-posta zaten kullanımda.';

  @override
  String get authRegisterErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get authForgotTitle => 'Şifremi Unuttum';

  @override
  String get authForgotDescription => 'Endişelenmeyin! Hesabınızla ilişkili e-posta adresini girin, size bir kurtarma bağlantısı gönderelim.';

  @override
  String get authForgotEmailLabel => 'E-posta Adresi';

  @override
  String get authForgotEmailPlaceholder => 'ad@ornek.com';

  @override
  String get authForgotSubmit => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get authForgotSuccessTitle => 'Bağlantı Gönderildi!';

  @override
  String get authForgotSuccessDescription => 'Sıfırlama bağlantısı için gelen kutunuzu kontrol edin. Göremezseniz spam klasörüne bakın.';

  @override
  String get authForgotSuccessResend => 'Tekrar gönder';

  @override
  String get authForgotSupportPrefix => 'Hâlâ sorun mu yaşıyorsunuz?';

  @override
  String get authForgotSupportContact => 'Destekle İletişime Geçin';

  @override
  String get authForgotErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get authValidationEmailRequired => 'E-posta adresi gerekli.';

  @override
  String get authValidationEmailInvalid => 'Geçerli bir e-posta adresi girin.';

  @override
  String get authValidationPasswordRequired => 'Şifre gerekli.';

  @override
  String get authValidationPasswordTooShort => 'Şifre en az 8 karakter olmalı.';

  @override
  String get authValidationFullNameRequired => 'Ad soyad gerekli.';

  @override
  String get authValidationTermsRequired => 'Devam etmek için koşulları kabul edin.';

  @override
  String get commonErrorGeneric => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get homeTeacherWelcome => 'Hoş geldin, Öğretmen';

  @override
  String get homeStudentWelcome => 'Hoş geldin, Öğrenci';

  @override
  String get homePlaceholderBody => 'Panel yakında burada olacak.';

  @override
  String get homeLogout => 'Çıkış Yap';

  @override
  String get commonRetry => 'Tekrar Dene';

  @override
  String get commonUndo => 'Geri Al';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonComingSoon => 'Yakında';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navReports => 'Raporlar';

  @override
  String get navProfile => 'Profil';

  @override
  String teacherDashboardGreeting(String name) {
    return 'Hoş Geldiniz, $name';
  }

  @override
  String teacherDashboardSubtitle(int count) {
    return 'Öğretmen Paneli • Bugün $count yeni raporunuz var.';
  }

  @override
  String get teacherDashboardSubtitleEmpty => 'Öğretmen Paneli • Yeni rapor yok.';

  @override
  String teacherDashboardStreak(int days) {
    return '$days Gün';
  }

  @override
  String get teacherDashboardActionNewLessonTitle => 'Yeni Ders Oluştur';

  @override
  String get teacherDashboardActionNewLessonDesc => 'Kendi kelime listenizle dakikalar içinde yeni bir ders hazırlayın.';

  @override
  String get teacherDashboardActionProgressTitle => 'Öğrenci Gelişimi';

  @override
  String get teacherDashboardActionProgressDesc => 'Sınıfların performansını ve bireysel öğrenci raporlarını inceleyin.';

  @override
  String get teacherDashboardLessonsTitle => 'Derslerim';

  @override
  String get teacherDashboardSeeAll => 'Tümünü Gör';

  @override
  String get teacherDashboardLessonNoStudents => 'Henüz öğrenci yok';

  @override
  String get teacherDashboardReportsTitle => 'Yeni Öğrenci Raporları';

  @override
  String get teacherDashboardEmptyLessonsTitle => 'Henüz dersiniz yok';

  @override
  String get teacherDashboardEmptyLessonsDesc => 'İlk dersinizi oluşturarak başlayın.';

  @override
  String get teacherDashboardEmptyReports => 'Henüz yeni rapor yok. Öğrenciler oyun oynadıkça burada görünecek.';

  @override
  String get teacherDashboardError => 'Dersler yüklenemedi';

  @override
  String get teacherDashboardLessonCreated => 'Ders oluşturuldu';

  @override
  String teacherDashboardWordCount(int count) {
    return '$count kelime';
  }

  @override
  String get teacherDashboardLessonPublished => 'Yayında';

  @override
  String get teacherDashboardLessonDraft => 'Taslak';

  @override
  String get lessonFormTitleCreate => 'Yeni Ders';

  @override
  String get lessonFormTitleEdit => 'Dersi Düzenle';

  @override
  String get lessonFormFieldTitleLabel => 'Ders Başlığı';

  @override
  String get lessonFormFieldTitlePlaceholder => 'Örn. 9-A İngilizce Ünite 3';

  @override
  String get lessonFormFieldTitleRequired => 'Ders başlığı gerekli';

  @override
  String get lessonFormFieldDescriptionLabel => 'Açıklama (isteğe bağlı)';

  @override
  String get lessonFormFieldDescriptionPlaceholder => 'Bu ders hakkında kısa bir not…';

  @override
  String get lessonFormFieldSourceLangLabel => 'Kaynak Dil';

  @override
  String get lessonFormFieldTargetLangLabel => 'Hedef Dil';

  @override
  String get lessonFormFieldLangSameError => 'Kaynak ve hedef dil aynı olamaz';

  @override
  String get lessonFormStatusLabel => 'Yayın Durumu';

  @override
  String get lessonFormStatusDraft => 'Taslak';

  @override
  String get lessonFormStatusPublished => 'Yayında';

  @override
  String get lessonFormStatusDraftHint => 'Taslak dersi yalnız siz görürsünüz.';

  @override
  String get lessonFormStatusPublishedHint => 'Yayındaki ders öğrencilerinizle paylaşılır.';

  @override
  String get lessonFormSubmitCreate => 'Dersi Oluştur';

  @override
  String get lessonFormSubmitEdit => 'Değişiklikleri Kaydet';

  @override
  String get lessonFormSubmitting => 'Kaydediliyor…';

  @override
  String get lessonFormDelete => 'Dersi Sil';

  @override
  String get lessonFormDeleteConfirm => 'Bu ders ve içindeki tüm kelimeler silinecek. Emin misiniz?';

  @override
  String get lessonFormDiscardTitle => 'Kaydedilmemiş değişiklikler';

  @override
  String get lessonFormDiscardConfirm => 'Çık';

  @override
  String get lessonFormDiscardCancel => 'Düzenlemeye Dön';

  @override
  String get lessonFormError => 'Ders kaydedilemedi, tekrar deneyin.';

  @override
  String get lessonFormCreatedSnack => 'Ders oluşturuldu';

  @override
  String get lessonFormUpdatedSnack => 'Ders güncellendi';

  @override
  String get lessonFormDeletedSnack => 'Ders silindi';

  @override
  String get lessonFormPublishNoWordsTitle => 'Bu derste henüz kelime yok.';

  @override
  String get lessonFormPublishNoWordsConfirm => 'Yine de yayınlansın mı?';

  @override
  String get lessonFormPublishNoWordsPublish => 'Yayınla';

  @override
  String get lessonFormPublishNoWordsAddWords => 'Kelime Ekle';

  @override
  String get langEnglish => 'İngilizce';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String wordsListCount(int count) {
    return '$count kelime';
  }

  @override
  String wordsListLangDir(String source, String target) {
    return '$source → $target';
  }

  @override
  String get wordsListScan => 'Kameradan Tara';

  @override
  String get wordsListAddManual => 'Manuel Ekle';

  @override
  String get wordsListSourceOcr => 'OCR';

  @override
  String get wordsListSourceManual => 'Manuel';

  @override
  String get wordsListSynonymPrefix => 'eş anlamlı:';

  @override
  String get wordsListEmptyTitle => 'Henüz kelime yok';

  @override
  String get wordsListEmptyDesc => 'Kameradan tarayın veya elle ekleyin.';

  @override
  String get wordsListDeleted => 'Kelime silindi';

  @override
  String get wordsListError => 'Kelimeler yüklenemedi';

  @override
  String get wordsListMenuEditLesson => 'Dersi Düzenle';

  @override
  String get wordsListMenuDeleteLesson => 'Dersi Sil';

  @override
  String get wordsListScanComingSoon => 'Kameradan tarama yakında eklenecek.';

  @override
  String get wordsFormTitleAdd => 'Kelime Ekle';

  @override
  String get wordsFormTitleEdit => 'Kelimeyi Düzenle';

  @override
  String wordsFormTermLabel(String sourceLang) {
    return 'Terim ($sourceLang)';
  }

  @override
  String get wordsFormTermPlaceholder => 'Örn. environment';

  @override
  String get wordsFormTermRequired => 'Terim gerekli';

  @override
  String get wordsFormMeaningLabel => 'Türkçe Karşılık(lar)';

  @override
  String get wordsFormMeaningPlaceholder => 'Örn. çevre';

  @override
  String get wordsFormMeaningAddMore => 'Karşılık Ekle';

  @override
  String get wordsFormMeaningRequired => 'En az bir Türkçe karşılık girin';

  @override
  String get wordsFormMeaningPrimaryLabel => 'Birincil karşılık';

  @override
  String wordsFormMeaningRemoveLabel(int index) {
    return 'Karşılık $index, sil';
  }

  @override
  String get wordsFormSynonymsLabel => 'Eş anlamlılar (isteğe bağlı)';

  @override
  String get wordsFormSynonymsHint => 'Aynı anlama gelen başka terimler. Oyunda ipucu olarak kullanılır.';

  @override
  String get wordsFormSynonymsPlaceholder => 'Eş anlamlı yazıp ekleyin';

  @override
  String get wordsFormSave => 'Kaydet';

  @override
  String get wordsFormSaveAndNew => 'Kaydet ve Yeni Ekle';

  @override
  String get wordsFormCancel => 'İptal';

  @override
  String get wordsFormSaving => 'Kaydediliyor…';

  @override
  String get wordsFormError => 'Kelime kaydedilemedi, tekrar deneyin.';

  @override
  String get wordsFormAddedSnack => 'Kelime eklendi';

  @override
  String get wordsFormUpdatedSnack => 'Kelime güncellendi';

  @override
  String get lessonsErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get lessonsErrorNotFound => 'İçerik bulunamadı.';

  @override
  String get lessonsErrorForbidden => 'Bu işlem için yetkiniz yok.';

  @override
  String get lessonsErrorValidation => 'Girilen bilgileri kontrol edin.';

  @override
  String get ocrCaptureTitle => 'Kelime Listesi Yükle';

  @override
  String get ocrCaptureHowTitle => 'Nasıl Çalışır?';

  @override
  String get ocrCaptureHowDesc => 'El yazısı listenizin fotoğrafını çekin. Metin tanıma kâğıdı tarar ve kelimeleri otomatik olarak listenize aktarır.';

  @override
  String get ocrCaptureStep1 => 'Fotoğraf Çek';

  @override
  String get ocrCaptureStep2 => 'Tara';

  @override
  String get ocrCaptureStep3 => 'Onayla';

  @override
  String get ocrCaptureTriggerTitle => 'Kamera ile Tara';

  @override
  String get ocrCaptureTriggerSubtitle => 'Veya galeriden bir fotoğraf seçin';

  @override
  String get ocrCaptureSourceCamera => 'Kamera';

  @override
  String get ocrCaptureSourceGallery => 'Galeriden Seç';

  @override
  String get ocrCapturePhotoRemoveLabel => 'Fotoğrafı kaldır';

  @override
  String get ocrCaptureExtract => 'Kelimeleri Çıkart';

  @override
  String get ocrCaptureScanning => 'Taranıyor…';

  @override
  String get ocrCaptureOr => 'VEYA';

  @override
  String get ocrCaptureManual => 'Manuel Giriş';

  @override
  String get ocrCaptureNoCamera => 'Bu cihazda kamera yok — galeriden seçin.';

  @override
  String get ocrCapturePermissionTitle => 'Kamera/galeri erişimi gerekli';

  @override
  String get ocrCapturePermissionDesc => 'Devam etmek için ayarlardan kamera veya galeri erişimine izin verin.';

  @override
  String get ocrCaptureOpenSettings => 'Ayarları Aç';

  @override
  String get ocrCaptureError => 'Fotoğraf alınamadı, tekrar deneyin.';

  @override
  String get ocrReviewTitle => 'Tanınan Kelimeler';

  @override
  String ocrReviewSummary(int count) {
    return '$count kelime tanındı';
  }

  @override
  String ocrReviewSelected(int count) {
    return '$count seçili';
  }

  @override
  String get ocrReviewConfidenceNote => 'Metin tanıma hatalı olabilir; kaydetmeden önce kontrol edin.';

  @override
  String ocrReviewTermLabel(String sourceLang) {
    return 'Terim ($sourceLang)';
  }

  @override
  String get ocrReviewTermPlaceholder => 'Örn. environment';

  @override
  String get ocrReviewIncludeLabel => 'Kaydedilecek';

  @override
  String get ocrReviewExcludeLabel => 'Hariç tutuldu';

  @override
  String ocrReviewRowRemoveLabel(int index) {
    return 'Aday $index, sil';
  }

  @override
  String get ocrReviewAddRow => 'Satır Ekle';

  @override
  String get ocrReviewClearAll => 'Tümünü Temizle';

  @override
  String ocrReviewSave(int count) {
    return 'Seçilenleri Kaydet ($count)';
  }

  @override
  String get ocrReviewEmptyTitle => 'Hiç kelime tanınamadı';

  @override
  String get ocrReviewEmptyDesc => 'Net, iyi aydınlatılmış bir fotoğraf deneyin.';

  @override
  String get ocrReviewRetry => 'Tekrar Tara';

  @override
  String get ocrReviewError => 'Tarama başarısız oldu';

  @override
  String get ocrReviewInvalidRows => 'Eksik satırları doldurun veya kaldırın.';

  @override
  String get ocrReviewSaving => 'Kaydediliyor…';

  @override
  String ocrReviewPartialError(int count) {
    return '$count kelime kaydedilemedi. Başarısız satırları tekrar deneyin.';
  }

  @override
  String ocrReviewSavedSnack(int count) {
    return '$count kelime eklendi';
  }

  @override
  String get commonContinue => 'Devam Et';

  @override
  String studentDashboardGreeting(String name) {
    return 'Merhaba, $name! 👋';
  }

  @override
  String get studentDashboardSubtitle => 'Günün kelime avına hazır mısın?';

  @override
  String studentDashboardStreak(int days) {
    return '$days';
  }

  @override
  String studentDashboardStreakSemantic(int days) {
    return '$days günlük seri';
  }

  @override
  String get studentDashboardGameOfDay => 'Günün Oyunu';

  @override
  String studentDashboardGameSharedBy(String teacher) {
    return 'Paylaşan: $teacher';
  }

  @override
  String get studentDashboardGameAssigned => 'Öğretmenin Atadığı Oyun';

  @override
  String studentDashboardGameDesc(int count) {
    return '$count kelimeyi eşleştir, doğruluk ve süreni geliştir.';
  }

  @override
  String get studentDashboardPlayGame => 'Oyuna Başla';

  @override
  String get studentDashboardLessonsTitle => 'Derslerim';

  @override
  String get studentDashboardProgressTitle => 'Gelişim Özeti';

  @override
  String get studentDashboardStatGames => 'Tamamlanan Oyun';

  @override
  String get studentDashboardStatAccuracy => 'Ortalama Doğruluk';

  @override
  String get studentDashboardWeeklyGoal => 'Haftalık Hedef';

  @override
  String get studentDashboardAchievementsTitle => 'Son Başarımlar';

  @override
  String get studentDashboardJoinTeacherTitle => 'Bir Öğretmene Katıl';

  @override
  String get studentDashboardJoinTeacherDesc => 'Öğretmeninden aldığın davet kodunu girerek derslerine eriş.';

  @override
  String get studentDashboardJoinTeacherLinkShort => 'Yeni öğretmene katıl';

  @override
  String get studentDashboardEmptyNoTeacherTitle => 'Henüz bir derse katılmadın';

  @override
  String get studentDashboardEmptyNoTeacherDesc => 'Öğretmeninden aldığın davet koduyla başla.';

  @override
  String get studentDashboardEmptyNoLessonsTitle => 'Öğretmenin henüz ders yayınlamadı';

  @override
  String get studentDashboardEmptyNoLessonsDesc => 'Yeni dersler burada görünecek.';

  @override
  String get studentDashboardStatsSoon => 'Yakında — ilk oyununu oynayınca burada görünecek.';

  @override
  String get studentDashboardError => 'Dersler yüklenemedi';

  @override
  String get studentDashboardJoined => 'Derse katıldın';

  @override
  String get studentJoinAppBarTitle => 'Öğretmene Katıl';

  @override
  String get studentJoinHeroTitle => 'Davet Kodunu Gir';

  @override
  String get studentJoinHeroDesc => 'Öğretmeninden aldığın daveti girerek derslerine katıl.';

  @override
  String get studentJoinCodeLabel => 'Davet Kodu';

  @override
  String get studentJoinCodeHint => 'Kodu öğretmeninden alabilirsin.';

  @override
  String get studentJoinSubmit => 'Katıl';

  @override
  String get studentJoinSubmitting => 'Katılıyor…';

  @override
  String get studentJoinErrorInvalid => 'Bu kod geçerli değil. Kontrol edip tekrar dene.';

  @override
  String get studentJoinErrorAlready => 'Bu öğretmene zaten katıldın.';

  @override
  String get studentJoinErrorExpired => 'Bu kodun süresi dolmuş. Öğretmeninden yeni kod iste.';

  @override
  String get studentJoinErrorNetwork => 'Bağlanılamadı. Tekrar dene.';

  @override
  String get studentJoinBackToDashboard => 'Panele Dön';

  @override
  String studentJoinSuccess(String teacher) {
    return '$teacher dersine katıldın';
  }

  @override
  String get studentLessonPlay => 'Oyna';

  @override
  String get studentLessonPlayComingSoon => 'Oyun yakında eklenecek.';

  @override
  String get studentLessonEmptyTitle => 'Bu derste henüz kelime yok';

  @override
  String get studentLessonEmptyDesc => 'Öğretmenin kelime ekleyince burada görünecek.';

  @override
  String get studentLessonError => 'Kelimeler yüklenemedi';

  @override
  String get teacherStudentsAppBarTitle => 'Öğrencilerim';

  @override
  String get teacherStudentsCodeLabel => 'Davet Kodu';

  @override
  String get teacherStudentsCodeDesc => 'Bu kodu öğrencilerinle paylaş; girince derslerine katılırlar.';

  @override
  String get teacherStudentsCopy => 'Kopyala';

  @override
  String get teacherStudentsCopied => 'Kod kopyalandı';

  @override
  String get teacherStudentsShare => 'Paylaş';

  @override
  String teacherStudentsShareMessage(String code) {
    return 'LingoCross\'ta bana katıl. Davet kodu: $code';
  }

  @override
  String get teacherStudentsShareCopied => 'Davet metni kopyalandı';

  @override
  String get teacherStudentsRegenerate => 'Yeni Kod';

  @override
  String get teacherStudentsRegenerateConfirm => 'Yeni kod oluşturursan eski kod çalışmayı durdurur. Devam edilsin mi?';

  @override
  String get teacherStudentsRegenerated => 'Yeni davet kodu oluşturuldu';

  @override
  String get teacherStudentsRegenerateError => 'Yeni kod oluşturulamadı, tekrar deneyin.';

  @override
  String get teacherStudentsListTitle => 'Öğrenciler';

  @override
  String teacherStudentsCount(int count) {
    return '$count öğrenci';
  }

  @override
  String teacherStudentsJoinedAt(String date) {
    return 'Katıldı: $date';
  }

  @override
  String get teacherStudentsStatusActive => 'Aktif';

  @override
  String get teacherStudentsEmptyTitle => 'Henüz öğrencin yok';

  @override
  String get teacherStudentsEmptyDesc => 'Yukarıdaki davet kodunu öğrencilerinle paylaş.';

  @override
  String get teacherStudentsErrorCode => 'Davet kodu yüklenemedi';

  @override
  String get teacherStudentsErrorList => 'Öğrenciler yüklenemedi';

  @override
  String teacherStudentsCodeSemantic(String spaced) {
    return 'Davet kodu: $spaced';
  }
}
