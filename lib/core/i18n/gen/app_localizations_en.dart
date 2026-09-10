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
  String get navPractice => 'Practice';

  @override
  String get navProgress => 'Progress';

  @override
  String get navFreePractice => 'Free';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileCreateTitle => 'Create your profile';

  @override
  String get profileCreateSubtitle => 'Pick a username to start practicing';

  @override
  String get profileUsernameLabel => 'Username';

  @override
  String get profileCreateStart => 'Start';

  @override
  String get profileUsernameInvalid => 'Enter a username up to 24 characters';

  @override
  String profileMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get profileRenameAction => 'Rename';

  @override
  String get profileRenameTitle => 'Rename profile';

  @override
  String get profileSave => 'Save';

  @override
  String get profileAchievementsAction => 'View achievements';

  @override
  String get profileStatsTitle => 'Your progress';

  @override
  String get profileViewProgressAction => 'View full progress';

  @override
  String get profileAboutTitle => 'About me';

  @override
  String get profileAboutEmptyState =>
      'Add your favorite languages, keyboard, and more to personalize your profile';

  @override
  String get profileEditCustomizationAction => 'Customize profile';

  @override
  String get profileEditCustomizationTitle => 'Customize your profile';

  @override
  String get profileFavoriteLanguageLabel => 'Favorite languages';

  @override
  String get profileKeyboardLayoutLabel => 'Keyboard layout';

  @override
  String get profileKeyboardBrandLabel => 'Keyboard brand';

  @override
  String get profileKeyboardModelLabel => 'Keyboard model';

  @override
  String get profileFavoriteProgrammerLabel =>
      'Favorite programmer or influence';

  @override
  String get profileFavoriteQuoteLabel => 'Favorite quote';

  @override
  String get profileCustomizationInvalid =>
      'Couldn\'t save — one of the fields is too long';

  @override
  String get profileSearchLanguageHint => 'Search languages…';

  @override
  String get profileSearchNoResults => 'No languages match your search';

  @override
  String get profileLanguageShowMore => 'More…';

  @override
  String get profileDeviceTitle => 'Device';

  @override
  String get favoriteLanguageGo => 'Go';

  @override
  String get favoriteLanguagePython => 'Python';

  @override
  String get favoriteLanguageJavascript => 'JavaScript';

  @override
  String get favoriteLanguageTypescript => 'TypeScript';

  @override
  String get favoriteLanguageRust => 'Rust';

  @override
  String get favoriteLanguageC => 'C';

  @override
  String get favoriteLanguageCpp => 'C++';

  @override
  String get favoriteLanguageCsharp => 'C#';

  @override
  String get favoriteLanguageJava => 'Java';

  @override
  String get favoriteLanguageKotlin => 'Kotlin';

  @override
  String get favoriteLanguageSwift => 'Swift';

  @override
  String get favoriteLanguageRuby => 'Ruby';

  @override
  String get favoriteLanguagePhp => 'PHP';

  @override
  String get favoriteLanguageDart => 'Dart';

  @override
  String get favoriteLanguageLua => 'Lua';

  @override
  String get favoriteLanguageHaskell => 'Haskell';

  @override
  String get favoriteLanguageScala => 'Scala';

  @override
  String get favoriteLanguageElixir => 'Elixir';

  @override
  String get favoriteLanguageClojure => 'Clojure';

  @override
  String get favoriteLanguagePerl => 'Perl';

  @override
  String get favoriteLanguageR => 'R';

  @override
  String get favoriteLanguageObjectiveC => 'Objective-C';

  @override
  String get favoriteLanguageShell => 'Shell / Bash';

  @override
  String get favoriteLanguageSql => 'SQL';

  @override
  String get favoriteLanguageAssembly => 'Assembly';

  @override
  String get favoriteLanguageZig => 'Zig';

  @override
  String get favoriteLanguageNim => 'Nim';

  @override
  String get favoriteLanguageJulia => 'Julia';

  @override
  String get favoriteLanguageGroovy => 'Groovy';

  @override
  String get favoriteLanguageFsharp => 'F#';

  @override
  String get favoriteLanguageOcaml => 'OCaml';

  @override
  String get favoriteLanguageErlang => 'Erlang';

  @override
  String get favoriteLanguageCrystal => 'Crystal';

  @override
  String get favoriteLanguageSolidity => 'Solidity';

  @override
  String get favoriteLanguagePowershell => 'PowerShell';

  @override
  String get favoriteLanguageLisp => 'Lisp';

  @override
  String get favoriteLanguageProlog => 'Prolog';

  @override
  String get favoriteLanguageCobol => 'COBOL';

  @override
  String get favoriteLanguageFortran => 'Fortran';

  @override
  String get favoriteLanguageMatlab => 'MATLAB';

  @override
  String get favoriteLanguageOther => 'Other';

  @override
  String get keyboardLayoutQwerty => 'QWERTY';

  @override
  String get keyboardLayoutAzerty => 'AZERTY';

  @override
  String get keyboardLayoutQwertz => 'QWERTZ';

  @override
  String get keyboardLayoutDvorak => 'Dvorak';

  @override
  String get keyboardLayoutColemak => 'Colemak';

  @override
  String get keyboardLayoutWorkman => 'Workman';

  @override
  String get keyboardLayoutOther => 'Other';

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
  String get settingsSectionPalette => 'Color palette';

  @override
  String get settingsPaletteSubtitle =>
      'Pick the accent and background tones for the whole app';

  @override
  String get paletteEmber => 'Ember';

  @override
  String get paletteOcean => 'Ocean';

  @override
  String get paletteForest => 'Forest';

  @override
  String get paletteGrape => 'Grape';

  @override
  String get paletteRose => 'Rose';

  @override
  String get paletteSunflower => 'Sunflower';

  @override
  String get paletteTeal => 'Teal';

  @override
  String get paletteCrimson => 'Crimson';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteNord => 'Nord';

  @override
  String get paletteGruvbox => 'Gruvbox';

  @override
  String get paletteDracula => 'Dracula';

  @override
  String get paletteSolarized => 'Solarized';

  @override
  String get paletteCatppuccin => 'Catppuccin';

  @override
  String get paletteTokyoNight => 'Tokyo Night';

  @override
  String get paletteTerminal => 'Terminal';

  @override
  String get paletteMatrix => 'Matrix';

  @override
  String get paletteFallout => 'Fallout';

  @override
  String get paletteBlackWhite => 'Black & White';

  @override
  String get paletteMonokai => 'Monokai';

  @override
  String get paletteOneDark => 'One Dark';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteSynthwave => 'Synthwave';

  @override
  String get paletteGithub => 'GitHub';

  @override
  String get paletteVscode => 'VS Code';

  @override
  String get settingsCornerStyle => 'Corner style';

  @override
  String get settingsCornerStyleSubtitle =>
      'Roundedness for buttons, cards, and the window frame — applies instantly';

  @override
  String get cornerStyleSharp => 'Sharp';

  @override
  String get cornerStyleSoft => 'Soft';

  @override
  String get cornerStyleRound => 'Round';

  @override
  String get cornerStylePill => 'Pill';

  @override
  String get settingsWindowBorder => 'Window border';

  @override
  String get settingsWindowBorderSubtitle =>
      'Rounded border and shadow around the app window, live as you change it';

  @override
  String get settingsWindowBorderWidth => 'Border thickness';

  @override
  String get windowBorderWidthThin => 'Thin';

  @override
  String get windowBorderWidthMedium => 'Medium';

  @override
  String get windowBorderWidthThick => 'Thick';

  @override
  String get settingsSectionSound => 'Sound';

  @override
  String get settingsSoundSubtitle =>
      'Keystroke sound effects — tap the play icon to preview a pack';

  @override
  String get settingsSoundPreview => 'Preview';

  @override
  String get soundPackMechanical => 'Mechanical';

  @override
  String get soundPackSoft => 'Soft';

  @override
  String get soundPackTypewriter => 'Typewriter';

  @override
  String get soundPackArcade => 'Arcade';

  @override
  String get soundPackPop => 'Pop';

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
  String get settingsAppLockBiometric => 'Use biometrics';

  @override
  String get settingsAppLockBiometricSubtitle =>
      'Unlock with fingerprint or Face ID instead of typing your PIN';

  @override
  String get settingsLockNow => 'Lock now';

  @override
  String get settingsSectionShortcuts => 'Keyboard shortcuts';

  @override
  String get settingsShortcutsTitle => 'Keyboard shortcuts';

  @override
  String get settingsShortcutsSubtitle =>
      'View and customize how you navigate without a mouse';

  @override
  String get shortcutsScreenTitle => 'Keyboard shortcuts';

  @override
  String get shortcutActionGoToPractice => 'Go to Practice';

  @override
  String get shortcutActionGoToProgress => 'Go to Progress';

  @override
  String get shortcutActionGoToFreePractice => 'Go to Free Practice';

  @override
  String get shortcutActionGoToProfile => 'Go to Profile';

  @override
  String get shortcutActionGoToSettings => 'Go to Settings';

  @override
  String get shortcutActionCycleNextSection => 'Next section';

  @override
  String get shortcutActionCyclePreviousSection => 'Previous section';

  @override
  String get shortcutActionCycleNextTab => 'Next tab';

  @override
  String get shortcutActionCyclePreviousTab => 'Previous tab';

  @override
  String get shortcutsCaptureDialogTitle => 'Press a key combination';

  @override
  String get shortcutsCaptureDialogHint => 'Must include Ctrl or Alt';

  @override
  String get shortcutsCaptureDialogWaiting => 'Waiting for input…';

  @override
  String get shortcutsCaptureDialogNeedsModifier =>
      'Add Ctrl or Alt to this combination';

  @override
  String shortcutsCaptureDialogConflict(String action) {
    return 'Already used by \"$action\"';
  }

  @override
  String get shortcutsCaptureDialogSaved => 'Shortcut updated';

  @override
  String get shortcutsCaptureCancel => 'Cancel';

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
  String get settingsAboutChangelog => 'What\'s new';

  @override
  String get settingsAboutChangelogSubtitle =>
      'See the release history for this app';

  @override
  String get changelogScreenTitle => 'What\'s new';

  @override
  String get changelogLoadError => 'Couldn\'t load the changelog';

  @override
  String get settingsSectionDataManagement => 'Data & progress';

  @override
  String get settingsDataManagementSubtitle =>
      'These actions only affect this device. Deleted data can\'t be recovered.';

  @override
  String get settingsResetLesson => 'Reset a lesson';

  @override
  String get settingsResetLessonSubtitle =>
      'Clear your progress on a single lesson so you can practice it again from scratch';

  @override
  String get settingsResetAllLessons => 'Reset all lessons';

  @override
  String get settingsResetAllLessonsSubtitle =>
      'Clear your progress on every lesson, across every learning path';

  @override
  String get settingsWipeAllData => 'Erase all local data';

  @override
  String get settingsWipeAllDataSubtitle =>
      'Deletes your profile, sessions, stats, achievements and PIN — the app starts over as new';

  @override
  String get settingsPickLessonTitle => 'Choose a lesson to reset';

  @override
  String get settingsPickLessonEmpty => 'No learning paths available yet';

  @override
  String settingsResetLessonConfirmTitle(String lessonTitle) {
    return 'Reset \"$lessonTitle\"?';
  }

  @override
  String get settingsResetLessonConfirmBody =>
      'Every attempt you\'ve made at this lesson will be deleted and its progress set back to not started. This can\'t be undone.';

  @override
  String get settingsResetAllLessonsConfirmTitle => 'Reset all lessons?';

  @override
  String get settingsResetAllLessonsConfirmBody =>
      'Every attempt at every lesson, across every learning path, will be deleted and reset to not started. Your XP and stats will be recalculated. This can\'t be undone.';

  @override
  String get settingsWipeAllDataConfirmTitle => 'Erase all local data?';

  @override
  String get settingsWipeAllDataConfirmBody =>
      'This permanently deletes your profile, every practice session, your stats, achievements and PIN from this device. You\'ll start over as a brand-new guest. This can\'t be undone.';

  @override
  String get settingsDataActionCancel => 'Cancel';

  @override
  String get settingsDataActionReset => 'Reset';

  @override
  String get settingsDataActionEraseEverything => 'Erase everything';

  @override
  String get settingsResetLessonSuccess => 'Lesson reset';

  @override
  String get settingsResetAllLessonsSuccess => 'All lessons reset';

  @override
  String get settingsDataActionError => 'Something went wrong. Try again.';

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
  String get lockSaveError => 'Couldn\'t save your PIN. Try again.';

  @override
  String get lockUnlock => 'Unlock';

  @override
  String get lockUseBiometrics => 'Use biometrics';

  @override
  String get lockBiometricReason => 'Unlock Just In Time';

  @override
  String get lockBiometricError => 'Biometric authentication failed';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSomethingWrong => 'Something went wrong';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get windowMinimize => 'Minimize';

  @override
  String get windowMaximize => 'Maximize';

  @override
  String get windowRestore => 'Restore';

  @override
  String get windowClose => 'Close';

  @override
  String get libraryTitle => 'Library';

  @override
  String get libraryEmptyState => 'No snippets match these filters';

  @override
  String get libraryFilterAll => 'All';

  @override
  String get difficultyBeginner => 'Beginner';

  @override
  String get difficultyIntermediate => 'Intermediate';

  @override
  String get difficultyAdvanced => 'Advanced';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get categoryVariablesAndTypes => 'Variables & types';

  @override
  String get categoryConditionals => 'Conditionals';

  @override
  String get categoryLoops => 'Loops';

  @override
  String get categoryFunctions => 'Functions';

  @override
  String get categoryStructs => 'Structs';

  @override
  String get categoryInterfaces => 'Interfaces';

  @override
  String get categorySlicesAndMaps => 'Slices & maps';

  @override
  String get categoryErrorHandling => 'Error handling';

  @override
  String get categoryPointers => 'Pointers';

  @override
  String get categoryConcurrency => 'Concurrency';

  @override
  String get categoryGenerics => 'Generics';

  @override
  String get categoryIdiomaticFormatting => 'Idiomatic formatting';

  @override
  String get categoryDomainModeling => 'Domain modeling';

  @override
  String get categoryHexagonalPorts => 'Hexagonal ports';

  @override
  String get categoryApplicationUseCases => 'Application use cases';

  @override
  String get categoryPersistenceAdapters => 'Persistence adapters';

  @override
  String get categoryRestAdapters => 'REST adapters';

  @override
  String get categoryTestingWithFakes => 'Testing with fakes';

  @override
  String get languageGo => 'Go';

  @override
  String get snippetPracticeAction => 'Practice';

  @override
  String get practiceZenTitle => 'Zen practice';

  @override
  String get practiceStartHint =>
      'Start typing to begin — no timer, no pressure.';

  @override
  String practiceLiveCharsTyped(int count) {
    return '$count typed';
  }

  @override
  String practiceLiveAccuracy(String pct) {
    return '$pct% so far';
  }

  @override
  String get practiceResultTitle => 'Session complete';

  @override
  String get practiceResultNetSpeed => 'Net speed';

  @override
  String get practiceResultRawSpeed => 'Raw speed';

  @override
  String get practiceResultAccuracy => 'Accuracy';

  @override
  String get practiceResultConsistency => 'Consistency';

  @override
  String get practiceResultStreak => 'Longest streak';

  @override
  String get practiceResultWeakestChars => 'Weakest characters this session';

  @override
  String get practiceResultDone => 'Done';

  @override
  String practiceResultScorePassed(int score) {
    return '$score/10 — Passed!';
  }

  @override
  String practiceResultScoreFailed(int score) {
    return '$score/10 — Not there yet, try again';
  }

  @override
  String get practiceResultRetry => 'Retry';

  @override
  String get practiceResultContinue => 'Continue';

  @override
  String get practiceResultLearnMoreTitle => 'What did you just type?';

  @override
  String get compilerFlavorPerfect => 'Build succeeded — 0 errors, 0 warnings.';

  @override
  String get compilerFlavorGreat => 'Compiled with a couple of minor warnings.';

  @override
  String get compilerFlavorGood => 'Build succeeded after a few patches.';

  @override
  String get compilerFlavorRough => 'Ran, but with some known bugs.';

  @override
  String get compilerFlavorBad =>
      'panic: runtime error — recovered. Try again.';

  @override
  String get practiceModePickerTitle => 'Choose a mode';

  @override
  String get practiceModeZen => 'Zen';

  @override
  String get practiceModeZenSubtitle =>
      'No timer, no pressure — just practice.';

  @override
  String get practiceModeSprint30 => 'Sprint · 30s';

  @override
  String get practiceModeSprint60 => 'Sprint · 60s';

  @override
  String get practiceModeSprint120 => 'Sprint · 120s';

  @override
  String get practiceModeSprintSubtitle =>
      'Beat the clock — maximize correct characters.';

  @override
  String get practiceModePrecision => 'Precision test';

  @override
  String get practiceModePrecisionSubtitle =>
      'Score above 7/10 (80%+ accuracy) to pass.';

  @override
  String get practiceHubTitle => 'Practice';

  @override
  String get freePracticeTitle => 'Free practice';

  @override
  String get practiceHubQuickModesTitle => 'Quick practice';

  @override
  String get practiceHubBrowseAllAction => 'Browse all snippets';

  @override
  String get practiceHubNoSnippetsAvailable => 'No snippets available yet.';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressEmptyState =>
      'Finish a practice session to see your progress here.';

  @override
  String get progressTabOverview => 'Overview';

  @override
  String get progressTabWeaknesses => 'Weaknesses';

  @override
  String get progressTabActivity => 'Activity';

  @override
  String get progressTabHistory => 'History';

  @override
  String progressLevelLabel(int level) {
    return 'Level $level';
  }

  @override
  String progressTotalXp(int xp) {
    return '$xp XP';
  }

  @override
  String progressStreakLabel(int days) {
    return '$days-day streak';
  }

  @override
  String get progressWeaknessTitle => 'Your weak spots';

  @override
  String get progressWeaknessCharacters => 'Characters';

  @override
  String get progressWeaknessFingers => 'Fingers';

  @override
  String get progressWeaknessNgrams => 'Combinations';

  @override
  String get progressWeaknessKeyTransitions => 'Key transitions';

  @override
  String get progressWeaknessEmpty => 'Not enough data yet';

  @override
  String get progressHeatmapTitle => 'Keyboard heatmap';

  @override
  String get progressMasteryTitle => 'Mastery';

  @override
  String get progressMasteryEmpty =>
      'Complete Precision sessions to start certifying categories';

  @override
  String get progressMasteryCertified => 'Mastered';

  @override
  String get progressMasteryNotYet => 'Not yet mastered';

  @override
  String get progressHistoryTitle => 'Personal history';

  @override
  String get progressHistoryEmpty => 'No history yet for this category';

  @override
  String progressHistoryAverage(int speed, int accuracy) {
    return 'Average: $speed cpm · $accuracy% accuracy';
  }

  @override
  String get progressFingerLeftPinky => 'Left pinky';

  @override
  String get progressFingerLeftRing => 'Left ring finger';

  @override
  String get progressFingerLeftMiddle => 'Left middle finger';

  @override
  String get progressFingerLeftIndex => 'Left index finger';

  @override
  String get progressFingerRightIndex => 'Right index finger';

  @override
  String get progressFingerRightMiddle => 'Right middle finger';

  @override
  String get progressFingerRightRing => 'Right ring finger';

  @override
  String get progressFingerRightPinky => 'Right pinky';

  @override
  String get progressFingerThumb => 'Thumb';

  @override
  String get progressTrendImproving => 'Improving';

  @override
  String get progressTrendWorsening => 'Worsening';

  @override
  String get progressTrendStable => 'Stable';

  @override
  String get progressKeySpace => 'Space';

  @override
  String get progressKeyTab => 'Tab';

  @override
  String get progressKeyEnter => 'Enter';

  @override
  String get progressKeyBackspace => 'Backspace';

  @override
  String get progressKeyDelete => 'Delete';

  @override
  String get progressKeyArrowLeft => 'Left arrow';

  @override
  String get progressKeyArrowRight => 'Right arrow';

  @override
  String get progressKeyShiftLeft => 'Left shift';

  @override
  String get progressKeyShiftRight => 'Right shift';

  @override
  String get progressActivityTitle => 'Activity';

  @override
  String get progressActivityMostPracticedCategories =>
      'Most practiced categories';

  @override
  String get progressActivityLowestScoringCategories =>
      'Lowest-scoring categories';

  @override
  String get progressActivityMostPracticedExercises =>
      'Most practiced exercises';

  @override
  String get progressActivityLowestScoringExercises =>
      'Lowest-scoring exercises';

  @override
  String progressActivitySessionCount(int count) {
    return '$count sessions';
  }

  @override
  String progressActivityScoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String get learningPathsTitle => 'Learning paths';

  @override
  String get learningPathsEmptyState => 'No learning paths available yet.';

  @override
  String learningPathsProgress(int completed, int total) {
    return '$completed/$total lessons complete';
  }

  @override
  String get learningPathsLessonListTitle => 'Lessons';

  @override
  String learningPathsContinueHint(String lessonTitle) {
    return 'Continue: $lessonTitle';
  }

  @override
  String get learningPathsContinueAction => 'Continue lesson';

  @override
  String get learningLessonLocked => 'Locked';

  @override
  String get learningLessonUnlocked => 'Unlocked';

  @override
  String get learningLessonCompleted => 'Completed';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String achievementUnlockedToast(String title) {
    return 'Achievement unlocked: $title';
  }

  @override
  String get achievementCeroErroresTitle => 'Zero Errors';

  @override
  String get achievementCeroErroresDescription =>
      'Finish a session with 100% accuracy and no corrections';

  @override
  String get achievementAmbidiestroTitle => 'Ambidextrous';

  @override
  String get achievementAmbidiestroDescription =>
      'Finish a 100+ character session with near-perfect hand balance';

  @override
  String get achievementMaratonistaBronzeTitle => 'Marathoner · Bronze';

  @override
  String get achievementMaratonistaSilverTitle => 'Marathoner · Silver';

  @override
  String get achievementMaratonistaGoldTitle => 'Marathoner · Gold';

  @override
  String achievementMaratonistaDescription(int count) {
    return 'Type $count correct characters in your lifetime';
  }

  @override
  String achievementCategoryMasteryTitle(String category, String difficulty) {
    return '$category · $difficulty Mastery';
  }

  @override
  String get achievementCategoryMasteryDescription =>
      'Certify mastery of a category and difficulty';

  @override
  String achievementStreakTitle(int days) {
    return '$days-Day Streak';
  }

  @override
  String achievementStreakDescription(int days) {
    return 'Practice $days days in a row';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingWelcomeTitle => 'Real code, not filler';

  @override
  String get onboardingWelcomeDescription =>
      'Train your typing with real Go snippets — the syntax you actually write at work, not random sentences.';

  @override
  String get onboardingMetricsTitle => 'Know exactly what slows you down';

  @override
  String get onboardingMetricsDescription =>
      'Speed, accuracy, per-finger and per-character — every session shows you what to improve, and why.';

  @override
  String get onboardingPathsTitle => 'Progress at your own pace';

  @override
  String get onboardingPathsDescription =>
      'Guided learning paths, XP, and achievements — fully offline, whenever you want.';

  @override
  String get onboardingReadyTitle => 'No friction, ever';

  @override
  String get onboardingReadyDescription =>
      'Just a username — no email, no password. Let\'s start typing.';

  @override
  String get onboardingAppearanceTitle => 'Make it yours';

  @override
  String get onboardingAppearanceDescription =>
      'Pick a palette, corner style, and color mode — you can always change this later in Settings.';

  @override
  String get onboardingDeviceTitle => 'We already know your setup';

  @override
  String get onboardingDeviceDescription =>
      'We detected your platform and device automatically — nothing to configure.';
}
