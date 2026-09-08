import 'package:flutter/material.dart';

import 'package:just_in_time/core/theme/app_colors.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/core/theme/app_typography.dart';
import 'package:just_in_time/core/theme/expressive_ink.dart';

/// The app's whole design system in one place: Material 3 Expressive color
/// and typography, but rendered completely flat — no shadows, no
/// gradients, no elevation tint. Hierarchy comes from the tonal surface
/// container roles instead, which is what keeps a flat UI from looking dead.
abstract final class AppTheme {
  static ThemeData light({bool expressiveColor = true}) =>
      _build(brightness: Brightness.light, expressiveColor: expressiveColor);

  static ThemeData dark({bool expressiveColor = true}) =>
      _build(brightness: Brightness.dark, expressiveColor: expressiveColor);

  static ThemeData _build({
    required Brightness brightness,
    required bool expressiveColor,
  }) {
    final colorScheme = buildColorScheme(
      brightness: brightness,
      expressive: expressiveColor,
    );
    final base = ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      useMaterial3: true,
      fontFamily: AppFonts.mono,
    );
    final textTheme = buildAppTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: expressiveSplashFactory,
      splashColor: colorScheme.primary.withValues(alpha: 0.16),
      highlightColor: colorScheme.primary.withValues(alpha: 0.06),
      hoverColor: colorScheme.primary.withValues(alpha: 0.06),
      visualDensity: VisualDensity.standard,

      // Flat surfaces everywhere: no shadow, no elevation tint.
      shadowColor: Colors.transparent,
      canvasColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: AppShapes.large,
      ),

      chipTheme: ChipThemeData(
        elevation: 0,
        pressElevation: 0,
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide.none,
        shape: AppShapes.small,
        labelStyle: textTheme.labelLarge,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: AppShapes.full,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
          animationDuration: AppMotion.effectsDefault,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          shape: AppShapes.full,
          side: BorderSide(color: colorScheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          shape: AppShapes.full,
          textStyle: textTheme.labelLarge,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: AppShapes.full,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: AppShapes.full,
          highlightColor: Colors.transparent,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: AppShapes.largeIncreased,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: colorScheme.secondaryContainer,
        indicatorShape: AppShapes.medium,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),

      navigationRailTheme: NavigationRailThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainer,
        useIndicator: true,
        indicatorShape: AppShapes.medium,
        indicatorColor: colorScheme.secondaryContainer,
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      dialogTheme: DialogThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: AppShapes.extraLarge,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        modalElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.extraLarge),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: AppShapes.medium,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          elevation: 0,
          shape: AppShapes.full,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),

      switchTheme: const SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: AppShapes.squircleRadius(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.squircleRadius(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.squircleRadius(AppRadius.medium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppShapes.squircleRadius(AppRadius.medium),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: AppShapes.extraLarge,
      ),

      timePickerTheme: TimePickerThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: AppShapes.extraLarge,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
