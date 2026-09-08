import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const sans = 'Geist';
  static const mono = 'GeistMono';
}

/// Geist Mono, app-wide — the whole type scale, not just numeric accents.
/// Monospace doesn't want the tight negative tracking a proportional
/// display face does, so weight carries the emphasis instead of letter
/// spacing.
TextTheme buildAppTextTheme(TextTheme base) {
  final applied = base.apply(fontFamily: AppFonts.mono);
  return applied.copyWith(
    displayLarge: applied.displayLarge?.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.05,
    ),
    displayMedium: applied.displayMedium?.copyWith(fontWeight: FontWeight.w700),
    displaySmall: applied.displaySmall?.copyWith(fontWeight: FontWeight.w600),
    headlineLarge: applied.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
    headlineMedium: applied.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: applied.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    titleLarge: applied.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    titleMedium: applied.titleMedium?.copyWith(fontWeight: FontWeight.w500),
    titleSmall: applied.titleSmall?.copyWith(fontWeight: FontWeight.w500),
    labelLarge: applied.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    labelMedium: applied.labelMedium?.copyWith(fontWeight: FontWeight.w500),
    labelSmall: applied.labelSmall?.copyWith(fontWeight: FontWeight.w500),
    bodyLarge: applied.bodyLarge?.copyWith(height: 1.4),
    bodyMedium: applied.bodyMedium?.copyWith(height: 1.4),
    bodySmall: applied.bodySmall?.copyWith(height: 1.35),
  );
}

/// Tabular figures for the spots that align digits vertically — due-date
/// stamps, PIN dots, counters.
extension TabularFigures on TextStyle {
  TextStyle get tabular =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
