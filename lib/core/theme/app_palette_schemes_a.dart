part of 'app_palette_catalog.dart';

ColorScheme _nord({required Brightness brightness, required bool expressive}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF88C0D0),
          surfaceDim: const Color(0xFF2E3440),
          surfaceBase: const Color(0xFF333A47),
          surfaceBright: const Color(0xFF4C566A),
          onSurface: const Color(0xFFECEFF4),
          outline: const Color(0xFF616E88),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF5E81AC),
          surfaceDim: const Color(0xFFD8DEE9),
          surfaceBase: const Color(0xFFE9ECF1),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF2E3440),
          outline: const Color(0xFFB6BECD),
        );
}

ColorScheme _gruvbox({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFFE8019),
          surfaceDim: const Color(0xFF1D2021),
          surfaceBase: const Color(0xFF282828),
          surfaceBright: const Color(0xFF504945),
          onSurface: const Color(0xFFEBDBB2),
          outline: const Color(0xFF7C6F64),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFD65D0E),
          surfaceDim: const Color(0xFFF9F5D7),
          surfaceBase: const Color(0xFFFBF1C7),
          surfaceBright: const Color(0xFFD5C4A1),
          onSurface: const Color(0xFF3C3836),
          outline: const Color(0xFFA89984),
        );
}

ColorScheme _dracula({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFBD93F9),
          surfaceDim: const Color(0xFF21222C),
          surfaceBase: const Color(0xFF282A36),
          surfaceBright: const Color(0xFF44475A),
          onSurface: const Color(0xFFF8F8F2),
          outline: const Color(0xFF6272A4),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF7C4DCC),
          surfaceDim: const Color(0xFFE9E7F5),
          surfaceBase: const Color(0xFFF5F3FA),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF282A36),
          outline: const Color(0xFFBFB9DD),
        );
}

ColorScheme _solarized({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF268BD2),
          surfaceDim: const Color(0xFF002B36),
          surfaceBase: const Color(0xFF073642),
          surfaceBright: const Color(0xFF586E75),
          onSurface: const Color(0xFF93A1A1),
          outline: const Color(0xFF586E75),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF268BD2),
          surfaceDim: const Color(0xFFEEE8D5),
          surfaceBase: const Color(0xFFFDF6E3),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF586E75),
          outline: const Color(0xFF93A1A1),
        );
}

ColorScheme _catppuccin({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFCBA6F7),
          surfaceDim: const Color(0xFF11111B),
          surfaceBase: const Color(0xFF1E1E2E),
          surfaceBright: const Color(0xFF45475A),
          onSurface: const Color(0xFFCDD6F4),
          outline: const Color(0xFF585B70),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF8839EF),
          surfaceDim: const Color(0xFFDCE0E8),
          surfaceBase: const Color(0xFFEFF1F5),
          surfaceBright: const Color(0xFFBCC0CC),
          onSurface: const Color(0xFF4C4F69),
          outline: const Color(0xFFACB0BE),
        );
}

ColorScheme _tokyoNight({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF7AA2F7),
          surfaceDim: const Color(0xFF16161E),
          surfaceBase: const Color(0xFF1A1B26),
          surfaceBright: const Color(0xFF292E42),
          onSurface: const Color(0xFFC0CAF5),
          outline: const Color(0xFF565F89),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF34548A),
          surfaceDim: const Color(0xFFD5D6DB),
          surfaceBase: const Color(0xFFE1E2E7),
          surfaceBright: const Color(0xFFF1F2F7),
          onSurface: const Color(0xFF343B58),
          outline: const Color(0xFF9699A3),
        );
}

ColorScheme _terminal({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF33FF33),
          surfaceDim: const Color(0xFF050805),
          surfaceBase: const Color(0xFF0A0F0A),
          surfaceBright: const Color(0xFF1F3D1F),
          onSurface: const Color(0xFFB8FFB8),
          outline: const Color(0xFF2E662E),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF1D7A1D),
          surfaceDim: const Color(0xFFD9F2D9),
          surfaceBase: const Color(0xFFF0FFF0),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF0B3D0B),
          outline: const Color(0xFFA8D9A8),
        );
}

ColorScheme _matrix({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF00FF41),
          surfaceDim: const Color(0xFF000000),
          surfaceBase: const Color(0xFF050505),
          surfaceBright: const Color(0xFF0D2818),
          onSurface: const Color(0xFF9CFFB8),
          outline: const Color(0xFF0F5132),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFF007A2E),
          surfaceDim: const Color(0xFFC9F7D6),
          surfaceBase: const Color(0xFFEFFFF3),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF001F0D),
          outline: const Color(0xFF7ADFA0),
        );
}

ColorScheme _fallout({
  required Brightness brightness,
  required bool expressive,
}) {
  return brightness == Brightness.dark
      ? _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFFFB000),
          surfaceDim: const Color(0xFF0D0900),
          surfaceBase: const Color(0xFF1A1400),
          surfaceBright: const Color(0xFF3D2E00),
          onSurface: const Color(0xFFFFD37A),
          outline: const Color(0xFF6B5200),
        )
      : _themed(
          brightness: brightness,
          expressive: expressive,
          seed: const Color(0xFFB37700),
          surfaceDim: const Color(0xFFFFE9B3),
          surfaceBase: const Color(0xFFFFF7E0),
          surfaceBright: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF2B1D00),
          outline: const Color(0xFFD9B366),
        );
}
