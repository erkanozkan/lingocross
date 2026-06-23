import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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

  /// No description provided for @authSocialGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google'**
  String get authSocialGoogle;

  /// No description provided for @authSocialApple.
  ///
  /// In tr, this message translates to:
  /// **'Apple'**
  String get authSocialApple;

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

  /// No description provided for @authWelcomeRoleStudentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci Olarak Kaydol'**
  String get authWelcomeRoleStudentTitle;

  /// No description provided for @authWelcomeRoleStudentSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hesap oluştur, öğrenmeye başla'**
  String get authWelcomeRoleStudentSubtitle;

  /// No description provided for @authWelcomeRoleTeacherTitle.
  ///
  /// In tr, this message translates to:
  /// **'Eğitmen Olarak Kaydol'**
  String get authWelcomeRoleTeacherTitle;

  /// No description provided for @authWelcomeRoleTeacherSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni hesap oluştur, sınıflarını yönet'**
  String get authWelcomeRoleTeacherSubtitle;

  /// No description provided for @authWelcomeForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get authWelcomeForgotPassword;

  /// No description provided for @authWelcomeHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı?'**
  String get authWelcomeHaveAccount;

  /// No description provided for @authWelcomeLoginCta.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get authWelcomeLoginCta;

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

  /// No description provided for @authLoginAppbarHelp.
  ///
  /// In tr, this message translates to:
  /// **'Yardım'**
  String get authLoginAppbarHelp;

  /// No description provided for @authLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Hoş Geldin'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'LingoCross ile yolculuğuna devam et'**
  String get authLoginSubtitle;

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

  /// No description provided for @authLoginDividerOr.
  ///
  /// In tr, this message translates to:
  /// **'VEYA ŞUNUNLA DEVAM ET'**
  String get authLoginDividerOr;

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

  /// No description provided for @authRegisterDividerOr.
  ///
  /// In tr, this message translates to:
  /// **'VEYA ŞUNUNLA KAYIT OL'**
  String get authRegisterDividerOr;

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
  /// **'Henüz yeni rapor yok. Öğrenciler oyun oynadıkça burada görünecek.'**
  String get teacherDashboardEmptyReports;

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

  /// No description provided for @wordsListCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kelime'**
  String wordsListCount(int count);

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

  /// No description provided for @wordsListScanComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Kameradan tarama yakında eklenecek.'**
  String get wordsListScanComingSoon;

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
  /// **'Türkçe Karşılık(lar)'**
  String get wordsFormMeaningLabel;

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
  /// **'En az bir Türkçe karşılık girin'**
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
