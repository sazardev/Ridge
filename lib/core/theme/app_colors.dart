import 'package:flutter/material.dart';

/// Single seed for the whole app — a vivid, punctual amber-orange that
/// reads as "on time" rather than alarming red. Every other color in the
/// app is derived from this seed through Material 3's color system.
abstract final class AppColors {
  static const seed = Color(0xFFFF5A36);
}

ColorScheme buildColorScheme({
  required Brightness brightness,
  required bool expressive,
}) {
  return ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    brightness: brightness,
    dynamicSchemeVariant: expressive
        ? DynamicSchemeVariant.expressive
        : DynamicSchemeVariant.tonalSpot,
  );
}
