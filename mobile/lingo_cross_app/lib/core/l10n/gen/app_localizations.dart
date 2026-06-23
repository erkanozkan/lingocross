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
