// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Just In Time';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navSettings => 'Settings';

  @override
  String get tasksTitle => 'Just In Time';

  @override
  String get tasksEmptyTitle => 'Nothing due yet';

  @override
  String get tasksEmptyBody =>
      'Add a task and give it a moment — it\'ll show up right here, just in time.';

  @override
  String get tasksSectionOverdue => 'Overdue';

  @override
  String get tasksSectionToday => 'Today';

  @override
  String get tasksSectionUpcoming => 'Upcoming';

  @override
  String get tasksSectionDone => 'Done';

  @override
  String get tasksAdd => 'New task';

  @override
  String get tasksAddSheetTitle => 'New task';

  @override
  String get tasksEditSheetTitle => 'Edit task';

  @override
  String get tasksFieldTitle => 'Title';

  @override
  String get tasksFieldTitleHint => 'What needs to get done?';

  @override
  String get tasksFieldNotes => 'Notes';

  @override
  String get tasksFieldNotesHint => 'Add details (optional)';

  @override
  String get tasksFieldDueDate => 'Due date';

  @override
  String get tasksFieldDueDateNone => 'No due date';

  @override
  String get tasksFieldPriority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get tasksSave => 'Save';

  @override
  String get tasksCancel => 'Cancel';

  @override
  String get tasksDelete => 'Delete';

  @override
  String get tasksDeleteConfirmTitle => 'Delete task?';

  @override
  String tasksDeleteConfirmBody(String title) {
    return '\"$title\" will be removed permanently.';
  }

  @override
  String get tasksMarkDone => 'Mark as done';

  @override
  String get tasksMarkUndone => 'Mark as not done';

  @override
  String get tasksUndoSnackbar => 'Task deleted';

  @override
  String get tasksUndoAction => 'Undo';

  @override
  String get tasksErrorEmptyTitle => 'Give the task a title first';

  @override
  String tasksCountRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks left',
      one: '1 task left',
      zero: 'All caught up',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsExpressiveColor => 'Expressive color';

  @override
  String get settingsExpressiveColorSubtitle =>
      'Use richer, more vivid Material 3 Expressive tones';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsLanguageSystem => 'Match system';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockSubtitle => 'Require a PIN to open Just In Time';

  @override
  String get settingsChangePin => 'Change PIN';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String settingsAboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutArchitecture =>
      'Built with hexagonal architecture & Riverpod';

  @override
  String get lockTitle => 'Enter your PIN';

  @override
  String get lockSubtitle => 'Just In Time is locked';

  @override
  String get lockSetTitle => 'Set a PIN';

  @override
  String get lockSetSubtitle => 'You\'ll need it to unlock the app';

  @override
  String get lockConfirmTitle => 'Confirm your PIN';

  @override
  String get lockError => 'Incorrect PIN, try again';

  @override
  String get lockMismatch => 'PINs don\'t match';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSomethingWrong => 'Something went wrong';

  @override
  String get commonLoading => 'Loading…';
}
