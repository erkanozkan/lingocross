// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LingoCross';

  @override
  String get authFooterCopyright => '© 2026 LingoCross';

  @override
  String get authFooterPrivacy => 'Privacy Policy';

  @override
  String get authFooterTerms => 'Terms of Use';

  @override
  String get authWelcomeTitle => 'Welcome to LingoCross';

  @override
  String get authWelcomeSubtitle => 'Start your language journey today and break down barriers.';

  @override
  String get authWelcomeBadgeHi => 'Hi!';

  @override
  String get authWelcomeBadgeMerhaba => 'Merhaba!';

  @override
  String get authLoginEmailLabel => 'Email Address';

  @override
  String get authLoginEmailPlaceholder => 'name@example.com';

  @override
  String get authLoginPasswordLabel => 'Password';

  @override
  String get authLoginPasswordPlaceholder => '••••••••';

  @override
  String get authLoginForgotPassword => 'Forgot Password?';

  @override
  String get authLoginSubmit => 'Log In';

  @override
  String get authLoginNoAccount => 'Don\'t have an account?';

  @override
  String get authLoginSignupCta => 'Sign up for free';

  @override
  String get authLoginErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authLoginErrorNetwork => 'Connection error. Please try again.';

  @override
  String get authLoginRememberMe => 'Remember Me';

  @override
  String get authRegisterAppbarLogin => 'Log In';

  @override
  String get authRegisterTitle => 'Start Your Journey';

  @override
  String get authRegisterSubtitle => 'Join thousands of language learners right now.';

  @override
  String get authRegisterRoleStudent => 'Student';

  @override
  String get authRegisterRoleTeacher => 'Teacher';

  @override
  String get authRegisterRoleGroupLabel => 'Role';

  @override
  String get authRegisterFullNameLabel => 'Full Name';

  @override
  String get authRegisterFullNamePlaceholder => 'Alex Rivera';

  @override
  String get authRegisterEmailLabel => 'Email Address';

  @override
  String get authRegisterEmailPlaceholder => 'alex@example.com';

  @override
  String get authRegisterPasswordLabel => 'Create Password';

  @override
  String get authRegisterPasswordPlaceholder => '••••••••';

  @override
  String get authRegisterTermsPrefix => 'I agree to:';

  @override
  String get authRegisterTermsTerms => 'Terms of Use';

  @override
  String get authRegisterTermsAnd => 'and';

  @override
  String get authRegisterTermsPrivacy => 'Privacy Policy';

  @override
  String get authRegisterSubmit => 'Create Account';

  @override
  String get authRegisterHaveAccount => 'Already have an account?';

  @override
  String get authRegisterLoginCta => 'Log In';

  @override
  String get authRegisterErrorEmailTaken => 'This email is already in use.';

  @override
  String get authRegisterErrorNetwork => 'Connection error. Please try again.';

  @override
  String get authForgotTitle => 'Forgot Password';

  @override
  String get authForgotDescription => 'Don\'t worry! Enter the email address associated with your account and we\'ll send you a recovery link.';

  @override
  String get authForgotEmailLabel => 'Email Address';

  @override
  String get authForgotEmailPlaceholder => 'name@example.com';

  @override
  String get authForgotSubmit => 'Send Reset Link';

  @override
  String get authForgotSuccessTitle => 'Link Sent!';

  @override
  String get authForgotSuccessDescription => 'Check your inbox for the reset link. If you can\'t find it, check your spam folder.';

  @override
  String get authForgotSuccessResend => 'Resend';

  @override
  String get authForgotSupportPrefix => 'Still having trouble?';

  @override
  String get authForgotSupportContact => 'Contact Support';

  @override
  String get authForgotErrorNetwork => 'Connection error. Please try again.';

  @override
  String get authValidationEmailRequired => 'Email address is required.';

  @override
  String get authValidationEmailInvalid => 'Enter a valid email address.';

  @override
  String get authValidationPasswordRequired => 'Password is required.';

  @override
  String get authValidationPasswordTooShort => 'Password must be at least 8 characters.';

  @override
  String get authValidationFullNameRequired => 'Full name is required.';

  @override
  String get authValidationTermsRequired => 'Accept the terms to continue.';

  @override
  String get commonErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeTeacherWelcome => 'Welcome, Teacher';

  @override
  String get homeStudentWelcome => 'Welcome, Student';

  @override
  String get homePlaceholderBody => 'Your dashboard will be here soon.';

  @override
  String get homeLogout => 'Log Out';

  @override
  String get commonRetry => 'Try Again';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonComingSoon => 'Coming Soon';

  @override
  String get navHome => 'Home';

  @override
  String get navReports => 'Reports';

  @override
  String get navProfile => 'Profile';

  @override
  String teacherDashboardGreeting(String name) {
    return 'Welcome, $name';
  }

  @override
  String teacherDashboardSubtitle(int count) {
    return 'Teacher Dashboard • You have $count new reports today.';
  }

  @override
  String get teacherDashboardSubtitleEmpty => 'Teacher Dashboard • No new reports.';

  @override
  String teacherDashboardStreak(int days) {
    return '$days Days';
  }

  @override
  String get teacherDashboardActionNewLessonTitle => 'Create New Lesson';

  @override
  String get teacherDashboardActionNewLessonDesc => 'Build a new lesson in minutes with your own word list.';

  @override
  String get teacherDashboardActionNewPuzzleTitle => 'Create New Puzzle';

  @override
  String get teacherDashboardActionNewPuzzleDesc => 'Create and publish a puzzle for your students from a lesson\'s words.';

  @override
  String get teacherDashboardActionProgressTitle => 'Student Progress';

  @override
  String get teacherDashboardActionProgressDesc => 'Review your classes\' performance and individual student reports.';

  @override
  String get teacherDashboardLessonsTitle => 'My Lessons';

  @override
  String get teacherDashboardSeeAll => 'See All';

  @override
  String get teacherDashboardLessonNoStudents => 'No students yet';

  @override
  String get teacherDashboardReportsTitle => 'New Student Reports';

  @override
  String get teacherDashboardEmptyLessonsTitle => 'You don\'t have any lessons yet';

  @override
  String get teacherDashboardEmptyLessonsDesc => 'Get started by creating your first lesson.';

  @override
  String get teacherDashboardEmptyReports => 'Reports will appear here as students share their results.';

  @override
  String get teacherDashboardReportsError => 'Couldn\'t load reports';

  @override
  String get teacherDashboardError => 'Couldn\'t load lessons';

  @override
  String get teacherDashboardLessonCreated => 'Lesson created';

  @override
  String teacherDashboardWordCount(int count) {
    return '$count words';
  }

  @override
  String get teacherDashboardLessonPublished => 'Published';

  @override
  String get teacherDashboardLessonDraft => 'Draft';

  @override
  String get teacherDashboardOpenProfile => 'Open profile';

  @override
  String get navClasses => 'Classes';

  @override
  String get lessonStatusDraft => 'Draft';

  @override
  String get lessonStatusActive => 'Active';

  @override
  String get lessonStatusCompleted => 'Completed';

  @override
  String get lessonStatusDraftUpper => 'DRAFT';

  @override
  String get lessonStatusActiveUpper => 'ACTIVE';

  @override
  String get lessonStatusCompletedUpper => 'COMPLETED';

  @override
  String get lessonsListTitle => 'My Lessons';

  @override
  String get lessonsListCreate => '+ Create New Lesson';

  @override
  String get lessonsListSectionTitle => 'Upcoming Lessons';

  @override
  String lessonsListTotal(int count) {
    return 'Total: $count';
  }

  @override
  String lessonsListWordCount(int count) {
    return '$count Words';
  }

  @override
  String get lessonsListEmptyTitle => 'You don\'t have any lessons yet';

  @override
  String get lessonsListEmptyDesc => 'Get started by creating your first lesson.';

  @override
  String get lessonsListError => 'Couldn\'t load lessons';

  @override
  String get lessonsListNoDate => 'No date set';

  @override
  String get lessonsListFooterHint => 'Scroll to see your past lessons';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get teacherProfileRoleLabel => 'Teacher';

  @override
  String get teacherProfileStatClasses => 'Classes';

  @override
  String get teacherProfileStatStudents => 'Students';

  @override
  String get teacherProfileStatParticipation => 'Participation';

  @override
  String get teacherProfileWeeklyTitle => 'Weekly Homework Completion';

  @override
  String teacherProfileWeeklyDesc(int done, int total) {
    return '$done/$total homework completed';
  }

  @override
  String teacherProfileWeeklyHint(int percent) {
    return 'Your classes\' homework completion rate is up $percent% compared to last week!';
  }

  @override
  String get teacherProfileWeeklyEmpty => 'No homework assigned this week.';

  @override
  String teacherProfileStatValue(int percent) {
    return '$percent%';
  }

  @override
  String get teacherProfileStatsError => 'Couldn\'t load statistics.';

  @override
  String get teacherProfileBadgesTitle => 'Teacher Badges';

  @override
  String get teacherProfileBadgePopular => 'Popular Instructor';

  @override
  String get teacherProfileBadgeFast => 'Fast Grader';

  @override
  String get teacherProfileBadgeInspiring => 'Inspiring';

  @override
  String get teacherProfileMenuClasses => 'Class Management';

  @override
  String get teacherProfileMenuLessons => 'My Lessons';

  @override
  String get teacherProfileMenuReports => 'Statistics & Reports';

  @override
  String get teacherProfileMenuSettings => 'Account Settings';

  @override
  String get teacherProfileMenuLogout => 'Log Out';

  @override
  String get teacherProfileStatsSoon => 'Statistics coming soon — they\'ll fill in as students play games.';

  @override
  String get studentProfileRoleLabel => 'Student';

  @override
  String get studentProfileSettingsTooltip => 'Settings';

  @override
  String get studentProfileStatStreak => 'Daily Streak';

  @override
  String get studentProfileStatGames => 'Games';

  @override
  String get studentProfileStatAccuracy => 'Accuracy';

  @override
  String get studentProfileStatsError => 'Couldn\'t load statistics.';

  @override
  String get studentProfileWeeklyGoalTitle => 'Weekly Goal';

  @override
  String get studentProfileWeeklyGoalSoon => 'Weekly goal tracking coming soon — you\'ll see your progress here as you play.';

  @override
  String get studentProfileAchievementsTitle => 'My Achievements';

  @override
  String get studentProfileBadgeFastStart => 'Fast Start';

  @override
  String get studentProfileBadgeWordHunter => 'Word Hunter';

  @override
  String get studentProfileBadgeQuizMaster => 'Quiz Master';

  @override
  String get studentProfileBadgeLocked => 'Polyglot';

  @override
  String get studentProfileMenuAccount => 'Account Settings';

  @override
  String get studentProfileMenuNotifications => 'Notification Preferences';

  @override
  String get studentProfileMenuHelp => 'Help & Support';

  @override
  String get studentProfileMenuLogout => 'Log Out';

  @override
  String get lessonFormHeroTitle => 'Plan a great lesson!';

  @override
  String get lessonFormHeroDesc => 'Your students are ready to learn something new.';

  @override
  String get lessonFormFieldScheduleLabel => 'Lesson Date / Week';

  @override
  String get lessonFormFieldSchedulePlaceholder => 'e.g. July 15–21, 2024';

  @override
  String get lessonFormFieldUnitLabel => 'Unit Name or Number';

  @override
  String get lessonFormFieldUnitPlaceholder => 'e.g. Unit 4: Food & Drinks';

  @override
  String get lessonFormFieldTopicsLabel => 'Lesson Details and Topics';

  @override
  String get lessonFormFieldTopicsPlaceholder => 'Which topics will you cover in this lesson? Add your important notes here...';

  @override
  String get lessonFormVocabTitle => 'Unit Vocabulary List';

  @override
  String get lessonFormVocabDesc => 'View this unit\'s words or add new ones.';

  @override
  String get lessonFormVocabSaveFirst => 'Save the lesson first, then add words.';

  @override
  String get lessonFormInfoNote => 'When you save the lesson, all your students will be notified. You can edit your plans anytime.';

  @override
  String get lessonFormSaveAndShare => 'Save and Share Lesson';

  @override
  String get lessonDetailTitle => 'Lesson Detail';

  @override
  String get lessonDetailScheduleNone => 'No date set';

  @override
  String get lessonDetailSharedTitle => 'Shared Classes';

  @override
  String lessonDetailSharedCount(int count) {
    return 'Open to $count students';
  }

  @override
  String get lessonDetailSharedNone => 'Not yet open to students';

  @override
  String get lessonDetailSharedDraft => 'Lesson is a draft — it opens to students once published';

  @override
  String get lessonDetailContentTitle => 'Lesson Content';

  @override
  String get lessonDetailContentEmpty => 'No content has been entered for this lesson.';

  @override
  String get lessonDetailWordsTitle => 'Word List';

  @override
  String get lessonDetailWordsSeeAll => 'See All';

  @override
  String get lessonDetailWordsEmpty => 'No words added yet.';

  @override
  String get lessonDetailAddWords => 'Add Words';

  @override
  String get lessonDetailEdit => 'Edit Lesson';

  @override
  String get lessonDetailAssignHomework => 'Assign Homework';

  @override
  String get lessonDetailPublish => 'Publish';

  @override
  String get lessonDetailUnpublish => 'Unpublish';

  @override
  String get lessonDetailComplete => 'Mark as Completed';

  @override
  String get lessonDetailPublishedSnack => 'Lesson published';

  @override
  String get lessonDetailUnpublishedSnack => 'Lesson unpublished';

  @override
  String get lessonDetailCompletedSnack => 'Lesson marked as completed';

  @override
  String get lessonDetailActionError => 'Action failed, please try again.';

  @override
  String get lessonDetailError => 'Couldn\'t load lesson';

  @override
  String get lessonFormTitleCreate => 'New Lesson';

  @override
  String get lessonFormTitleEdit => 'Edit Lesson';

  @override
  String get lessonFormFieldTitleLabel => 'Lesson Title';

  @override
  String get lessonFormFieldTitlePlaceholder => 'e.g. 9-A English Unit 3';

  @override
  String get lessonFormFieldTitleRequired => 'Lesson title is required';

  @override
  String get lessonFormFieldDescriptionLabel => 'Description (optional)';

  @override
  String get lessonFormFieldDescriptionPlaceholder => 'A short note about this lesson…';

  @override
  String get lessonFormFieldSourceLangLabel => 'Source Language';

  @override
  String get lessonFormFieldTargetLangLabel => 'Target Language';

  @override
  String get lessonFormFieldLangSameError => 'Source and target language can\'t be the same';

  @override
  String get lessonFormStatusLabel => 'Publication Status';

  @override
  String get lessonFormStatusDraft => 'Draft';

  @override
  String get lessonFormStatusPublished => 'Published';

  @override
  String get lessonFormStatusDraftHint => 'Only you can see a draft lesson.';

  @override
  String get lessonFormStatusPublishedHint => 'A published lesson is shared with your students.';

  @override
  String get lessonFormSubmitCreate => 'Create Lesson';

  @override
  String get lessonFormSubmitEdit => 'Save Changes';

  @override
  String get lessonFormSubmitting => 'Saving…';

  @override
  String get lessonFormDelete => 'Delete Lesson';

  @override
  String get lessonFormDeleteConfirm => 'This lesson and all its words will be deleted. Are you sure?';

  @override
  String get lessonFormDiscardTitle => 'Unsaved changes';

  @override
  String get lessonFormDiscardConfirm => 'Leave';

  @override
  String get lessonFormDiscardCancel => 'Back to Editing';

  @override
  String get lessonFormError => 'Couldn\'t save lesson, please try again.';

  @override
  String get lessonFormCreatedSnack => 'Lesson created';

  @override
  String get lessonFormUpdatedSnack => 'Lesson updated';

  @override
  String get lessonFormDeletedSnack => 'Lesson deleted';

  @override
  String get lessonFormPublishNoWordsTitle => 'This lesson has no words yet.';

  @override
  String get lessonFormPublishNoWordsConfirm => 'Publish anyway?';

  @override
  String get lessonFormPublishNoWordsPublish => 'Publish';

  @override
  String get lessonFormPublishNoWordsAddWords => 'Add Words';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Turkish';

  @override
  String get langNameEnglish => 'English';

  @override
  String get langNameTurkish => 'Turkish';

  @override
  String get langNameGerman => 'German';

  @override
  String get langNameSpanish => 'Spanish';

  @override
  String get langNameFrench => 'French';

  @override
  String get langNameItalian => 'Italian';

  @override
  String wordsListCount(int count) {
    return '$count words';
  }

  @override
  String get wordsListWordUnit => 'words';

  @override
  String wordsListLangDir(String source, String target) {
    return '$source → $target';
  }

  @override
  String get wordsListScan => 'Scan with Camera';

  @override
  String get wordsListAddManual => 'Add Manually';

  @override
  String get wordsListSourceOcr => 'OCR';

  @override
  String get wordsListSourceManual => 'Manual';

  @override
  String get wordsListSynonymPrefix => 'synonym:';

  @override
  String get wordsListEmptyTitle => 'No words yet';

  @override
  String get wordsListEmptyDesc => 'Scan with the camera or add them manually.';

  @override
  String get wordsListDeleted => 'Word deleted';

  @override
  String get wordsListError => 'Couldn\'t load words';

  @override
  String get wordsListMenuEditLesson => 'Edit Lesson';

  @override
  String get wordsListMenuDeleteLesson => 'Delete Lesson';

  @override
  String get wordsFormTitleAdd => 'Add Word';

  @override
  String get wordsFormTitleEdit => 'Edit Word';

  @override
  String wordsFormTermLabel(String sourceLang) {
    return 'Term ($sourceLang)';
  }

  @override
  String get wordsFormTermPlaceholder => 'e.g. environment';

  @override
  String get wordsFormTermRequired => 'Term is required';

  @override
  String wordsFormMeaningLabel(String lang) {
    return '$lang meaning(s)';
  }

  @override
  String get wordsFormMeaningPlaceholder => 'e.g. çevre';

  @override
  String get wordsFormMeaningAddMore => 'Add Meaning';

  @override
  String get wordsFormMeaningRequired => 'Enter at least one meaning';

  @override
  String get wordsFormMeaningPrimaryLabel => 'Primary meaning';

  @override
  String wordsFormMeaningRemoveLabel(int index) {
    return 'Meaning $index, delete';
  }

  @override
  String get wordsFormSynonymsLabel => 'Synonyms (optional)';

  @override
  String get wordsFormSynonymsHint => 'Other terms with the same meaning. Used as hints in the game.';

  @override
  String get wordsFormSynonymsPlaceholder => 'Type a synonym and add it';

  @override
  String get wordsFormSave => 'Save';

  @override
  String get wordsFormSaveAndNew => 'Save and Add New';

  @override
  String get wordsFormCancel => 'Cancel';

  @override
  String get wordsFormSaving => 'Saving…';

  @override
  String get wordsFormError => 'Couldn\'t save word, please try again.';

  @override
  String get wordsFormAddedSnack => 'Word added';

  @override
  String get wordsFormUpdatedSnack => 'Word updated';

  @override
  String get lessonsErrorNetwork => 'Connection error. Please try again.';

  @override
  String get lessonsErrorNotFound => 'Content not found.';

  @override
  String get lessonsErrorForbidden => 'You don\'t have permission for this action.';

  @override
  String get lessonsErrorValidation => 'Check the information you entered.';

  @override
  String get ocrCaptureTitle => 'Upload Word List';

  @override
  String get ocrCaptureHowTitle => 'How It Works';

  @override
  String get ocrCaptureHowDesc => 'Take a photo of your handwritten list. AI reads the photo and imports the words into your list automatically.';

  @override
  String get ocrCaptureStep1 => 'Take Photo';

  @override
  String get ocrCaptureStep2 => 'Scan';

  @override
  String get ocrCaptureStep3 => 'Confirm';

  @override
  String get ocrCaptureTriggerTitle => 'Scan with Camera';

  @override
  String get ocrCaptureTriggerSubtitle => 'Or pick a photo from your gallery';

  @override
  String get ocrCaptureSourceCamera => 'Take with camera';

  @override
  String get ocrCaptureSourceGallery => 'Pick from Gallery';

  @override
  String get ocrCapturePhotoRemoveLabel => 'Remove photo';

  @override
  String get ocrCaptureExtract => 'Extract Words';

  @override
  String get ocrCaptureReading => 'Reading image with AI…';

  @override
  String get ocrCaptureOr => 'OR';

  @override
  String get ocrCaptureManual => 'Manual Entry';

  @override
  String get ocrCapturePermissionTitle => 'Camera/gallery access required';

  @override
  String get ocrCapturePermissionDesc => 'To continue, allow camera or gallery access in settings.';

  @override
  String get ocrReviewTitle => 'Recognized Words';

  @override
  String ocrReviewSummary(int count) {
    return '$count words recognized';
  }

  @override
  String ocrReviewSelected(int count) {
    return '$count selected';
  }

  @override
  String get ocrReviewConfidenceNote => 'AI reading can be inaccurate; review before saving.';

  @override
  String ocrReviewTermLabel(String sourceLang) {
    return 'Term ($sourceLang)';
  }

  @override
  String get ocrReviewTermPlaceholder => 'e.g. environment';

  @override
  String get ocrReviewIncludeLabel => 'Will be saved';

  @override
  String get ocrReviewExcludeLabel => 'Excluded';

  @override
  String ocrReviewRowRemoveLabel(int index) {
    return 'Candidate $index, delete';
  }

  @override
  String get ocrReviewSwap => 'Swap term and meaning';

  @override
  String get ocrReviewAddRow => 'Add Row';

  @override
  String get ocrReviewClearAll => 'Clear All';

  @override
  String ocrReviewSave(int count) {
    return 'Save Selected ($count)';
  }

  @override
  String get ocrReviewEmptyTitle => 'No words recognized';

  @override
  String get ocrReviewEmptyDesc => 'Try a clear, well-lit photo.';

  @override
  String get ocrReviewRetry => 'Scan Again';

  @override
  String get ocrReviewError => 'Scan failed';

  @override
  String get ocrReviewInvalidRows => 'Fill in or remove the incomplete rows.';

  @override
  String get ocrReviewSaving => 'Saving…';

  @override
  String ocrReviewPartialError(int count) {
    return '$count words couldn\'t be saved. Retry the failed rows.';
  }

  @override
  String ocrReviewSavedSnack(int count) {
    return '$count words added';
  }

  @override
  String get commonContinue => 'Continue';

  @override
  String studentDashboardGreeting(String name) {
    return 'Hi, $name! 👋';
  }

  @override
  String get studentDashboardSubtitle => 'Ready for today\'s word hunt?';

  @override
  String get studentDashboardMyClassesTitle => 'My Classes';

  @override
  String studentDashboardMyClassTeacher(String teacher) {
    return 'Teacher: $teacher';
  }

  @override
  String get studentDashboardMyClassesEmpty => 'You haven\'t joined a class yet.';

  @override
  String studentDashboardStreak(int days) {
    return '$days';
  }

  @override
  String studentDashboardStreakSemantic(int days) {
    return '$days-day streak';
  }

  @override
  String get studentDashboardGameOfDay => 'Game of the Day';

  @override
  String studentDashboardGameSharedBy(String teacher) {
    return 'Shared by: $teacher';
  }

  @override
  String get studentDashboardGameAssigned => 'Game Assigned by Your Teacher';

  @override
  String studentDashboardGameDesc(int count) {
    return 'Match $count words and improve your accuracy and time.';
  }

  @override
  String get studentDashboardPlayGame => 'Start Game';

  @override
  String get studentDashboardLessonsTitle => 'My Lessons';

  @override
  String get studentDashboardProgressTitle => 'Progress Summary';

  @override
  String get studentDashboardStatGames => 'Games Completed';

  @override
  String get studentDashboardStatAccuracy => 'Average Accuracy';

  @override
  String get studentDashboardWeeklyGoal => 'Weekly Goal';

  @override
  String get studentDashboardAchievementsTitle => 'Recent Achievements';

  @override
  String get studentDashboardJoinTeacherTitle => 'Join a Class';

  @override
  String get studentDashboardJoinTeacherDesc => 'Enter the class invite code from your teacher to access their lessons.';

  @override
  String get studentDashboardJoinTeacherLinkShort => 'Join a new class';

  @override
  String get studentDashboardEmptyNoTeacherTitle => 'You haven\'t joined a class yet';

  @override
  String get studentDashboardEmptyNoTeacherDesc => 'Get started with the class invite code from your teacher.';

  @override
  String get studentDashboardEmptyNoLessonsTitle => 'Your teacher hasn\'t published any lessons yet';

  @override
  String get studentDashboardEmptyNoLessonsDesc => 'New lessons will appear here.';

  @override
  String get studentDashboardPuzzlesTitle => 'Assigned Puzzles';

  @override
  String get studentDashboardEmptyNoPuzzlesTitle => 'Your teacher hasn\'t assigned any puzzles yet';

  @override
  String get studentDashboardEmptyNoPuzzlesDesc => 'They\'ll appear here once your teacher publishes a puzzle.';

  @override
  String studentDashboardPuzzleLesson(String lesson, int count) {
    return '$lesson • $count words';
  }

  @override
  String get studentDashboardCompletedTitle => 'Completed Puzzles';

  @override
  String studentDashboardCompletedScore(int percent) {
    return '$percent%';
  }

  @override
  String get studentDashboardCompletedSeeStats => 'See Stats';

  @override
  String get studentDashboardCompletedBadge => 'Completed';

  @override
  String get studentDashboardStatsSoon => 'Coming soon — it\'ll appear here once you play your first game.';

  @override
  String get studentDashboardStatsEmpty => 'You haven\'t played any games yet.';

  @override
  String get studentDashboardStatsError => 'Couldn\'t load progress summary.';

  @override
  String studentDashboardStatAccuracyValue(int percent) {
    return '$percent%';
  }

  @override
  String get studentDashboardSeeReports => 'My Reports';

  @override
  String get studentDashboardError => 'Couldn\'t load lessons';

  @override
  String get studentDashboardJoined => 'You joined the class';

  @override
  String get studentJoinAppBarTitle => 'Join a Teacher';

  @override
  String get studentJoinHeroTitle => 'Enter the Invite Code';

  @override
  String get studentJoinHeroDesc => 'Enter the invite from your teacher to join their lessons.';

  @override
  String get studentJoinCodeLabel => 'Invite Code';

  @override
  String get studentJoinCodeHint => 'You can get the code from your teacher.';

  @override
  String get studentJoinSubmit => 'Join';

  @override
  String get studentJoinSubmitting => 'Joining…';

  @override
  String get studentJoinErrorInvalid => 'This code isn\'t valid. Check it and try again.';

  @override
  String get studentJoinErrorAlready => 'You\'ve already joined this teacher.';

  @override
  String get studentJoinErrorExpired => 'This code has expired. Ask your teacher for a new one.';

  @override
  String get studentJoinErrorNetwork => 'Couldn\'t connect. Try again.';

  @override
  String get studentJoinBackToDashboard => 'Back to Dashboard';

  @override
  String studentJoinSuccess(String teacher) {
    return 'You joined $teacher\'s class';
  }

  @override
  String get studentLessonPlay => 'Play';

  @override
  String get studentLessonEmptyTitle => 'No words in this lesson yet';

  @override
  String get studentLessonEmptyDesc => 'They\'ll appear here once your teacher adds words.';

  @override
  String get studentLessonError => 'Couldn\'t load words';

  @override
  String get gameStarting => 'Preparing game…';

  @override
  String get gameStartErrorNetwork => 'Couldn\'t connect. Try again.';

  @override
  String get gameStartErrorNotFound => 'Game not found.';

  @override
  String get gameStartErrorForbidden => 'You don\'t have access to this game.';

  @override
  String get gameStartErrorInsufficientWords => 'This lesson doesn\'t have enough words for a game. The game will be ready once your teacher adds words.';

  @override
  String get gameMatchingTitle => 'Word Matching';

  @override
  String get gameMatchingCurrentGameLabel => 'Current Game';

  @override
  String gameMatchingCounter(int matched, int total) {
    return '$matched / $total';
  }

  @override
  String get gameMatchingColEnglish => 'English';

  @override
  String get gameMatchingColTurkish => 'Turkish';

  @override
  String get gameMatchingColEnglishUpper => 'ENGLISH';

  @override
  String get gameMatchingColTurkishUpper => 'TURKISH';

  @override
  String get gameMatchingCurrentGameLabelUpper => 'CURRENT GAME';

  @override
  String gameMatchingTimerSemantic(String time) {
    return 'Elapsed time $time';
  }

  @override
  String get gameMatchingEncouragement => 'You\'re doing great! Match the words to pick up speed.';

  @override
  String get gameMatchingQuit => 'Quit';

  @override
  String get gameMatchingQuitConfirmTitle => 'Quit the game?';

  @override
  String get gameMatchingQuitConfirmDesc => 'If you quit, your progress won\'t be saved.';

  @override
  String get gameMatchingQuitConfirmConfirm => 'Quit';

  @override
  String get gameMatchingQuitConfirmCancel => 'Continue';

  @override
  String get gameMatchingA11yMatched => 'matched';

  @override
  String get gameMatchingA11yWrong => 'wrong, try again';

  @override
  String get gameMatchingCompleteTitle => 'Congratulations!';

  @override
  String gameMatchingCompleteMessage(int matched, int total, String time) {
    return 'You matched all words $matched/$total. Time: $time.';
  }

  @override
  String get gameMatchingCompleteFinish => 'Finish';

  @override
  String get gameMatchingEmptyTitle => 'No game in this lesson yet';

  @override
  String get gameMatchingEmptyDesc => 'The game will be ready once your teacher adds enough words.';

  @override
  String get gameMatchingError => 'Couldn\'t load game';

  @override
  String get createGameTitle => 'Create New Puzzle';

  @override
  String get createGameStep1Title => 'Choose Game Type';

  @override
  String get createGameStep2Title => 'Select Lesson';

  @override
  String get createGameTypeMatchingTitle => 'Word Matching';

  @override
  String get createGameTypeMatchingDesc => 'Speed up learning by matching words with their meanings.';

  @override
  String get createGameTypeCrosswordTitle => 'Crossword';

  @override
  String get createGameTypeCrosswordDesc => 'Have them find the words using clues.';

  @override
  String get createGameTypeScrambledTitle => 'Scrambled Letters';

  @override
  String get createGameTypeScrambledDesc => 'Have them unscramble the letters into the correct order to find the word.';

  @override
  String get createGameLessonLabel => 'Word List to Use';

  @override
  String get createGameLessonHint => 'Select a lesson…';

  @override
  String get createGameLessonsEmpty => 'You don\'t have any lessons yet. Create a lesson first.';

  @override
  String get createGameLessonsError => 'Couldn\'t load lessons.';

  @override
  String get createGamePreviewTitle => 'Sample Preview';

  @override
  String get createGamePreviewSubtitle => 'This is roughly how the puzzle will look once saved. If you don\'t like it, go back and change the type or lesson.';

  @override
  String get createGamePreviewSampleNote => 'This is only a sample preview; it hasn\'t been saved.';

  @override
  String get createGamePreviewLoading => 'Preparing preview…';

  @override
  String get createGamePreviewError => 'Couldn\'t build the preview, please try again.';

  @override
  String get createGamePreviewEmpty => 'No content to preview.';

  @override
  String get createGameSubmit => 'Create Puzzle';

  @override
  String get createGameSuccess => 'Puzzle created and published.';

  @override
  String get createGameErrorInsufficientWords => 'A lesson must have at least 4 words to create a puzzle.';

  @override
  String get createGameErrorNetwork => 'Couldn\'t connect. Try again.';

  @override
  String get createGameErrorGeneric => 'Couldn\'t create puzzle, please try again.';

  @override
  String get gameCrosswordTitle => 'Puzzle of the Day';

  @override
  String gameCrosswordCounter(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get gameCrosswordAcross => 'ACROSS';

  @override
  String get gameCrosswordDown => 'DOWN';

  @override
  String get gameCrosswordFinish => 'Finish';

  @override
  String get gameCrosswordKeyDelete => 'Delete';

  @override
  String get gameCrosswordCompleteTitle => 'Puzzle completed!';

  @override
  String get gameCrosswordCellSemantic => 'Puzzle cell';

  @override
  String gameCrosswordCellNumberedSemantic(int number) {
    return 'Starting cell of word number $number';
  }

  @override
  String get gameCrosswordCellEmpty => 'empty';

  @override
  String get gameScrambledTitle => 'Arrange the Letters';

  @override
  String get gameScrambledClueLabel => 'TRANSLATION HINT';

  @override
  String get gameScrambledInstruction => 'Tap the letters to arrange them in the correct order. Tap a placed letter to take it back.';

  @override
  String get gameScrambledPrevious => 'Previous word';

  @override
  String get gameScrambledNext => 'Next word';

  @override
  String get gameScrambledLetterSemantic => 'letter, tap to add';

  @override
  String get gameScrambledSlotSemantic => 'placed, tap to remove';

  @override
  String get gameScrambledEmptySlot => 'empty letter slot';

  @override
  String get teacherStudentsAppBarTitle => 'My Students';

  @override
  String get teacherStudentsCodeLabel => 'Invite Code';

  @override
  String get teacherStudentsCodeDesc => 'Share this code with your students; once they enter it, they join your lessons.';

  @override
  String get teacherStudentsCopy => 'Copy';

  @override
  String get teacherStudentsCopied => 'Code copied';

  @override
  String get teacherStudentsShare => 'Share';

  @override
  String teacherStudentsShareMessage(String code) {
    return 'Join me on LingoCross. Invite code: $code';
  }

  @override
  String get teacherStudentsShareCopied => 'Invite text copied';

  @override
  String get teacherStudentsRegenerate => 'New Code';

  @override
  String get teacherStudentsRegenerateConfirm => 'If you generate a new code, the old one will stop working. Continue?';

  @override
  String get teacherStudentsRegenerated => 'New invite code generated';

  @override
  String get teacherStudentsRegenerateError => 'Couldn\'t generate a new code, please try again.';

  @override
  String get teacherStudentsListTitle => 'Students';

  @override
  String teacherStudentsCount(int count) {
    return '$count students';
  }

  @override
  String teacherStudentsJoinedAt(String date) {
    return 'Joined: $date';
  }

  @override
  String get teacherStudentsStatusActive => 'Active';

  @override
  String get teacherStudentsEmptyTitle => 'You don\'t have any students yet';

  @override
  String get teacherStudentsEmptyDesc => 'Share the invite code above with your students.';

  @override
  String get teacherStudentsErrorCode => 'Couldn\'t load invite code';

  @override
  String get teacherStudentsErrorList => 'Couldn\'t load students';

  @override
  String teacherStudentsCodeSemantic(String spaced) {
    return 'Invite code: $spaced';
  }

  @override
  String get gameResultSubmitting => 'Saving your result…';

  @override
  String get gameResultSubmitError => 'Couldn\'t save result, please try again.';

  @override
  String get gameResultTitle => 'Game Summary';

  @override
  String get gameResultSubtitle => 'Great job!';

  @override
  String gameResultAccuracyValue(int percent) {
    return '$percent%';
  }

  @override
  String get gameResultAccuracyLabel => 'Accuracy';

  @override
  String gameResultAccuracyA11y(int percent) {
    return 'Accuracy $percent percent';
  }

  @override
  String get gameResultTimeLabel => 'Elapsed Time';

  @override
  String get gameResultWordsLabel => 'Words Found';

  @override
  String gameResultWordsValue(int found, int total) {
    return '$found / $total';
  }

  @override
  String get gameResultSharedNote => 'Shared with your teacher';

  @override
  String get gameResultErrorTitle => 'Couldn\'t load result';

  @override
  String get resultsHistoryTitle => 'My Results';

  @override
  String get resultsHistorySubtitle => 'All your game history';

  @override
  String get resultsHistorySummaryTotalGames => 'Total Games';

  @override
  String get resultsHistorySummaryAvgAccuracy => 'Average Accuracy';

  @override
  String get resultsHistoryItemShared => 'Sent';

  @override
  String resultsHistoryItemA11y(String lesson, int percent, String time, int found, int total) {
    return '$lesson, accuracy $percent percent, time $time, $found / $total';
  }

  @override
  String resultsHistoryItemDateA11y(String lesson, int percent, String time, int found, int total, String date) {
    return '$lesson, accuracy $percent percent, time $time, $found / $total, $date';
  }

  @override
  String get resultsHistoryEmptyTitle => 'You haven\'t played any games yet';

  @override
  String get resultsHistoryEmptyDesc => 'Once you finish a lesson game, your result will appear here.';

  @override
  String get resultsHistoryEmptyCta => 'Start Game';

  @override
  String get resultsHistoryErrorTitle => 'Couldn\'t load results';

  @override
  String get resultsErrorNetwork => 'Connection error. Please try again.';

  @override
  String get resultsErrorNotFound => 'Result not found.';

  @override
  String get resultsErrorForbidden => 'You don\'t have permission for this action.';

  @override
  String get trackingStudentsTitle => 'Student Reports';

  @override
  String get trackingStudentsSubtitle => 'Track the game results your students share.';

  @override
  String get trackingStudentsListTitle => 'Students';

  @override
  String trackingSharedCountLabel(int count) {
    return '$count shared results';
  }

  @override
  String get trackingAverageLabel => 'Average';

  @override
  String get trackingAverageNone => '—';

  @override
  String trackingLastActivityLabel(String date) {
    return 'Last activity: $date';
  }

  @override
  String get trackingLastActivityNone => 'Last activity: none yet';

  @override
  String trackingStudentRowA11y(String name, int count) {
    return '$name, $count shared results';
  }

  @override
  String get trackingStudentsEmptyTitle => 'No shared results yet';

  @override
  String get trackingStudentsEmptyDesc => 'Results appear here once your students share their games. If you don\'t have any students yet, share your invite code from the Classes tab.';

  @override
  String get trackingStudentsErrorTitle => 'Couldn\'t load students';

  @override
  String get trackingDetailTitle => 'Student Report';

  @override
  String get trackingDetailAverageLabel => 'Average Accuracy';

  @override
  String get trackingDetailResultsLabel => 'Shared Results';

  @override
  String get trackingDetailResultsTitle => 'Shared Results';

  @override
  String get trackingDetailEmptyTitle => 'No shared results yet';

  @override
  String get trackingDetailEmptyDesc => 'This student hasn\'t shared any game results with you yet.';

  @override
  String get trackingDetailErrorTitle => 'Couldn\'t load results';

  @override
  String trackingResultA11y(String lesson, int percent, String time, int found, int total, String date) {
    return '$lesson, accuracy $percent percent, time $time, $found / $total, $date';
  }

  @override
  String get resultDetailTitle => 'Result Detail';

  @override
  String resultDetailDateTime(String date, String time) {
    return '$date • $time';
  }

  @override
  String get resultDetailMetricAccuracy => 'Score';

  @override
  String get resultDetailMetricCorrect => 'Correct';

  @override
  String get resultDetailMetricDuration => 'Time';

  @override
  String resultDetailFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String resultDetailFilterCorrect(int count) {
    return 'Correct ($count)';
  }

  @override
  String resultDetailFilterWrong(int count) {
    return 'Wrong ($count)';
  }

  @override
  String get resultDetailBadgeCorrect => 'Correct';

  @override
  String get resultDetailBadgeWrong => 'Wrong';

  @override
  String resultDetailCorrectAnswer(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String resultDetailStudentAnswer(String answer) {
    return 'Student\'s answer: $answer';
  }

  @override
  String get resultDetailStudentAnswerEmpty => 'Student\'s answer: — (empty)';

  @override
  String get resultDetailAnalysisTitle => 'Round Analysis';

  @override
  String get resultDetailSpeedScore => 'Speed Score';

  @override
  String get resultDetailSpeedGreat => 'Great!';

  @override
  String get resultDetailSpeedGood => 'Good';

  @override
  String get resultDetailSpeedFair => 'Fair';

  @override
  String get resultDetailSpeedSlow => 'Take your time';

  @override
  String resultDetailSpeedDesc(String seconds) {
    return 'Average $seconds sec per word.';
  }

  @override
  String get resultDetailNoItemsTitle => 'No word details';

  @override
  String get resultDetailNoItemsDesc => 'There\'s no per-word breakdown because this result comes from an older play.';

  @override
  String get resultDetailErrorTitle => 'Couldn\'t load result detail';

  @override
  String resultDetailItemCorrectA11y(String term, String answer) {
    return '$term, meaning $answer, correct';
  }

  @override
  String resultDetailItemWrongA11y(String term, String expected, String given) {
    return '$term, correct answer $expected, student\'s answer $given, wrong';
  }

  @override
  String get gameTypeWordMatching => 'Word Matching';

  @override
  String get gameTypeCrossword => 'Crossword';

  @override
  String get gameTypeQuestionSet => 'Question Set';

  @override
  String get gameTypeScrambled => 'Scrambled Letters';

  @override
  String get trackingErrorNetwork => 'Connection error. Please try again.';

  @override
  String get trackingErrorNotFound => 'Student not found.';

  @override
  String get trackingErrorForbidden => 'You don\'t have permission for this action.';

  @override
  String get teacherDashboardActionMyPuzzlesTitle => 'My Puzzles';

  @override
  String get teacherDashboardActionMyPuzzlesDesc => 'View, share, and track solve statistics for all the puzzles you\'ve created.';

  @override
  String get myPuzzlesTitle => 'My Puzzles';

  @override
  String get myPuzzlesCreateCta => 'Create New Puzzle';

  @override
  String get myPuzzlesFilterAll => 'All';

  @override
  String myPuzzlesFilterActive(int count) {
    return 'Active ($count)';
  }

  @override
  String get myPuzzlesTypeWordMatching => 'Word Matching';

  @override
  String get myPuzzlesTypeCrossword => 'Crossword';

  @override
  String get myPuzzlesStatusActive => 'Active';

  @override
  String myPuzzlesCreatedAt(String date) {
    return 'Created: $date';
  }

  @override
  String myPuzzlesSharedWith(int count) {
    return 'Shared with: $count students';
  }

  @override
  String get myPuzzlesSeeDetails => 'See Details';

  @override
  String get myPuzzlesStatTotal => 'Total Puzzles';

  @override
  String get myPuzzlesStatSolves => 'Student Solves';

  @override
  String get myPuzzlesEmptyTitle => 'No puzzles yet';

  @override
  String get myPuzzlesEmptyDesc => 'Get started by creating your first puzzle.';

  @override
  String get myPuzzlesErrorTitle => 'Couldn\'t load puzzles';

  @override
  String get accountSettingsTitle => 'Account Settings';

  @override
  String get accountEditProfileCta => 'Edit Profile';

  @override
  String get accountGroupGeneral => 'GENERAL';

  @override
  String get accountGroupSecurity => 'SECURITY';

  @override
  String get accountGroupSupport => 'SUPPORT & ABOUT';

  @override
  String get accountRowNotifications => 'Notification Settings';

  @override
  String get accountRowLanguage => 'Language Preference';

  @override
  String get accountRowTheme => 'Theme';

  @override
  String get accountRowThemeValueLight => 'Light';

  @override
  String get accountRowChangePassword => 'Change Password';

  @override
  String get accountRowTwoFactor => 'Two-Factor Authentication';

  @override
  String get accountRowHelpCenter => 'Help Center';

  @override
  String get accountRowPrivacy => 'Privacy Policy';

  @override
  String get accountLogout => 'Log Out';

  @override
  String accountVersion(String version) {
    return 'LingoCross v$version';
  }

  @override
  String get accountSaveLabel => 'Save';

  @override
  String get accountSavingLabel => 'Saving…';

  @override
  String get accountEditProfileTitle => 'Edit Profile';

  @override
  String get accountEditProfileNameLabel => 'Full Name';

  @override
  String get accountEditProfileNamePlaceholder => 'Enter your name';

  @override
  String get accountEditProfileSavedSnack => 'Your profile was updated';

  @override
  String get accountChangePasswordTitle => 'Change Password';

  @override
  String get accountChangePasswordCurrentLabel => 'Current Password';

  @override
  String get accountChangePasswordNewLabel => 'New Password';

  @override
  String get accountChangePasswordConfirmLabel => 'New Password (Repeat)';

  @override
  String get accountChangePasswordMismatch => 'New passwords don\'t match.';

  @override
  String get accountChangePasswordWrongCurrent => 'Current password is incorrect.';

  @override
  String get accountChangePasswordSubmit => 'Update Password';

  @override
  String get accountChangePasswordSavedSnack => 'Your password was changed';

  @override
  String get accountGroupDangerZone => 'DANGER ZONE';

  @override
  String get accountRowDeleteAccount => 'Delete Account';

  @override
  String get accountDeleteDialogTitle => 'Delete your account';

  @override
  String get accountDeleteDialogBody => 'Your account and all your data (classes, lessons, results) will be permanently deleted. This action cannot be undone.';

  @override
  String get accountDeleteConfirm => 'Delete Account';

  @override
  String get accountDeleteCancel => 'Cancel';

  @override
  String get accountDeleteError => 'Your account could not be deleted. Please try again.';

  @override
  String get classesTitle => 'My Classes';

  @override
  String get classesHeroTitle => 'Hello, Teacher!';

  @override
  String classesHeroSubtitle(int count) {
    return 'You have lessons with $count different classes today. Good luck.';
  }

  @override
  String get classesStatTotalStudents => 'Total Students';

  @override
  String get classesStatActivity => 'Activity';

  @override
  String classesStatActivityValue(int percent) {
    return '$percent%';
  }

  @override
  String get classesActiveSectionTitle => 'Active Classes';

  @override
  String get classesSeeAll => 'See All';

  @override
  String classesStudentCount(int count) {
    return '$count students';
  }

  @override
  String get classesInviteCodeChipLabel => 'Invite Code:';

  @override
  String get classesCreateButton => 'Create New Class';

  @override
  String get classesEmptyTitle => 'You don\'t have any classes yet';

  @override
  String get classesEmptyDesc => 'Create your first class and invite your students with the invite code.';

  @override
  String get classesError => 'Couldn\'t load classes';

  @override
  String get classCreateTitle => 'New Class';

  @override
  String get classCreateNameLabel => 'Class Name';

  @override
  String get classCreateNamePlaceholder => 'e.g. 6-A';

  @override
  String get classCreateInfo => 'After you create the class, an invite code to share with your students will be generated.';

  @override
  String get classCreatePerkProgress => 'Progress Tracking';

  @override
  String get classCreatePerkRewards => 'Reward System';

  @override
  String get classCreateSubmit => 'Create';

  @override
  String classCreateSuccess(String name) {
    return 'Class $name created.';
  }

  @override
  String get classCreateErrorNetwork => 'Couldn\'t connect. Try again.';

  @override
  String get classCreateErrorGeneric => 'Couldn\'t create class, please try again.';

  @override
  String get classDetailFallbackTitle => 'Class';

  @override
  String get classDetailCodeLabel => 'Class Invite Code';

  @override
  String classDetailCodeSemantic(String spaced) {
    return 'Class invite code: $spaced';
  }

  @override
  String get classDetailCopy => 'Copy';

  @override
  String get classDetailCodeCopied => 'Code copied';

  @override
  String get classDetailShare => 'Share';

  @override
  String classDetailShareMessage(String code) {
    return 'Join my class on LingoCross. Invite code: $code';
  }

  @override
  String get classDetailShareCopied => 'Invite text copied';

  @override
  String get classDetailRegenerate => 'Generate New Code';

  @override
  String get classDetailRegenerateConfirm => 'If you generate a new code, the old one will stop working. Continue?';

  @override
  String get classDetailRegenerated => 'New invite code generated';

  @override
  String get classDetailRegenerateError => 'Couldn\'t generate a new code, please try again.';

  @override
  String classDetailStudents(int count) {
    return 'Students ($count)';
  }

  @override
  String get classDetailAdd => 'Add';

  @override
  String get classDetailAddHint => 'Share the invite code to add students.';

  @override
  String get classDetailRemove => 'Remove';

  @override
  String classDetailRemoveConfirm(String name) {
    return 'Remove $name from this class?';
  }

  @override
  String classDetailRemoved(String name) {
    return '$name removed from the class';
  }

  @override
  String get classDetailRemoveError => 'Couldn\'t remove student, please try again.';

  @override
  String get classDetailAssignHomework => 'Assign Homework to This Class';

  @override
  String get classDetailEmptyTitle => 'No students yet';

  @override
  String get classDetailEmptyDesc => 'Share the invite code above with your students.';

  @override
  String get classDetailErrorCode => 'Couldn\'t load invite code';

  @override
  String get classDetailErrorList => 'Couldn\'t load students';

  @override
  String get joinClassTitle => 'Join a Class';

  @override
  String get joinClassHeroTitle => 'A New Class';

  @override
  String get joinClassHeroDesc => 'Enter the class invite code from your teacher to start your learning journey.';

  @override
  String get joinClassCodePlaceholder => 'ABC123XY';

  @override
  String get joinClassCodeHint => 'You can get the code from your teacher.';

  @override
  String get joinClassWhereTitle => 'Where\'s the Code?';

  @override
  String get joinClassWhereDesc => 'Your teacher should have projected this code on the board or shared it with you.';

  @override
  String get joinClassSubmit => 'Join';

  @override
  String get joinClassSubmitting => 'Joining…';

  @override
  String joinClassSuccess(String className) {
    return 'You joined the class $className';
  }

  @override
  String get joinClassErrorInvalid => 'This code isn\'t valid. Check it and try again.';

  @override
  String get joinClassErrorNetwork => 'Couldn\'t connect. Try again.';

  @override
  String get createGameStep1Subtitle => 'Pick the interactive puzzle format that works best for your students.';

  @override
  String get createGameStep2Subtitle => 'Which word list will this puzzle be based on?';

  @override
  String get createGameStep3Title => 'Assign Classes';

  @override
  String get createGameStep3Subtitle => 'Choose the target classes that will solve this puzzle.';

  @override
  String get createGameStepBack => 'Go Back';

  @override
  String get createGameStepNext => 'Next Step';

  @override
  String get createGameClassesEmpty => 'You don\'t have any classes yet. Create a class first.';

  @override
  String get createGameClassesError => 'Couldn\'t load classes.';

  @override
  String get createGameNoClassesTitle => 'Create a class first';

  @override
  String get createGameNoClassesDesc => 'You need at least one class before you can assign a puzzle.';

  @override
  String get createGameNoClassesAction => 'Create a Class';

  @override
  String get notificationSettingsTitle => 'Notification Settings';

  @override
  String get notificationMasterTitle => 'Notifications';

  @override
  String get notificationMasterDesc => 'Manage app notifications';

  @override
  String get notificationGroupAssignments => 'HOMEWORK & PUZZLES';

  @override
  String get notificationAssignedTitle => 'When new homework/puzzle is assigned';

  @override
  String get notificationAssignedDesc => 'Be notified when new content is published';

  @override
  String get notificationReminderTitle => 'Homework reminder';

  @override
  String get notificationReminderDesc => 'For homework that\'s almost due';

  @override
  String get notificationGroupResults => 'RESULTS';

  @override
  String get notificationResultTeacherTitle => 'When a student shares a result';

  @override
  String get notificationResultStudentTitle => 'When my result reaches my teacher';

  @override
  String get notificationGroupGeneral => 'GENERAL';

  @override
  String get notificationAnnouncementsTitle => 'Announcements and updates';

  @override
  String get notificationQuietHoursTitle => 'Quiet Hours';

  @override
  String get notificationQuietHoursDesc => 'Mute notifications during night hours to stay focused.';

  @override
  String get notificationQuietHoursCta => 'Set Now';

  @override
  String get notificationPrefsLoadError => 'Couldn\'t load notification preferences.';

  @override
  String get notificationPrefsSaveError => 'Couldn\'t save notification preference. Please try again.';

  @override
  String get pushNotificationTitle => 'Notification';

  @override
  String get languagePreferenceTitle => 'Language Preference';

  @override
  String get languageOptionTurkish => 'Türkçe';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get languageComingSoonBadge => 'Coming Soon';

  @override
  String get languageInfo => 'Your selected language is saved to your account across all your devices.';

  @override
  String get languageDecorationCaption => 'Global Learning Community';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpSearchPlaceholder => 'Search help topics';

  @override
  String get helpFaqSectionTitle => 'Frequently Asked Questions';

  @override
  String get helpFaqEmpty => 'No topic matches your search.';

  @override
  String get helpFaqQ1 => 'How do I create a class?';

  @override
  String get helpFaqA1 => 'To create a class, go to the \"My Classes\" tab in the main menu. Tap the \"+\" button at the top right, give the class a name, and tap \"Save\". An invite code is generated automatically when the class is created.';

  @override
  String get helpFaqQ2 => 'How do I invite students?';

  @override
  String get helpFaqA2 => 'Open the detail of the class you created. Share the class\'s invite code with your students; the student is added to your class by entering this code on the \"Join a Class\" screen in the app.';

  @override
  String get helpFaqQ3 => 'How do I add words to a lesson (OCR + manual)?';

  @override
  String get helpFaqA3 => 'Start the \"Add Words\" flow in the lesson detail. With manual entry, you type the English term and its Turkish meaning. For OCR, you write the words on paper and scan them with the camera or gallery; you review and edit the recognized words, then save them.';

  @override
  String get helpFaqQ4 => 'How do I create and assign a puzzle?';

  @override
  String get helpFaqA4 => 'After preparing your word list, open the \"Create New Puzzle\" flow, choose the game type and word list, then pick the classes that will solve the puzzle and publish it. The puzzle is assigned as homework to active students.';

  @override
  String get helpFaqQ5 => 'Where do I see student results?';

  @override
  String get helpFaqA5 => 'You can see shared results from the \"Reports\" tab or from the relevant student\'s detail. Each result shows the completion time and accuracy rate.';

  @override
  String get helpFaqQ6 => 'I forgot my password, what should I do?';

  @override
  String get helpFaqA6 => 'Tap the \"Forgot Password\" link on the login screen and enter your registered email address. Follow the instructions sent to you to set a new password.';

  @override
  String get helpContactTitle => 'Still need help?';

  @override
  String get helpContactDesc => 'Our team is here to answer your questions. Reach out to us anytime.';

  @override
  String get helpContactCta => 'Contact Us';

  @override
  String get helpContactEmailSubject => 'LingoCross Support Request';

  @override
  String helpContactCopied(String email) {
    return 'Email address copied: $email';
  }

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyLastUpdated => 'Last updated: June 24, 2026';

  @override
  String get privacyIntro => 'At LingoCross, we take your privacy seriously. This policy explains how your data is collected, used, and protected when you use our app.';

  @override
  String get privacySection1Title => '1. Information We Collect';

  @override
  String get privacySection1Body => 'To give you a better experience, we collect certain information. This may include account details (full name, email address, role), learning data (created lessons, solved puzzles, accuracy and time results), and technical data (device type, operating system version).';

  @override
  String get privacySection2Title => '2. How We Use Information';

  @override
  String get privacySection2Body => 'We use the data we collect only to provide and improve the service: teacher-student matching, lesson and word management, sharing game results, and tracking progress. We do not sell your personal data to third parties for advertising.';

  @override
  String get privacySection3Title => '3. Data Retention and Security';

  @override
  String get privacySection3Body => 'Your data is transmitted with industry-standard encryption (SSL/TLS) and stored on secure servers. When you delete your account, your personal data—apart from legal retention obligations—is permanently deleted within a reasonable period.';

  @override
  String get privacySection4Title => '4. Third-Party Services';

  @override
  String get privacySection4Body => 'To run the app, we may work with a limited number of trusted service providers (e.g. hosting and infrastructure providers). These providers have limited access to your data, only to perform the task assigned to them.';

  @override
  String get privacySection5Title => '5. Your Rights';

  @override
  String get privacySection5Body => 'Under KVKK and GDPR, you have the right to access your data, request correction of inaccurate data, and request deletion of your data (the right to be forgotten).';

  @override
  String get privacyRight1 => 'Request access to and a copy of your data.';

  @override
  String get privacyRight2 => 'Request correction of inaccurate data.';

  @override
  String get privacyRight3 => 'Request complete deletion of your data.';

  @override
  String get privacySection6Title => '6. Contact';

  @override
  String get privacySection6Body => 'For questions about our privacy policy, you can contact us:';

  @override
  String get privacyContactEmail => 'privacy@lingocross.app';

  @override
  String get privacyContactLocation => 'Maslak, Istanbul / Türkiye';

  @override
  String get privacyContactEmailSubject => 'LingoCross Privacy Question';

  @override
  String get paywallTitle => 'Premium';

  @override
  String get paywallHeadline => 'LingoCross Premium';

  @override
  String get paywallSubtitle => 'Unlock all features';

  @override
  String get paywallBannerOcr => 'AI word scanning is in Premium';

  @override
  String get paywallBannerClassLimit => 'Unlimited classes are in Premium';

  @override
  String get paywallBannerLessonLimit => 'Unlimited lessons are in Premium';

  @override
  String get paywallBannerMultiTeacher => 'Multiple teachers are in Premium';

  @override
  String get paywallBannerDefault => 'All features are in Premium';

  @override
  String get paywallBenefitUnlimitedClasses => 'Unlimited classes and lessons';

  @override
  String get paywallBenefitOcr => 'AI word scanning';

  @override
  String get paywallBenefitMultiTeacher => 'Join multiple teachers';

  @override
  String get paywallBenefitReports => 'All reports and statistics';

  @override
  String get paywallPlanMonthlyTitle => 'Monthly';

  @override
  String get paywallPlanMonthlySubtitle => 'Renews automatically each month';

  @override
  String get paywallPlanMonthlyPeriod => '/mo';

  @override
  String get paywallPlanAnnualTitle => 'Annual';

  @override
  String get paywallPlanAnnualSubtitle => 'Annual payment, the better deal';

  @override
  String get paywallPlanAnnualPeriod => '/yr';

  @override
  String get paywallPlanBestValue => 'Best Value';

  @override
  String get paywallPlanPriceComingSoon => '—';

  @override
  String get paywallTrialNote => 'Try 7 days free, cancel anytime.';

  @override
  String get paywallCta => 'Upgrade to Premium';

  @override
  String get paywallSkip => 'Skip for now';

  @override
  String get paywallActivateSuccess => 'Premium activated.';

  @override
  String get paywallPurchaseDisabled => 'Purchases are currently off (test).';

  @override
  String get paywallActivateError => 'Something went wrong, please try again.';

  @override
  String get paywallRestore => 'Restore Purchases';

  @override
  String get paywallRestoreSuccess => 'Premium restored.';

  @override
  String get paywallPurchaseSuccess => 'Premium activated.';

  @override
  String get paywallPurchaseCanceled => 'Purchase canceled.';

  @override
  String get paywallPurchaseError => 'Purchase could not be completed, please try again.';

  @override
  String get paywallProductsUnavailable => 'The store is currently unreachable.';

  @override
  String get paywallProductsError => 'Could not load subscription details.';

  @override
  String get paywallPriceUnavailable => '—';

  @override
  String get lockedFeatureLabel => 'Premium';
}
