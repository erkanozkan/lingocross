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
  String get authLoginRememberMe => 'Beni Hatırla';

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
  String get authResetTitle => 'Şifreyi Sıfırla';

  @override
  String authResetDescription(String email) {
    return '$email adresine gönderilen 6 haneli kodu girin ve yeni şifrenizi belirleyin.';
  }

  @override
  String get authResetCodeLabel => 'Doğrulama Kodu';

  @override
  String get authResetCodeHint => '000000';

  @override
  String get authResetNewPasswordLabel => 'Yeni Şifre';

  @override
  String get authResetNewPasswordHint => 'En az 8 karakter';

  @override
  String get authResetConfirmPasswordLabel => 'Yeni Şifre (Tekrar)';

  @override
  String get authResetConfirmPasswordHint => 'Şifreyi tekrar girin';

  @override
  String get authResetSubmit => 'Şifreyi Sıfırla';

  @override
  String get authResetSuccess => 'Şifreniz güncellendi. Yeni şifrenizle giriş yapabilirsiniz.';

  @override
  String get authResetResend => 'Kod gelmedi mi? Tekrar gönder';

  @override
  String get authResetErrorCodeInvalid => 'Kod hatalı veya süresi dolmuş. Lütfen tekrar deneyin.';

  @override
  String get authValidationEmailRequired => 'E-posta adresi gerekli.';

  @override
  String get authValidationEmailInvalid => 'Geçerli bir e-posta adresi girin.';

  @override
  String get authValidationPasswordRequired => 'Şifre gerekli.';

  @override
  String get authValidationPasswordTooShort => 'Şifre en az 8 karakter olmalı.';

  @override
  String get authValidationPasswordMismatch => 'Şifreler eşleşmiyor.';

  @override
  String get authValidationCodeRequired => 'Doğrulama kodu gerekli.';

  @override
  String get authValidationCodeInvalid => 'Kod 6 rakam olmalı.';

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
  String get teacherDashboardActionNewPuzzleTitle => 'Yeni Bulmaca Oluştur';

  @override
  String get teacherDashboardActionNewPuzzleDesc => 'Bir dersin kelimelerinden öğrencilerine bulmaca hazırla ve yayınla.';

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
  String get teacherDashboardEmptyReports => 'Öğrenciler sonuç paylaştıkça burada görünecek.';

  @override
  String get teacherDashboardReportsError => 'Raporlar yüklenemedi';

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
  String get teacherDashboardOpenProfile => 'Profili aç';

  @override
  String get navClasses => 'Sınıflar';

  @override
  String get lessonStatusDraft => 'Taslak';

  @override
  String get lessonStatusActive => 'Aktif';

  @override
  String get lessonStatusCompleted => 'Tamamlandı';

  @override
  String get lessonStatusDraftUpper => 'TASLAK';

  @override
  String get lessonStatusActiveUpper => 'AKTİF';

  @override
  String get lessonStatusCompletedUpper => 'TAMAMLANDI';

  @override
  String get lessonsListTitle => 'Derslerim';

  @override
  String get lessonsListCreate => '+ Yeni Ders Oluştur';

  @override
  String get lessonsListSectionTitle => 'Yaklaşan Dersler';

  @override
  String lessonsListTotal(int count) {
    return 'Toplam: $count';
  }

  @override
  String lessonsListWordCount(int count) {
    return '$count Kelime';
  }

  @override
  String get lessonsListEmptyTitle => 'Henüz dersiniz yok';

  @override
  String get lessonsListEmptyDesc => 'İlk dersinizi oluşturarak başlayın.';

  @override
  String get lessonsListError => 'Dersler yüklenemedi';

  @override
  String get lessonsListNoDate => 'Tarih belirtilmedi';

  @override
  String get lessonsListFooterHint => 'Geçmiş derslerinizi görmek için kaydırın';

  @override
  String get reportsTitle => 'Raporlar';

  @override
  String get teacherProfileRoleLabel => 'Öğretmen';

  @override
  String get teacherProfileStatClasses => 'Sınıf';

  @override
  String get teacherProfileStatStudents => 'Öğrenci';

  @override
  String get teacherProfileStatParticipation => 'Katılım';

  @override
  String get teacherProfileWeeklyTitle => 'Haftalık Ödev Tamamlama';

  @override
  String teacherProfileWeeklyDesc(int done, int total) {
    return '$done/$total ödev tamamlandı';
  }

  @override
  String teacherProfileWeeklyHint(int percent) {
    return 'Sınıflarınızın ödev tamamlama oranı geçen haftaya göre %$percent arttı!';
  }

  @override
  String get teacherProfileWeeklyEmpty => 'Bu hafta atanmış ödev yok.';

  @override
  String teacherProfileStatValue(int percent) {
    return '%$percent';
  }

  @override
  String get teacherProfileStatsError => 'İstatistikler yüklenemedi.';

  @override
  String get teacherProfileBadgesTitle => 'Öğretmen Rozetleri';

  @override
  String get teacherProfileBadgePopular => 'Popüler Eğitmen';

  @override
  String get teacherProfileBadgeFast => 'Hızlı Değerlendirici';

  @override
  String get teacherProfileBadgeInspiring => 'İlham Veren';

  @override
  String get teacherProfileMenuClasses => 'Sınıf Yönetimi';

  @override
  String get teacherProfileMenuLessons => 'Derslerim';

  @override
  String get teacherProfileMenuReports => 'İstatistikler ve Raporlar';

  @override
  String get teacherProfileMenuSettings => 'Hesap Ayarları';

  @override
  String get teacherProfileMenuLogout => 'Çıkış Yap';

  @override
  String get teacherProfileStatsSoon => 'İstatistikler yakında — öğrenciler oyun oynadıkça dolacak.';

  @override
  String get studentProfileRoleLabel => 'Öğrenci';

  @override
  String get studentProfileSettingsTooltip => 'Ayarlar';

  @override
  String get studentProfileStatStreak => 'Günlük Seri';

  @override
  String get studentProfileStatGames => 'Oyun';

  @override
  String get studentProfileStatAccuracy => 'Doğruluk';

  @override
  String get studentProfileStatsError => 'İstatistikler yüklenemedi.';

  @override
  String get studentProfileWeeklyGoalTitle => 'Haftalık Hedef';

  @override
  String get studentProfileWeeklyGoalSoon => 'Haftalık hedef takibi yakında — oyun oynadıkça ilerlemeni burada göreceksin.';

  @override
  String get studentProfileAchievementsTitle => 'Başarılarım';

  @override
  String get studentProfileBadgeFastStart => 'Hızlı Başlangıç';

  @override
  String get studentProfileBadgeWordHunter => 'Kelime Avcısı';

  @override
  String get studentProfileBadgeQuizMaster => 'Sınav Ustası';

  @override
  String get studentProfileBadgeLocked => 'Poliglot';

  @override
  String get studentProfileMenuAccount => 'Hesap Ayarları';

  @override
  String get studentProfileMenuNotifications => 'Bildirim Tercihleri';

  @override
  String get studentProfileMenuHelp => 'Yardım ve Destek';

  @override
  String get studentProfileMenuLogout => 'Çıkış Yap';

  @override
  String get lessonFormHeroTitle => 'Harika bir ders planla!';

  @override
  String get lessonFormHeroDesc => 'Öğrencilerin yeni şeyler öğrenmeye hazır.';

  @override
  String get lessonFormFieldScheduleLabel => 'Ders Tarihi / Haftası';

  @override
  String get lessonFormFieldSchedulePlaceholder => 'Örn: 15-21 Temmuz 2024';

  @override
  String get lessonFormFieldUnitLabel => 'Ünite Adı veya Numarası';

  @override
  String get lessonFormFieldUnitPlaceholder => 'Örn: Unit 4: Food & Drinks';

  @override
  String get lessonFormFieldTopicsLabel => 'Ders Detayları ve Konular';

  @override
  String get lessonFormFieldTopicsPlaceholder => 'Bu derste hangi konuları işleyeceksiniz? Önemli notları buraya ekleyin...';

  @override
  String get lessonFormVocabTitle => 'Ünite Kelime Listesi';

  @override
  String get lessonFormVocabDesc => 'Bu üniteye ait kelimeleri görüntüle veya yeni kelimeler ekle.';

  @override
  String get lessonFormVocabSaveFirst => 'Önce dersi kaydedin, sonra kelime ekleyin.';

  @override
  String get lessonFormInfoNote => 'Dersi kaydettiğinizde tüm öğrencileriniz bildirim alacaktır. Planlamalarınızı istediğiniz zaman düzenleyebilirsiniz.';

  @override
  String get lessonFormSaveAndShare => 'Dersi Kaydet ve Paylaş';

  @override
  String get lessonDetailTitle => 'Ders Detayı';

  @override
  String get lessonDetailScheduleNone => 'Tarih belirtilmedi';

  @override
  String get lessonDetailSharedTitle => 'Paylaşılan Sınıflar';

  @override
  String lessonDetailSharedCount(int count) {
    return '$count öğrenciye açık';
  }

  @override
  String get lessonDetailSharedNone => 'Henüz öğrenciye açık değil';

  @override
  String get lessonDetailSharedDraft => 'Ders taslakta — yayınlanınca öğrencilere açılır';

  @override
  String get lessonDetailContentTitle => 'Ders İçeriği';

  @override
  String get lessonDetailContentEmpty => 'Bu ders için içerik girilmemiş.';

  @override
  String get lessonDetailWordsTitle => 'Kelime Listesi';

  @override
  String get lessonDetailWordsSeeAll => 'Tümünü Gör';

  @override
  String get lessonDetailWordsEmpty => 'Henüz kelime eklenmemiş.';

  @override
  String get lessonDetailAddWords => 'Kelime Ekle';

  @override
  String get lessonDetailEdit => 'Dersi Düzenle';

  @override
  String get lessonDetailAssignHomework => 'Ödev Ataması Yap';

  @override
  String get lessonDetailPublish => 'Yayınla';

  @override
  String get lessonDetailUnpublish => 'Yayından Kaldır';

  @override
  String get lessonDetailComplete => 'Tamamlandı İşaretle';

  @override
  String get lessonDetailPublishedSnack => 'Ders yayınlandı';

  @override
  String get lessonDetailUnpublishedSnack => 'Ders yayından kaldırıldı';

  @override
  String get lessonDetailCompletedSnack => 'Ders tamamlandı olarak işaretlendi';

  @override
  String get lessonDetailActionError => 'İşlem başarısız, tekrar deneyin.';

  @override
  String get lessonDetailError => 'Ders yüklenemedi';

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
  String get langNameEnglish => 'İngilizce';

  @override
  String get langNameTurkish => 'Türkçe';

  @override
  String get langNameGerman => 'Almanca';

  @override
  String get langNameSpanish => 'İspanyolca';

  @override
  String get langNameFrench => 'Fransızca';

  @override
  String get langNameItalian => 'İtalyanca';

  @override
  String wordsListCount(int count) {
    return '$count kelime';
  }

  @override
  String get wordsListWordUnit => 'kelime';

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
  String wordsFormMeaningLabel(String lang) {
    return '$lang Karşılık(lar)';
  }

  @override
  String get wordsFormMeaningPlaceholder => 'Örn. çevre';

  @override
  String get wordsFormMeaningAddMore => 'Karşılık Ekle';

  @override
  String get wordsFormMeaningRequired => 'En az bir karşılık girin';

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
  String get ocrCaptureHowDesc => 'El yazısı listenizin fotoğrafını çekin. Yapay zeka fotoğrafı okur ve kelimeleri otomatik olarak listenize aktarır.';

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
  String get ocrCaptureSourceCamera => 'Kamera ile çek';

  @override
  String get ocrCaptureSourceGallery => 'Galeriden Seç';

  @override
  String get ocrCapturePhotoRemoveLabel => 'Fotoğrafı kaldır';

  @override
  String get ocrCaptureExtract => 'Kelimeleri Çıkart';

  @override
  String get ocrCaptureReading => 'Görüntü yapay zeka ile okunuyor…';

  @override
  String get ocrCaptureOr => 'VEYA';

  @override
  String get ocrCaptureManual => 'Manuel Giriş';

  @override
  String get ocrCapturePermissionTitle => 'Kamera/galeri erişimi gerekli';

  @override
  String get ocrCapturePermissionDesc => 'Devam etmek için ayarlardan kamera veya galeri erişimine izin verin.';

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
  String get ocrReviewConfidenceNote => 'Yapay zeka okuması hatalı olabilir; kaydetmeden önce kontrol edin.';

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
  String get ocrReviewSwap => 'Terim ve karşılığı yer değiştir';

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
  String get studentDashboardMyClassesTitle => 'Sınıflarım';

  @override
  String studentDashboardMyClassTeacher(String teacher) {
    return 'Öğretmen: $teacher';
  }

  @override
  String get studentDashboardMyClassesEmpty => 'Henüz bir sınıfa katılmadın.';

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
  String get studentDashboardJoinTeacherTitle => 'Bir Sınıfa Katıl';

  @override
  String get studentDashboardJoinTeacherDesc => 'Öğretmeninden aldığın sınıf davet kodunu girerek derslerine eriş.';

  @override
  String get studentDashboardJoinTeacherLinkShort => 'Yeni sınıfa katıl';

  @override
  String get studentDashboardEmptyNoTeacherTitle => 'Henüz bir sınıfa katılmadın';

  @override
  String get studentDashboardEmptyNoTeacherDesc => 'Öğretmeninden aldığın sınıf davet koduyla başla.';

  @override
  String get studentDashboardEmptyNoLessonsTitle => 'Öğretmenin henüz ders yayınlamadı';

  @override
  String get studentDashboardEmptyNoLessonsDesc => 'Yeni dersler burada görünecek.';

  @override
  String get studentDashboardPuzzlesTitle => 'Atanan Bulmacalar';

  @override
  String get studentDashboardEmptyNoPuzzlesTitle => 'Öğretmenin henüz bulmaca atamadı';

  @override
  String get studentDashboardEmptyNoPuzzlesDesc => 'Öğretmenin bir bulmaca yayınlayınca burada görünecek.';

  @override
  String studentDashboardPuzzleLesson(String lesson, int count) {
    return '$lesson • $count kelime';
  }

  @override
  String get studentDashboardCompletedTitle => 'Tamamlanan Bulmacalar';

  @override
  String studentDashboardCompletedScore(int percent) {
    return '%$percent';
  }

  @override
  String get studentDashboardCompletedSeeStats => 'İstatistikleri Gör';

  @override
  String get studentDashboardCompletedBadge => 'Tamamlandı';

  @override
  String get studentDashboardStatsSoon => 'Yakında — ilk oyununu oynayınca burada görünecek.';

  @override
  String get studentDashboardStatsEmpty => 'Henüz oyun oynamadın.';

  @override
  String get studentDashboardStatsError => 'Gelişim özeti yüklenemedi.';

  @override
  String studentDashboardStatAccuracyValue(int percent) {
    return '%$percent';
  }

  @override
  String get studentDashboardSeeReports => 'Raporlarım';

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
  String get studentLessonEmptyTitle => 'Bu derste henüz kelime yok';

  @override
  String get studentLessonEmptyDesc => 'Öğretmenin kelime ekleyince burada görünecek.';

  @override
  String get studentLessonError => 'Kelimeler yüklenemedi';

  @override
  String get gameStarting => 'Oyun hazırlanıyor…';

  @override
  String get gameStartErrorNetwork => 'Bağlanılamadı. Tekrar dene.';

  @override
  String get gameStartErrorNotFound => 'Oyun bulunamadı.';

  @override
  String get gameStartErrorForbidden => 'Bu oyuna erişim iznin yok.';

  @override
  String get gameStartErrorInsufficientWords => 'Bu derste oyun için yeterli kelime yok. Öğretmenin kelime ekleyince oyun hazır olacak.';

  @override
  String get gameMatchingTitle => 'Kelime Eşleştirme';

  @override
  String get gameMatchingCurrentGameLabel => 'Mevcut Oyun';

  @override
  String gameMatchingCounter(int matched, int total) {
    return '$matched / $total';
  }

  @override
  String get gameMatchingColEnglish => 'İngilizce';

  @override
  String get gameMatchingColTurkish => 'Türkçe';

  @override
  String get gameMatchingColEnglishUpper => 'İNGİLİZCE';

  @override
  String get gameMatchingColTurkishUpper => 'TÜRKÇE';

  @override
  String get gameMatchingCurrentGameLabelUpper => 'MEVCUT OYUN';

  @override
  String gameMatchingTimerSemantic(String time) {
    return 'Geçen süre $time';
  }

  @override
  String get gameMatchingEncouragement => 'Harika gidiyorsun! Kelimeleri birleştirerek hız kazan.';

  @override
  String get gameMatchingQuit => 'Vazgeç';

  @override
  String get gameMatchingQuitConfirmTitle => 'Oyundan çık?';

  @override
  String get gameMatchingQuitConfirmDesc => 'Çıkarsan ilerlemen kaydedilmeyecek.';

  @override
  String get gameMatchingQuitConfirmConfirm => 'Çık';

  @override
  String get gameMatchingQuitConfirmCancel => 'Devam Et';

  @override
  String get gameMatchingA11yMatched => 'eşleşti';

  @override
  String get gameMatchingA11yWrong => 'yanlış, tekrar dene';

  @override
  String get gameMatchingCompleteTitle => 'Tebrikler!';

  @override
  String gameMatchingCompleteMessage(int matched, int total, String time) {
    return 'Tüm kelimeleri $matched/$total eşleştirdin. Süre: $time.';
  }

  @override
  String get gameMatchingCompleteFinish => 'Bitir';

  @override
  String get gameMatchingEmptyTitle => 'Bu derste henüz oyun yok';

  @override
  String get gameMatchingEmptyDesc => 'Öğretmen yeterli kelime ekleyince oyun hazır olacak.';

  @override
  String get gameMatchingError => 'Oyun yüklenemedi';

  @override
  String get createGameTitle => 'Yeni Bulmaca Oluştur';

  @override
  String get createGameStep1Title => 'Oyun Türünü Seç';

  @override
  String get createGameStep2Title => 'Ders Seçimi';

  @override
  String get createGameTypeMatchingTitle => 'Kelime Eşleştirme';

  @override
  String get createGameTypeMatchingDesc => 'Kelime ve anlamlarını eşleştirerek öğrenmeyi hızlandır.';

  @override
  String get createGameTypeCrosswordTitle => 'Çengel Bulmaca';

  @override
  String get createGameTypeCrosswordDesc => 'İpuçları kullanarak kelimeleri bulmalarını sağla.';

  @override
  String get createGameTypeScrambledTitle => 'Karışık Harfler';

  @override
  String get createGameTypeScrambledDesc => 'Karışık harfleri doğru sıraya dizerek kelimeyi bulmalarını sağla.';

  @override
  String get createGameLessonLabel => 'Kullanılacak Kelime Listesi';

  @override
  String get createGameLessonHint => 'Bir ders seçin…';

  @override
  String get createGameLessonsEmpty => 'Henüz dersin yok. Önce bir ders oluştur.';

  @override
  String get createGameLessonsError => 'Dersler yüklenemedi.';

  @override
  String get createGamePreviewTitle => 'Örnek Önizleme';

  @override
  String get createGamePreviewSubtitle => 'Bu bulmaca kaydedildiğinde yaklaşık olarak böyle görünecek. Beğenmezsen geri dönüp türü ya da dersi değiştirebilirsin.';

  @override
  String get createGamePreviewSampleNote => 'Bu yalnızca bir örnek önizlemedir; kaydedilmedi.';

  @override
  String get createGamePreviewLoading => 'Önizleme hazırlanıyor…';

  @override
  String get createGamePreviewError => 'Önizleme oluşturulamadı, tekrar dene.';

  @override
  String get createGamePreviewEmpty => 'Önizlenecek içerik bulunamadı.';

  @override
  String get createGameSubmit => 'Bulmacayı Oluştur';

  @override
  String get createGameSuccess => 'Bulmaca oluşturuldu ve yayınlandı.';

  @override
  String get createGameErrorInsufficientWords => 'Bulmaca oluşturmak için ders en az 4 kelime içermeli.';

  @override
  String get createGameErrorNetwork => 'Bağlanılamadı. Tekrar dene.';

  @override
  String get createGameErrorGeneric => 'Bulmaca oluşturulamadı, tekrar dene.';

  @override
  String get gameCrosswordTitle => 'Günün Bulmacası';

  @override
  String gameCrosswordCounter(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get gameCrosswordAcross => 'SOLDAN SAĞA';

  @override
  String get gameCrosswordDown => 'YUKARIDAN AŞAĞI';

  @override
  String get gameCrosswordFinish => 'Bitir';

  @override
  String get gameCrosswordKeyDelete => 'Sil';

  @override
  String get gameCrosswordCompleteTitle => 'Bulmaca tamamlandı!';

  @override
  String get gameCrosswordCellSemantic => 'Bulmaca hücresi';

  @override
  String gameCrosswordCellNumberedSemantic(int number) {
    return '$number numaralı kelimenin başlangıç hücresi';
  }

  @override
  String get gameCrosswordCellEmpty => 'boş';

  @override
  String get gameScrambledTitle => 'Harfleri Diz';

  @override
  String get gameScrambledClueLabel => 'ÇEVİRİ İPUCU';

  @override
  String get gameScrambledInstruction => 'Harflere dokunarak doğru sıraya diz. Geri almak için dizdiğin harfe dokun.';

  @override
  String get gameScrambledPrevious => 'Önceki kelime';

  @override
  String get gameScrambledNext => 'Sonraki kelime';

  @override
  String get gameScrambledLetterSemantic => 'harf, eklemek için dokun';

  @override
  String get gameScrambledSlotSemantic => 'yerleştirildi, geri almak için dokun';

  @override
  String get gameScrambledEmptySlot => 'boş harf yuvası';

  @override
  String get questionSetTitle => 'Çıkmış Sorular';

  @override
  String questionSetQuestionOf(int current, int total) {
    return 'Soru $current / $total';
  }

  @override
  String get questionSetFinish => 'Bitir';

  @override
  String get questionSetSubtitle => 'Çıkmış Sorular';

  @override
  String get questionSetNextQuestion => 'Sonraki Soru';

  @override
  String get questionSetPrevious => 'Önceki';

  @override
  String questionSetElapsed(String time) {
    return 'Süre $time';
  }

  @override
  String get questionSetSelectAnswer => 'Bir cevap seç';

  @override
  String get questionSetExplanation => 'Açıklama';

  @override
  String get questionTopicsTitle => 'Çıkmış Sorular';

  @override
  String get questionTopicsHeroTitle => 'Çıkmış Sorular';

  @override
  String get questionTopicsHeroSubtitle => 'Gerçek sınav tecrübesiyle öğrencilerinin İngilizce seviyesini bir üst noktaya taşı.';

  @override
  String get questionTopicsAssign => 'Sınıfa Ata';

  @override
  String get questionTopicsAssignSheetTitle => 'Sınıflara Ata';

  @override
  String get questionTopicsAssignSubmit => 'Ata';

  @override
  String get questionTopicsAssignSuccess => 'Konu seçili sınıflara atandı.';

  @override
  String questionTopicsQuestionCount(int count) {
    return '$count Soru';
  }

  @override
  String get questionTopicsEmpty => 'Henüz atanabilir soru konusu yok.';

  @override
  String get gameCardQuestionSet => 'Çıkmış Sorular';

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

  @override
  String get gameResultSubmitting => 'Sonucun kaydediliyor…';

  @override
  String get gameResultSubmitError => 'Sonuç kaydedilemedi, tekrar dene.';

  @override
  String get gameResultTitle => 'Oyun Özeti';

  @override
  String get gameResultSubtitle => 'Harika bir iş çıkardın!';

  @override
  String gameResultAccuracyValue(int percent) {
    return '%$percent';
  }

  @override
  String get gameResultAccuracyLabel => 'Doğruluk';

  @override
  String gameResultAccuracyA11y(int percent) {
    return 'Doğruluk yüzde $percent';
  }

  @override
  String get gameResultTimeLabel => 'Geçen Süre';

  @override
  String get gameResultWordsLabel => 'Bulunan Kelime';

  @override
  String gameResultWordsValue(int found, int total) {
    return '$found / $total';
  }

  @override
  String get gameResultSharedNote => 'Öğretmeninle paylaşıldı';

  @override
  String get gameResultErrorTitle => 'Sonuç yüklenemedi';

  @override
  String get resultsHistoryTitle => 'Sonuçlarım';

  @override
  String get resultsHistorySubtitle => 'Tüm oyun geçmişin';

  @override
  String get resultsHistorySummaryTotalGames => 'Toplam Oyun';

  @override
  String get resultsHistorySummaryAvgAccuracy => 'Ortalama Doğruluk';

  @override
  String get resultsHistoryItemShared => 'Gönderildi';

  @override
  String resultsHistoryItemA11y(String lesson, int percent, String time, int found, int total) {
    return '$lesson, doğruluk yüzde $percent, süre $time, $found / $total';
  }

  @override
  String resultsHistoryItemDateA11y(String lesson, int percent, String time, int found, int total, String date) {
    return '$lesson, doğruluk yüzde $percent, süre $time, $found / $total, $date';
  }

  @override
  String get resultsHistoryEmptyTitle => 'Henüz oyun oynamadın';

  @override
  String get resultsHistoryEmptyDesc => 'Bir ders oyununu bitirince sonucun burada görünür.';

  @override
  String get resultsHistoryEmptyCta => 'Oyuna Başla';

  @override
  String get resultsHistoryErrorTitle => 'Sonuçlar yüklenemedi';

  @override
  String get resultsErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get resultsErrorNotFound => 'Sonuç bulunamadı.';

  @override
  String get resultsErrorForbidden => 'Bu işlem için yetkiniz yok.';

  @override
  String get trackingStudentsTitle => 'Öğrenci Raporları';

  @override
  String get trackingStudentsSubtitle => 'Öğrencilerinin paylaştığı oyun sonuçlarını takip et.';

  @override
  String get trackingStudentsListTitle => 'Öğrenciler';

  @override
  String trackingSharedCountLabel(int count) {
    return '$count paylaşılan sonuç';
  }

  @override
  String get trackingAverageLabel => 'Ortalama';

  @override
  String get trackingAverageNone => '—';

  @override
  String trackingLastActivityLabel(String date) {
    return 'Son aktivite: $date';
  }

  @override
  String get trackingLastActivityNone => 'Son aktivite: henüz yok';

  @override
  String trackingStudentRowA11y(String name, int count) {
    return '$name, $count paylaşılan sonuç';
  }

  @override
  String get trackingStudentsEmptyTitle => 'Henüz paylaşılan sonuç yok';

  @override
  String get trackingStudentsEmptyDesc => 'Öğrencilerin oyun sonuçlarını paylaşınca burada görünür. Henüz öğrencin yoksa Sınıflar sekmesinden davet kodunu paylaş.';

  @override
  String get trackingStudentsErrorTitle => 'Öğrenciler yüklenemedi';

  @override
  String get trackingDetailTitle => 'Öğrenci Raporu';

  @override
  String get trackingDetailAverageLabel => 'Ortalama Doğruluk';

  @override
  String get trackingDetailResultsLabel => 'Paylaşılan Sonuç';

  @override
  String get trackingDetailResultsTitle => 'Paylaşılan Sonuçlar';

  @override
  String get trackingDetailEmptyTitle => 'Henüz paylaşılan sonuç yok';

  @override
  String get trackingDetailEmptyDesc => 'Bu öğrenci henüz seninle bir oyun sonucu paylaşmadı.';

  @override
  String get trackingDetailErrorTitle => 'Sonuçlar yüklenemedi';

  @override
  String trackingResultA11y(String lesson, int percent, String time, int found, int total, String date) {
    return '$lesson, doğruluk yüzde $percent, süre $time, $found / $total, $date';
  }

  @override
  String get resultDetailTitle => 'Sonuç Detayı';

  @override
  String resultDetailDateTime(String date, String time) {
    return '$date • $time';
  }

  @override
  String get resultDetailMetricAccuracy => 'Başarı';

  @override
  String get resultDetailMetricCorrect => 'Doğru';

  @override
  String get resultDetailMetricDuration => 'Süre';

  @override
  String resultDetailFilterAll(int count) {
    return 'Tümü ($count)';
  }

  @override
  String resultDetailFilterCorrect(int count) {
    return 'Doğrular ($count)';
  }

  @override
  String resultDetailFilterWrong(int count) {
    return 'Yanlışlar ($count)';
  }

  @override
  String get resultDetailBadgeCorrect => 'Doğru';

  @override
  String get resultDetailBadgeWrong => 'Yanlış';

  @override
  String resultDetailCorrectAnswer(String answer) {
    return 'Doğru cevap: $answer';
  }

  @override
  String resultDetailStudentAnswer(String answer) {
    return 'Öğrencinin cevabı: $answer';
  }

  @override
  String get resultDetailStudentAnswerEmpty => 'Öğrencinin cevabı: — (boş)';

  @override
  String get resultDetailAnalysisTitle => 'Bölüm Analizi';

  @override
  String get resultDetailSpeedScore => 'Hız Skoru';

  @override
  String get resultDetailSpeedGreat => 'Harika!';

  @override
  String get resultDetailSpeedGood => 'İyi';

  @override
  String get resultDetailSpeedFair => 'Orta';

  @override
  String get resultDetailSpeedSlow => 'Acele etme';

  @override
  String resultDetailSpeedDesc(String seconds) {
    return 'Kelime başına ortalama $seconds sn.';
  }

  @override
  String get resultDetailNoItemsTitle => 'Kelime detayı yok';

  @override
  String get resultDetailNoItemsDesc => 'Bu sonuç eski bir oynamadan geldiği için kelime bazlı döküm bulunmuyor.';

  @override
  String get resultDetailErrorTitle => 'Sonuç detayı yüklenemedi';

  @override
  String resultDetailItemCorrectA11y(String term, String answer) {
    return '$term, karşılığı $answer, doğru';
  }

  @override
  String resultDetailItemWrongA11y(String term, String expected, String given) {
    return '$term, doğru cevap $expected, öğrencinin cevabı $given, yanlış';
  }

  @override
  String get gameTypeWordMatching => 'Kelime Eşleştirme';

  @override
  String get gameTypeCrossword => 'Bulmaca';

  @override
  String get gameTypeQuestionSet => 'Soru Seti';

  @override
  String get gameTypeScrambled => 'Karışık Harfler';

  @override
  String get trackingErrorNetwork => 'Bağlantı hatası. Lütfen tekrar deneyin.';

  @override
  String get trackingErrorNotFound => 'Öğrenci bulunamadı.';

  @override
  String get trackingErrorForbidden => 'Bu işlem için yetkiniz yok.';

  @override
  String get teacherDashboardActionMyPuzzlesTitle => 'Bulmacalarım';

  @override
  String get teacherDashboardActionMyPuzzlesDesc => 'Oluşturduğun tüm bulmacaları gör, paylaş ve çözüm istatistiklerini izle.';

  @override
  String get teacherDashboardActionQuestionTopicsTitle => 'Çıkmış Sorular';

  @override
  String get teacherDashboardActionQuestionTopicsDesc => 'Soru konularını seç ve sınıflarına ata; öğrenciler 10 soruluk setleri çözsün.';

  @override
  String get myPuzzlesTitle => 'Bulmacalarım';

  @override
  String get myPuzzlesCreateCta => 'Yeni Bulmaca Oluştur';

  @override
  String get myPuzzlesFilterAll => 'Tümü';

  @override
  String myPuzzlesFilterActive(int count) {
    return 'Aktif ($count)';
  }

  @override
  String get myPuzzlesTypeWordMatching => 'Kelime Eşleştirme';

  @override
  String get myPuzzlesTypeCrossword => 'Crossword';

  @override
  String get myPuzzlesStatusActive => 'Aktif';

  @override
  String myPuzzlesCreatedAt(String date) {
    return 'Oluşturulma: $date';
  }

  @override
  String myPuzzlesSharedWith(int count) {
    return 'Paylaşılan: $count öğrenci';
  }

  @override
  String get myPuzzlesSeeDetails => 'Detayları Gör';

  @override
  String get myPuzzlesStatTotal => 'Toplam Bulmaca';

  @override
  String get myPuzzlesStatSolves => 'Öğrenci Çözümü';

  @override
  String get myPuzzlesEmptyTitle => 'Henüz bulmaca yok';

  @override
  String get myPuzzlesEmptyDesc => 'İlk bulmacanı oluşturarak başla.';

  @override
  String get myPuzzlesErrorTitle => 'Bulmacalar yüklenemedi';

  @override
  String get accountSettingsTitle => 'Hesap Ayarları';

  @override
  String get accountEditProfileCta => 'Profili Düzenle';

  @override
  String get accountGroupGeneral => 'GENEL';

  @override
  String get accountGroupSecurity => 'GÜVENLİK';

  @override
  String get accountGroupSupport => 'DESTEK & HAKKIMIZDA';

  @override
  String get accountRowNotifications => 'Bildirim Ayarları';

  @override
  String get accountRowLanguage => 'Dil Tercihi';

  @override
  String get accountRowTheme => 'Tema';

  @override
  String get accountRowThemeValueLight => 'Açık';

  @override
  String get accountRowChangePassword => 'Şifre Değiştir';

  @override
  String get accountRowTwoFactor => 'İki Faktörlü Doğrulama';

  @override
  String get accountRowHelpCenter => 'Yardım Merkezi';

  @override
  String get accountRowPrivacy => 'Gizlilik Politikası';

  @override
  String get accountLogout => 'Çıkış Yap';

  @override
  String accountVersion(String version) {
    return 'LingoCross v$version';
  }

  @override
  String get accountSaveLabel => 'Kaydet';

  @override
  String get accountSavingLabel => 'Kaydediliyor…';

  @override
  String get accountEditProfileTitle => 'Profili Düzenle';

  @override
  String get accountEditProfileNameLabel => 'Ad Soyad';

  @override
  String get accountEditProfileNamePlaceholder => 'Adınızı girin';

  @override
  String get accountEditProfileSavedSnack => 'Profiliniz güncellendi';

  @override
  String get accountChangePasswordTitle => 'Şifre Değiştir';

  @override
  String get accountChangePasswordCurrentLabel => 'Mevcut Şifre';

  @override
  String get accountChangePasswordNewLabel => 'Yeni Şifre';

  @override
  String get accountChangePasswordConfirmLabel => 'Yeni Şifre (Tekrar)';

  @override
  String get accountChangePasswordMismatch => 'Yeni şifreler eşleşmiyor.';

  @override
  String get accountChangePasswordWrongCurrent => 'Mevcut şifre hatalı.';

  @override
  String get accountChangePasswordSubmit => 'Şifreyi Güncelle';

  @override
  String get accountChangePasswordSavedSnack => 'Şifreniz değiştirildi';

  @override
  String get accountGroupDangerZone => 'TEHLİKELİ BÖLGE';

  @override
  String get accountRowDeleteAccount => 'Hesabı Sil';

  @override
  String get accountDeleteDialogTitle => 'Hesabını sil';

  @override
  String get accountDeleteDialogBody => 'Hesabın ve tüm verilerin (sınıflar, dersler, sonuçlar) kalıcı olarak silinecek. Bu işlem geri alınamaz.';

  @override
  String get accountDeleteConfirm => 'Hesabı Sil';

  @override
  String get accountDeleteCancel => 'Vazgeç';

  @override
  String get accountDeleteError => 'Hesabın silinemedi. Lütfen tekrar dene.';

  @override
  String get classesTitle => 'Sınıflarım';

  @override
  String get classesHeroTitle => 'Merhaba, Öğretmenim!';

  @override
  String classesHeroSubtitle(int count) {
    return 'Bugün $count farklı sınıfınla dersin bulunuyor. Başarılar dileriz.';
  }

  @override
  String get classesStatTotalStudents => 'Toplam Öğrenci';

  @override
  String get classesStatActivity => 'Aktiflik';

  @override
  String classesStatActivityValue(int percent) {
    return '%$percent';
  }

  @override
  String get classesActiveSectionTitle => 'Aktif Sınıflar';

  @override
  String get classesSeeAll => 'Tümünü Gör';

  @override
  String classesStudentCount(int count) {
    return '$count öğrenci';
  }

  @override
  String get classesInviteCodeChipLabel => 'Davet Kodu:';

  @override
  String get classesCreateButton => 'Yeni Sınıf Oluştur';

  @override
  String get classesEmptyTitle => 'Henüz sınıfın yok';

  @override
  String get classesEmptyDesc => 'İlk sınıfını oluştur ve davet koduyla öğrencilerini davet et.';

  @override
  String get classesError => 'Sınıflar yüklenemedi';

  @override
  String get classCreateTitle => 'Yeni Sınıf';

  @override
  String get classCreateNameLabel => 'Sınıf Adı';

  @override
  String get classCreateNamePlaceholder => 'örn. 6-A';

  @override
  String get classCreateInfo => 'Sınıfı oluşturduktan sonra öğrencilerinle paylaşacağın bir davet kodu üretilecek.';

  @override
  String get classCreatePerkProgress => 'İlerleme Takibi';

  @override
  String get classCreatePerkRewards => 'Ödül Sistemi';

  @override
  String get classCreateSubmit => 'Oluştur';

  @override
  String classCreateSuccess(String name) {
    return '$name sınıfı oluşturuldu.';
  }

  @override
  String get classCreateErrorNetwork => 'Bağlanılamadı. Tekrar dene.';

  @override
  String get classCreateErrorGeneric => 'Sınıf oluşturulamadı, tekrar dene.';

  @override
  String get classDetailFallbackTitle => 'Sınıf';

  @override
  String get classDetailCodeLabel => 'Sınıf Davet Kodu';

  @override
  String classDetailCodeSemantic(String spaced) {
    return 'Sınıf davet kodu: $spaced';
  }

  @override
  String get classDetailCopy => 'Kopyala';

  @override
  String get classDetailCodeCopied => 'Kod kopyalandı';

  @override
  String get classDetailShare => 'Paylaş';

  @override
  String classDetailShareMessage(String code) {
    return 'LingoCross\'ta sınıfıma katıl. Davet kodu: $code';
  }

  @override
  String get classDetailShareCopied => 'Davet metni kopyalandı';

  @override
  String get classDetailRegenerate => 'Yeni Kod Üret';

  @override
  String get classDetailRegenerateConfirm => 'Yeni kod oluşturursan eski kod çalışmayı durdurur. Devam edilsin mi?';

  @override
  String get classDetailRegenerated => 'Yeni davet kodu oluşturuldu';

  @override
  String get classDetailRegenerateError => 'Yeni kod oluşturulamadı, tekrar deneyin.';

  @override
  String classDetailStudents(int count) {
    return 'Öğrenciler ($count)';
  }

  @override
  String get classDetailAdd => 'Ekle';

  @override
  String get classDetailAddHint => 'Öğrenci eklemek için davet kodunu paylaş.';

  @override
  String get classDetailRemove => 'Çıkar';

  @override
  String classDetailRemoveConfirm(String name) {
    return '$name bu sınıftan çıkarılsın mı?';
  }

  @override
  String classDetailRemoved(String name) {
    return '$name sınıftan çıkarıldı';
  }

  @override
  String get classDetailRemoveError => 'Öğrenci çıkarılamadı, tekrar deneyin.';

  @override
  String get classDetailAssignHomework => 'Bu Sınıfa Ödev Ata';

  @override
  String get classDetailEmptyTitle => 'Henüz öğrenci yok';

  @override
  String get classDetailEmptyDesc => 'Yukarıdaki davet kodunu öğrencilerinle paylaş.';

  @override
  String get classDetailErrorCode => 'Davet kodu yüklenemedi';

  @override
  String get classDetailErrorList => 'Öğrenciler yüklenemedi';

  @override
  String get joinClassTitle => 'Sınıfa Katıl';

  @override
  String get joinClassHeroTitle => 'Yeni Bir Sınıf';

  @override
  String get joinClassHeroDesc => 'Öğretmeninin verdiği sınıf davet kodunu girerek öğrenme yolculuğuna başlayabilirsin.';

  @override
  String get joinClassCodePlaceholder => 'ABC123XY';

  @override
  String get joinClassCodeHint => 'Kodu öğretmeninden alabilirsin.';

  @override
  String get joinClassWhereTitle => 'Kod Nerede?';

  @override
  String get joinClassWhereDesc => 'Öğretmenin bu kodu tahtaya yansıtmış veya seninle paylaşmış olmalı.';

  @override
  String get joinClassSubmit => 'Katıl';

  @override
  String get joinClassSubmitting => 'Katılıyor…';

  @override
  String joinClassSuccess(String className) {
    return '$className sınıfına katıldın';
  }

  @override
  String get joinClassErrorInvalid => 'Bu kod geçerli değil. Kontrol edip tekrar dene.';

  @override
  String get joinClassErrorNetwork => 'Bağlanılamadı. Tekrar dene.';

  @override
  String get createGameStep1Subtitle => 'Öğrencilerin için en uygun etkileşimli bulmaca formatını belirle.';

  @override
  String get createGameStep2Subtitle => 'Bu bulmaca hangi kelime listesi kapsamında yer alacak?';

  @override
  String get createGameStep3Title => 'Sınıfları Ata';

  @override
  String get createGameStep3Subtitle => 'Bu bulmacayı çözecek hedef sınıfları belirle.';

  @override
  String get createGameStepBack => 'Geri Dön';

  @override
  String get createGameStepNext => 'Sonraki Adım';

  @override
  String get createGameClassesEmpty => 'Henüz sınıfın yok. Önce bir sınıf oluştur.';

  @override
  String get createGameClassesError => 'Sınıflar yüklenemedi.';

  @override
  String get createGameNoClassesTitle => 'Önce bir sınıf oluştur';

  @override
  String get createGameNoClassesDesc => 'Bulmaca atayabilmek için en az bir sınıfın olması gerekir.';

  @override
  String get createGameNoClassesAction => 'Sınıf Oluştur';

  @override
  String get notificationSettingsTitle => 'Bildirim Ayarları';

  @override
  String get notificationMasterTitle => 'Bildirimler';

  @override
  String get notificationMasterDesc => 'Uygulama bildirimlerini yönetin';

  @override
  String get notificationGroupAssignments => 'ÖDEV & BULMACA';

  @override
  String get notificationAssignedTitle => 'Yeni ödev/bulmaca atandığında';

  @override
  String get notificationAssignedDesc => 'Yeni içerikler yayınlandığında haberdar olun';

  @override
  String get notificationReminderTitle => 'Ödev hatırlatması';

  @override
  String get notificationReminderDesc => 'Süresi dolmak üzere olan ödevler için';

  @override
  String get notificationGroupResults => 'SONUÇLAR';

  @override
  String get notificationResultTeacherTitle => 'Öğrenci sonuç paylaştığında';

  @override
  String get notificationResultStudentTitle => 'Sonucum öğretmene ulaştığında';

  @override
  String get notificationGroupGeneral => 'GENEL';

  @override
  String get notificationAnnouncementsTitle => 'Duyurular ve güncellemeler';

  @override
  String get notificationQuietHoursTitle => 'Sessiz Saatler';

  @override
  String get notificationQuietHoursDesc => 'Gece saatlerinde bildirimleri susturarak odağınızı koruyun.';

  @override
  String get notificationQuietHoursCta => 'Şimdi Ayarla';

  @override
  String get notificationPrefsLoadError => 'Bildirim tercihleri yüklenemedi.';

  @override
  String get notificationPrefsSaveError => 'Bildirim tercihi kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get pushNotificationTitle => 'Bildirim';

  @override
  String get languagePreferenceTitle => 'Dil Tercihi';

  @override
  String get languageOptionTurkish => 'Türkçe';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageComingSoonBadge => 'Yakında';

  @override
  String get languageInfo => 'Seçtiğiniz dil tüm cihazlarınızda hesabınıza kaydedilir.';

  @override
  String get languageDecorationCaption => 'Global Öğrenim Topluluğu';

  @override
  String get helpCenterTitle => 'Yardım Merkezi';

  @override
  String get helpSearchPlaceholder => 'Yardım konusu ara';

  @override
  String get helpFaqSectionTitle => 'Sıkça Sorulan Sorular';

  @override
  String get helpFaqEmpty => 'Aramanızla eşleşen bir konu bulunamadı.';

  @override
  String get helpFaqQ1 => 'Nasıl sınıf oluştururum?';

  @override
  String get helpFaqA1 => 'Sınıf oluşturmak için ana menüdeki \"Sınıflarım\" sekmesine gidin. Sağ üstteki \"+\" butonuna dokunup sınıfa bir ad verin ve \"Kaydet\" deyin. Sınıf oluştuğunda otomatik bir davet kodu üretilir.';

  @override
  String get helpFaqQ2 => 'Öğrencileri nasıl davet ederim?';

  @override
  String get helpFaqA2 => 'Oluşturduğunuz sınıfın detayına girin. Sınıfın davet kodunu öğrencilerinizle paylaşın; öğrenci uygulamada \"Sınıfa Katıl\" ekranından bu kodu girerek sınıfınıza eklenir.';

  @override
  String get helpFaqQ3 => 'Bir derse nasıl kelime eklerim (OCR + manuel)?';

  @override
  String get helpFaqA3 => 'Ders detayında \"Kelime Ekle\" akışını başlatın. Manuel girişte İngilizce terimi ve Türkçe karşılığını yazarsınız. OCR için kelimeleri kâğıda yazıp kameradan veya galeriden okutursunuz; tanınan kelimeleri gözden geçirip düzenledikten sonra kaydedersiniz.';

  @override
  String get helpFaqQ4 => 'Bulmacayı nasıl oluşturup atarım?';

  @override
  String get helpFaqA4 => 'Kelime listenizi hazırladıktan sonra \"Yeni Bulmaca Oluştur\" akışını açın, oyun türünü ve kelime listesini seçin, ardından bulmacayı çözecek sınıfları belirleyip yayınlayın. Bulmaca aktif öğrencilere ödev olarak atanır.';

  @override
  String get helpFaqQ5 => 'Öğrenci sonuçlarını nerede görürüm?';

  @override
  String get helpFaqA5 => '\"Raporlar\" sekmesinden veya ilgili öğrencinin detayından paylaşılan sonuçları görebilirsiniz. Her sonuçta tamamlanma süresi ve başarı oranı yer alır.';

  @override
  String get helpFaqQ6 => 'Şifremi unuttum, ne yapmalıyım?';

  @override
  String get helpFaqA6 => 'Giriş ekranındaki \"Şifremi Unuttum\" bağlantısına dokunun ve kayıtlı e-posta adresinizi girin. Size gönderilecek talimatları izleyerek yeni bir şifre belirleyebilirsiniz.';

  @override
  String get helpContactTitle => 'Hâlâ yardıma mı ihtiyacın var?';

  @override
  String get helpContactDesc => 'Ekibimiz sorularını yanıtlamak için burada. Bize dilediğin zaman ulaşabilirsin.';

  @override
  String get helpContactCta => 'Bize Ulaşın';

  @override
  String get helpContactEmailSubject => 'LingoCross Destek Talebi';

  @override
  String helpContactCopied(String email) {
    return 'E-posta adresi kopyalandı: $email';
  }

  @override
  String get privacyPolicyTitle => 'Gizlilik Politikası';

  @override
  String get privacyLastUpdated => 'Son güncelleme: 24 Haziran 2026';

  @override
  String get privacyIntro => 'LingoCross olarak gizliliğinize büyük önem veriyoruz. Bu politika, uygulamamızı kullanırken verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.';

  @override
  String get privacySection1Title => '1. Topladığımız Bilgiler';

  @override
  String get privacySection1Body => 'Size daha iyi bir deneyim sunabilmek için belirli bilgileri topluyoruz. Bunlar arasında hesap bilgileri (ad soyad, e-posta adresi, rol), öğrenme verileri (oluşturulan dersler, çözülen bulmacalar, başarı ve süre sonuçları) ve teknik veriler (cihaz türü, işletim sistemi sürümü) yer alabilir.';

  @override
  String get privacySection2Title => '2. Bilgileri Nasıl Kullanırız';

  @override
  String get privacySection2Body => 'Topladığımız verileri yalnızca hizmeti sunmak ve geliştirmek için kullanırız: öğretmen-öğrenci eşleştirmesi, ders ve kelime yönetimi, oyun sonuçlarının paylaşılması ve ilerlemenin takibi. Kişisel verilerinizi reklam amacıyla üçüncü taraflara satmayız.';

  @override
  String get privacySection3Title => '3. Veri Saklama ve Güvenlik';

  @override
  String get privacySection3Body => 'Verileriniz endüstri standardı şifreleme (SSL/TLS) ile aktarılır ve güvenli sunucularda saklanır. Hesabınızı sildiğinizde, yasal saklama yükümlülükleri dışındaki kişisel verileriniz makul bir süre içinde kalıcı olarak silinir.';

  @override
  String get privacySection4Title => '4. Üçüncü Taraf Hizmetler';

  @override
  String get privacySection4Body => 'Uygulamanın çalışması için sınırlı sayıda güvenilir hizmet sağlayıcıyla (ör. barındırma ve altyapı sağlayıcıları) çalışabiliriz. Bu sağlayıcılar verilerinize yalnızca kendilerine verilen görevi yerine getirmek için sınırlı erişime sahiptir.';

  @override
  String get privacySection5Title => '5. Haklarınız';

  @override
  String get privacySection5Body => 'KVKK ve GDPR kapsamında verilerinize erişme, hatalı verilerin düzeltilmesini isteme ve verilerinizin silinmesini (unutulma hakkı) talep etme haklarına sahipsiniz.';

  @override
  String get privacyRight1 => 'Verilerinize erişim talep etme ve kopyasını alma.';

  @override
  String get privacyRight2 => 'Hatalı verilerin düzeltilmesini isteme.';

  @override
  String get privacyRight3 => 'Verilerinizin tamamen silinmesini talep etme.';

  @override
  String get privacySection6Title => '6. İletişim';

  @override
  String get privacySection6Body => 'Gizlilik politikamızla ilgili sorularınız için bizimle iletişime geçebilirsiniz:';

  @override
  String get privacyContactEmail => 'support@duocross.com';

  @override
  String get privacyContactLocation => 'Maslak, İstanbul / Türkiye';

  @override
  String get privacyContactEmailSubject => 'LingoCross Gizlilik Sorusu';

  @override
  String get paywallTitle => 'Premium';

  @override
  String get paywallHeadline => 'LingoCross Premium';

  @override
  String get paywallSubtitle => 'Tüm özelliklerin kilidini aç';

  @override
  String get paywallBannerOcr => 'AI ile kelime tarama Premium\'da';

  @override
  String get paywallBannerClassLimit => 'Sınırsız sınıf Premium\'da';

  @override
  String get paywallBannerLessonLimit => 'Sınırsız ders Premium\'da';

  @override
  String get paywallBannerMultiTeacher => 'Birden fazla öğretmen Premium\'da';

  @override
  String get paywallBannerPuzzleCreate => 'Bulmaca oluşturma Premium\'da';

  @override
  String get paywallBannerDefault => 'Tüm özellikler Premium\'da';

  @override
  String get paywallBenefitUnlimitedClasses => 'Sınırsız sınıf ve ders';

  @override
  String get paywallBenefitOcr => 'AI ile kelime tarama';

  @override
  String get paywallBenefitMultiTeacher => 'Birden fazla öğretmene katılma';

  @override
  String get paywallBenefitReports => 'Tüm raporlar ve istatistikler';

  @override
  String get paywallPlanMonthlyTitle => 'Aylık';

  @override
  String get paywallPlanMonthlySubtitle => 'Her ay otomatik yenilenir';

  @override
  String get paywallPlanMonthlyPeriod => '/ay';

  @override
  String get paywallPlanAnnualTitle => 'Yıllık';

  @override
  String get paywallPlanAnnualSubtitle => 'Yıllık ödeme, karlı seçim';

  @override
  String get paywallPlanAnnualPeriod => '/yıl';

  @override
  String get paywallPlanBestValue => 'En Avantajlı';

  @override
  String get paywallPlanPriceComingSoon => '—';

  @override
  String get paywallTrialNote => '7 gün ücretsiz dene, istediğin zaman iptal et.';

  @override
  String get paywallCta => 'Premium\'a Yükselt';

  @override
  String get paywallSkip => 'Şimdilik geç';

  @override
  String get paywallActivateSuccess => 'Premium etkinleştirildi.';

  @override
  String get paywallPurchaseDisabled => 'Şu an satın alma kapalı (test).';

  @override
  String get paywallActivateError => 'Bir hata oluştu, lütfen tekrar deneyin.';

  @override
  String get paywallRestore => 'Satın Alımları Geri Yükle';

  @override
  String get paywallAutoRenewNote => 'Abonelik otomatik yenilenir, istediğin zaman iptal edebilirsin.';

  @override
  String get paywallPrivacyLink => 'Gizlilik Politikası';

  @override
  String get paywallTermsLink => 'Kullanım Koşulları';

  @override
  String get paywallRestoreSuccess => 'Premium geri yüklendi.';

  @override
  String get paywallPurchaseSuccess => 'Premium etkinleştirildi.';

  @override
  String get paywallPurchaseCanceled => 'Satın alma iptal edildi.';

  @override
  String get paywallPurchaseError => 'Satın alma tamamlanamadı, lütfen tekrar deneyin.';

  @override
  String get paywallProductsUnavailable => 'Mağazaya şu an ulaşılamıyor.';

  @override
  String get paywallProductsError => 'Abonelik bilgileri yüklenemedi.';

  @override
  String get paywallPriceUnavailable => '—';

  @override
  String get lockedFeatureLabel => 'Premium';
}
