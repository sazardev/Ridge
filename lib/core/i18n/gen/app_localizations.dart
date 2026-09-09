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

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navFreePractice.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get navFreePractice;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get profileCreateTitle;

  /// No description provided for @profileCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a username to start practicing'**
  String get profileCreateSubtitle;

  /// No description provided for @profileUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsernameLabel;

  /// No description provided for @profileCreateStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get profileCreateStart;

  /// No description provided for @profileUsernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a username up to 24 characters'**
  String get profileUsernameInvalid;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String profileMemberSince(String date);

  /// No description provided for @profileRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get profileRenameAction;

  /// No description provided for @profileRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename profile'**
  String get profileRenameTitle;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileAchievementsAction.
  ///
  /// In en, this message translates to:
  /// **'View achievements'**
  String get profileAchievementsAction;

  /// No description provided for @profileStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get profileStatsTitle;

  /// No description provided for @profileViewProgressAction.
  ///
  /// In en, this message translates to:
  /// **'View full progress'**
  String get profileViewProgressAction;

  /// No description provided for @profileAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get profileAboutTitle;

  /// No description provided for @profileAboutEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite languages, keyboard, and more to personalize your profile'**
  String get profileAboutEmptyState;

  /// No description provided for @profileEditCustomizationAction.
  ///
  /// In en, this message translates to:
  /// **'Customize profile'**
  String get profileEditCustomizationAction;

  /// No description provided for @profileEditCustomizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your profile'**
  String get profileEditCustomizationTitle;

  /// No description provided for @profileFavoriteLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorite languages'**
  String get profileFavoriteLanguageLabel;

  /// No description provided for @profileKeyboardLayoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Keyboard layout'**
  String get profileKeyboardLayoutLabel;

  /// No description provided for @profileKeyboardBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Keyboard brand'**
  String get profileKeyboardBrandLabel;

  /// No description provided for @profileKeyboardModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Keyboard model'**
  String get profileKeyboardModelLabel;

  /// No description provided for @profileFavoriteProgrammerLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorite programmer or influence'**
  String get profileFavoriteProgrammerLabel;

  /// No description provided for @profileFavoriteQuoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorite quote'**
  String get profileFavoriteQuoteLabel;

  /// No description provided for @profileCustomizationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save — one of the fields is too long'**
  String get profileCustomizationInvalid;

  /// No description provided for @profileSearchLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Search languages…'**
  String get profileSearchLanguageHint;

  /// No description provided for @profileSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No languages match your search'**
  String get profileSearchNoResults;

  /// No description provided for @profileLanguageShowMore.
  ///
  /// In en, this message translates to:
  /// **'More…'**
  String get profileLanguageShowMore;

  /// No description provided for @favoriteLanguageGo.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get favoriteLanguageGo;

  /// No description provided for @favoriteLanguagePython.
  ///
  /// In en, this message translates to:
  /// **'Python'**
  String get favoriteLanguagePython;

  /// No description provided for @favoriteLanguageJavascript.
  ///
  /// In en, this message translates to:
  /// **'JavaScript'**
  String get favoriteLanguageJavascript;

  /// No description provided for @favoriteLanguageTypescript.
  ///
  /// In en, this message translates to:
  /// **'TypeScript'**
  String get favoriteLanguageTypescript;

  /// No description provided for @favoriteLanguageRust.
  ///
  /// In en, this message translates to:
  /// **'Rust'**
  String get favoriteLanguageRust;

  /// No description provided for @favoriteLanguageC.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get favoriteLanguageC;

  /// No description provided for @favoriteLanguageCpp.
  ///
  /// In en, this message translates to:
  /// **'C++'**
  String get favoriteLanguageCpp;

  /// No description provided for @favoriteLanguageCsharp.
  ///
  /// In en, this message translates to:
  /// **'C#'**
  String get favoriteLanguageCsharp;

  /// No description provided for @favoriteLanguageJava.
  ///
  /// In en, this message translates to:
  /// **'Java'**
  String get favoriteLanguageJava;

  /// No description provided for @favoriteLanguageKotlin.
  ///
  /// In en, this message translates to:
  /// **'Kotlin'**
  String get favoriteLanguageKotlin;

  /// No description provided for @favoriteLanguageSwift.
  ///
  /// In en, this message translates to:
  /// **'Swift'**
  String get favoriteLanguageSwift;

  /// No description provided for @favoriteLanguageRuby.
  ///
  /// In en, this message translates to:
  /// **'Ruby'**
  String get favoriteLanguageRuby;

  /// No description provided for @favoriteLanguagePhp.
  ///
  /// In en, this message translates to:
  /// **'PHP'**
  String get favoriteLanguagePhp;

  /// No description provided for @favoriteLanguageDart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get favoriteLanguageDart;

  /// No description provided for @favoriteLanguageLua.
  ///
  /// In en, this message translates to:
  /// **'Lua'**
  String get favoriteLanguageLua;

  /// No description provided for @favoriteLanguageHaskell.
  ///
  /// In en, this message translates to:
  /// **'Haskell'**
  String get favoriteLanguageHaskell;

  /// No description provided for @favoriteLanguageScala.
  ///
  /// In en, this message translates to:
  /// **'Scala'**
  String get favoriteLanguageScala;

  /// No description provided for @favoriteLanguageElixir.
  ///
  /// In en, this message translates to:
  /// **'Elixir'**
  String get favoriteLanguageElixir;

  /// No description provided for @favoriteLanguageClojure.
  ///
  /// In en, this message translates to:
  /// **'Clojure'**
  String get favoriteLanguageClojure;

  /// No description provided for @favoriteLanguagePerl.
  ///
  /// In en, this message translates to:
  /// **'Perl'**
  String get favoriteLanguagePerl;

  /// No description provided for @favoriteLanguageR.
  ///
  /// In en, this message translates to:
  /// **'R'**
  String get favoriteLanguageR;

  /// No description provided for @favoriteLanguageObjectiveC.
  ///
  /// In en, this message translates to:
  /// **'Objective-C'**
  String get favoriteLanguageObjectiveC;

  /// No description provided for @favoriteLanguageShell.
  ///
  /// In en, this message translates to:
  /// **'Shell / Bash'**
  String get favoriteLanguageShell;

  /// No description provided for @favoriteLanguageSql.
  ///
  /// In en, this message translates to:
  /// **'SQL'**
  String get favoriteLanguageSql;

  /// No description provided for @favoriteLanguageAssembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get favoriteLanguageAssembly;

  /// No description provided for @favoriteLanguageZig.
  ///
  /// In en, this message translates to:
  /// **'Zig'**
  String get favoriteLanguageZig;

  /// No description provided for @favoriteLanguageNim.
  ///
  /// In en, this message translates to:
  /// **'Nim'**
  String get favoriteLanguageNim;

  /// No description provided for @favoriteLanguageJulia.
  ///
  /// In en, this message translates to:
  /// **'Julia'**
  String get favoriteLanguageJulia;

  /// No description provided for @favoriteLanguageGroovy.
  ///
  /// In en, this message translates to:
  /// **'Groovy'**
  String get favoriteLanguageGroovy;

  /// No description provided for @favoriteLanguageFsharp.
  ///
  /// In en, this message translates to:
  /// **'F#'**
  String get favoriteLanguageFsharp;

  /// No description provided for @favoriteLanguageOcaml.
  ///
  /// In en, this message translates to:
  /// **'OCaml'**
  String get favoriteLanguageOcaml;

  /// No description provided for @favoriteLanguageErlang.
  ///
  /// In en, this message translates to:
  /// **'Erlang'**
  String get favoriteLanguageErlang;

  /// No description provided for @favoriteLanguageCrystal.
  ///
  /// In en, this message translates to:
  /// **'Crystal'**
  String get favoriteLanguageCrystal;

  /// No description provided for @favoriteLanguageSolidity.
  ///
  /// In en, this message translates to:
  /// **'Solidity'**
  String get favoriteLanguageSolidity;

  /// No description provided for @favoriteLanguagePowershell.
  ///
  /// In en, this message translates to:
  /// **'PowerShell'**
  String get favoriteLanguagePowershell;

  /// No description provided for @favoriteLanguageLisp.
  ///
  /// In en, this message translates to:
  /// **'Lisp'**
  String get favoriteLanguageLisp;

  /// No description provided for @favoriteLanguageProlog.
  ///
  /// In en, this message translates to:
  /// **'Prolog'**
  String get favoriteLanguageProlog;

  /// No description provided for @favoriteLanguageCobol.
  ///
  /// In en, this message translates to:
  /// **'COBOL'**
  String get favoriteLanguageCobol;

  /// No description provided for @favoriteLanguageFortran.
  ///
  /// In en, this message translates to:
  /// **'Fortran'**
  String get favoriteLanguageFortran;

  /// No description provided for @favoriteLanguageMatlab.
  ///
  /// In en, this message translates to:
  /// **'MATLAB'**
  String get favoriteLanguageMatlab;

  /// No description provided for @favoriteLanguageOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get favoriteLanguageOther;

  /// No description provided for @keyboardLayoutQwerty.
  ///
  /// In en, this message translates to:
  /// **'QWERTY'**
  String get keyboardLayoutQwerty;

  /// No description provided for @keyboardLayoutAzerty.
  ///
  /// In en, this message translates to:
  /// **'AZERTY'**
  String get keyboardLayoutAzerty;

  /// No description provided for @keyboardLayoutQwertz.
  ///
  /// In en, this message translates to:
  /// **'QWERTZ'**
  String get keyboardLayoutQwertz;

  /// No description provided for @keyboardLayoutDvorak.
  ///
  /// In en, this message translates to:
  /// **'Dvorak'**
  String get keyboardLayoutDvorak;

  /// No description provided for @keyboardLayoutColemak.
  ///
  /// In en, this message translates to:
  /// **'Colemak'**
  String get keyboardLayoutColemak;

  /// No description provided for @keyboardLayoutWorkman.
  ///
  /// In en, this message translates to:
  /// **'Workman'**
  String get keyboardLayoutWorkman;

  /// No description provided for @keyboardLayoutOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get keyboardLayoutOther;

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

  /// No description provided for @settingsSectionPalette.
  ///
  /// In en, this message translates to:
  /// **'Color palette'**
  String get settingsSectionPalette;

  /// No description provided for @settingsPaletteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the accent and background tones for the whole app'**
  String get settingsPaletteSubtitle;

  /// No description provided for @paletteEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get paletteEmber;

  /// No description provided for @paletteOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get paletteOcean;

  /// No description provided for @paletteForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get paletteForest;

  /// No description provided for @paletteGrape.
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get paletteGrape;

  /// No description provided for @paletteRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get paletteRose;

  /// No description provided for @paletteSunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get paletteSunflower;

  /// No description provided for @paletteTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get paletteTeal;

  /// No description provided for @paletteCrimson.
  ///
  /// In en, this message translates to:
  /// **'Crimson'**
  String get paletteCrimson;

  /// No description provided for @paletteMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get paletteMono;

  /// No description provided for @paletteNord.
  ///
  /// In en, this message translates to:
  /// **'Nord'**
  String get paletteNord;

  /// No description provided for @paletteGruvbox.
  ///
  /// In en, this message translates to:
  /// **'Gruvbox'**
  String get paletteGruvbox;

  /// No description provided for @paletteDracula.
  ///
  /// In en, this message translates to:
  /// **'Dracula'**
  String get paletteDracula;

  /// No description provided for @paletteSolarized.
  ///
  /// In en, this message translates to:
  /// **'Solarized'**
  String get paletteSolarized;

  /// No description provided for @paletteCatppuccin.
  ///
  /// In en, this message translates to:
  /// **'Catppuccin'**
  String get paletteCatppuccin;

  /// No description provided for @paletteTokyoNight.
  ///
  /// In en, this message translates to:
  /// **'Tokyo Night'**
  String get paletteTokyoNight;

  /// No description provided for @paletteTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get paletteTerminal;

  /// No description provided for @paletteMatrix.
  ///
  /// In en, this message translates to:
  /// **'Matrix'**
  String get paletteMatrix;

  /// No description provided for @paletteFallout.
  ///
  /// In en, this message translates to:
  /// **'Fallout'**
  String get paletteFallout;

  /// No description provided for @paletteBlackWhite.
  ///
  /// In en, this message translates to:
  /// **'Black & White'**
  String get paletteBlackWhite;

  /// No description provided for @paletteMonokai.
  ///
  /// In en, this message translates to:
  /// **'Monokai'**
  String get paletteMonokai;

  /// No description provided for @paletteOneDark.
  ///
  /// In en, this message translates to:
  /// **'One Dark'**
  String get paletteOneDark;

  /// No description provided for @paletteCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get paletteCyberpunk;

  /// No description provided for @paletteSynthwave.
  ///
  /// In en, this message translates to:
  /// **'Synthwave'**
  String get paletteSynthwave;

  /// No description provided for @paletteGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get paletteGithub;

  /// No description provided for @paletteVscode.
  ///
  /// In en, this message translates to:
  /// **'VS Code'**
  String get paletteVscode;

  /// No description provided for @settingsCornerStyle.
  ///
  /// In en, this message translates to:
  /// **'Corner style'**
  String get settingsCornerStyle;

  /// No description provided for @settingsCornerStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Roundedness for buttons, cards, and the window frame — applies instantly'**
  String get settingsCornerStyleSubtitle;

  /// No description provided for @cornerStyleSharp.
  ///
  /// In en, this message translates to:
  /// **'Sharp'**
  String get cornerStyleSharp;

  /// No description provided for @cornerStyleSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get cornerStyleSoft;

  /// No description provided for @cornerStyleRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get cornerStyleRound;

  /// No description provided for @cornerStylePill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get cornerStylePill;

  /// No description provided for @settingsWindowBorder.
  ///
  /// In en, this message translates to:
  /// **'Window border'**
  String get settingsWindowBorder;

  /// No description provided for @settingsWindowBorderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rounded border and shadow around the app window, live as you change it'**
  String get settingsWindowBorderSubtitle;

  /// No description provided for @settingsWindowBorderWidth.
  ///
  /// In en, this message translates to:
  /// **'Border thickness'**
  String get settingsWindowBorderWidth;

  /// No description provided for @windowBorderWidthThin.
  ///
  /// In en, this message translates to:
  /// **'Thin'**
  String get windowBorderWidthThin;

  /// No description provided for @windowBorderWidthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get windowBorderWidthMedium;

  /// No description provided for @windowBorderWidthThick.
  ///
  /// In en, this message translates to:
  /// **'Thick'**
  String get windowBorderWidthThick;

  /// No description provided for @settingsSectionSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSectionSound;

  /// No description provided for @settingsSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keystroke sound effects — tap the play icon to preview a pack'**
  String get settingsSoundSubtitle;

  /// No description provided for @settingsSoundPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get settingsSoundPreview;

  /// No description provided for @soundPackMechanical.
  ///
  /// In en, this message translates to:
  /// **'Mechanical'**
  String get soundPackMechanical;

  /// No description provided for @soundPackSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get soundPackSoft;

  /// No description provided for @soundPackTypewriter.
  ///
  /// In en, this message translates to:
  /// **'Typewriter'**
  String get soundPackTypewriter;

  /// No description provided for @soundPackArcade.
  ///
  /// In en, this message translates to:
  /// **'Arcade'**
  String get soundPackArcade;

  /// No description provided for @soundPackPop.
  ///
  /// In en, this message translates to:
  /// **'Pop'**
  String get soundPackPop;

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

  /// No description provided for @settingsAboutChangelog.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get settingsAboutChangelog;

  /// No description provided for @settingsAboutChangelogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See the release history for this app'**
  String get settingsAboutChangelogSubtitle;

  /// No description provided for @changelogScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get changelogScreenTitle;

  /// No description provided for @changelogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the changelog'**
  String get changelogLoadError;

  /// No description provided for @settingsSectionDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data & progress'**
  String get settingsSectionDataManagement;

  /// No description provided for @settingsDataManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These actions only affect this device. Deleted data can\'t be recovered.'**
  String get settingsDataManagementSubtitle;

  /// No description provided for @settingsResetLesson.
  ///
  /// In en, this message translates to:
  /// **'Reset a lesson'**
  String get settingsResetLesson;

  /// No description provided for @settingsResetLessonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear your progress on a single lesson so you can practice it again from scratch'**
  String get settingsResetLessonSubtitle;

  /// No description provided for @settingsResetAllLessons.
  ///
  /// In en, this message translates to:
  /// **'Reset all lessons'**
  String get settingsResetAllLessons;

  /// No description provided for @settingsResetAllLessonsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear your progress on every lesson, across every learning path'**
  String get settingsResetAllLessonsSubtitle;

  /// No description provided for @settingsWipeAllData.
  ///
  /// In en, this message translates to:
  /// **'Erase all local data'**
  String get settingsWipeAllData;

  /// No description provided for @settingsWipeAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deletes your profile, sessions, stats, achievements and PIN — the app starts over as new'**
  String get settingsWipeAllDataSubtitle;

  /// No description provided for @settingsPickLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a lesson to reset'**
  String get settingsPickLessonTitle;

  /// No description provided for @settingsPickLessonEmpty.
  ///
  /// In en, this message translates to:
  /// **'No learning paths available yet'**
  String get settingsPickLessonEmpty;

  /// No description provided for @settingsResetLessonConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset \"{lessonTitle}\"?'**
  String settingsResetLessonConfirmTitle(String lessonTitle);

  /// No description provided for @settingsResetLessonConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Every attempt you\'ve made at this lesson will be deleted and its progress set back to not started. This can\'t be undone.'**
  String get settingsResetLessonConfirmBody;

  /// No description provided for @settingsResetAllLessonsConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all lessons?'**
  String get settingsResetAllLessonsConfirmTitle;

  /// No description provided for @settingsResetAllLessonsConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Every attempt at every lesson, across every learning path, will be deleted and reset to not started. Your XP and stats will be recalculated. This can\'t be undone.'**
  String get settingsResetAllLessonsConfirmBody;

  /// No description provided for @settingsWipeAllDataConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase all local data?'**
  String get settingsWipeAllDataConfirmTitle;

  /// No description provided for @settingsWipeAllDataConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your profile, every practice session, your stats, achievements and PIN from this device. You\'ll start over as a brand-new guest. This can\'t be undone.'**
  String get settingsWipeAllDataConfirmBody;

  /// No description provided for @settingsDataActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsDataActionCancel;

  /// No description provided for @settingsDataActionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settingsDataActionReset;

  /// No description provided for @settingsDataActionEraseEverything.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get settingsDataActionEraseEverything;

  /// No description provided for @settingsResetLessonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Lesson reset'**
  String get settingsResetLessonSuccess;

  /// No description provided for @settingsResetAllLessonsSuccess.
  ///
  /// In en, this message translates to:
  /// **'All lessons reset'**
  String get settingsResetAllLessonsSuccess;

  /// No description provided for @settingsDataActionError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get settingsDataActionError;

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

  /// No description provided for @windowMinimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get windowMinimize;

  /// No description provided for @windowMaximize.
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get windowMaximize;

  /// No description provided for @windowRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get windowRestore;

  /// No description provided for @windowClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get windowClose;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @libraryEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No snippets match these filters'**
  String get libraryEmptyState;

  /// No description provided for @libraryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryFilterAll;

  /// No description provided for @difficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get difficultyBeginner;

  /// No description provided for @difficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get difficultyIntermediate;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyAdvanced;

  /// No description provided for @difficultyExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get difficultyExpert;

  /// No description provided for @categoryVariablesAndTypes.
  ///
  /// In en, this message translates to:
  /// **'Variables & types'**
  String get categoryVariablesAndTypes;

  /// No description provided for @categoryConditionals.
  ///
  /// In en, this message translates to:
  /// **'Conditionals'**
  String get categoryConditionals;

  /// No description provided for @categoryLoops.
  ///
  /// In en, this message translates to:
  /// **'Loops'**
  String get categoryLoops;

  /// No description provided for @categoryFunctions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get categoryFunctions;

  /// No description provided for @categoryStructs.
  ///
  /// In en, this message translates to:
  /// **'Structs'**
  String get categoryStructs;

  /// No description provided for @categoryInterfaces.
  ///
  /// In en, this message translates to:
  /// **'Interfaces'**
  String get categoryInterfaces;

  /// No description provided for @categorySlicesAndMaps.
  ///
  /// In en, this message translates to:
  /// **'Slices & maps'**
  String get categorySlicesAndMaps;

  /// No description provided for @categoryErrorHandling.
  ///
  /// In en, this message translates to:
  /// **'Error handling'**
  String get categoryErrorHandling;

  /// No description provided for @categoryPointers.
  ///
  /// In en, this message translates to:
  /// **'Pointers'**
  String get categoryPointers;

  /// No description provided for @categoryConcurrency.
  ///
  /// In en, this message translates to:
  /// **'Concurrency'**
  String get categoryConcurrency;

  /// No description provided for @categoryGenerics.
  ///
  /// In en, this message translates to:
  /// **'Generics'**
  String get categoryGenerics;

  /// No description provided for @categoryIdiomaticFormatting.
  ///
  /// In en, this message translates to:
  /// **'Idiomatic formatting'**
  String get categoryIdiomaticFormatting;

  /// No description provided for @languageGo.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get languageGo;

  /// No description provided for @snippetPracticeAction.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get snippetPracticeAction;

  /// No description provided for @practiceZenTitle.
  ///
  /// In en, this message translates to:
  /// **'Zen practice'**
  String get practiceZenTitle;

  /// No description provided for @practiceStartHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing to begin — no timer, no pressure.'**
  String get practiceStartHint;

  /// No description provided for @practiceLiveCharsTyped.
  ///
  /// In en, this message translates to:
  /// **'{count} typed'**
  String practiceLiveCharsTyped(int count);

  /// No description provided for @practiceLiveAccuracy.
  ///
  /// In en, this message translates to:
  /// **'{pct}% so far'**
  String practiceLiveAccuracy(String pct);

  /// No description provided for @practiceResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get practiceResultTitle;

  /// No description provided for @practiceResultNetSpeed.
  ///
  /// In en, this message translates to:
  /// **'Net speed'**
  String get practiceResultNetSpeed;

  /// No description provided for @practiceResultRawSpeed.
  ///
  /// In en, this message translates to:
  /// **'Raw speed'**
  String get practiceResultRawSpeed;

  /// No description provided for @practiceResultAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get practiceResultAccuracy;

  /// No description provided for @practiceResultConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get practiceResultConsistency;

  /// No description provided for @practiceResultStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get practiceResultStreak;

  /// No description provided for @practiceResultWeakestChars.
  ///
  /// In en, this message translates to:
  /// **'Weakest characters this session'**
  String get practiceResultWeakestChars;

  /// No description provided for @practiceResultDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get practiceResultDone;

  /// No description provided for @practiceResultScorePassed.
  ///
  /// In en, this message translates to:
  /// **'{score}/10 — Passed!'**
  String practiceResultScorePassed(int score);

  /// No description provided for @practiceResultScoreFailed.
  ///
  /// In en, this message translates to:
  /// **'{score}/10 — Not there yet, try again'**
  String practiceResultScoreFailed(int score);

  /// No description provided for @practiceResultRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get practiceResultRetry;

  /// No description provided for @practiceResultContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get practiceResultContinue;

  /// No description provided for @practiceResultLearnMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'What did you just type?'**
  String get practiceResultLearnMoreTitle;

  /// No description provided for @compilerFlavorPerfect.
  ///
  /// In en, this message translates to:
  /// **'Build succeeded — 0 errors, 0 warnings.'**
  String get compilerFlavorPerfect;

  /// No description provided for @compilerFlavorGreat.
  ///
  /// In en, this message translates to:
  /// **'Compiled with a couple of minor warnings.'**
  String get compilerFlavorGreat;

  /// No description provided for @compilerFlavorGood.
  ///
  /// In en, this message translates to:
  /// **'Build succeeded after a few patches.'**
  String get compilerFlavorGood;

  /// No description provided for @compilerFlavorRough.
  ///
  /// In en, this message translates to:
  /// **'Ran, but with some known bugs.'**
  String get compilerFlavorRough;

  /// No description provided for @compilerFlavorBad.
  ///
  /// In en, this message translates to:
  /// **'panic: runtime error — recovered. Try again.'**
  String get compilerFlavorBad;

  /// No description provided for @practiceModePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a mode'**
  String get practiceModePickerTitle;

  /// No description provided for @practiceModeZen.
  ///
  /// In en, this message translates to:
  /// **'Zen'**
  String get practiceModeZen;

  /// No description provided for @practiceModeZenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No timer, no pressure — just practice.'**
  String get practiceModeZenSubtitle;

  /// No description provided for @practiceModeSprint30.
  ///
  /// In en, this message translates to:
  /// **'Sprint · 30s'**
  String get practiceModeSprint30;

  /// No description provided for @practiceModeSprint60.
  ///
  /// In en, this message translates to:
  /// **'Sprint · 60s'**
  String get practiceModeSprint60;

  /// No description provided for @practiceModeSprint120.
  ///
  /// In en, this message translates to:
  /// **'Sprint · 120s'**
  String get practiceModeSprint120;

  /// No description provided for @practiceModeSprintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Beat the clock — maximize correct characters.'**
  String get practiceModeSprintSubtitle;

  /// No description provided for @practiceModePrecision.
  ///
  /// In en, this message translates to:
  /// **'Precision test'**
  String get practiceModePrecision;

  /// No description provided for @practiceModePrecisionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Score above 7/10 (80%+ accuracy) to pass.'**
  String get practiceModePrecisionSubtitle;

  /// No description provided for @practiceHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceHubTitle;

  /// No description provided for @freePracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free practice'**
  String get freePracticeTitle;

  /// No description provided for @practiceHubQuickModesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick practice'**
  String get practiceHubQuickModesTitle;

  /// No description provided for @practiceHubBrowseAllAction.
  ///
  /// In en, this message translates to:
  /// **'Browse all snippets'**
  String get practiceHubBrowseAllAction;

  /// No description provided for @practiceHubNoSnippetsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No snippets available yet.'**
  String get practiceHubNoSnippetsAvailable;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Finish a practice session to see your progress here.'**
  String get progressEmptyState;

  /// No description provided for @progressLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String progressLevelLabel(int level);

  /// No description provided for @progressTotalXp.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String progressTotalXp(int xp);

  /// No description provided for @progressStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String progressStreakLabel(int days);

  /// No description provided for @progressWeaknessTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weak spots'**
  String get progressWeaknessTitle;

  /// No description provided for @progressWeaknessCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get progressWeaknessCharacters;

  /// No description provided for @progressWeaknessFingers.
  ///
  /// In en, this message translates to:
  /// **'Fingers'**
  String get progressWeaknessFingers;

  /// No description provided for @progressWeaknessNgrams.
  ///
  /// In en, this message translates to:
  /// **'Combinations'**
  String get progressWeaknessNgrams;

  /// No description provided for @progressWeaknessEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get progressWeaknessEmpty;

  /// No description provided for @progressHeatmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard heatmap'**
  String get progressHeatmapTitle;

  /// No description provided for @progressMasteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Mastery'**
  String get progressMasteryTitle;

  /// No description provided for @progressMasteryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Complete Precision sessions to start certifying categories'**
  String get progressMasteryEmpty;

  /// No description provided for @progressMasteryCertified.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get progressMasteryCertified;

  /// No description provided for @progressMasteryNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet mastered'**
  String get progressMasteryNotYet;

  /// No description provided for @progressHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal history'**
  String get progressHistoryTitle;

  /// No description provided for @progressHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet for this category'**
  String get progressHistoryEmpty;

  /// No description provided for @progressHistoryAverage.
  ///
  /// In en, this message translates to:
  /// **'Average: {speed} cpm · {accuracy}% accuracy'**
  String progressHistoryAverage(int speed, int accuracy);

  /// No description provided for @progressFingerLeftPinky.
  ///
  /// In en, this message translates to:
  /// **'Left pinky'**
  String get progressFingerLeftPinky;

  /// No description provided for @progressFingerLeftRing.
  ///
  /// In en, this message translates to:
  /// **'Left ring finger'**
  String get progressFingerLeftRing;

  /// No description provided for @progressFingerLeftMiddle.
  ///
  /// In en, this message translates to:
  /// **'Left middle finger'**
  String get progressFingerLeftMiddle;

  /// No description provided for @progressFingerLeftIndex.
  ///
  /// In en, this message translates to:
  /// **'Left index finger'**
  String get progressFingerLeftIndex;

  /// No description provided for @progressFingerRightIndex.
  ///
  /// In en, this message translates to:
  /// **'Right index finger'**
  String get progressFingerRightIndex;

  /// No description provided for @progressFingerRightMiddle.
  ///
  /// In en, this message translates to:
  /// **'Right middle finger'**
  String get progressFingerRightMiddle;

  /// No description provided for @progressFingerRightRing.
  ///
  /// In en, this message translates to:
  /// **'Right ring finger'**
  String get progressFingerRightRing;

  /// No description provided for @progressFingerRightPinky.
  ///
  /// In en, this message translates to:
  /// **'Right pinky'**
  String get progressFingerRightPinky;

  /// No description provided for @progressFingerThumb.
  ///
  /// In en, this message translates to:
  /// **'Thumb'**
  String get progressFingerThumb;

  /// No description provided for @progressTrendImproving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get progressTrendImproving;

  /// No description provided for @progressTrendWorsening.
  ///
  /// In en, this message translates to:
  /// **'Worsening'**
  String get progressTrendWorsening;

  /// No description provided for @progressTrendStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get progressTrendStable;

  /// No description provided for @learningPathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning paths'**
  String get learningPathsTitle;

  /// No description provided for @learningPathsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No learning paths available yet.'**
  String get learningPathsEmptyState;

  /// No description provided for @learningPathsProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} lessons complete'**
  String learningPathsProgress(int completed, int total);

  /// No description provided for @learningPathsLessonListTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get learningPathsLessonListTitle;

  /// No description provided for @learningPathsContinueHint.
  ///
  /// In en, this message translates to:
  /// **'Continue: {lessonTitle}'**
  String learningPathsContinueHint(String lessonTitle);

  /// No description provided for @learningPathsContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue lesson'**
  String get learningPathsContinueAction;

  /// No description provided for @learningLessonLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get learningLessonLocked;

  /// No description provided for @learningLessonUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get learningLessonUnlocked;

  /// No description provided for @learningLessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get learningLessonCompleted;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementUnlockedToast.
  ///
  /// In en, this message translates to:
  /// **'Achievement unlocked: {title}'**
  String achievementUnlockedToast(String title);

  /// No description provided for @achievementCeroErroresTitle.
  ///
  /// In en, this message translates to:
  /// **'Zero Errors'**
  String get achievementCeroErroresTitle;

  /// No description provided for @achievementCeroErroresDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish a session with 100% accuracy and no corrections'**
  String get achievementCeroErroresDescription;

  /// No description provided for @achievementAmbidiestroTitle.
  ///
  /// In en, this message translates to:
  /// **'Ambidextrous'**
  String get achievementAmbidiestroTitle;

  /// No description provided for @achievementAmbidiestroDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish a 100+ character session with near-perfect hand balance'**
  String get achievementAmbidiestroDescription;

  /// No description provided for @achievementMaratonistaBronzeTitle.
  ///
  /// In en, this message translates to:
  /// **'Marathoner · Bronze'**
  String get achievementMaratonistaBronzeTitle;

  /// No description provided for @achievementMaratonistaSilverTitle.
  ///
  /// In en, this message translates to:
  /// **'Marathoner · Silver'**
  String get achievementMaratonistaSilverTitle;

  /// No description provided for @achievementMaratonistaGoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Marathoner · Gold'**
  String get achievementMaratonistaGoldTitle;

  /// No description provided for @achievementMaratonistaDescription.
  ///
  /// In en, this message translates to:
  /// **'Type {count} correct characters in your lifetime'**
  String achievementMaratonistaDescription(int count);

  /// No description provided for @achievementCategoryMasteryTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} · {difficulty} Mastery'**
  String achievementCategoryMasteryTitle(String category, String difficulty);

  /// No description provided for @achievementCategoryMasteryDescription.
  ///
  /// In en, this message translates to:
  /// **'Certify mastery of a category and difficulty'**
  String get achievementCategoryMasteryDescription;

  /// No description provided for @achievementStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{days}-Day Streak'**
  String achievementStreakTitle(int days);

  /// No description provided for @achievementStreakDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice {days} days in a row'**
  String achievementStreakDescription(int days);

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Real code, not filler'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Train your typing with real Go snippets — the syntax you actually write at work, not random sentences.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @onboardingMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Know exactly what slows you down'**
  String get onboardingMetricsTitle;

  /// No description provided for @onboardingMetricsDescription.
  ///
  /// In en, this message translates to:
  /// **'Speed, accuracy, per-finger and per-character — every session shows you what to improve, and why.'**
  String get onboardingMetricsDescription;

  /// No description provided for @onboardingPathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress at your own pace'**
  String get onboardingPathsTitle;

  /// No description provided for @onboardingPathsDescription.
  ///
  /// In en, this message translates to:
  /// **'Guided learning paths, XP, and achievements — fully offline, whenever you want.'**
  String get onboardingPathsDescription;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'No friction, ever'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyDescription.
  ///
  /// In en, this message translates to:
  /// **'Just a username — no email, no password. Let\'s start typing.'**
  String get onboardingReadyDescription;

  /// No description provided for @onboardingAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Make it yours'**
  String get onboardingAppearanceTitle;

  /// No description provided for @onboardingAppearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick a palette, corner style, and color mode — you can always change this later in Settings.'**
  String get onboardingAppearanceDescription;
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
