part of 'app_palette_catalog.dart';

/// Forces a literally colorless scheme — every accent role collapses to
/// black/white/gray so this genuinely reads as "no color," unlike [_mono]
/// which still carries a faint neutral-gray hue from M3's tonal derivation.
ColorScheme _blackWhite({
  required Brightness brightness,
  required bool expressive,
}) {
  final isDark = brightness == Brightness.dark;
  final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  final bg = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  final mid = isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE0E0E0);
  final dim = isDark ? const Color(0xFF141414) : const Color(0xFFF2F2F2);
  final base = ColorScheme.fromSeed(
    seedColor: const Color(0xFF808080),
    brightness: brightness,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  );
  return base.copyWith(
    primary: fg,
    onPrimary: bg,
    primaryContainer: mid,
    onPrimaryContainer: fg,
    secondary: fg,
    onSecondary: bg,
    secondaryContainer: mid,
    onSecondaryContainer: fg,
    tertiary: fg,
    onTertiary: bg,
    tertiaryContainer: mid,
    onTertiaryContainer: fg,
    surface: bg,
    onSurface: fg,
    surfaceDim: dim,
    surfaceBright: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF),
    surfaceContainerLowest: bg,
    surfaceContainerLow: dim,
    surfaceContainer: isDark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF7F7F7),
    surfaceContainerHigh: isDark
        ? const Color(0xFF262626)
        : const Color(0xFFEDEDED),
    surfaceContainerHighest: mid,
    outline: const Color(0xFF737373),
    outlineVariant: isDark ? const Color(0xFF404040) : const Color(0xFFBFBFBF),
    inverseSurface: fg,
    onInverseSurface: bg,
    inversePrimary: bg,
  );
}

ColorScheme _monokai({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFF92672),
          surfaceDim: const Color(0xFF1E1F1C),
          surfaceBase: const Color(0xFF272822),
          surfaceBright: const Color(0xFF49483E),
          onSurface: const Color(0xFFF8F8F2),
          outline: const Color(0xFF75715E),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFC4145C),
          surfaceDim: const Color(0xFFE8E6DF),
          surfaceBase: const Color(0xFFFAFAF8),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF272822),
          outline: const Color(0xFFA59F85),
        );
}

ColorScheme _oneDark({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF61AFEF),
          surfaceDim: const Color(0xFF21252B),
          surfaceBase: const Color(0xFF282C34),
          surfaceBright: const Color(0xFF3E4451),
          onSurface: const Color(0xFFABB2BF),
          outline: const Color(0xFF5C6370),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF4078F2),
          surfaceDim: const Color(0xFFF0F0F1),
          surfaceBase: const Color(0xFFFAFAFA),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF383A42),
          outline: const Color(0xFFA0A1A7),
        );
}

ColorScheme _cyberpunk({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFFCEE0A),
          surfaceDim: const Color(0xFF07070C),
          surfaceBase: const Color(0xFF0D0D14),
          surfaceBright: const Color(0xFF23232F),
          onSurface: const Color(0xFFE7E7EA),
          outline: const Color(0xFF3D3D52),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFA88600),
          surfaceDim: const Color(0xFFDCE0F5),
          surfaceBase: const Color(0xFFF0F3FF),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF0D0D14),
          outline: const Color(0xFF9AA0C4),
        );
}

ColorScheme _synthwave({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFFF2E97),
          surfaceDim: const Color(0xFF170F20),
          surfaceBase: const Color(0xFF241B2F),
          surfaceBright: const Color(0xFF3B2A52),
          onSurface: const Color(0xFFF4EEFF),
          outline: const Color(0xFF6B4984),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFC41E82),
          surfaceDim: const Color(0xFFF0DFFF),
          surfaceBase: const Color(0xFFFBEFFF),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF2B1B3D),
          outline: const Color(0xFFC9A6DE),
        );
}

ColorScheme _github({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF58A6FF),
          surfaceDim: const Color(0xFF010409),
          surfaceBase: const Color(0xFF0D1117),
          surfaceBright: const Color(0xFF21262D),
          onSurface: const Color(0xFFC9D1D9),
          outline: const Color(0xFF30363D),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF0969DA),
          surfaceDim: const Color(0xFFF6F8FA),
          surfaceBase: const Color(0xFFFFFFFF),
          surfaceBright: const Color(0xFFEAEEF2),
          onSurface: const Color(0xFF1F2328),
          outline: const Color(0xFFD0D7DE),
        );
}

ColorScheme _vscode({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF007ACC),
          surfaceDim: const Color(0xFF181818),
          surfaceBase: const Color(0xFF1E1E1E),
          surfaceBright: const Color(0xFF2D2D30),
          onSurface: const Color(0xFFD4D4D4),
          outline: const Color(0xFF3C3C3C),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF007ACC),
          surfaceDim: const Color(0xFFF3F3F3),
          surfaceBase: const Color(0xFFFFFFFF),
          surfaceBright: const Color(0xFFE8E8E8),
          onSurface: const Color(0xFF1E1E1E),
          outline: const Color(0xFFD4D4D4),
        );
}
