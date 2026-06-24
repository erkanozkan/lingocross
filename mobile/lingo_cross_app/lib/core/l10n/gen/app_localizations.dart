import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// Uygulama / wordmark adı.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross'**
  String get appName;

  /// No description provided for @authFooterCopyright.
  ///
  /// In tr, this message translates to:
  /// **'© 2026 LingoCross'**
  String get authFooterCopyright;

  /// No description provided for @authFooterPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get authFooterPrivacy;

  /// No description provided for @authFooterTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get authFooterTerms;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross\'a Hoş Geldiniz'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil yolculuğuna bugün başla, sınırları ortadan kaldır.'**
  String get authWelcomeSubtitle;

  /// No description provided for @authWelcomeBadgeHi.
  ///
  /// In tr, this message translates to:
  /// **'Hi!'**
  String get authWelcomeBadgeHi;

  /// No description provided for @authWelcomeBadgeMerhaba.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba!'**
  String get authWelcomeBadgeMerhaba;

  /// No description provided for @authLoginEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresi'**
  String get authLoginEmailLabel;

  /// No description provided for @authLoginEmailPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'isim@ornek.com'**
  String get authLoginEmailPlaceholder;

  /// No description provided for @authLoginPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get authLoginPasswordLabel;

  /// No description provided for @authLoginPasswordPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'••••••••'**
  String get authLoginPasswordPlaceholder;

  /// No description provided for @authLoginForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum?'**
  String get authLoginForgotPassword;

  /// No description provided for @authLoginSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authLoginSubmit;

  /// No description provided for @authLoginNoAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın yok mu?'**
  String get authLoginNoAccount;

  /// No description provided for @authLoginSignupCta.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz kayıt ol'**
  String get authLoginSignupCta;

  /// No description provided for @authLoginErrorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get authLoginErrorInvalidCredentials;

  /// No description provided for @authLoginErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get authLoginErrorNetwork;

  /// No description provided for @authLoginRememberMe.
  ///
  /// In tr, this message translates to:
  /// **'Beni Hatırla'**
  String get authLoginRememberMe;

  /// No description provided for @authRegisterAppbarLogin.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authRegisterAppbarLogin;

  /// No description provided for @authRegisterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yolculuğuna Başla'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Binlerce dil öğrenicisine hemen katıl.'**
  String get authRegisterSubtitle;

  /// No description provided for @authRegisterRoleStudent.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get authRegisterRoleStudent;

  /// No description provided for @authRegisterRoleTeacher.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen'**
  String get authRegisterRoleTeacher;

  /// No description provided for @authRegisterRoleGroupLabel.
  ///
  /// In tr, this message translates to:
  /// **'Rol'**
  String get authRegisterRoleGroupLabel;

  /// No description provided for @authRegisterFullNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get authRegisterFullNameLabel;

  /// No description provided for @authRegisterFullNamePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Alex Rivera'**
  String get authRegisterFullNamePlaceholder;

  /// No description provided for @authRegisterEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresi'**
  String get authRegisterEmailLabel;

  /// No description provided for @authRegisterEmailPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'alex@ornek.com'**
  String get authRegisterEmailPlaceholder;

  /// No description provided for @authRegisterPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Oluştur'**
  String get authRegisterPasswordLabel;

  /// No description provided for @authRegisterPasswordPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'••••••••'**
  String get authRegisterPasswordPlaceholder;

  /// No description provided for @authRegisterTermsPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Kabul ediyorum:'**
  String get authRegisterTermsPrefix;

  /// No description provided for @authRegisterTermsTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get authRegisterTermsTerms;

  /// No description provided for @authRegisterTermsAnd.
  ///
  /// In tr, this message translates to:
  /// **'ve'**
  String get authRegisterTermsAnd;

  /// No description provided for @authRegisterTermsPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get authRegisterTermsPrivacy;

  /// No description provided for @authRegisterSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get authRegisterSubmit;

  /// No description provided for @authRegisterHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten bir hesabın var mı?'**
  String get authRegisterHaveAccount;

  /// No description provided for @authRegisterLoginCta.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authRegisterLoginCta;

  /// No description provided for @authRegisterErrorEmailTaken.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta zaten kullanımda.'**
  String get authRegisterErrorEmailTaken;

  /// No description provided for @authRegisterErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get authRegisterErrorNetwork;

  /// No description provided for @authForgotTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get authForgotTitle;

  /// No description provided for @authForgotDescription.
  ///
  /// In tr, this message translates to:
  /// **'Endişelenmeyin! Hesabınızla ilişkili e-posta adresini girin, size bir kurtarma bağlantısı gönderelim.'**
  String get authForgotDescription;

  /// No description provided for @authForgotEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Adresi'**
  String get authForgotEmailLabel;

  /// No description provided for @authForgotEmailPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'ad@ornek.com'**
  String get authForgotEmailPlaceholder;

  /// No description provided for @authForgotSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırlama Bağlantısı Gönder'**
  String get authForgotSubmit;

  /// No description provided for @authForgotSuccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Gönderildi!'**
  String get authForgotSuccessTitle;

  /// No description provided for @authForgotSuccessDescription.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırlama bağlantısı için gelen kutunuzu kontrol edin. Göremezseniz spam klasörüne bakın.'**
  String get authForgotSuccessDescription;

  /// No description provided for @authForgotSuccessResend.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar gönder'**
  String get authForgotSuccessResend;

  /// No description provided for @authForgotSupportPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Hâlâ sorun mu yaşıyorsunuz?'**
  String get authForgotSupportPrefix;

  /// No description provided for @authForgotSupportContact.
  ///
  /// In tr, this message translates to:
  /// **'Destekle İletişime Geçin'**
  String get authForgotSupportContact;

  /// No description provided for @authForgotErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get authForgotErrorNetwork;

  /// No description provided for @authValidationEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi gerekli.'**
  String get authValidationEmailRequired;

  /// No description provided for @authValidationEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin.'**
  String get authValidationEmailInvalid;

  /// No description provided for @authValidationPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre gerekli.'**
  String get authValidationPasswordRequired;

  /// No description provided for @authValidationPasswordTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter olmalı.'**
  String get authValidationPasswordTooShort;

  /// No description provided for @authValidationFullNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ad soyad gerekli.'**
  String get authValidationFullNameRequired;

  /// No description provided for @authValidationTermsRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için koşulları kabul edin.'**
  String get authValidationTermsRequired;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti. Lütfen tekrar deneyin.'**
  String get commonErrorGeneric;

  /// No description provided for @homeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get homeTitle;

  /// No description provided for @homeTeacherWelcome.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldin, Öğretmen'**
  String get homeTeacherWelcome;

  /// No description provided for @homeStudentWelcome.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldin, Öğrenci'**
  String get homeStudentWelcome;

  /// No description provided for @homePlaceholderBody.
  ///
  /// In tr, this message translates to:
  /// **'Panel yakında burada olacak.'**
  String get homePlaceholderBody;

  /// No description provided for @homeLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get homeLogout;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get commonRetry;

  /// No description provided for @commonUndo.
  ///
  /// In tr, this message translates to:
  /// **'Geri Al'**
  String get commonUndo;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get commonCancel;

  /// No description provided for @commonComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get commonComingSoon;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navReports.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar'**
  String get navReports;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @teacherDashboardGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Hoş Geldiniz, {name}'**
  String teacherDashboardGreeting(String name);

  /// No description provided for @teacherDashboardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen Paneli • Bugün {count} yeni raporunuz var.'**
  String teacherDashboardSubtitle(int count);

  /// No description provided for @teacherDashboardSubtitleEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen Paneli • Yeni rapor yok.'**
  String get teacherDashboardSubtitleEmpty;

  /// No description provided for @teacherDashboardStreak.
  ///
  /// In tr, this message translates to:
  /// **'{days} Gün'**
  String teacherDashboardStreak(int days);

  /// No description provided for @teacherDashboardActionNewLessonTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ders Oluştur'**
  String get teacherDashboardActionNewLessonTitle;

  /// No description provided for @teacherDashboardActionNewLessonDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kendi kelime listenizle dakikalar içinde yeni bir ders hazırlayın.'**
  String get teacherDashboardActionNewLessonDesc;

  /// No description provided for @teacherDashboardActionNewPuzzleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bulmaca Oluştur'**
  String get teacherDashboardActionNewPuzzleTitle;

  /// No description provided for @teacherDashboardActionNewPuzzleDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bir dersin kelimelerinden öğrencilerine bulmaca hazırla ve yayınla.'**
  String get teacherDashboardActionNewPuzzleDesc;

  /// No description provided for @teacherDashboardActionProgressTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Gelişimi'**
  String get teacherDashboardActionProgressTitle;

  /// No description provided for @teacherDashboardActionProgressDesc.
  ///
  /// In tr, this message translates to:
  /// **'Sınıfların performansını ve bireysel öğrenci raporlarını inceleyin.'**
  String get teacherDashboardActionProgressDesc;

  /// No description provided for @teacherDashboardLessonsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Derslerim'**
  String get teacherDashboardLessonsTitle;

  /// No description provided for @teacherDashboardSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get teacherDashboardSeeAll;

  /// No description provided for @teacherDashboardLessonNoStudents.
  ///
  /// In tr, this message translates to:
  /// **'Henüz öğrenci yok'**
  String get teacherDashboardLessonNoStudents;

  /// No description provided for @teacherDashboardReportsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Öğrenci Raporları'**
  String get teacherDashboardReportsTitle;

  /// No description provided for @teacherDashboardEmptyLessonsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz dersiniz yok'**
  String get teacherDashboardEmptyLessonsTitle;

  /// No description provided for @teacherDashboardEmptyLessonsDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk dersinizi oluşturarak başlayın.'**
  String get teacherDashboardEmptyLessonsDesc;

  /// No description provided for @teacherDashboardEmptyReports.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler sonuç paylaştıkça burada görünecek.'**
  String get teacherDashboardEmptyReports;

  /// No description provided for @teacherDashboardReportsError.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar yüklenemedi'**
  String get teacherDashboardReportsError;

  /// No description provided for @teacherDashboardError.
  ///
  /// In tr, this message translates to:
  /// **'Dersler yüklenemedi'**
  String get teacherDashboardError;

  /// No description provided for @teacherDashboardLessonCreated.
  ///
  /// In tr, this message translates to:
  /// **'Ders oluşturuldu'**
  String get teacherDashboardLessonCreated;

  /// No description provided for @teacherDashboardWordCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String teacherDashboardWordCount(int count);

  /// No description provided for @teacherDashboardLessonPublished.
  ///
  /// In tr, this message translates to:
  /// **'Yayında'**
  String get teacherDashboardLessonPublished;

  /// No description provided for @teacherDashboardLessonDraft.
  ///
  /// In tr, this message translates to:
  /// **'Taslak'**
  String get teacherDashboardLessonDraft;

  /// No description provided for @teacherDashboardOpenProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili aç'**
  String get teacherDashboardOpenProfile;

  /// No description provided for @navClasses.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflar'**
  String get navClasses;

  /// No description provided for @lessonStatusDraft.
  ///
  /// In tr, this message translates to:
  /// **'Taslak'**
  String get lessonStatusDraft;

  /// No description provided for @lessonStatusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get lessonStatusActive;

  /// No description provided for @lessonStatusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı'**
  String get lessonStatusCompleted;

  /// No description provided for @lessonStatusDraftUpper.
  ///
  /// In tr, this message translates to:
  /// **'TASLAK'**
  String get lessonStatusDraftUpper;

  /// No description provided for @lessonStatusActiveUpper.
  ///
  /// In tr, this message translates to:
  /// **'AKTİF'**
  String get lessonStatusActiveUpper;

  /// No description provided for @lessonStatusCompletedUpper.
  ///
  /// In tr, this message translates to:
  /// **'TAMAMLANDI'**
  String get lessonStatusCompletedUpper;

  /// No description provided for @lessonsListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Derslerim'**
  String get lessonsListTitle;

  /// No description provided for @lessonsListCreate.
  ///
  /// In tr, this message translates to:
  /// **'+ Yeni Ders Oluştur'**
  String get lessonsListCreate;

  /// No description provided for @lessonsListSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Dersler'**
  String get lessonsListSectionTitle;

  /// No description provided for @lessonsListTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {count}'**
  String lessonsListTotal(int count);

  /// No description provided for @lessonsListWordCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} Kelime'**
  String lessonsListWordCount(int count);

  /// No description provided for @lessonsListEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz dersiniz yok'**
  String get lessonsListEmptyTitle;

  /// No description provided for @lessonsListEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk dersinizi oluşturarak başlayın.'**
  String get lessonsListEmptyDesc;

  /// No description provided for @lessonsListError.
  ///
  /// In tr, this message translates to:
  /// **'Dersler yüklenemedi'**
  String get lessonsListError;

  /// No description provided for @lessonsListNoDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih belirtilmedi'**
  String get lessonsListNoDate;

  /// No description provided for @lessonsListFooterHint.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş derslerinizi görmek için kaydırın'**
  String get lessonsListFooterHint;

  /// No description provided for @reportsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar'**
  String get reportsTitle;

  /// No description provided for @teacherProfileRoleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen'**
  String get teacherProfileRoleLabel;

  /// No description provided for @teacherProfileStatClasses.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf'**
  String get teacherProfileStatClasses;

  /// No description provided for @teacherProfileStatStudents.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get teacherProfileStatStudents;

  /// No description provided for @teacherProfileStatParticipation.
  ///
  /// In tr, this message translates to:
  /// **'Katılım'**
  String get teacherProfileStatParticipation;

  /// No description provided for @teacherProfileWeeklyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Ödev Tamamlama'**
  String get teacherProfileWeeklyTitle;

  /// No description provided for @teacherProfileWeeklyDesc.
  ///
  /// In tr, this message translates to:
  /// **'{done}/{total} ödev tamamlandı'**
  String teacherProfileWeeklyDesc(int done, int total);

  /// No description provided for @teacherProfileWeeklyHint.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflarınızın ödev tamamlama oranı geçen haftaya göre %{percent} arttı!'**
  String teacherProfileWeeklyHint(int percent);

  /// No description provided for @teacherProfileWeeklyEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta atanmış ödev yok.'**
  String get teacherProfileWeeklyEmpty;

  /// No description provided for @teacherProfileStatValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String teacherProfileStatValue(int percent);

  /// No description provided for @teacherProfileStatsError.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler yüklenemedi.'**
  String get teacherProfileStatsError;

  /// No description provided for @teacherProfileBadgesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen Rozetleri'**
  String get teacherProfileBadgesTitle;

  /// No description provided for @teacherProfileBadgePopular.
  ///
  /// In tr, this message translates to:
  /// **'Popüler Eğitmen'**
  String get teacherProfileBadgePopular;

  /// No description provided for @teacherProfileBadgeFast.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Değerlendirici'**
  String get teacherProfileBadgeFast;

  /// No description provided for @teacherProfileBadgeInspiring.
  ///
  /// In tr, this message translates to:
  /// **'İlham Veren'**
  String get teacherProfileBadgeInspiring;

  /// No description provided for @teacherProfileMenuClasses.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf Yönetimi'**
  String get teacherProfileMenuClasses;

  /// No description provided for @teacherProfileMenuLessons.
  ///
  /// In tr, this message translates to:
  /// **'Derslerim'**
  String get teacherProfileMenuLessons;

  /// No description provided for @teacherProfileMenuReports.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler ve Raporlar'**
  String get teacherProfileMenuReports;

  /// No description provided for @teacherProfileMenuSettings.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Ayarları'**
  String get teacherProfileMenuSettings;

  /// No description provided for @teacherProfileMenuLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get teacherProfileMenuLogout;

  /// No description provided for @teacherProfileStatsSoon.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler yakında — öğrenciler oyun oynadıkça dolacak.'**
  String get teacherProfileStatsSoon;

  /// Öğrenci profil ekranında ad altındaki rol etiketi.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get studentProfileRoleLabel;

  /// No description provided for @studentProfileSettingsTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get studentProfileSettingsTooltip;

  /// No description provided for @studentProfileStatStreak.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Seri'**
  String get studentProfileStatStreak;

  /// No description provided for @studentProfileStatGames.
  ///
  /// In tr, this message translates to:
  /// **'Oyun'**
  String get studentProfileStatGames;

  /// No description provided for @studentProfileStatAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Doğruluk'**
  String get studentProfileStatAccuracy;

  /// No description provided for @studentProfileStatsError.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler yüklenemedi.'**
  String get studentProfileStatsError;

  /// No description provided for @studentProfileWeeklyGoalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Hedef'**
  String get studentProfileWeeklyGoalTitle;

  /// No description provided for @studentProfileWeeklyGoalSoon.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık hedef takibi yakında — oyun oynadıkça ilerlemeni burada göreceksin.'**
  String get studentProfileWeeklyGoalSoon;

  /// No description provided for @studentProfileAchievementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başarılarım'**
  String get studentProfileAchievementsTitle;

  /// No description provided for @studentProfileBadgeFastStart.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Başlangıç'**
  String get studentProfileBadgeFastStart;

  /// No description provided for @studentProfileBadgeWordHunter.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Avcısı'**
  String get studentProfileBadgeWordHunter;

  /// No description provided for @studentProfileBadgeQuizMaster.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Ustası'**
  String get studentProfileBadgeQuizMaster;

  /// No description provided for @studentProfileBadgeLocked.
  ///
  /// In tr, this message translates to:
  /// **'Poliglot'**
  String get studentProfileBadgeLocked;

  /// No description provided for @studentProfileMenuAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Ayarları'**
  String get studentProfileMenuAccount;

  /// No description provided for @studentProfileMenuNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Tercihleri'**
  String get studentProfileMenuNotifications;

  /// No description provided for @studentProfileMenuHelp.
  ///
  /// In tr, this message translates to:
  /// **'Yardım ve Destek'**
  String get studentProfileMenuHelp;

  /// No description provided for @studentProfileMenuLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get studentProfileMenuLogout;

  /// No description provided for @lessonFormHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Harika bir ders planla!'**
  String get lessonFormHeroTitle;

  /// No description provided for @lessonFormHeroDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencilerin yeni şeyler öğrenmeye hazır.'**
  String get lessonFormHeroDesc;

  /// No description provided for @lessonFormFieldScheduleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ders Tarihi / Haftası'**
  String get lessonFormFieldScheduleLabel;

  /// No description provided for @lessonFormFieldSchedulePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn: 15-21 Temmuz 2024'**
  String get lessonFormFieldSchedulePlaceholder;

  /// No description provided for @lessonFormFieldUnitLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ünite Adı veya Numarası'**
  String get lessonFormFieldUnitLabel;

  /// No description provided for @lessonFormFieldUnitPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Unit 4: Food & Drinks'**
  String get lessonFormFieldUnitPlaceholder;

  /// No description provided for @lessonFormFieldTopicsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ders Detayları ve Konular'**
  String get lessonFormFieldTopicsLabel;

  /// No description provided for @lessonFormFieldTopicsPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Bu derste hangi konuları işleyeceksiniz? Önemli notları buraya ekleyin...'**
  String get lessonFormFieldTopicsPlaceholder;

  /// No description provided for @lessonFormVocabTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ünite Kelime Listesi'**
  String get lessonFormVocabTitle;

  /// No description provided for @lessonFormVocabDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu üniteye ait kelimeleri görüntüle veya yeni kelimeler ekle.'**
  String get lessonFormVocabDesc;

  /// No description provided for @lessonFormVocabSaveFirst.
  ///
  /// In tr, this message translates to:
  /// **'Önce dersi kaydedin, sonra kelime ekleyin.'**
  String get lessonFormVocabSaveFirst;

  /// No description provided for @lessonFormInfoNote.
  ///
  /// In tr, this message translates to:
  /// **'Dersi kaydettiğinizde tüm öğrencileriniz bildirim alacaktır. Planlamalarınızı istediğiniz zaman düzenleyebilirsiniz.'**
  String get lessonFormInfoNote;

  /// No description provided for @lessonFormSaveAndShare.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Kaydet ve Paylaş'**
  String get lessonFormSaveAndShare;

  /// No description provided for @lessonDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ders Detayı'**
  String get lessonDetailTitle;

  /// No description provided for @lessonDetailScheduleNone.
  ///
  /// In tr, this message translates to:
  /// **'Tarih belirtilmedi'**
  String get lessonDetailScheduleNone;

  /// No description provided for @lessonDetailSharedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan Sınıflar'**
  String get lessonDetailSharedTitle;

  /// No description provided for @lessonDetailSharedCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} öğrenciye açık'**
  String lessonDetailSharedCount(int count);

  /// No description provided for @lessonDetailSharedNone.
  ///
  /// In tr, this message translates to:
  /// **'Henüz öğrenciye açık değil'**
  String get lessonDetailSharedNone;

  /// No description provided for @lessonDetailSharedDraft.
  ///
  /// In tr, this message translates to:
  /// **'Ders taslakta — yayınlanınca öğrencilere açılır'**
  String get lessonDetailSharedDraft;

  /// No description provided for @lessonDetailContentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ders İçeriği'**
  String get lessonDetailContentTitle;

  /// No description provided for @lessonDetailContentEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu ders için içerik girilmemiş.'**
  String get lessonDetailContentEmpty;

  /// No description provided for @lessonDetailWordsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Listesi'**
  String get lessonDetailWordsTitle;

  /// No description provided for @lessonDetailWordsSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get lessonDetailWordsSeeAll;

  /// No description provided for @lessonDetailWordsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kelime eklenmemiş.'**
  String get lessonDetailWordsEmpty;

  /// No description provided for @lessonDetailAddWords.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Ekle'**
  String get lessonDetailAddWords;

  /// No description provided for @lessonDetailEdit.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Düzenle'**
  String get lessonDetailEdit;

  /// No description provided for @lessonDetailAssignHomework.
  ///
  /// In tr, this message translates to:
  /// **'Ödev Ataması Yap'**
  String get lessonDetailAssignHomework;

  /// No description provided for @lessonDetailPublish.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla'**
  String get lessonDetailPublish;

  /// No description provided for @lessonDetailUnpublish.
  ///
  /// In tr, this message translates to:
  /// **'Yayından Kaldır'**
  String get lessonDetailUnpublish;

  /// No description provided for @lessonDetailComplete.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı İşaretle'**
  String get lessonDetailComplete;

  /// No description provided for @lessonDetailPublishedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders yayınlandı'**
  String get lessonDetailPublishedSnack;

  /// No description provided for @lessonDetailUnpublishedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders yayından kaldırıldı'**
  String get lessonDetailUnpublishedSnack;

  /// No description provided for @lessonDetailCompletedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders tamamlandı olarak işaretlendi'**
  String get lessonDetailCompletedSnack;

  /// No description provided for @lessonDetailActionError.
  ///
  /// In tr, this message translates to:
  /// **'İşlem başarısız, tekrar deneyin.'**
  String get lessonDetailActionError;

  /// No description provided for @lessonDetailError.
  ///
  /// In tr, this message translates to:
  /// **'Ders yüklenemedi'**
  String get lessonDetailError;

  /// No description provided for @lessonFormTitleCreate.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ders'**
  String get lessonFormTitleCreate;

  /// No description provided for @lessonFormTitleEdit.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Düzenle'**
  String get lessonFormTitleEdit;

  /// No description provided for @lessonFormFieldTitleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ders Başlığı'**
  String get lessonFormFieldTitleLabel;

  /// No description provided for @lessonFormFieldTitlePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn. 9-A İngilizce Ünite 3'**
  String get lessonFormFieldTitlePlaceholder;

  /// No description provided for @lessonFormFieldTitleRequired.
  ///
  /// In tr, this message translates to:
  /// **'Ders başlığı gerekli'**
  String get lessonFormFieldTitleRequired;

  /// No description provided for @lessonFormFieldDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama (isteğe bağlı)'**
  String get lessonFormFieldDescriptionLabel;

  /// No description provided for @lessonFormFieldDescriptionPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Bu ders hakkında kısa bir not…'**
  String get lessonFormFieldDescriptionPlaceholder;

  /// No description provided for @lessonFormFieldSourceLangLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak Dil'**
  String get lessonFormFieldSourceLangLabel;

  /// No description provided for @lessonFormFieldTargetLangLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Dil'**
  String get lessonFormFieldTargetLangLabel;

  /// No description provided for @lessonFormFieldLangSameError.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak ve hedef dil aynı olamaz'**
  String get lessonFormFieldLangSameError;

  /// No description provided for @lessonFormStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yayın Durumu'**
  String get lessonFormStatusLabel;

  /// No description provided for @lessonFormStatusDraft.
  ///
  /// In tr, this message translates to:
  /// **'Taslak'**
  String get lessonFormStatusDraft;

  /// No description provided for @lessonFormStatusPublished.
  ///
  /// In tr, this message translates to:
  /// **'Yayında'**
  String get lessonFormStatusPublished;

  /// No description provided for @lessonFormStatusDraftHint.
  ///
  /// In tr, this message translates to:
  /// **'Taslak dersi yalnız siz görürsünüz.'**
  String get lessonFormStatusDraftHint;

  /// No description provided for @lessonFormStatusPublishedHint.
  ///
  /// In tr, this message translates to:
  /// **'Yayındaki ders öğrencilerinizle paylaşılır.'**
  String get lessonFormStatusPublishedHint;

  /// No description provided for @lessonFormSubmitCreate.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Oluştur'**
  String get lessonFormSubmitCreate;

  /// No description provided for @lessonFormSubmitEdit.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Kaydet'**
  String get lessonFormSubmitEdit;

  /// No description provided for @lessonFormSubmitting.
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor…'**
  String get lessonFormSubmitting;

  /// No description provided for @lessonFormDelete.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Sil'**
  String get lessonFormDelete;

  /// No description provided for @lessonFormDeleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu ders ve içindeki tüm kelimeler silinecek. Emin misiniz?'**
  String get lessonFormDeleteConfirm;

  /// No description provided for @lessonFormDiscardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilmemiş değişiklikler'**
  String get lessonFormDiscardTitle;

  /// No description provided for @lessonFormDiscardConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Çık'**
  String get lessonFormDiscardConfirm;

  /// No description provided for @lessonFormDiscardCancel.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlemeye Dön'**
  String get lessonFormDiscardCancel;

  /// No description provided for @lessonFormError.
  ///
  /// In tr, this message translates to:
  /// **'Ders kaydedilemedi, tekrar deneyin.'**
  String get lessonFormError;

  /// No description provided for @lessonFormCreatedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders oluşturuldu'**
  String get lessonFormCreatedSnack;

  /// No description provided for @lessonFormUpdatedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders güncellendi'**
  String get lessonFormUpdatedSnack;

  /// No description provided for @lessonFormDeletedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ders silindi'**
  String get lessonFormDeletedSnack;

  /// No description provided for @lessonFormPublishNoWordsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu derste henüz kelime yok.'**
  String get lessonFormPublishNoWordsTitle;

  /// No description provided for @lessonFormPublishNoWordsConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yine de yayınlansın mı?'**
  String get lessonFormPublishNoWordsConfirm;

  /// No description provided for @lessonFormPublishNoWordsPublish.
  ///
  /// In tr, this message translates to:
  /// **'Yayınla'**
  String get lessonFormPublishNoWordsPublish;

  /// No description provided for @lessonFormPublishNoWordsAddWords.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Ekle'**
  String get lessonFormPublishNoWordsAddWords;

  /// No description provided for @langEnglish.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get langEnglish;

  /// No description provided for @langTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @langNameEnglish.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get langNameEnglish;

  /// No description provided for @langNameTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langNameTurkish;

  /// No description provided for @langNameGerman.
  ///
  /// In tr, this message translates to:
  /// **'Almanca'**
  String get langNameGerman;

  /// No description provided for @langNameSpanish.
  ///
  /// In tr, this message translates to:
  /// **'İspanyolca'**
  String get langNameSpanish;

  /// No description provided for @langNameFrench.
  ///
  /// In tr, this message translates to:
  /// **'Fransızca'**
  String get langNameFrench;

  /// No description provided for @langNameItalian.
  ///
  /// In tr, this message translates to:
  /// **'İtalyanca'**
  String get langNameItalian;

  /// No description provided for @wordsListCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String wordsListCount(int count);

  /// No description provided for @wordsListWordUnit.
  ///
  /// In tr, this message translates to:
  /// **'kelime'**
  String get wordsListWordUnit;

  /// No description provided for @wordsListLangDir.
  ///
  /// In tr, this message translates to:
  /// **'{source} → {target}'**
  String wordsListLangDir(String source, String target);

  /// No description provided for @wordsListScan.
  ///
  /// In tr, this message translates to:
  /// **'Kameradan Tara'**
  String get wordsListScan;

  /// No description provided for @wordsListAddManual.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Ekle'**
  String get wordsListAddManual;

  /// No description provided for @wordsListSourceOcr.
  ///
  /// In tr, this message translates to:
  /// **'OCR'**
  String get wordsListSourceOcr;

  /// No description provided for @wordsListSourceManual.
  ///
  /// In tr, this message translates to:
  /// **'Manuel'**
  String get wordsListSourceManual;

  /// No description provided for @wordsListSynonymPrefix.
  ///
  /// In tr, this message translates to:
  /// **'eş anlamlı:'**
  String get wordsListSynonymPrefix;

  /// No description provided for @wordsListEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kelime yok'**
  String get wordsListEmptyTitle;

  /// No description provided for @wordsListEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kameradan tarayın veya elle ekleyin.'**
  String get wordsListEmptyDesc;

  /// No description provided for @wordsListDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Kelime silindi'**
  String get wordsListDeleted;

  /// No description provided for @wordsListError.
  ///
  /// In tr, this message translates to:
  /// **'Kelimeler yüklenemedi'**
  String get wordsListError;

  /// No description provided for @wordsListMenuEditLesson.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Düzenle'**
  String get wordsListMenuEditLesson;

  /// No description provided for @wordsListMenuDeleteLesson.
  ///
  /// In tr, this message translates to:
  /// **'Dersi Sil'**
  String get wordsListMenuDeleteLesson;

  /// No description provided for @wordsFormTitleAdd.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Ekle'**
  String get wordsFormTitleAdd;

  /// No description provided for @wordsFormTitleEdit.
  ///
  /// In tr, this message translates to:
  /// **'Kelimeyi Düzenle'**
  String get wordsFormTitleEdit;

  /// No description provided for @wordsFormTermLabel.
  ///
  /// In tr, this message translates to:
  /// **'Terim ({sourceLang})'**
  String wordsFormTermLabel(String sourceLang);

  /// No description provided for @wordsFormTermPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn. environment'**
  String get wordsFormTermPlaceholder;

  /// No description provided for @wordsFormTermRequired.
  ///
  /// In tr, this message translates to:
  /// **'Terim gerekli'**
  String get wordsFormTermRequired;

  /// No description provided for @wordsFormMeaningLabel.
  ///
  /// In tr, this message translates to:
  /// **'{lang} Karşılık(lar)'**
  String wordsFormMeaningLabel(String lang);

  /// No description provided for @wordsFormMeaningPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn. çevre'**
  String get wordsFormMeaningPlaceholder;

  /// No description provided for @wordsFormMeaningAddMore.
  ///
  /// In tr, this message translates to:
  /// **'Karşılık Ekle'**
  String get wordsFormMeaningAddMore;

  /// No description provided for @wordsFormMeaningRequired.
  ///
  /// In tr, this message translates to:
  /// **'En az bir karşılık girin'**
  String get wordsFormMeaningRequired;

  /// No description provided for @wordsFormMeaningPrimaryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Birincil karşılık'**
  String get wordsFormMeaningPrimaryLabel;

  /// No description provided for @wordsFormMeaningRemoveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Karşılık {index}, sil'**
  String wordsFormMeaningRemoveLabel(int index);

  /// No description provided for @wordsFormSynonymsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Eş anlamlılar (isteğe bağlı)'**
  String get wordsFormSynonymsLabel;

  /// No description provided for @wordsFormSynonymsHint.
  ///
  /// In tr, this message translates to:
  /// **'Aynı anlama gelen başka terimler. Oyunda ipucu olarak kullanılır.'**
  String get wordsFormSynonymsHint;

  /// No description provided for @wordsFormSynonymsPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Eş anlamlı yazıp ekleyin'**
  String get wordsFormSynonymsPlaceholder;

  /// No description provided for @wordsFormSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get wordsFormSave;

  /// No description provided for @wordsFormSaveAndNew.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet ve Yeni Ekle'**
  String get wordsFormSaveAndNew;

  /// No description provided for @wordsFormCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get wordsFormCancel;

  /// No description provided for @wordsFormSaving.
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor…'**
  String get wordsFormSaving;

  /// No description provided for @wordsFormError.
  ///
  /// In tr, this message translates to:
  /// **'Kelime kaydedilemedi, tekrar deneyin.'**
  String get wordsFormError;

  /// No description provided for @wordsFormAddedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Kelime eklendi'**
  String get wordsFormAddedSnack;

  /// No description provided for @wordsFormUpdatedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Kelime güncellendi'**
  String get wordsFormUpdatedSnack;

  /// No description provided for @lessonsErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get lessonsErrorNetwork;

  /// No description provided for @lessonsErrorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'İçerik bulunamadı.'**
  String get lessonsErrorNotFound;

  /// No description provided for @lessonsErrorForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get lessonsErrorForbidden;

  /// No description provided for @lessonsErrorValidation.
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgileri kontrol edin.'**
  String get lessonsErrorValidation;

  /// No description provided for @ocrCaptureTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Listesi Yükle'**
  String get ocrCaptureTitle;

  /// No description provided for @ocrCaptureHowTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl Çalışır?'**
  String get ocrCaptureHowTitle;

  /// No description provided for @ocrCaptureHowDesc.
  ///
  /// In tr, this message translates to:
  /// **'El yazısı listenizin fotoğrafını çekin. Metin tanıma kâğıdı tarar ve kelimeleri otomatik olarak listenize aktarır.'**
  String get ocrCaptureHowDesc;

  /// No description provided for @ocrCaptureStep1.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Çek'**
  String get ocrCaptureStep1;

  /// No description provided for @ocrCaptureStep2.
  ///
  /// In tr, this message translates to:
  /// **'Tara'**
  String get ocrCaptureStep2;

  /// No description provided for @ocrCaptureStep3.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get ocrCaptureStep3;

  /// No description provided for @ocrCaptureTriggerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ile Tara'**
  String get ocrCaptureTriggerTitle;

  /// No description provided for @ocrCaptureTriggerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Veya galeriden bir fotoğraf seçin'**
  String get ocrCaptureTriggerSubtitle;

  /// No description provided for @ocrCaptureSourceCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ile çek'**
  String get ocrCaptureSourceCamera;

  /// No description provided for @ocrCaptureSourceGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get ocrCaptureSourceGallery;

  /// No description provided for @ocrCapturePhotoRemoveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı kaldır'**
  String get ocrCapturePhotoRemoveLabel;

  /// No description provided for @ocrCaptureExtract.
  ///
  /// In tr, this message translates to:
  /// **'Kelimeleri Çıkart'**
  String get ocrCaptureExtract;

  /// No description provided for @ocrCaptureScanning.
  ///
  /// In tr, this message translates to:
  /// **'Taranıyor…'**
  String get ocrCaptureScanning;

  /// OCR yakalama ekranında bulut AI zenginleştirmesi sürerken gösterilen yükleme metni.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka ile düzeltiliyor…'**
  String get ocrCaptureEnriching;

  /// No description provided for @ocrCaptureOr.
  ///
  /// In tr, this message translates to:
  /// **'VEYA'**
  String get ocrCaptureOr;

  /// No description provided for @ocrCaptureManual.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Giriş'**
  String get ocrCaptureManual;

  /// No description provided for @ocrCapturePermissionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera/galeri erişimi gerekli'**
  String get ocrCapturePermissionTitle;

  /// No description provided for @ocrCapturePermissionDesc.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için ayarlardan kamera veya galeri erişimine izin verin.'**
  String get ocrCapturePermissionDesc;

  /// No description provided for @ocrReviewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tanınan Kelimeler'**
  String get ocrReviewTitle;

  /// No description provided for @ocrReviewSummary.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime tanındı'**
  String ocrReviewSummary(int count);

  /// No description provided for @ocrReviewSelected.
  ///
  /// In tr, this message translates to:
  /// **'{count} seçili'**
  String ocrReviewSelected(int count);

  /// No description provided for @ocrReviewConfidenceNote.
  ///
  /// In tr, this message translates to:
  /// **'Metin tanıma hatalı olabilir; kaydetmeden önce kontrol edin.'**
  String get ocrReviewConfidenceNote;

  /// AI zenginleştirme (503/çevrimdışı) başarısız olup yerel ML Kit sonucuna düşüldüğünde gösterilen bilgi notu.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka düzeltmesi şu an kullanılamadı; cihazda tanınan sonuç gösteriliyor.'**
  String get ocrReviewAiUnavailable;

  /// No description provided for @ocrReviewTermLabel.
  ///
  /// In tr, this message translates to:
  /// **'Terim ({sourceLang})'**
  String ocrReviewTermLabel(String sourceLang);

  /// No description provided for @ocrReviewTermPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Örn. environment'**
  String get ocrReviewTermPlaceholder;

  /// No description provided for @ocrReviewIncludeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilecek'**
  String get ocrReviewIncludeLabel;

  /// No description provided for @ocrReviewExcludeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hariç tutuldu'**
  String get ocrReviewExcludeLabel;

  /// No description provided for @ocrReviewRowRemoveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aday {index}, sil'**
  String ocrReviewRowRemoveLabel(int index);

  /// OCR gözden geçirme satırında terim ↔ karşılık takas butonu (semantics + tooltip).
  ///
  /// In tr, this message translates to:
  /// **'Terim ve karşılığı yer değiştir'**
  String get ocrReviewSwap;

  /// No description provided for @ocrReviewAddRow.
  ///
  /// In tr, this message translates to:
  /// **'Satır Ekle'**
  String get ocrReviewAddRow;

  /// No description provided for @ocrReviewClearAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Temizle'**
  String get ocrReviewClearAll;

  /// No description provided for @ocrReviewSave.
  ///
  /// In tr, this message translates to:
  /// **'Seçilenleri Kaydet ({count})'**
  String ocrReviewSave(int count);

  /// No description provided for @ocrReviewEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hiç kelime tanınamadı'**
  String get ocrReviewEmptyTitle;

  /// No description provided for @ocrReviewEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Net, iyi aydınlatılmış bir fotoğraf deneyin.'**
  String get ocrReviewEmptyDesc;

  /// No description provided for @ocrReviewRetry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Tara'**
  String get ocrReviewRetry;

  /// No description provided for @ocrReviewError.
  ///
  /// In tr, this message translates to:
  /// **'Tarama başarısız oldu'**
  String get ocrReviewError;

  /// No description provided for @ocrReviewInvalidRows.
  ///
  /// In tr, this message translates to:
  /// **'Eksik satırları doldurun veya kaldırın.'**
  String get ocrReviewInvalidRows;

  /// No description provided for @ocrReviewSaving.
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor…'**
  String get ocrReviewSaving;

  /// No description provided for @ocrReviewPartialError.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime kaydedilemedi. Başarısız satırları tekrar deneyin.'**
  String ocrReviewPartialError(int count);

  /// No description provided for @ocrReviewSavedSnack.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime eklendi'**
  String ocrReviewSavedSnack(int count);

  /// No description provided for @commonContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get commonContinue;

  /// No description provided for @studentDashboardGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}! 👋'**
  String studentDashboardGreeting(String name);

  /// No description provided for @studentDashboardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün kelime avına hazır mısın?'**
  String get studentDashboardSubtitle;

  /// No description provided for @studentDashboardStreak.
  ///
  /// In tr, this message translates to:
  /// **'{days}'**
  String studentDashboardStreak(int days);

  /// No description provided for @studentDashboardStreakSemantic.
  ///
  /// In tr, this message translates to:
  /// **'{days} günlük seri'**
  String studentDashboardStreakSemantic(int days);

  /// No description provided for @studentDashboardGameOfDay.
  ///
  /// In tr, this message translates to:
  /// **'Günün Oyunu'**
  String get studentDashboardGameOfDay;

  /// No description provided for @studentDashboardGameSharedBy.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşan: {teacher}'**
  String studentDashboardGameSharedBy(String teacher);

  /// No description provided for @studentDashboardGameAssigned.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin Atadığı Oyun'**
  String get studentDashboardGameAssigned;

  /// No description provided for @studentDashboardGameDesc.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelimeyi eşleştir, doğruluk ve süreni geliştir.'**
  String studentDashboardGameDesc(int count);

  /// No description provided for @studentDashboardPlayGame.
  ///
  /// In tr, this message translates to:
  /// **'Oyuna Başla'**
  String get studentDashboardPlayGame;

  /// No description provided for @studentDashboardLessonsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Derslerim'**
  String get studentDashboardLessonsTitle;

  /// No description provided for @studentDashboardProgressTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim Özeti'**
  String get studentDashboardProgressTitle;

  /// No description provided for @studentDashboardStatGames.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlanan Oyun'**
  String get studentDashboardStatGames;

  /// No description provided for @studentDashboardStatAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Doğruluk'**
  String get studentDashboardStatAccuracy;

  /// No description provided for @studentDashboardWeeklyGoal.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Hedef'**
  String get studentDashboardWeeklyGoal;

  /// No description provided for @studentDashboardAchievementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son Başarımlar'**
  String get studentDashboardAchievementsTitle;

  /// No description provided for @studentDashboardJoinTeacherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir Sınıfa Katıl'**
  String get studentDashboardJoinTeacherTitle;

  /// No description provided for @studentDashboardJoinTeacherDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmeninden aldığın sınıf davet kodunu girerek derslerine eriş.'**
  String get studentDashboardJoinTeacherDesc;

  /// No description provided for @studentDashboardJoinTeacherLinkShort.
  ///
  /// In tr, this message translates to:
  /// **'Yeni sınıfa katıl'**
  String get studentDashboardJoinTeacherLinkShort;

  /// No description provided for @studentDashboardEmptyNoTeacherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bir sınıfa katılmadın'**
  String get studentDashboardEmptyNoTeacherTitle;

  /// No description provided for @studentDashboardEmptyNoTeacherDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmeninden aldığın sınıf davet koduyla başla.'**
  String get studentDashboardEmptyNoTeacherDesc;

  /// No description provided for @studentDashboardEmptyNoLessonsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin henüz ders yayınlamadı'**
  String get studentDashboardEmptyNoLessonsTitle;

  /// No description provided for @studentDashboardEmptyNoLessonsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yeni dersler burada görünecek.'**
  String get studentDashboardEmptyNoLessonsDesc;

  /// No description provided for @studentDashboardPuzzlesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Atanan Bulmacalar'**
  String get studentDashboardPuzzlesTitle;

  /// No description provided for @studentDashboardEmptyNoPuzzlesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin henüz bulmaca atamadı'**
  String get studentDashboardEmptyNoPuzzlesTitle;

  /// No description provided for @studentDashboardEmptyNoPuzzlesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin bir bulmaca yayınlayınca burada görünecek.'**
  String get studentDashboardEmptyNoPuzzlesDesc;

  /// No description provided for @studentDashboardPuzzleLesson.
  ///
  /// In tr, this message translates to:
  /// **'{lesson} • {count} kelime'**
  String studentDashboardPuzzleLesson(String lesson, int count);

  /// No description provided for @studentDashboardStatsSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yakında — ilk oyununu oynayınca burada görünecek.'**
  String get studentDashboardStatsSoon;

  /// No description provided for @studentDashboardStatsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz oyun oynamadın.'**
  String get studentDashboardStatsEmpty;

  /// No description provided for @studentDashboardStatsError.
  ///
  /// In tr, this message translates to:
  /// **'Gelişim özeti yüklenemedi.'**
  String get studentDashboardStatsError;

  /// No description provided for @studentDashboardStatAccuracyValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String studentDashboardStatAccuracyValue(int percent);

  /// No description provided for @studentDashboardSeeReports.
  ///
  /// In tr, this message translates to:
  /// **'Raporlarım'**
  String get studentDashboardSeeReports;

  /// No description provided for @studentDashboardError.
  ///
  /// In tr, this message translates to:
  /// **'Dersler yüklenemedi'**
  String get studentDashboardError;

  /// No description provided for @studentDashboardJoined.
  ///
  /// In tr, this message translates to:
  /// **'Derse katıldın'**
  String get studentDashboardJoined;

  /// No description provided for @studentJoinAppBarTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmene Katıl'**
  String get studentJoinAppBarTitle;

  /// No description provided for @studentJoinHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodunu Gir'**
  String get studentJoinHeroTitle;

  /// No description provided for @studentJoinHeroDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmeninden aldığın daveti girerek derslerine katıl.'**
  String get studentJoinHeroDesc;

  /// No description provided for @studentJoinCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get studentJoinCodeLabel;

  /// No description provided for @studentJoinCodeHint.
  ///
  /// In tr, this message translates to:
  /// **'Kodu öğretmeninden alabilirsin.'**
  String get studentJoinCodeHint;

  /// No description provided for @studentJoinSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get studentJoinSubmit;

  /// No description provided for @studentJoinSubmitting.
  ///
  /// In tr, this message translates to:
  /// **'Katılıyor…'**
  String get studentJoinSubmitting;

  /// No description provided for @studentJoinErrorInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bu kod geçerli değil. Kontrol edip tekrar dene.'**
  String get studentJoinErrorInvalid;

  /// No description provided for @studentJoinErrorAlready.
  ///
  /// In tr, this message translates to:
  /// **'Bu öğretmene zaten katıldın.'**
  String get studentJoinErrorAlready;

  /// No description provided for @studentJoinErrorExpired.
  ///
  /// In tr, this message translates to:
  /// **'Bu kodun süresi dolmuş. Öğretmeninden yeni kod iste.'**
  String get studentJoinErrorExpired;

  /// No description provided for @studentJoinErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanılamadı. Tekrar dene.'**
  String get studentJoinErrorNetwork;

  /// No description provided for @studentJoinBackToDashboard.
  ///
  /// In tr, this message translates to:
  /// **'Panele Dön'**
  String get studentJoinBackToDashboard;

  /// No description provided for @studentJoinSuccess.
  ///
  /// In tr, this message translates to:
  /// **'{teacher} dersine katıldın'**
  String studentJoinSuccess(String teacher);

  /// No description provided for @studentLessonPlay.
  ///
  /// In tr, this message translates to:
  /// **'Oyna'**
  String get studentLessonPlay;

  /// No description provided for @studentLessonEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu derste henüz kelime yok'**
  String get studentLessonEmptyTitle;

  /// No description provided for @studentLessonEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin kelime ekleyince burada görünecek.'**
  String get studentLessonEmptyDesc;

  /// No description provided for @studentLessonError.
  ///
  /// In tr, this message translates to:
  /// **'Kelimeler yüklenemedi'**
  String get studentLessonError;

  /// No description provided for @gameStarting.
  ///
  /// In tr, this message translates to:
  /// **'Oyun hazırlanıyor…'**
  String get gameStarting;

  /// No description provided for @gameStartErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanılamadı. Tekrar dene.'**
  String get gameStartErrorNetwork;

  /// No description provided for @gameStartErrorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Oyun bulunamadı.'**
  String get gameStartErrorNotFound;

  /// No description provided for @gameStartErrorForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Bu oyuna erişim iznin yok.'**
  String get gameStartErrorForbidden;

  /// No description provided for @gameStartErrorInsufficientWords.
  ///
  /// In tr, this message translates to:
  /// **'Bu derste oyun için yeterli kelime yok. Öğretmenin kelime ekleyince oyun hazır olacak.'**
  String get gameStartErrorInsufficientWords;

  /// No description provided for @gameMatchingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Eşleştirme'**
  String get gameMatchingTitle;

  /// No description provided for @gameMatchingCurrentGameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Oyun'**
  String get gameMatchingCurrentGameLabel;

  /// No description provided for @gameMatchingCounter.
  ///
  /// In tr, this message translates to:
  /// **'{matched} / {total}'**
  String gameMatchingCounter(int matched, int total);

  /// No description provided for @gameMatchingColEnglish.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get gameMatchingColEnglish;

  /// No description provided for @gameMatchingColTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get gameMatchingColTurkish;

  /// No description provided for @gameMatchingColEnglishUpper.
  ///
  /// In tr, this message translates to:
  /// **'İNGİLİZCE'**
  String get gameMatchingColEnglishUpper;

  /// No description provided for @gameMatchingColTurkishUpper.
  ///
  /// In tr, this message translates to:
  /// **'TÜRKÇE'**
  String get gameMatchingColTurkishUpper;

  /// No description provided for @gameMatchingCurrentGameLabelUpper.
  ///
  /// In tr, this message translates to:
  /// **'MEVCUT OYUN'**
  String get gameMatchingCurrentGameLabelUpper;

  /// No description provided for @gameMatchingTimerSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Geçen süre {time}'**
  String gameMatchingTimerSemantic(String time);

  /// No description provided for @gameMatchingEncouragement.
  ///
  /// In tr, this message translates to:
  /// **'Harika gidiyorsun! Kelimeleri birleştirerek hız kazan.'**
  String get gameMatchingEncouragement;

  /// No description provided for @gameMatchingQuit.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get gameMatchingQuit;

  /// No description provided for @gameMatchingQuitConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Oyundan çık?'**
  String get gameMatchingQuitConfirmTitle;

  /// No description provided for @gameMatchingQuitConfirmDesc.
  ///
  /// In tr, this message translates to:
  /// **'Çıkarsan ilerlemen kaydedilmeyecek.'**
  String get gameMatchingQuitConfirmDesc;

  /// No description provided for @gameMatchingQuitConfirmConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Çık'**
  String get gameMatchingQuitConfirmConfirm;

  /// No description provided for @gameMatchingQuitConfirmCancel.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get gameMatchingQuitConfirmCancel;

  /// No description provided for @gameMatchingA11yMatched.
  ///
  /// In tr, this message translates to:
  /// **'eşleşti'**
  String get gameMatchingA11yMatched;

  /// No description provided for @gameMatchingA11yWrong.
  ///
  /// In tr, this message translates to:
  /// **'yanlış, tekrar dene'**
  String get gameMatchingA11yWrong;

  /// No description provided for @gameMatchingCompleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler!'**
  String get gameMatchingCompleteTitle;

  /// No description provided for @gameMatchingCompleteMessage.
  ///
  /// In tr, this message translates to:
  /// **'Tüm kelimeleri {matched}/{total} eşleştirdin. Süre: {time}.'**
  String gameMatchingCompleteMessage(int matched, int total, String time);

  /// No description provided for @gameMatchingCompleteFinish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get gameMatchingCompleteFinish;

  /// No description provided for @gameMatchingEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu derste henüz oyun yok'**
  String get gameMatchingEmptyTitle;

  /// No description provided for @gameMatchingEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmen yeterli kelime ekleyince oyun hazır olacak.'**
  String get gameMatchingEmptyDesc;

  /// No description provided for @gameMatchingError.
  ///
  /// In tr, this message translates to:
  /// **'Oyun yüklenemedi'**
  String get gameMatchingError;

  /// No description provided for @createGameTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bulmaca Oluştur'**
  String get createGameTitle;

  /// No description provided for @createGameStep1Title.
  ///
  /// In tr, this message translates to:
  /// **'Oyun Türünü Seç'**
  String get createGameStep1Title;

  /// No description provided for @createGameStep2Title.
  ///
  /// In tr, this message translates to:
  /// **'Ders Seçimi'**
  String get createGameStep2Title;

  /// No description provided for @createGameTypeMatchingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Eşleştirme'**
  String get createGameTypeMatchingTitle;

  /// No description provided for @createGameTypeMatchingDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kelime ve anlamlarını eşleştirerek öğrenmeyi hızlandır.'**
  String get createGameTypeMatchingDesc;

  /// No description provided for @createGameTypeCrosswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çengel Bulmaca'**
  String get createGameTypeCrosswordTitle;

  /// No description provided for @createGameTypeCrosswordDesc.
  ///
  /// In tr, this message translates to:
  /// **'İpuçları kullanarak kelimeleri bulmalarını sağla.'**
  String get createGameTypeCrosswordDesc;

  /// No description provided for @createGameLessonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılacak Kelime Listesi'**
  String get createGameLessonLabel;

  /// No description provided for @createGameLessonHint.
  ///
  /// In tr, this message translates to:
  /// **'Bir ders seçin…'**
  String get createGameLessonHint;

  /// No description provided for @createGameLessonsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz dersin yok. Önce bir ders oluştur.'**
  String get createGameLessonsEmpty;

  /// No description provided for @createGameLessonsError.
  ///
  /// In tr, this message translates to:
  /// **'Dersler yüklenemedi.'**
  String get createGameLessonsError;

  /// No description provided for @createGamePreviewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Önizleme Henüz Hazır Değil'**
  String get createGamePreviewTitle;

  /// No description provided for @createGamePreviewDesc.
  ///
  /// In tr, this message translates to:
  /// **'Oyun türü ve kelime listesi seçtiğinizde burada bir özet görünecektir.'**
  String get createGamePreviewDesc;

  /// No description provided for @createGameSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Bulmacayı Oluştur ve Yayınla'**
  String get createGameSubmit;

  /// No description provided for @createGameSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca oluşturuldu ve yayınlandı.'**
  String get createGameSuccess;

  /// No description provided for @createGameErrorInsufficientWords.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca oluşturmak için ders en az 4 kelime içermeli.'**
  String get createGameErrorInsufficientWords;

  /// No description provided for @createGameErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanılamadı. Tekrar dene.'**
  String get createGameErrorNetwork;

  /// No description provided for @createGameErrorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca oluşturulamadı, tekrar dene.'**
  String get createGameErrorGeneric;

  /// No description provided for @gameCrosswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün Bulmacası'**
  String get gameCrosswordTitle;

  /// No description provided for @gameCrosswordCounter.
  ///
  /// In tr, this message translates to:
  /// **'{correct} / {total}'**
  String gameCrosswordCounter(int correct, int total);

  /// No description provided for @gameCrosswordAcross.
  ///
  /// In tr, this message translates to:
  /// **'SOLDAN SAĞA'**
  String get gameCrosswordAcross;

  /// No description provided for @gameCrosswordDown.
  ///
  /// In tr, this message translates to:
  /// **'YUKARIDAN AŞAĞI'**
  String get gameCrosswordDown;

  /// No description provided for @gameCrosswordFinish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get gameCrosswordFinish;

  /// No description provided for @gameCrosswordKeyDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get gameCrosswordKeyDelete;

  /// No description provided for @gameCrosswordCompleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca tamamlandı!'**
  String get gameCrosswordCompleteTitle;

  /// No description provided for @gameCrosswordCellSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca hücresi'**
  String get gameCrosswordCellSemantic;

  /// No description provided for @gameCrosswordCellNumberedSemantic.
  ///
  /// In tr, this message translates to:
  /// **'{number} numaralı kelimenin başlangıç hücresi'**
  String gameCrosswordCellNumberedSemantic(int number);

  /// No description provided for @gameCrosswordCellEmpty.
  ///
  /// In tr, this message translates to:
  /// **'boş'**
  String get gameCrosswordCellEmpty;

  /// No description provided for @teacherStudentsAppBarTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencilerim'**
  String get teacherStudentsAppBarTitle;

  /// No description provided for @teacherStudentsCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu'**
  String get teacherStudentsCodeLabel;

  /// No description provided for @teacherStudentsCodeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu kodu öğrencilerinle paylaş; girince derslerine katılırlar.'**
  String get teacherStudentsCodeDesc;

  /// No description provided for @teacherStudentsCopy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get teacherStudentsCopy;

  /// No description provided for @teacherStudentsCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kod kopyalandı'**
  String get teacherStudentsCopied;

  /// No description provided for @teacherStudentsShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get teacherStudentsShare;

  /// No description provided for @teacherStudentsShareMessage.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross\'ta bana katıl. Davet kodu: {code}'**
  String teacherStudentsShareMessage(String code);

  /// No description provided for @teacherStudentsShareCopied.
  ///
  /// In tr, this message translates to:
  /// **'Davet metni kopyalandı'**
  String get teacherStudentsShareCopied;

  /// No description provided for @teacherStudentsRegenerate.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kod'**
  String get teacherStudentsRegenerate;

  /// No description provided for @teacherStudentsRegenerateConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod oluşturursan eski kod çalışmayı durdurur. Devam edilsin mi?'**
  String get teacherStudentsRegenerateConfirm;

  /// No description provided for @teacherStudentsRegenerated.
  ///
  /// In tr, this message translates to:
  /// **'Yeni davet kodu oluşturuldu'**
  String get teacherStudentsRegenerated;

  /// No description provided for @teacherStudentsRegenerateError.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod oluşturulamadı, tekrar deneyin.'**
  String get teacherStudentsRegenerateError;

  /// No description provided for @teacherStudentsListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler'**
  String get teacherStudentsListTitle;

  /// No description provided for @teacherStudentsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} öğrenci'**
  String teacherStudentsCount(int count);

  /// No description provided for @teacherStudentsJoinedAt.
  ///
  /// In tr, this message translates to:
  /// **'Katıldı: {date}'**
  String teacherStudentsJoinedAt(String date);

  /// No description provided for @teacherStudentsStatusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get teacherStudentsStatusActive;

  /// No description provided for @teacherStudentsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz öğrencin yok'**
  String get teacherStudentsEmptyTitle;

  /// No description provided for @teacherStudentsEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yukarıdaki davet kodunu öğrencilerinle paylaş.'**
  String get teacherStudentsEmptyDesc;

  /// No description provided for @teacherStudentsErrorCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu yüklenemedi'**
  String get teacherStudentsErrorCode;

  /// No description provided for @teacherStudentsErrorList.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler yüklenemedi'**
  String get teacherStudentsErrorList;

  /// No description provided for @teacherStudentsCodeSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu: {spaced}'**
  String teacherStudentsCodeSemantic(String spaced);

  /// No description provided for @gameResultSubmitting.
  ///
  /// In tr, this message translates to:
  /// **'Sonucun kaydediliyor…'**
  String get gameResultSubmitting;

  /// No description provided for @gameResultSubmitError.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç kaydedilemedi, tekrar dene.'**
  String get gameResultSubmitError;

  /// No description provided for @gameResultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Oyun Özeti'**
  String get gameResultTitle;

  /// No description provided for @gameResultSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Harika bir iş çıkardın!'**
  String get gameResultSubtitle;

  /// No description provided for @gameResultAccuracyValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String gameResultAccuracyValue(int percent);

  /// No description provided for @gameResultAccuracyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğruluk'**
  String get gameResultAccuracyLabel;

  /// No description provided for @gameResultAccuracyA11y.
  ///
  /// In tr, this message translates to:
  /// **'Doğruluk yüzde {percent}'**
  String gameResultAccuracyA11y(int percent);

  /// No description provided for @gameResultTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Geçen Süre'**
  String get gameResultTimeLabel;

  /// No description provided for @gameResultWordsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bulunan Kelime'**
  String get gameResultWordsLabel;

  /// No description provided for @gameResultWordsValue.
  ///
  /// In tr, this message translates to:
  /// **'{found} / {total}'**
  String gameResultWordsValue(int found, int total);

  /// No description provided for @gameResultShare.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmene Gönder'**
  String get gameResultShare;

  /// No description provided for @gameResultShareSending.
  ///
  /// In tr, this message translates to:
  /// **'Gönderiliyor…'**
  String get gameResultShareSending;

  /// No description provided for @gameResultShareShared.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmene Gönderildi'**
  String get gameResultShareShared;

  /// No description provided for @gameResultShareToastSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Sonucun öğretmenine gönderildi.'**
  String get gameResultShareToastSuccess;

  /// No description provided for @gameResultShareToastError.
  ///
  /// In tr, this message translates to:
  /// **'Gönderilemedi, tekrar dene.'**
  String get gameResultShareToastError;

  /// No description provided for @gameResultPlayAgain.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Oyna'**
  String get gameResultPlayAgain;

  /// No description provided for @gameResultErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç yüklenemedi'**
  String get gameResultErrorTitle;

  /// No description provided for @gameResultA11ySending.
  ///
  /// In tr, this message translates to:
  /// **'Gönderiliyor'**
  String get gameResultA11ySending;

  /// No description provided for @gameResultA11yShared.
  ///
  /// In tr, this message translates to:
  /// **'Gönderildi'**
  String get gameResultA11yShared;

  /// No description provided for @gameResultA11yError.
  ///
  /// In tr, this message translates to:
  /// **'Gönderilemedi'**
  String get gameResultA11yError;

  /// No description provided for @resultsHistoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlarım'**
  String get resultsHistoryTitle;

  /// No description provided for @resultsHistorySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tüm oyun geçmişin'**
  String get resultsHistorySubtitle;

  /// No description provided for @resultsHistorySummaryTotalGames.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Oyun'**
  String get resultsHistorySummaryTotalGames;

  /// No description provided for @resultsHistorySummaryAvgAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Doğruluk'**
  String get resultsHistorySummaryAvgAccuracy;

  /// No description provided for @resultsHistoryItemShared.
  ///
  /// In tr, this message translates to:
  /// **'Gönderildi'**
  String get resultsHistoryItemShared;

  /// No description provided for @resultsHistoryItemA11y.
  ///
  /// In tr, this message translates to:
  /// **'{lesson}, doğruluk yüzde {percent}, süre {time}, {found} / {total}'**
  String resultsHistoryItemA11y(String lesson, int percent, String time, int found, int total);

  /// No description provided for @resultsHistoryItemDateA11y.
  ///
  /// In tr, this message translates to:
  /// **'{lesson}, doğruluk yüzde {percent}, süre {time}, {found} / {total}, {date}'**
  String resultsHistoryItemDateA11y(String lesson, int percent, String time, int found, int total, String date);

  /// No description provided for @resultsHistoryEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz oyun oynamadın'**
  String get resultsHistoryEmptyTitle;

  /// No description provided for @resultsHistoryEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bir ders oyununu bitirince sonucun burada görünür.'**
  String get resultsHistoryEmptyDesc;

  /// No description provided for @resultsHistoryEmptyCta.
  ///
  /// In tr, this message translates to:
  /// **'Oyuna Başla'**
  String get resultsHistoryEmptyCta;

  /// No description provided for @resultsHistoryErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlar yüklenemedi'**
  String get resultsHistoryErrorTitle;

  /// No description provided for @resultsErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get resultsErrorNetwork;

  /// No description provided for @resultsErrorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı.'**
  String get resultsErrorNotFound;

  /// No description provided for @resultsErrorForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get resultsErrorForbidden;

  /// No description provided for @trackingStudentsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Raporları'**
  String get trackingStudentsTitle;

  /// No description provided for @trackingStudentsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencilerinin paylaştığı oyun sonuçlarını takip et.'**
  String get trackingStudentsSubtitle;

  /// No description provided for @trackingStudentsListTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler'**
  String get trackingStudentsListTitle;

  /// No description provided for @trackingSharedCountLabel.
  ///
  /// In tr, this message translates to:
  /// **'{count} paylaşılan sonuç'**
  String trackingSharedCountLabel(int count);

  /// No description provided for @trackingAverageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get trackingAverageLabel;

  /// No description provided for @trackingAverageNone.
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get trackingAverageNone;

  /// No description provided for @trackingLastActivityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son aktivite: {date}'**
  String trackingLastActivityLabel(String date);

  /// No description provided for @trackingLastActivityNone.
  ///
  /// In tr, this message translates to:
  /// **'Son aktivite: henüz yok'**
  String get trackingLastActivityNone;

  /// No description provided for @trackingStudentRowA11y.
  ///
  /// In tr, this message translates to:
  /// **'{name}, {count} paylaşılan sonuç'**
  String trackingStudentRowA11y(String name, int count);

  /// No description provided for @trackingStudentsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz paylaşılan sonuç yok'**
  String get trackingStudentsEmptyTitle;

  /// No description provided for @trackingStudentsEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencilerin oyun sonuçlarını paylaşınca burada görünür. Henüz öğrencin yoksa Sınıflar sekmesinden davet kodunu paylaş.'**
  String get trackingStudentsEmptyDesc;

  /// No description provided for @trackingStudentsErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler yüklenemedi'**
  String get trackingStudentsErrorTitle;

  /// No description provided for @trackingDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Raporu'**
  String get trackingDetailTitle;

  /// No description provided for @trackingDetailAverageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama Doğruluk'**
  String get trackingDetailAverageLabel;

  /// No description provided for @trackingDetailResultsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan Sonuç'**
  String get trackingDetailResultsLabel;

  /// No description provided for @trackingDetailResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan Sonuçlar'**
  String get trackingDetailResultsTitle;

  /// No description provided for @trackingDetailEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz paylaşılan sonuç yok'**
  String get trackingDetailEmptyTitle;

  /// No description provided for @trackingDetailEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu öğrenci henüz seninle bir oyun sonucu paylaşmadı.'**
  String get trackingDetailEmptyDesc;

  /// No description provided for @trackingDetailErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuçlar yüklenemedi'**
  String get trackingDetailErrorTitle;

  /// No description provided for @trackingResultA11y.
  ///
  /// In tr, this message translates to:
  /// **'{lesson}, doğruluk yüzde {percent}, süre {time}, {found} / {total}, {date}'**
  String trackingResultA11y(String lesson, int percent, String time, int found, int total, String date);

  /// No description provided for @resultDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç Detayı'**
  String get resultDetailTitle;

  /// No description provided for @resultDetailDateTime.
  ///
  /// In tr, this message translates to:
  /// **'{date} • {time}'**
  String resultDetailDateTime(String date, String time);

  /// No description provided for @resultDetailMetricAccuracy.
  ///
  /// In tr, this message translates to:
  /// **'Başarı'**
  String get resultDetailMetricAccuracy;

  /// No description provided for @resultDetailMetricCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru'**
  String get resultDetailMetricCorrect;

  /// No description provided for @resultDetailMetricDuration.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get resultDetailMetricDuration;

  /// No description provided for @resultDetailFilterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü ({count})'**
  String resultDetailFilterAll(int count);

  /// No description provided for @resultDetailFilterCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğrular ({count})'**
  String resultDetailFilterCorrect(int count);

  /// No description provided for @resultDetailFilterWrong.
  ///
  /// In tr, this message translates to:
  /// **'Yanlışlar ({count})'**
  String resultDetailFilterWrong(int count);

  /// No description provided for @resultDetailBadgeCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru'**
  String get resultDetailBadgeCorrect;

  /// No description provided for @resultDetailBadgeWrong.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış'**
  String get resultDetailBadgeWrong;

  /// No description provided for @resultDetailCorrectAnswer.
  ///
  /// In tr, this message translates to:
  /// **'Doğru cevap: {answer}'**
  String resultDetailCorrectAnswer(String answer);

  /// No description provided for @resultDetailStudentAnswer.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencinin cevabı: {answer}'**
  String resultDetailStudentAnswer(String answer);

  /// No description provided for @resultDetailStudentAnswerEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencinin cevabı: — (boş)'**
  String get resultDetailStudentAnswerEmpty;

  /// No description provided for @resultDetailAnalysisTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm Analizi'**
  String get resultDetailAnalysisTitle;

  /// No description provided for @resultDetailSpeedScore.
  ///
  /// In tr, this message translates to:
  /// **'Hız Skoru'**
  String get resultDetailSpeedScore;

  /// No description provided for @resultDetailSpeedGreat.
  ///
  /// In tr, this message translates to:
  /// **'Harika!'**
  String get resultDetailSpeedGreat;

  /// No description provided for @resultDetailSpeedGood.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get resultDetailSpeedGood;

  /// No description provided for @resultDetailSpeedFair.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get resultDetailSpeedFair;

  /// No description provided for @resultDetailSpeedSlow.
  ///
  /// In tr, this message translates to:
  /// **'Acele etme'**
  String get resultDetailSpeedSlow;

  /// No description provided for @resultDetailSpeedDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kelime başına ortalama {seconds} sn.'**
  String resultDetailSpeedDesc(String seconds);

  /// No description provided for @resultDetailNoItemsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kelime detayı yok'**
  String get resultDetailNoItemsTitle;

  /// No description provided for @resultDetailNoItemsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu sonuç eski bir oynamadan geldiği için kelime bazlı döküm bulunmuyor.'**
  String get resultDetailNoItemsDesc;

  /// No description provided for @resultDetailErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç detayı yüklenemedi'**
  String get resultDetailErrorTitle;

  /// No description provided for @resultDetailItemCorrectA11y.
  ///
  /// In tr, this message translates to:
  /// **'{term}, karşılığı {answer}, doğru'**
  String resultDetailItemCorrectA11y(String term, String answer);

  /// No description provided for @resultDetailItemWrongA11y.
  ///
  /// In tr, this message translates to:
  /// **'{term}, doğru cevap {expected}, öğrencinin cevabı {given}, yanlış'**
  String resultDetailItemWrongA11y(String term, String expected, String given);

  /// No description provided for @gameTypeWordMatching.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Eşleştirme'**
  String get gameTypeWordMatching;

  /// No description provided for @gameTypeCrossword.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca'**
  String get gameTypeCrossword;

  /// No description provided for @gameTypeQuestionSet.
  ///
  /// In tr, this message translates to:
  /// **'Soru Seti'**
  String get gameTypeQuestionSet;

  /// No description provided for @trackingErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası. Lütfen tekrar deneyin.'**
  String get trackingErrorNetwork;

  /// No description provided for @trackingErrorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci bulunamadı.'**
  String get trackingErrorNotFound;

  /// No description provided for @trackingErrorForbidden.
  ///
  /// In tr, this message translates to:
  /// **'Bu işlem için yetkiniz yok.'**
  String get trackingErrorForbidden;

  /// No description provided for @teacherDashboardActionMyPuzzlesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bulmacalarım'**
  String get teacherDashboardActionMyPuzzlesTitle;

  /// No description provided for @teacherDashboardActionMyPuzzlesDesc.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturduğun tüm bulmacaları gör, paylaş ve çözüm istatistiklerini izle.'**
  String get teacherDashboardActionMyPuzzlesDesc;

  /// No description provided for @myPuzzlesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bulmacalarım'**
  String get myPuzzlesTitle;

  /// No description provided for @myPuzzlesCreateCta.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bulmaca Oluştur'**
  String get myPuzzlesCreateCta;

  /// No description provided for @myPuzzlesFilterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get myPuzzlesFilterAll;

  /// No description provided for @myPuzzlesFilterActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif ({count})'**
  String myPuzzlesFilterActive(int count);

  /// No description provided for @myPuzzlesTypeWordMatching.
  ///
  /// In tr, this message translates to:
  /// **'Kelime Eşleştirme'**
  String get myPuzzlesTypeWordMatching;

  /// No description provided for @myPuzzlesTypeCrossword.
  ///
  /// In tr, this message translates to:
  /// **'Crossword'**
  String get myPuzzlesTypeCrossword;

  /// No description provided for @myPuzzlesStatusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get myPuzzlesStatusActive;

  /// No description provided for @myPuzzlesCreatedAt.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma: {date}'**
  String myPuzzlesCreatedAt(String date);

  /// No description provided for @myPuzzlesSharedWith.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılan: {count} öğrenci'**
  String myPuzzlesSharedWith(int count);

  /// No description provided for @myPuzzlesShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get myPuzzlesShare;

  /// No description provided for @myPuzzlesShared.
  ///
  /// In tr, this message translates to:
  /// **'Bulmaca paylaşıldı.'**
  String get myPuzzlesShared;

  /// No description provided for @myPuzzlesSeeDetails.
  ///
  /// In tr, this message translates to:
  /// **'Detayları Gör'**
  String get myPuzzlesSeeDetails;

  /// No description provided for @myPuzzlesStatTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Bulmaca'**
  String get myPuzzlesStatTotal;

  /// No description provided for @myPuzzlesStatSolves.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Çözümü'**
  String get myPuzzlesStatSolves;

  /// No description provided for @myPuzzlesEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bulmaca yok'**
  String get myPuzzlesEmptyTitle;

  /// No description provided for @myPuzzlesEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk bulmacanı oluşturarak başla.'**
  String get myPuzzlesEmptyDesc;

  /// No description provided for @myPuzzlesErrorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bulmacalar yüklenemedi'**
  String get myPuzzlesErrorTitle;

  /// No description provided for @accountSettingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Ayarları'**
  String get accountSettingsTitle;

  /// No description provided for @accountEditProfileCta.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get accountEditProfileCta;

  /// No description provided for @accountGroupGeneral.
  ///
  /// In tr, this message translates to:
  /// **'GENEL'**
  String get accountGroupGeneral;

  /// No description provided for @accountGroupSecurity.
  ///
  /// In tr, this message translates to:
  /// **'GÜVENLİK'**
  String get accountGroupSecurity;

  /// No description provided for @accountGroupSupport.
  ///
  /// In tr, this message translates to:
  /// **'DESTEK & HAKKIMIZDA'**
  String get accountGroupSupport;

  /// No description provided for @accountRowNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get accountRowNotifications;

  /// No description provided for @accountRowLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil Tercihi'**
  String get accountRowLanguage;

  /// No description provided for @accountRowTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get accountRowTheme;

  /// No description provided for @accountRowThemeValueLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get accountRowThemeValueLight;

  /// No description provided for @accountRowChangePassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Değiştir'**
  String get accountRowChangePassword;

  /// No description provided for @accountRowTwoFactor.
  ///
  /// In tr, this message translates to:
  /// **'İki Faktörlü Doğrulama'**
  String get accountRowTwoFactor;

  /// No description provided for @accountRowHelpCenter.
  ///
  /// In tr, this message translates to:
  /// **'Yardım Merkezi'**
  String get accountRowHelpCenter;

  /// No description provided for @accountRowPrivacy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get accountRowPrivacy;

  /// No description provided for @accountLogout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get accountLogout;

  /// No description provided for @accountVersion.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross v{version}'**
  String accountVersion(String version);

  /// No description provided for @accountSaveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get accountSaveLabel;

  /// No description provided for @accountSavingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor…'**
  String get accountSavingLabel;

  /// No description provided for @accountEditProfileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get accountEditProfileTitle;

  /// No description provided for @accountEditProfileNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get accountEditProfileNameLabel;

  /// No description provided for @accountEditProfileNamePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Adınızı girin'**
  String get accountEditProfileNamePlaceholder;

  /// No description provided for @accountEditProfileSavedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Profiliniz güncellendi'**
  String get accountEditProfileSavedSnack;

  /// No description provided for @accountChangePasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Değiştir'**
  String get accountChangePasswordTitle;

  /// No description provided for @accountChangePasswordCurrentLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut Şifre'**
  String get accountChangePasswordCurrentLabel;

  /// No description provided for @accountChangePasswordNewLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre'**
  String get accountChangePasswordNewLabel;

  /// No description provided for @accountChangePasswordConfirmLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre (Tekrar)'**
  String get accountChangePasswordConfirmLabel;

  /// No description provided for @accountChangePasswordMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifreler eşleşmiyor.'**
  String get accountChangePasswordMismatch;

  /// No description provided for @accountChangePasswordWrongCurrent.
  ///
  /// In tr, this message translates to:
  /// **'Mevcut şifre hatalı.'**
  String get accountChangePasswordWrongCurrent;

  /// No description provided for @accountChangePasswordSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Güncelle'**
  String get accountChangePasswordSubmit;

  /// No description provided for @accountChangePasswordSavedSnack.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz değiştirildi'**
  String get accountChangePasswordSavedSnack;

  /// No description provided for @classesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflarım'**
  String get classesTitle;

  /// No description provided for @classesHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, Öğretmenim!'**
  String get classesHeroTitle;

  /// No description provided for @classesHeroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {count} farklı sınıfınla dersin bulunuyor. Başarılar dileriz.'**
  String classesHeroSubtitle(int count);

  /// No description provided for @classesStatTotalStudents.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Öğrenci'**
  String get classesStatTotalStudents;

  /// No description provided for @classesStatActivity.
  ///
  /// In tr, this message translates to:
  /// **'Aktiflik'**
  String get classesStatActivity;

  /// No description provided for @classesStatActivityValue.
  ///
  /// In tr, this message translates to:
  /// **'%{percent}'**
  String classesStatActivityValue(int percent);

  /// No description provided for @classesActiveSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Sınıflar'**
  String get classesActiveSectionTitle;

  /// No description provided for @classesSeeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get classesSeeAll;

  /// No description provided for @classesStudentCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} öğrenci'**
  String classesStudentCount(int count);

  /// No description provided for @classesInviteCodeChipLabel.
  ///
  /// In tr, this message translates to:
  /// **'Davet Kodu:'**
  String get classesInviteCodeChipLabel;

  /// No description provided for @classesCreateButton.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Sınıf Oluştur'**
  String get classesCreateButton;

  /// No description provided for @classesEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz sınıfın yok'**
  String get classesEmptyTitle;

  /// No description provided for @classesEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'İlk sınıfını oluştur ve davet koduyla öğrencilerini davet et.'**
  String get classesEmptyDesc;

  /// No description provided for @classesError.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflar yüklenemedi'**
  String get classesError;

  /// No description provided for @classCreateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Sınıf'**
  String get classCreateTitle;

  /// No description provided for @classCreateNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf Adı'**
  String get classCreateNameLabel;

  /// No description provided for @classCreateNamePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'örn. 6-A'**
  String get classCreateNamePlaceholder;

  /// No description provided for @classCreateInfo.
  ///
  /// In tr, this message translates to:
  /// **'Sınıfı oluşturduktan sonra öğrencilerinle paylaşacağın bir davet kodu üretilecek.'**
  String get classCreateInfo;

  /// No description provided for @classCreatePerkProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme Takibi'**
  String get classCreatePerkProgress;

  /// No description provided for @classCreatePerkRewards.
  ///
  /// In tr, this message translates to:
  /// **'Ödül Sistemi'**
  String get classCreatePerkRewards;

  /// No description provided for @classCreateSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get classCreateSubmit;

  /// No description provided for @classCreateSuccess.
  ///
  /// In tr, this message translates to:
  /// **'{name} sınıfı oluşturuldu.'**
  String classCreateSuccess(String name);

  /// No description provided for @classCreateErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanılamadı. Tekrar dene.'**
  String get classCreateErrorNetwork;

  /// No description provided for @classCreateErrorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf oluşturulamadı, tekrar dene.'**
  String get classCreateErrorGeneric;

  /// No description provided for @classDetailFallbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf'**
  String get classDetailFallbackTitle;

  /// No description provided for @classDetailCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf Davet Kodu'**
  String get classDetailCodeLabel;

  /// No description provided for @classDetailCodeSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf davet kodu: {spaced}'**
  String classDetailCodeSemantic(String spaced);

  /// No description provided for @classDetailCopy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get classDetailCopy;

  /// No description provided for @classDetailCodeCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kod kopyalandı'**
  String get classDetailCodeCopied;

  /// No description provided for @classDetailShare.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get classDetailShare;

  /// No description provided for @classDetailShareMessage.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross\'ta sınıfıma katıl. Davet kodu: {code}'**
  String classDetailShareMessage(String code);

  /// No description provided for @classDetailShareCopied.
  ///
  /// In tr, this message translates to:
  /// **'Davet metni kopyalandı'**
  String get classDetailShareCopied;

  /// No description provided for @classDetailRegenerate.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Kod Üret'**
  String get classDetailRegenerate;

  /// No description provided for @classDetailRegenerateConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod oluşturursan eski kod çalışmayı durdurur. Devam edilsin mi?'**
  String get classDetailRegenerateConfirm;

  /// No description provided for @classDetailRegenerated.
  ///
  /// In tr, this message translates to:
  /// **'Yeni davet kodu oluşturuldu'**
  String get classDetailRegenerated;

  /// No description provided for @classDetailRegenerateError.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kod oluşturulamadı, tekrar deneyin.'**
  String get classDetailRegenerateError;

  /// No description provided for @classDetailStudents.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler ({count})'**
  String classDetailStudents(int count);

  /// No description provided for @classDetailAdd.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get classDetailAdd;

  /// No description provided for @classDetailAddHint.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci eklemek için davet kodunu paylaş.'**
  String get classDetailAddHint;

  /// No description provided for @classDetailRemove.
  ///
  /// In tr, this message translates to:
  /// **'Çıkar'**
  String get classDetailRemove;

  /// No description provided for @classDetailRemoveConfirm.
  ///
  /// In tr, this message translates to:
  /// **'{name} bu sınıftan çıkarılsın mı?'**
  String classDetailRemoveConfirm(String name);

  /// No description provided for @classDetailRemoved.
  ///
  /// In tr, this message translates to:
  /// **'{name} sınıftan çıkarıldı'**
  String classDetailRemoved(String name);

  /// No description provided for @classDetailRemoveError.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci çıkarılamadı, tekrar deneyin.'**
  String get classDetailRemoveError;

  /// No description provided for @classDetailAssignHomework.
  ///
  /// In tr, this message translates to:
  /// **'Bu Sınıfa Ödev Ata'**
  String get classDetailAssignHomework;

  /// No description provided for @classDetailEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz öğrenci yok'**
  String get classDetailEmptyTitle;

  /// No description provided for @classDetailEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yukarıdaki davet kodunu öğrencilerinle paylaş.'**
  String get classDetailEmptyDesc;

  /// No description provided for @classDetailErrorCode.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu yüklenemedi'**
  String get classDetailErrorCode;

  /// No description provided for @classDetailErrorList.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler yüklenemedi'**
  String get classDetailErrorList;

  /// No description provided for @joinClassTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınıfa Katıl'**
  String get joinClassTitle;

  /// No description provided for @joinClassHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bir Sınıf'**
  String get joinClassHeroTitle;

  /// No description provided for @joinClassHeroDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmeninin verdiği sınıf davet kodunu girerek öğrenme yolculuğuna başlayabilirsin.'**
  String get joinClassHeroDesc;

  /// No description provided for @joinClassCodePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'ABC123XY'**
  String get joinClassCodePlaceholder;

  /// No description provided for @joinClassCodeHint.
  ///
  /// In tr, this message translates to:
  /// **'Kodu öğretmeninden alabilirsin.'**
  String get joinClassCodeHint;

  /// No description provided for @joinClassWhereTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kod Nerede?'**
  String get joinClassWhereTitle;

  /// No description provided for @joinClassWhereDesc.
  ///
  /// In tr, this message translates to:
  /// **'Öğretmenin bu kodu tahtaya yansıtmış veya seninle paylaşmış olmalı.'**
  String get joinClassWhereDesc;

  /// No description provided for @joinClassSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Katıl'**
  String get joinClassSubmit;

  /// No description provided for @joinClassSubmitting.
  ///
  /// In tr, this message translates to:
  /// **'Katılıyor…'**
  String get joinClassSubmitting;

  /// No description provided for @joinClassSuccess.
  ///
  /// In tr, this message translates to:
  /// **'{className} sınıfına katıldın'**
  String joinClassSuccess(String className);

  /// No description provided for @joinClassErrorInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Bu kod geçerli değil. Kontrol edip tekrar dene.'**
  String get joinClassErrorInvalid;

  /// No description provided for @joinClassErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Bağlanılamadı. Tekrar dene.'**
  String get joinClassErrorNetwork;

  /// No description provided for @createGameStep1Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencilerin için en uygun etkileşimli bulmaca formatını belirle.'**
  String get createGameStep1Subtitle;

  /// No description provided for @createGameStep2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu bulmaca hangi kelime listesi kapsamında yer alacak?'**
  String get createGameStep2Subtitle;

  /// No description provided for @createGameStep3Title.
  ///
  /// In tr, this message translates to:
  /// **'Sınıfları Ata'**
  String get createGameStep3Title;

  /// No description provided for @createGameStep3Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu bulmacayı çözecek hedef sınıfları belirle.'**
  String get createGameStep3Subtitle;

  /// No description provided for @createGameStepBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri Dön'**
  String get createGameStepBack;

  /// No description provided for @createGameStepNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Adım'**
  String get createGameStepNext;

  /// No description provided for @createGameClassesEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz sınıfın yok. Önce bir sınıf oluştur.'**
  String get createGameClassesEmpty;

  /// No description provided for @createGameClassesError.
  ///
  /// In tr, this message translates to:
  /// **'Sınıflar yüklenemedi.'**
  String get createGameClassesError;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Ayarları'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationMasterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationMasterTitle;

  /// No description provided for @notificationMasterDesc.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama bildirimlerini yönetin'**
  String get notificationMasterDesc;

  /// No description provided for @notificationGroupAssignments.
  ///
  /// In tr, this message translates to:
  /// **'ÖDEV & BULMACA'**
  String get notificationGroupAssignments;

  /// No description provided for @notificationAssignedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni ödev/bulmaca atandığında'**
  String get notificationAssignedTitle;

  /// No description provided for @notificationAssignedDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yeni içerikler yayınlandığında haberdar olun'**
  String get notificationAssignedDesc;

  /// No description provided for @notificationReminderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödev hatırlatması'**
  String get notificationReminderTitle;

  /// No description provided for @notificationReminderDesc.
  ///
  /// In tr, this message translates to:
  /// **'Süresi dolmak üzere olan ödevler için'**
  String get notificationReminderDesc;

  /// No description provided for @notificationGroupResults.
  ///
  /// In tr, this message translates to:
  /// **'SONUÇLAR'**
  String get notificationGroupResults;

  /// No description provided for @notificationResultTeacherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci sonuç paylaştığında'**
  String get notificationResultTeacherTitle;

  /// No description provided for @notificationResultStudentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonucum öğretmene ulaştığında'**
  String get notificationResultStudentTitle;

  /// No description provided for @notificationGroupGeneral.
  ///
  /// In tr, this message translates to:
  /// **'GENEL'**
  String get notificationGroupGeneral;

  /// No description provided for @notificationAnnouncementsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular ve güncellemeler'**
  String get notificationAnnouncementsTitle;

  /// No description provided for @notificationQuietHoursTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sessiz Saatler'**
  String get notificationQuietHoursTitle;

  /// No description provided for @notificationQuietHoursDesc.
  ///
  /// In tr, this message translates to:
  /// **'Gece saatlerinde bildirimleri susturarak odağınızı koruyun.'**
  String get notificationQuietHoursDesc;

  /// No description provided for @notificationQuietHoursCta.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi Ayarla'**
  String get notificationQuietHoursCta;

  /// No description provided for @notificationPrefsLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim tercihleri yüklenemedi.'**
  String get notificationPrefsLoadError;

  /// No description provided for @notificationPrefsSaveError.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim tercihi kaydedilemedi. Lütfen tekrar deneyin.'**
  String get notificationPrefsSaveError;

  /// No description provided for @pushNotificationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get pushNotificationTitle;

  /// No description provided for @languagePreferenceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil Tercihi'**
  String get languagePreferenceTitle;

  /// No description provided for @languageOptionTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageOptionTurkish;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @languageComingSoonBadge.
  ///
  /// In tr, this message translates to:
  /// **'Yakında'**
  String get languageComingSoonBadge;

  /// No description provided for @languageInfo.
  ///
  /// In tr, this message translates to:
  /// **'Seçtiğiniz dil tüm cihazlarınızda hesabınıza kaydedilir.'**
  String get languageInfo;

  /// No description provided for @languageDecorationCaption.
  ///
  /// In tr, this message translates to:
  /// **'Global Öğrenim Topluluğu'**
  String get languageDecorationCaption;

  /// No description provided for @helpCenterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yardım Merkezi'**
  String get helpCenterTitle;

  /// No description provided for @helpSearchPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Yardım konusu ara'**
  String get helpSearchPlaceholder;

  /// No description provided for @helpFaqSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıkça Sorulan Sorular'**
  String get helpFaqSectionTitle;

  /// No description provided for @helpFaqEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Aramanızla eşleşen bir konu bulunamadı.'**
  String get helpFaqEmpty;

  /// No description provided for @helpFaqQ1.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl sınıf oluştururum?'**
  String get helpFaqQ1;

  /// No description provided for @helpFaqA1.
  ///
  /// In tr, this message translates to:
  /// **'Sınıf oluşturmak için ana menüdeki \"Sınıflarım\" sekmesine gidin. Sağ üstteki \"+\" butonuna dokunup sınıfa bir ad verin ve \"Kaydet\" deyin. Sınıf oluştuğunda otomatik bir davet kodu üretilir.'**
  String get helpFaqA1;

  /// No description provided for @helpFaqQ2.
  ///
  /// In tr, this message translates to:
  /// **'Öğrencileri nasıl davet ederim?'**
  String get helpFaqQ2;

  /// No description provided for @helpFaqA2.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturduğunuz sınıfın detayına girin. Sınıfın davet kodunu öğrencilerinizle paylaşın; öğrenci uygulamada \"Sınıfa Katıl\" ekranından bu kodu girerek sınıfınıza eklenir.'**
  String get helpFaqA2;

  /// No description provided for @helpFaqQ3.
  ///
  /// In tr, this message translates to:
  /// **'Bir derse nasıl kelime eklerim (OCR + manuel)?'**
  String get helpFaqQ3;

  /// No description provided for @helpFaqA3.
  ///
  /// In tr, this message translates to:
  /// **'Ders detayında \"Kelime Ekle\" akışını başlatın. Manuel girişte İngilizce terimi ve Türkçe karşılığını yazarsınız. OCR için kelimeleri kâğıda yazıp kameradan veya galeriden okutursunuz; tanınan kelimeleri gözden geçirip düzenledikten sonra kaydedersiniz.'**
  String get helpFaqA3;

  /// No description provided for @helpFaqQ4.
  ///
  /// In tr, this message translates to:
  /// **'Bulmacayı nasıl oluşturup atarım?'**
  String get helpFaqQ4;

  /// No description provided for @helpFaqA4.
  ///
  /// In tr, this message translates to:
  /// **'Kelime listenizi hazırladıktan sonra \"Yeni Bulmaca Oluştur\" akışını açın, oyun türünü ve kelime listesini seçin, ardından bulmacayı çözecek sınıfları belirleyip yayınlayın. Bulmaca aktif öğrencilere ödev olarak atanır.'**
  String get helpFaqA4;

  /// No description provided for @helpFaqQ5.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci sonuçlarını nerede görürüm?'**
  String get helpFaqQ5;

  /// No description provided for @helpFaqA5.
  ///
  /// In tr, this message translates to:
  /// **'\"Raporlar\" sekmesinden veya ilgili öğrencinin detayından paylaşılan sonuçları görebilirsiniz. Her sonuçta tamamlanma süresi ve başarı oranı yer alır.'**
  String get helpFaqA5;

  /// No description provided for @helpFaqQ6.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum, ne yapmalıyım?'**
  String get helpFaqQ6;

  /// No description provided for @helpFaqA6.
  ///
  /// In tr, this message translates to:
  /// **'Giriş ekranındaki \"Şifremi Unuttum\" bağlantısına dokunun ve kayıtlı e-posta adresinizi girin. Size gönderilecek talimatları izleyerek yeni bir şifre belirleyebilirsiniz.'**
  String get helpFaqA6;

  /// No description provided for @helpContactTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hâlâ yardıma mı ihtiyacın var?'**
  String get helpContactTitle;

  /// No description provided for @helpContactDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ekibimiz sorularını yanıtlamak için burada. Bize dilediğin zaman ulaşabilirsin.'**
  String get helpContactDesc;

  /// No description provided for @helpContactCta.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşın'**
  String get helpContactCta;

  /// No description provided for @helpContactEmailSubject.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross Destek Talebi'**
  String get helpContactEmailSubject;

  /// No description provided for @helpContactCopied.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi kopyalandı: {email}'**
  String helpContactCopied(String email);

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Son güncelleme: 24 Haziran 2026'**
  String get privacyLastUpdated;

  /// No description provided for @privacyIntro.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross olarak gizliliğinize büyük önem veriyoruz. Bu politika, uygulamamızı kullanırken verilerinizin nasıl toplandığını, kullanıldığını ve korunduğunu açıklar.'**
  String get privacyIntro;

  /// No description provided for @privacySection1Title.
  ///
  /// In tr, this message translates to:
  /// **'1. Topladığımız Bilgiler'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In tr, this message translates to:
  /// **'Size daha iyi bir deneyim sunabilmek için belirli bilgileri topluyoruz. Bunlar arasında hesap bilgileri (ad soyad, e-posta adresi, rol), öğrenme verileri (oluşturulan dersler, çözülen bulmacalar, başarı ve süre sonuçları) ve teknik veriler (cihaz türü, işletim sistemi sürümü) yer alabilir.'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In tr, this message translates to:
  /// **'2. Bilgileri Nasıl Kullanırız'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In tr, this message translates to:
  /// **'Topladığımız verileri yalnızca hizmeti sunmak ve geliştirmek için kullanırız: öğretmen-öğrenci eşleştirmesi, ders ve kelime yönetimi, oyun sonuçlarının paylaşılması ve ilerlemenin takibi. Kişisel verilerinizi reklam amacıyla üçüncü taraflara satmayız.'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In tr, this message translates to:
  /// **'3. Veri Saklama ve Güvenlik'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In tr, this message translates to:
  /// **'Verileriniz endüstri standardı şifreleme (SSL/TLS) ile aktarılır ve güvenli sunucularda saklanır. Hesabınızı sildiğinizde, yasal saklama yükümlülükleri dışındaki kişisel verileriniz makul bir süre içinde kalıcı olarak silinir.'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In tr, this message translates to:
  /// **'4. Üçüncü Taraf Hizmetler'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın çalışması için sınırlı sayıda güvenilir hizmet sağlayıcıyla (ör. barındırma ve altyapı sağlayıcıları) çalışabiliriz. Bu sağlayıcılar verilerinize yalnızca kendilerine verilen görevi yerine getirmek için sınırlı erişime sahiptir.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In tr, this message translates to:
  /// **'5. Haklarınız'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In tr, this message translates to:
  /// **'KVKK ve GDPR kapsamında verilerinize erişme, hatalı verilerin düzeltilmesini isteme ve verilerinizin silinmesini (unutulma hakkı) talep etme haklarına sahipsiniz.'**
  String get privacySection5Body;

  /// No description provided for @privacyRight1.
  ///
  /// In tr, this message translates to:
  /// **'Verilerinize erişim talep etme ve kopyasını alma.'**
  String get privacyRight1;

  /// No description provided for @privacyRight2.
  ///
  /// In tr, this message translates to:
  /// **'Hatalı verilerin düzeltilmesini isteme.'**
  String get privacyRight2;

  /// No description provided for @privacyRight3.
  ///
  /// In tr, this message translates to:
  /// **'Verilerinizin tamamen silinmesini talep etme.'**
  String get privacyRight3;

  /// No description provided for @privacySection6Title.
  ///
  /// In tr, this message translates to:
  /// **'6. İletişim'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik politikamızla ilgili sorularınız için bizimle iletişime geçebilirsiniz:'**
  String get privacySection6Body;

  /// No description provided for @privacyContactEmail.
  ///
  /// In tr, this message translates to:
  /// **'privacy@lingocross.app'**
  String get privacyContactEmail;

  /// No description provided for @privacyContactLocation.
  ///
  /// In tr, this message translates to:
  /// **'Maslak, İstanbul / Türkiye'**
  String get privacyContactLocation;

  /// No description provided for @privacyContactEmailSubject.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross Gizlilik Sorusu'**
  String get privacyContactEmailSubject;

  /// Paywall ekranı başlığı (AppBar).
  ///
  /// In tr, this message translates to:
  /// **'Premium'**
  String get paywallTitle;

  /// Paywall hero başlığı.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross Premium'**
  String get paywallHeadline;

  /// Paywall hero alt başlığı.
  ///
  /// In tr, this message translates to:
  /// **'Tüm özelliklerin kilidini aç'**
  String get paywallSubtitle;

  /// No description provided for @paywallBannerOcr.
  ///
  /// In tr, this message translates to:
  /// **'AI ile kelime tarama Premium\'da'**
  String get paywallBannerOcr;

  /// No description provided for @paywallBannerClassLimit.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız sınıf Premium\'da'**
  String get paywallBannerClassLimit;

  /// No description provided for @paywallBannerLessonLimit.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız ders Premium\'da'**
  String get paywallBannerLessonLimit;

  /// No description provided for @paywallBannerMultiTeacher.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla öğretmen Premium\'da'**
  String get paywallBannerMultiTeacher;

  /// No description provided for @paywallBannerDefault.
  ///
  /// In tr, this message translates to:
  /// **'Tüm özellikler Premium\'da'**
  String get paywallBannerDefault;

  /// No description provided for @paywallBenefitUnlimitedClasses.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız sınıf ve ders'**
  String get paywallBenefitUnlimitedClasses;

  /// No description provided for @paywallBenefitOcr.
  ///
  /// In tr, this message translates to:
  /// **'AI ile kelime tarama'**
  String get paywallBenefitOcr;

  /// No description provided for @paywallBenefitMultiTeacher.
  ///
  /// In tr, this message translates to:
  /// **'Birden fazla öğretmene katılma'**
  String get paywallBenefitMultiTeacher;

  /// No description provided for @paywallBenefitReports.
  ///
  /// In tr, this message translates to:
  /// **'Tüm raporlar ve istatistikler'**
  String get paywallBenefitReports;

  /// No description provided for @paywallPlanMonthlyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get paywallPlanMonthlyTitle;

  /// No description provided for @paywallPlanMonthlySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Her ay otomatik yenilenir'**
  String get paywallPlanMonthlySubtitle;

  /// No description provided for @paywallPlanMonthlyPeriod.
  ///
  /// In tr, this message translates to:
  /// **'/ay'**
  String get paywallPlanMonthlyPeriod;

  /// No description provided for @paywallPlanAnnualTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get paywallPlanAnnualTitle;

  /// No description provided for @paywallPlanAnnualSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık ödeme, karlı seçim'**
  String get paywallPlanAnnualSubtitle;

  /// No description provided for @paywallPlanAnnualPeriod.
  ///
  /// In tr, this message translates to:
  /// **'/yıl'**
  String get paywallPlanAnnualPeriod;

  /// Yıllık plan rozeti.
  ///
  /// In tr, this message translates to:
  /// **'En Avantajlı'**
  String get paywallPlanBestValue;

  /// Fiyat yer tutucusu (henüz belirlenmedi).
  ///
  /// In tr, this message translates to:
  /// **'—'**
  String get paywallPlanPriceComingSoon;

  /// Plan kartları altındaki deneme notu.
  ///
  /// In tr, this message translates to:
  /// **'7 gün ücretsiz dene, istediğin zaman iptal et.'**
  String get paywallTrialNote;

  /// Paywall ana aksiyon butonu.
  ///
  /// In tr, this message translates to:
  /// **'Premium\'a Yükselt'**
  String get paywallCta;

  /// No description provided for @paywallSkip.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik geç'**
  String get paywallSkip;

  /// Stub satın alma başarı mesajı.
  ///
  /// In tr, this message translates to:
  /// **'Premium etkinleştirildi.'**
  String get paywallActivateSuccess;

  /// 503 stub kapalı mesajı.
  ///
  /// In tr, this message translates to:
  /// **'Şu an satın alma kapalı (test).'**
  String get paywallPurchaseDisabled;

  /// No description provided for @paywallActivateError.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu, lütfen tekrar deneyin.'**
  String get paywallActivateError;

  /// Kilitli özellik rozeti etiketi.
  ///
  /// In tr, this message translates to:
  /// **'Premium'**
  String get lockedFeatureLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
