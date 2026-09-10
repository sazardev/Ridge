import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';

/// Localized display label for a [FavoriteLanguage], shared by every
/// widget that renders one so the mapping lives in exactly one place.
extension FavoriteLanguageLabel on FavoriteLanguage {
  /// Returns this language's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    FavoriteLanguage.go => l10n.favoriteLanguageGo,
    FavoriteLanguage.python => l10n.favoriteLanguagePython,
    FavoriteLanguage.javascript => l10n.favoriteLanguageJavascript,
    FavoriteLanguage.typescript => l10n.favoriteLanguageTypescript,
    FavoriteLanguage.rust => l10n.favoriteLanguageRust,
    FavoriteLanguage.c => l10n.favoriteLanguageC,
    FavoriteLanguage.cpp => l10n.favoriteLanguageCpp,
    FavoriteLanguage.csharp => l10n.favoriteLanguageCsharp,
    FavoriteLanguage.java => l10n.favoriteLanguageJava,
    FavoriteLanguage.kotlin => l10n.favoriteLanguageKotlin,
    FavoriteLanguage.swift => l10n.favoriteLanguageSwift,
    FavoriteLanguage.ruby => l10n.favoriteLanguageRuby,
    FavoriteLanguage.php => l10n.favoriteLanguagePhp,
    FavoriteLanguage.dart => l10n.favoriteLanguageDart,
    FavoriteLanguage.lua => l10n.favoriteLanguageLua,
    FavoriteLanguage.haskell => l10n.favoriteLanguageHaskell,
    FavoriteLanguage.scala => l10n.favoriteLanguageScala,
    FavoriteLanguage.elixir => l10n.favoriteLanguageElixir,
    FavoriteLanguage.clojure => l10n.favoriteLanguageClojure,
    FavoriteLanguage.perl => l10n.favoriteLanguagePerl,
    FavoriteLanguage.r => l10n.favoriteLanguageR,
    FavoriteLanguage.objectiveC => l10n.favoriteLanguageObjectiveC,
    FavoriteLanguage.shell => l10n.favoriteLanguageShell,
    FavoriteLanguage.sql => l10n.favoriteLanguageSql,
    FavoriteLanguage.assembly => l10n.favoriteLanguageAssembly,
    FavoriteLanguage.zig => l10n.favoriteLanguageZig,
    FavoriteLanguage.nim => l10n.favoriteLanguageNim,
    FavoriteLanguage.julia => l10n.favoriteLanguageJulia,
    FavoriteLanguage.groovy => l10n.favoriteLanguageGroovy,
    FavoriteLanguage.fsharp => l10n.favoriteLanguageFsharp,
    FavoriteLanguage.ocaml => l10n.favoriteLanguageOcaml,
    FavoriteLanguage.erlang => l10n.favoriteLanguageErlang,
    FavoriteLanguage.crystal => l10n.favoriteLanguageCrystal,
    FavoriteLanguage.solidity => l10n.favoriteLanguageSolidity,
    FavoriteLanguage.powershell => l10n.favoriteLanguagePowershell,
    FavoriteLanguage.lisp => l10n.favoriteLanguageLisp,
    FavoriteLanguage.prolog => l10n.favoriteLanguageProlog,
    FavoriteLanguage.cobol => l10n.favoriteLanguageCobol,
    FavoriteLanguage.fortran => l10n.favoriteLanguageFortran,
    FavoriteLanguage.matlab => l10n.favoriteLanguageMatlab,
    FavoriteLanguage.other => l10n.favoriteLanguageOther,
  };
}

/// Localized display label and icon for a [KeyboardLayout], shared by
/// every widget that renders one so the mapping lives in exactly one
/// place.
extension KeyboardLayoutLabel on KeyboardLayout {
  /// Returns this layout's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeyboardLayout.qwerty => l10n.keyboardLayoutQwerty,
    KeyboardLayout.azerty => l10n.keyboardLayoutAzerty,
    KeyboardLayout.qwertz => l10n.keyboardLayoutQwertz,
    KeyboardLayout.dvorak => l10n.keyboardLayoutDvorak,
    KeyboardLayout.colemak => l10n.keyboardLayoutColemak,
    KeyboardLayout.workman => l10n.keyboardLayoutWorkman,
    KeyboardLayout.other => l10n.keyboardLayoutOther,
  };
}
