// Unit tests for `SyntaxColors.fromScheme` — guards against a real bug
// found during manual verification: Material 3 specs `secondary` as the
// *same hue* as `primary` (just lower chroma), so deriving syntax colors
// directly off primary/secondary/tertiary made keywords and numbers
// render as near-identical colors under most seeded schemes, including
// this app's own default (dark, non-expressive) palette.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/presentation/syntax_colors.dart';

double _hue(Color c) => HSLColor.fromColor(c).hue;

double _hueDistance(double a, double b) {
  final diff = (a - b).abs() % 360;
  return diff > 180 ? 360 - diff : diff;
}

void main() {
  test('keyword/string/number stay visually distinct under a warm, low-chroma '
      "dark scheme (this app's own default Ember palette)", () {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5A36),
      brightness: Brightness.dark,
    );
    final colors = SyntaxColors.fromScheme(scheme);
    const minSeparation = 60.0;
    expect(
      _hueDistance(_hue(colors.keyword), _hue(colors.number)),
      greaterThanOrEqualTo(minSeparation),
    );
    expect(
      _hueDistance(_hue(colors.keyword), _hue(colors.string)),
      greaterThanOrEqualTo(minSeparation),
    );
    expect(
      _hueDistance(_hue(colors.string), _hue(colors.number)),
      greaterThanOrEqualTo(minSeparation),
    );
  });

  test(
    'keyword/string/number stay visually distinct under a cool dark scheme',
    () {
      final scheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF7AA2F7),
        brightness: Brightness.dark,
      );
      final colors = SyntaxColors.fromScheme(scheme);
      const minSeparation = 60.0;
      expect(
        _hueDistance(_hue(colors.keyword), _hue(colors.number)),
        greaterThanOrEqualTo(minSeparation),
      );
      expect(
        _hueDistance(_hue(colors.keyword), _hue(colors.string)),
        greaterThanOrEqualTo(minSeparation),
      );
      expect(
        _hueDistance(_hue(colors.string), _hue(colors.number)),
        greaterThanOrEqualTo(minSeparation),
      );
    },
  );

  test("comment and plain reuse the scheme's existing muted/foreground "
      'roles unchanged', () {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF5A36),
      brightness: Brightness.dark,
    );
    final colors = SyntaxColors.fromScheme(scheme);
    expect(colors.comment, scheme.onSurfaceVariant);
    expect(colors.plain, scheme.onSurface);
    expect(colors.operatorColor, scheme.onSurface);
  });
}
