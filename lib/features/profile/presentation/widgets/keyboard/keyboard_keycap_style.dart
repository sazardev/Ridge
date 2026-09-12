import 'package:flutter/material.dart';

/// Resolved colors and proportions for the pseudo-3D keycap rendering —
/// a VIA-style look (light keycaps with a visible extruded side, on a
/// noticeably darker board) derived entirely from the active
/// [ColorScheme], so every user palette gets a coherent keyboard without
/// hardcoding a single color.
///
/// Surface roles alone aren't enough for this: `surfaceBright`/`surfaceDim`
/// invert or collapse to ~1.06 contrast in several bundled palettes
/// (gruvbox light, blackWhite, dracula light, ...). So the board is always
/// anchored to the scheme's darkest end (`inverseSurface` in light,
/// `surfaceContainerLowest` + `shadow` in dark) and key tops to its
/// lightest (`surfaceBright`, pulled toward `onSurface` in dark so very
/// dark schemes still read as keycaps), which keeps the board-darker-than-
/// keys relationship true for every palette and brightness.
@immutable
class KeyboardKeycapStyle {
  /// Creates a style from already-resolved colors and radii — callers go
  /// through [KeyboardKeycapStyle.fromScheme].
  const new({
    required this.keyTop,
    required this.keyTopAccent,
    required this.keySide,
    required this.keySideAccent,
    required this.keyBorder,
    required this.caseTop,
    required this.caseSide,
    required this.caseBorder,
    required this.plate,
    required this.hoverTint,
    required this.keyCornerRadius,
    required this.caseCornerRadius,
    this.keyDepthFraction = 0.10,
    this.caseDepthFraction = 0.16,
    this.topLightnessDelta = 0.045,
    this.bottomLightnessDelta = 0.03,
  });

  /// Resolves [scheme] into the keycap style, with corner radii from the
  /// app's live shape scale.
  factory fromScheme(
    ColorScheme scheme, {
    required double keyCornerRadius,
    required double caseCornerRadius,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    // The board: always near the scheme's dark end, so light-mode palettes
    // get a genuinely dark chassis (VIA-like) instead of a washed-out one.
    final caseTop = isDark
        ? _mix(scheme.surfaceContainerLowest, scheme.shadow, 0.35)
        : _mix(scheme.inverseSurface, scheme.surface, 0.12);
    // Key tops: the light end. In dark schemes `surfaceBright` is only a
    // slightly-lifted dark tone, so pull it toward `onSurface` (the
    // scheme's contrast text color) to keep keycaps visibly lighter.
    final keyTop = isDark
        ? _mix(scheme.surfaceBright, scheme.onSurface, 0.45)
        : scheme.surfaceBright;
    final accentTop = _mix(keyTop, caseTop, isDark ? 0.20 : 0.14);

    return KeyboardKeycapStyle(
      keyTop: keyTop,
      keyTopAccent: accentTop,
      keySide: _mix(keyTop, caseTop, 0.45),
      keySideAccent: _mix(accentTop, caseTop, 0.45),
      keyBorder: _mix(_mix(keyTop, caseTop, 0.45), caseTop, 0.35),
      caseTop: caseTop,
      caseSide: _mix(caseTop, scheme.shadow, 0.40),
      caseBorder: _mix(caseTop, scheme.shadow, 0.55),
      plate: _mix(caseTop, scheme.shadow, 0.22),
      hoverTint: scheme.primary,
      keyCornerRadius: keyCornerRadius,
      caseCornerRadius: caseCornerRadius,
    );
  }

  /// Fill of a standard 1u alpha keycap's top face.
  final Color keyTop;

  /// Fill of a modifier/spacebar keycap's top face — the same visual cue
  /// real keyboards use to set the alpha block apart.
  final Color keyTopAccent;

  /// Extruded side/lip of a standard keycap.
  final Color keySide;

  /// Extruded side/lip of an accent keycap.
  final Color keySideAccent;

  /// Stroke around tight keycap top faces.
  final Color keyBorder;

  /// Inner plate the keys sit on (slightly darker than the case top, so it
  /// reads as a recess).
  final Color plate;

  /// Fill of the outer case/body.
  final Color caseTop;

  /// Extruded side/lip of the case.
  final Color caseSide;

  /// Stroke around the case outline.
  final Color caseBorder;

  /// Tint blended into a keycap's top face while hovered.
  final Color hoverTint;

  /// Corner radius applied to every keycap.
  final double keyCornerRadius;

  /// Corner radius applied to the case/body.
  final double caseCornerRadius;

  /// Keycap extrusion depth, as a fraction of one key-unit.
  final double keyDepthFraction;

  /// Case extrusion depth, as a fraction of one key-unit.
  final double caseDepthFraction;

  /// How much lighter the top edge of a keycap's face gradient is, in HSL
  /// lightness.
  final double topLightnessDelta;

  /// How much darker the bottom edge of a keycap's face gradient is, in
  /// HSL lightness.
  final double bottomLightnessDelta;

  /// [color]'s HSL lightness shifted by [delta], clamped to legal range.
  static Color shiftLightness(Color color, double delta) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
  }

  /// [a] mixed [t] of the way toward [b].
  static Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeyboardKeycapStyle &&
        keyTop == other.keyTop &&
        keyTopAccent == other.keyTopAccent &&
        keySide == other.keySide &&
        keySideAccent == other.keySideAccent &&
        keyBorder == other.keyBorder &&
        caseTop == other.caseTop &&
        caseSide == other.caseSide &&
        caseBorder == other.caseBorder &&
        plate == other.plate &&
        hoverTint == other.hoverTint &&
        keyCornerRadius == other.keyCornerRadius &&
        caseCornerRadius == other.caseCornerRadius &&
        keyDepthFraction == other.keyDepthFraction &&
        caseDepthFraction == other.caseDepthFraction &&
        topLightnessDelta == other.topLightnessDelta &&
        bottomLightnessDelta == other.bottomLightnessDelta;
  }

  @override
  int get hashCode => Object.hash(
    keyTop,
    keyTopAccent,
    keySide,
    keySideAccent,
    keyBorder,
    caseTop,
    caseSide,
    caseBorder,
    plate,
    hoverTint,
    keyCornerRadius,
    caseCornerRadius,
    keyDepthFraction,
    caseDepthFraction,
    topLightnessDelta,
    bottomLightnessDelta,
  );
}
