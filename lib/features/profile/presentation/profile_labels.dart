import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';

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

/// Localized display label for a [KeyboardShapeFamily].
extension KeyboardShapeFamilyLabel on KeyboardShapeFamily {
  /// Returns this family's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeyboardShapeFamily.fullSize => l10n.keyboardShapeFamilyFullSize,
    KeyboardShapeFamily.tkl => l10n.keyboardShapeFamilyTkl,
    KeyboardShapeFamily.seventyFive => l10n.keyboardShapeFamilySeventyFive,
    KeyboardShapeFamily.sixtyFive => l10n.keyboardShapeFamilySixtyFive,
    KeyboardShapeFamily.sixty => l10n.keyboardShapeFamilySixty,
    KeyboardShapeFamily.splitErgo => l10n.keyboardShapeFamilySplitErgo,
    KeyboardShapeFamily.custom => l10n.keyboardShapeFamilyCustom,
  };
}

/// Localized display label for a [KeycapShape].
extension KeycapShapeLabel on KeycapShape {
  /// Returns this shape's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeycapShape.rounded => l10n.keyboardKeycapShapeRounded,
    KeycapShape.square => l10n.keyboardKeycapShapeSquare,
    KeycapShape.round => l10n.keyboardKeycapShapeRound,
  };
}

/// Localized display label for an [RgbEffect].
extension RgbEffectLabel on RgbEffect {
  /// Returns this effect's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    RgbEffect.static => l10n.keyboardRgbEffectStatic,
    RgbEffect.breathing => l10n.keyboardRgbEffectBreathing,
    RgbEffect.rainbow => l10n.keyboardRgbEffectRainbow,
    RgbEffect.colorCycle => l10n.keyboardRgbEffectColorCycle,
    RgbEffect.wave => l10n.keyboardRgbEffectWave,
    RgbEffect.aurora => l10n.keyboardRgbEffectAurora,
    RgbEffect.stars => l10n.keyboardRgbEffectStars,
    RgbEffect.rain => l10n.keyboardRgbEffectRain,
    RgbEffect.gradient => l10n.keyboardRgbEffectGradient,
    RgbEffect.reactive => l10n.keyboardRgbEffectReactive,
    RgbEffect.ripple => l10n.keyboardRgbEffectRipple,
  };
}

/// Localized display label for a [KeycapTransparency].
extension KeycapTransparencyLabel on KeycapTransparency {
  /// Returns this transparency's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeycapTransparency.opaque => l10n.keyboardKeycapTransparencyOpaque,
    KeycapTransparency.shineThrough =>
      l10n.keyboardKeycapTransparencyShineThrough,
    KeycapTransparency.pudding => l10n.keyboardKeycapTransparencyPudding,
    KeycapTransparency.translucent =>
      l10n.keyboardKeycapTransparencyTranslucent,
  };
}

/// Localized display label for a [SwitchType].
extension SwitchTypeLabel on SwitchType {
  /// Returns this switch type's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    SwitchType.linear => l10n.keyboardSwitchLinear,
    SwitchType.tactile => l10n.keyboardSwitchTactile,
    SwitchType.clicky => l10n.keyboardSwitchClicky,
    SwitchType.optical => l10n.keyboardSwitchOptical,
    SwitchType.magnetic => l10n.keyboardSwitchMagnetic,
    SwitchType.topre => l10n.keyboardSwitchTopre,
    SwitchType.rubberDome => l10n.keyboardSwitchRubberDome,
    SwitchType.scissor => l10n.keyboardSwitchScissor,
    SwitchType.bucklingSpring => l10n.keyboardSwitchBucklingSpring,
    SwitchType.other => l10n.keyboardSwitchOther,
  };
}

/// Localized display label for a [KeycapMaterial].
extension KeycapMaterialLabel on KeycapMaterial {
  /// Returns this material's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeycapMaterial.abs => l10n.keyboardKeycapMaterialAbs,
    KeycapMaterial.pbt => l10n.keyboardKeycapMaterialPbt,
    KeycapMaterial.pom => l10n.keyboardKeycapMaterialPom,
    KeycapMaterial.metal => l10n.keyboardKeycapMaterialMetal,
    KeycapMaterial.ceramic => l10n.keyboardKeycapMaterialCeramic,
    KeycapMaterial.wood => l10n.keyboardKeycapMaterialWood,
    KeycapMaterial.other => l10n.keyboardKeycapMaterialOther,
  };
}

/// Localized display label for a [CaseMaterial].
extension CaseMaterialLabel on CaseMaterial {
  /// Returns this material's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    CaseMaterial.plastic => l10n.keyboardCaseMaterialPlastic,
    CaseMaterial.aluminum => l10n.keyboardCaseMaterialAluminum,
    CaseMaterial.steel => l10n.keyboardCaseMaterialSteel,
    CaseMaterial.wood => l10n.keyboardCaseMaterialWood,
    CaseMaterial.resin => l10n.keyboardCaseMaterialResin,
    CaseMaterial.other => l10n.keyboardCaseMaterialOther,
  };
}

/// Localized display label for a [KeyboardPhysicalLayout].
extension KeyboardPhysicalLayoutLabel on KeyboardPhysicalLayout {
  /// Returns this physical layout's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeyboardPhysicalLayout.ansi => l10n.keyboardPhysicalLayoutAnsi,
    KeyboardPhysicalLayout.iso => l10n.keyboardPhysicalLayoutIso,
    KeyboardPhysicalLayout.jis => l10n.keyboardPhysicalLayoutJis,
    KeyboardPhysicalLayout.other => l10n.keyboardPhysicalLayoutOther,
  };
}

/// Localized display label for a [KeyboardConnectionType].
extension KeyboardConnectionTypeLabel on KeyboardConnectionType {
  /// Returns this connection type's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    KeyboardConnectionType.wired => l10n.keyboardConnectionWired,
    KeyboardConnectionType.bluetooth => l10n.keyboardConnectionBluetooth,
    KeyboardConnectionType.wireless24 => l10n.keyboardConnectionWireless24,
    KeyboardConnectionType.multi => l10n.keyboardConnectionMulti,
  };
}
