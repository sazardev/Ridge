import 'package:flutter/material.dart';
import 'package:ridge/core/theme/app_palette_catalog.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';

/// App-wide colors that live outside the user-selectable [ColorScheme].
abstract final class AppColors {
  /// The app's original single-hue brand seed — also [AppPaletteId.ember],
  /// the default palette.
  static const seed = Color(0xFFFF5A36);
}

/// Builds the app's [ColorScheme] for the given [brightness] and [palette],
/// either the vivid Material 3 Expressive variant or the more conservative
/// tonal one depending on [expressive]. See [AppPaletteCatalog] for what
/// each palette actually looks like.
ColorScheme buildColorScheme({
  required Brightness brightness,
  required bool expressive,
  AppPaletteId palette = AppPaletteId.ember,
}) {
  return AppPaletteCatalog.of(palette)
      .buildScheme(brightness: brightness, expressive: expressive);
}
