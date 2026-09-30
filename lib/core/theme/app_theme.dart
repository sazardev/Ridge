import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_colors.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/theme/app_typography.dart';
import 'package:ridge/core/theme/expressive_ink.dart';
import 'package:ridge/core/theme/spring_page_transitions.dart';
import 'package:ridge/features/settings/domain/entities/app_corner_style.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';

/// The app's whole design system in one place: Material 3 Expressive color
/// and typography, but rendered completely flat — no shadows, no
/// gradients, no elevation tint. Hierarchy comes from the tonal surface
/// container roles instead, which is what keeps a flat UI from looking dead.
abstract final class AppTheme {
  /// The light [ThemeData] for [palette]/[cornerStyle], expressive-colored
  /// unless [expressiveColor] is turned off.
  static ThemeData light({
    bool expressiveColor = true,
    AppPaletteId palette = AppPaletteId.ember,
    AppCornerStyle cornerStyle = AppCornerStyle.soft,
  }) => _build(
    brightness: Brightness.light,
    expressiveColor: expressiveColor,
    palette: palette,
    cornerStyle: cornerStyle,
  );

  /// The dark [ThemeData] for [palette]/[cornerStyle], expressive-colored
  /// unless [expressiveColor] is turned off.
  static ThemeData dark({
    bool expressiveColor = true,
    AppPaletteId palette = AppPaletteId.ember,
    AppCornerStyle cornerStyle = AppCornerStyle.soft,
  }) => _build(
    brightness: Brightness.dark,
    expressiveColor: expressiveColor,
    palette: palette,
    cornerStyle: cornerStyle,
  );

  static ThemeData _build({
    required Brightness brightness,
    required bool expressiveColor,
    required AppPaletteId palette,
    required AppCornerStyle cornerStyle,
  }) {
    final colorScheme = buildColorScheme(
      brightness: brightness,
      expressive: expressiveColor,
      palette: palette,
    );
    final shapes = AppShapeTheme.forStyle(cornerStyle);
    final base = ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      useMaterial3: true,
      fontFamily: AppFonts.mono,
    );
    final textTheme = buildAppTextTheme(base.textTheme);

    return base.copyWith(
      extensions: [shapes],
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
        shape: shapes.largeShape,
      ),

      chipTheme: ChipThemeData(
        elevation: 0,
        pressElevation: 0,
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide.none,
        shape: shapes.smallShape,
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
          animationDuration: AppMotion.spatialFast,

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
        ).copyWith(shape: _pressMorph(shapes)),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          animationDuration: AppMotion.spatialFast,

          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
        ).copyWith(shape: _pressMorph(shapes)),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0,
          animationDuration: AppMotion.spatialFast,

          textStyle: textTheme.labelLarge,
        ).copyWith(shape: _pressMorph(shapes)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,

          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ).copyWith(shape: _pressMorph(shapes)),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(highlightColor: Colors.transparent)
            .copyWith(shape: _pressMorph(shapes)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: shapes.largeIncreasedShape,
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
        indicatorShape: shapes.mediumShape,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.onSecondaryContainer
                : colorScheme.onSurfaceVariant,
          ),
        ),
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
        backgroundColor: colorScheme.surface,
        useIndicator: true,
        indicatorShape: shapes.mediumShape,
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
        shape: shapes.extraLargeShape,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(shapes.extraLarge),
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
        shape: shapes.mediumShape,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          elevation: 0,
          animationDuration: AppMotion.spatialFast,

          side: BorderSide.none,
        ).copyWith(shape: _pressMorph(shapes)),
      ),

      switchTheme: SwitchThemeData(
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        // Expressive switch: a check on the thumb when on, so the toggle
        // reads as a state change and not just a color swap.
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check)
              : null,
        ),
      ),

      listTileTheme: ListTileThemeData(shape: shapes.mediumShape),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // No border on any state — focus/error read through the fill color
        // tinting instead, keeping with the tonal-surface hierarchy used
        // everywhere else in this theme.
        fillColor: WidgetStateColor.resolveWith((states) {
          final resting = colorScheme.surfaceContainerHighest;
          if (states.contains(WidgetState.disabled)) return resting;
          if (states.contains(WidgetState.error)) {
            return Color.alphaBlend(
              colorScheme.error.withValues(alpha: 0.1),
              resting,
            );
          }
          if (states.contains(WidgetState.focused)) {
            return Color.alphaBlend(
              colorScheme.primary.withValues(alpha: 0.1),
              resting,
            );
          }
          return resting;
        }),
        border: _noInputBorder(shapes),
        enabledBorder: _noInputBorder(shapes),
        focusedBorder: _noInputBorder(shapes),
        errorBorder: _noInputBorder(shapes),
        focusedErrorBorder: _noInputBorder(shapes),
        disabledBorder: _noInputBorder(shapes),
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
        shape: shapes.extraLargeShape,
      ),

      timePickerTheme: TimePickerThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: shapes.extraLargeShape,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.linux: SpringPageTransitionsBuilder(),
          TargetPlatform.windows: SpringPageTransitionsBuilder(),
          TargetPlatform.macOS: SpringPageTransitionsBuilder(),
          TargetPlatform.iOS: SpringPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Expressive press morph: buttons rest in their pill shape and squish
  /// toward a tighter squircle while pressed. The button's
  /// `animationDuration` interpolates the shape, so it springs back.
  static WidgetStateProperty<OutlinedBorder> _pressMorph(
    AppShapeTheme shapes,
  ) => WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.pressed)
        ? shapes.largeShape
        : shapes.fullShape,
  );

  static OutlineInputBorder _noInputBorder(AppShapeTheme shapes) =>
      OutlineInputBorder(
        borderRadius: AppShapes.squircleRadius(shapes.medium),
        borderSide: BorderSide.none,
      );
}
