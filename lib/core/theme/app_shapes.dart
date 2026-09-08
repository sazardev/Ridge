import 'package:flutter/material.dart';

/// Material 3 shape-scale radii. Kept as plain doubles so any widget can
/// build either a [RoundedSuperellipseBorder] (squircle) or a rectangle
/// out of the same scale.
abstract final class AppRadius {
  static const none = 0.0;
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const largeIncreased = 20.0;
  static const extraLarge = 28.0;
  static const extraLargeIncreased = 32.0;
  static const full = 999.0;
}

/// Flat, shadow-free shapes for the whole design system. Depth is
/// communicated with tonal surface containers, never elevation or shadow,
/// so every shape here is a continuous "squircle" — the softer, more
/// organic corner Material 3 Expressive favors over a plain rounded rect.
abstract final class AppShapes {
  static OutlinedBorder squircle(double radius) =>
      RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(radius));

  static BorderRadius squircleRadius(double radius) =>
      BorderRadius.circular(radius);

  static final OutlinedBorder extraSmall = squircle(AppRadius.extraSmall);
  static final OutlinedBorder small = squircle(AppRadius.small);
  static final OutlinedBorder medium = squircle(AppRadius.medium);
  static final OutlinedBorder large = squircle(AppRadius.large);
  static final OutlinedBorder largeIncreased = squircle(
    AppRadius.largeIncreased,
  );
  static final OutlinedBorder extraLarge = squircle(AppRadius.extraLarge);
  static final OutlinedBorder extraLargeIncreased = squircle(
    AppRadius.extraLargeIncreased,
  );
  static final OutlinedBorder full = squircle(AppRadius.full);
}
