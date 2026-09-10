import 'package:flutter/material.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';

part 'app_palette_schemes_a.dart';
part 'app_palette_schemes_b.dart';

/// How a palette is presented in the settings picker — a plain single-hue
/// seed the user can pick freely, or a curated, named community theme with
/// its own authentic background/foreground tones.
enum AppPaletteGroup {
  /// A single seed color driving Material 3's standard tonal derivation.
  solid,

  /// A hand-tuned, recognizable community theme (Nord, Gruvbox, ...).
  themed,
}

/// Everything the settings UI and the app theme builder need to know about
/// a palette: which group it belongs to, the color swatch shown in the
/// picker, and how to build its actual [ColorScheme] for a given brightness.
class AppPaletteDefinition {
  /// Creates a palette catalog entry.
  const new({
    required this.id,
    required this.group,
    required this.swatch,
    required this.buildScheme,
  });

  /// The domain id this definition describes.
  final AppPaletteId id;

  /// Whether this is a freeform solid seed or a curated named theme.
  final AppPaletteGroup group;

  /// The representative color shown for this palette in the picker.
  final Color swatch;

  /// Builds the actual [ColorScheme] for this palette.
  final ColorScheme Function({
    required Brightness brightness,
    required bool expressive,
  })
  buildScheme;
}

/// A single-hue seed, deriving the rest of the scheme through Material 3's
/// standard tonal palette — used for the "solid" picker group.
ColorScheme _seeded(
  Color seed, {
  required Brightness brightness,
  required bool expressive,
}) {
  return ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
    dynamicSchemeVariant: expressive
        ? DynamicSchemeVariant.expressive
        : DynamicSchemeVariant.tonalSpot,
  );
}

/// A near-grayscale seed forced through M3's `neutral` variant, which keeps
/// hue drift out of the tonal ramp — the only way to get a genuinely
/// monochrome scheme regardless of the expressive-color toggle.
ColorScheme _mono({required Brightness brightness, required bool expressive}) {
  return ColorScheme.fromSeed(
    seedColor: const Color(0xFF6B7280),
    brightness: brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  );
}

/// Builds a seed-derived scheme, then retextures its neutral surface roles
/// with a named theme's real background/foreground tones so it actually
/// reads as that theme instead of a generic M3-gray canvas.
ColorScheme _themed({
  required Brightness brightness,
  required bool expressive,
  required Color seed,
  required Color surfaceDim,
  required Color surfaceBase,
  required Color surfaceBright,
  required Color onSurface,
  required Color outline,
}) {
  final base = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: brightness,
    dynamicSchemeVariant: expressive
        ? DynamicSchemeVariant.expressive
        : DynamicSchemeVariant.tonalSpot,
  );
  return base.copyWith(
    surface: surfaceBase,
    onSurface: onSurface,
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: Color.lerp(surfaceDim, surfaceBase, 0.25),
    surfaceContainerLow: Color.lerp(surfaceDim, surfaceBase, 0.6),
    surfaceContainer: surfaceBase,
    surfaceContainerHigh: Color.lerp(surfaceBase, surfaceBright, 0.5),
    surfaceContainerHighest: Color.lerp(surfaceBase, surfaceBright, 0.85),
    inverseSurface: onSurface,
    onInverseSurface: surfaceBase,
    outline: outline,
    outlineVariant: Color.lerp(outline, surfaceBase, 0.5),
  );
}

/// The full set of selectable palettes, in display order.
abstract final class AppPaletteCatalog {
  /// All palettes, solid seeds first, then curated named themes.
  static final all = <AppPaletteDefinition>[
    AppPaletteDefinition(
      id: AppPaletteId.ember,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFFFF5A36),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFFFF5A36),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.ocean,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFF2F6FED),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFF2F6FED),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.forest,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFF2E7D4F),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFF2E7D4F),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.grape,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFF7C5CFC),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFF7C5CFC),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.rose,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFFE83E8C),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFFE83E8C),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.sunflower,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFFE8A400),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFFE8A400),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.teal,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFF0E9594),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFF0E9594),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    AppPaletteDefinition(
      id: AppPaletteId.crimson,
      group: AppPaletteGroup.solid,
      swatch: const Color(0xFFE23B3B),
      buildScheme: ({required brightness, required expressive}) => _seeded(
        const Color(0xFFE23B3B),
        brightness: brightness,
        expressive: expressive,
      ),
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.mono,
      group: AppPaletteGroup.solid,
      swatch: Color(0xFF6B7280),
      buildScheme: _mono,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.nord,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF88C0D0),
      buildScheme: _nord,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.gruvbox,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFFE8019),
      buildScheme: _gruvbox,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.dracula,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFBD93F9),
      buildScheme: _dracula,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.solarized,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF268BD2),
      buildScheme: _solarized,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.catppuccin,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFCBA6F7),
      buildScheme: _catppuccin,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.tokyoNight,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF7AA2F7),
      buildScheme: _tokyoNight,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.terminal,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF33FF33),
      buildScheme: _terminal,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.matrix,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF00FF41),
      buildScheme: _matrix,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.fallout,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFFFB000),
      buildScheme: _fallout,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.blackWhite,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF000000),
      buildScheme: _blackWhite,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.monokai,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFF92672),
      buildScheme: _monokai,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.oneDark,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF61AFEF),
      buildScheme: _oneDark,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.cyberpunk,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFFCEE0A),
      buildScheme: _cyberpunk,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.synthwave,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFFFF2E97),
      buildScheme: _synthwave,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.github,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF58A6FF),
      buildScheme: _github,
    ),
    const AppPaletteDefinition(
      id: AppPaletteId.vscode,
      group: AppPaletteGroup.themed,
      swatch: Color(0xFF007ACC),
      buildScheme: _vscode,
    ),
  ];

  static final Map<AppPaletteId, AppPaletteDefinition> _byId = {
    for (final p in all) p.id: p,
  };

  /// The catalog entry for [id].
  static AppPaletteDefinition of(AppPaletteId id) => _byId[id]!;
}
