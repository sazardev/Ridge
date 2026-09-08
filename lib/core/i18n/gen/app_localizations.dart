import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The application name, shown in the OS task switcher and window title.
  ///
  /// In en, this message translates to:
  /// **'Just In Time'**
  String get appName;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Just In Time'**
  String get tasksTitle;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing due yet'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a task and give it a moment — it\'ll show up right here, just in time.'**
  String get tasksEmptyBody;

  /// No description provided for @tasksSectionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get tasksSectionOverdue;

  /// No description provided for @tasksSectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksSectionToday;

  /// No description provided for @tasksSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tasksSectionUpcoming;

  /// No description provided for @tasksSectionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksSectionDone;

  /// No description provided for @tasksAdd.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksAdd;

  /// No description provided for @tasksAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get tasksAddSheetTitle;

  /// No description provided for @tasksEditSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get tasksEditSheetTitle;

  /// No description provided for @tasksFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksFieldTitle;

  /// No description provided for @tasksFieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to get done?'**
  String get tasksFieldTitleHint;

  /// No description provided for @tasksFieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tasksFieldNotes;

  /// No description provided for @tasksFieldNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add details (optional)'**
  String get tasksFieldNotesHint;

  /// No description provided for @tasksFieldDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get tasksFieldDueDate;

  /// No description provided for @tasksFieldDueDateNone.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksFieldDueDateNone;

  /// No description provided for @tasksFieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get tasksFieldPriority;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @tasksSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tasksSave;

  /// No description provided for @tasksCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasksCancel;

  /// No description provided for @tasksDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tasksDelete;

  /// No description provided for @tasksDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get tasksDeleteConfirmTitle;

  /// No description provided for @tasksDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be removed permanently.'**
  String tasksDeleteConfirmBody(String title);

  /// No description provided for @tasksMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark as done'**
  String get tasksMarkDone;

  /// No description provided for @tasksMarkUndone.
  ///
  /// In en, this message translates to:
  /// **'Mark as not done'**
  String get tasksMarkUndone;

  /// No description provided for @tasksUndoSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get tasksUndoSnackbar;

  /// No description provided for @tasksUndoAction.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get tasksUndoAction;

  /// No description provided for @tasksErrorEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Give the task a title first'**
  String get tasksErrorEmptyTitle;

  /// No description provided for @tasksCountRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All caught up} =1{1 task left} other{{count} tasks left}}'**
  String tasksCountRemaining(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsExpressiveColor.
  ///
  /// In en, this message translates to:
  /// **'Expressive color'**
  String get settingsExpressiveColor;

  /// No description provided for @settingsExpressiveColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use richer, more vivid Material 3 Expressive tones'**
  String get settingsExpressiveColorSubtitle;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// No description provided for @settingsAppLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require a PIN to open Just In Time'**
  String get settingsAppLockSubtitle;

  /// No description provided for @settingsChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get settingsChangePin;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAboutVersion(String version);

  /// No description provided for @settingsAboutArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Built with hexagonal architecture & Riverpod'**
  String get settingsAboutArchitecture;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just In Time is locked'**
  String get lockSubtitle;

  /// No description provided for @lockSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get lockSetTitle;

  /// No description provided for @lockSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need it to unlock the app'**
  String get lockSetSubtitle;

  /// No description provided for @lockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get lockConfirmTitle;

  /// No description provided for @lockError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN, try again'**
  String get lockError;

  /// No description provided for @lockMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs don\'t match'**
  String get lockMismatch;

  /// No description provided for @lockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockUnlock;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWrong;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
