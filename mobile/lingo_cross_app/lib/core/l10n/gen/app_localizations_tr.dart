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
}
