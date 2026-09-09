import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:just_in_time/features/settings/domain/entities/app_corner_style.dart';

/// Material 3 shape-scale radii — the "soft" (default) reference values
/// [AppShapeTheme.forStyle] scales from. Kept as plain doubles so any
/// widget can build either a [RoundedSuperellipseBorder] (squircle) or a
/// rectangle out of the same scale.
abstract final class AppRadius {
  /// Square corners — dividers, full-bleed surfaces. Always 0 regardless
  /// of the user's chosen [AppCornerStyle].
  static const none = 0.0;

  /// Smallest rounding — chips, small controls.
  static const extraSmall = 4.0;

  /// Compact rounding — indicators, small chips.
  static const small = 8.0;

  /// Standard rounding for mid-sized surfaces — navigation indicators.
  static const medium = 12.0;

  /// Standard rounding for cards and large surfaces.
  static const large = 16.0;

  /// Slightly more rounded than [large] — emphasized cards.
  static const largeIncreased = 20.0;

  /// Rounding for dialogs, sheets, and other prominent surfaces.
  static const extraLarge = 28.0;

  /// Slightly more rounded than [extraLarge] — the FAB.
  static const extraLargeIncreased = 32.0;

  /// Fully rounded (pill/stadium) — buttons.
  static const full = 999.0;
}

/// The live radius scale for every named [AppRadius] token, swappable via
/// [AppCornerStyle] and threaded through [ThemeData.extensions] (see
/// `AppTheme`) so any widget in the tree can read the user's chosen
/// roundedness with `AppShapes.of(context)` and stay in sync in real time.
@immutable
class AppShapeTheme extends ThemeExtension<AppShapeTheme> {
  /// Creates a shape scale from explicit radii.
  const new({
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    required this.largeIncreased,
    required this.extraLarge,
    required this.extraLargeIncreased,
    required this.full,
  });

  /// The radius scale [style] resolves to.
  factory forStyle(AppCornerStyle style) {
    return switch (style) {
      AppCornerStyle.sharp => const AppShapeTheme(
        extraSmall: 0,
        small: 0,
        medium: 0,
        large: 0,
        largeIncreased: 0,
        extraLarge: 0,
        extraLargeIncreased: 0,
        full: 0,
      ),
      AppCornerStyle.soft => const AppShapeTheme(
        extraSmall: AppRadius.extraSmall,
        small: AppRadius.small,
        medium: AppRadius.medium,
        large: AppRadius.large,
        largeIncreased: AppRadius.largeIncreased,
        extraLarge: AppRadius.extraLarge,
        extraLargeIncreased: AppRadius.extraLargeIncreased,
        full: AppRadius.full,
      ),
      AppCornerStyle.round => const AppShapeTheme(
        extraSmall: 8,
        small: 14,
        medium: 20,
        large: 26,
        largeIncreased: 30,
        extraLarge: 36,
        extraLargeIncreased: 40,
        full: AppRadius.full,
      ),
      AppCornerStyle.pill => const AppShapeTheme(
        extraSmall: AppRadius.full,
        small: AppRadius.full,
        medium: AppRadius.full,
        large: AppRadius.full,
        largeIncreased: AppRadius.full,
        extraLarge: AppRadius.full,
        extraLargeIncreased: AppRadius.full,
        full: AppRadius.full,
      ),
    };
  }

  /// Squircle at [extraSmall].
  final double extraSmall;

  /// Squircle at [small].
  final double small;

  /// Squircle at [medium].
  final double medium;

  /// Squircle at [large].
  final double large;

  /// Squircle at [largeIncreased].
  final double largeIncreased;

  /// Squircle at [extraLarge].
  final double extraLarge;

  /// Squircle at [extraLargeIncreased].
  final double extraLargeIncreased;

  /// Squircle at [full] — a pill/stadium shape (or square, under
  /// [AppCornerStyle.sharp]).
  final double full;

  /// Squircle [OutlinedBorder] at [extraSmall].
  OutlinedBorder get extraSmallShape => AppShapes.squircle(extraSmall);

  /// Squircle [OutlinedBorder] at [small].
  OutlinedBorder get smallShape => AppShapes.squircle(small);

  /// Squircle [OutlinedBorder] at [medium].
  OutlinedBorder get mediumShape => AppShapes.squircle(medium);

  /// Squircle [OutlinedBorder] at [large].
  OutlinedBorder get largeShape => AppShapes.squircle(large);

  /// Squircle [OutlinedBorder] at [largeIncreased].
  OutlinedBorder get largeIncreasedShape => AppShapes.squircle(largeIncreased);

  /// Squircle [OutlinedBorder] at [extraLarge].
  OutlinedBorder get extraLargeShape => AppShapes.squircle(extraLarge);

  /// Squircle [OutlinedBorder] at [extraLargeIncreased].
  OutlinedBorder get extraLargeIncreasedShape =>
      AppShapes.squircle(extraLargeIncreased);

  /// Squircle [OutlinedBorder] at [full].
  OutlinedBorder get fullShape => AppShapes.squircle(full);

  @override
  AppShapeTheme copyWith({
    double? extraSmall,
    double? small,
    double? medium,
    double? large,
    double? largeIncreased,
    double? extraLarge,
    double? extraLargeIncreased,
    double? full,
  }) {
    return AppShapeTheme(
      extraSmall: extraSmall ?? this.extraSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      largeIncreased: largeIncreased ?? this.largeIncreased,
      extraLarge: extraLarge ?? this.extraLarge,
      extraLargeIncreased: extraLargeIncreased ?? this.extraLargeIncreased,
      full: full ?? this.full,
    );
  }

  @override
  AppShapeTheme lerp(ThemeExtension<AppShapeTheme>? other, double t) {
    if (other is! AppShapeTheme) return this;
    return AppShapeTheme(
      extraSmall: lerpDouble(extraSmall, other.extraSmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      largeIncreased: lerpDouble(largeIncreased, other.largeIncreased, t)!,
      extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
      extraLargeIncreased: lerpDouble(
        extraLargeIncreased,
        other.extraLargeIncreased,
        t,
      )!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}

/// Flat, shadow-free shape utilities for the whole design system. Depth is
/// communicated with tonal surface containers, never elevation or shadow,
/// so every shape here is a continuous "squircle" — the softer, more
/// organic corner Material 3 Expressive favors over a plain rounded rect.
abstract final class AppShapes {
  /// The live, user-customizable shape scale for the nearest [ThemeData] —
  /// falls back to [AppCornerStyle.soft] if none is registered (e.g. in a
  /// test harness that builds a bare [ThemeData]).
  static AppShapeTheme of(BuildContext context) =>
      Theme.of(context).extension<AppShapeTheme>() ??
      AppShapeTheme.forStyle(AppCornerStyle.soft);

  /// Builds a squircle border at the given [radius].
  static OutlinedBorder squircle(double radius) =>
      RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(radius));

  /// The [BorderRadius] a squircle at the given [radius] would use — for
  /// APIs that only accept a radius, not a full [OutlinedBorder].
  static BorderRadius squircleRadius(double radius) =>
      BorderRadius.circular(radius);
}
