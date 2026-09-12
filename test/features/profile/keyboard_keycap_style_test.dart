// Guards the one property the pseudo-3D keycap look can't ship without:
// key tops must stay clearly lighter than the board for every bundled
// palette and brightness — the very failure mode `surfaceBright`/
// `surfaceDim` alone produced (gruvbox light inverted, several dark
// palettes collapsed to ~1.06 contrast).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/theme/app_palette_catalog.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_keycap_style.dart';

/// WCAG contrast ratio between two opaque colors.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  test('every palette and brightness keeps keys lighter than the board', () {
    for (final def in AppPaletteCatalog.all) {
      for (final brightness in Brightness.values) {
        final scheme = def.buildScheme(
          brightness: brightness,
          expressive: true,
        );
        final style = KeyboardKeycapStyle.fromScheme(
          scheme,
          keyCornerRadius: 4,
          caseCornerRadius: 12,
        );

        expect(
          _contrast(style.keyTop, style.caseTop),
          greaterThanOrEqualTo(2.5),
          reason: '${def.id.name}/${brightness.name} key/board contrast',
        );
        expect(
          _contrast(style.keySide, style.caseTop),
          greaterThan(1.1),
          reason: '${def.id.name}/${brightness.name} key side visibility',
        );
        expect(
          style.keySide.computeLuminance(),
          lessThan(style.keyTop.computeLuminance()),
          reason: '${def.id.name}/${brightness.name} side darker than top',
        );
      }
    }
  });

  test('accent keys read as a distinct, darker tone than alpha keys', () {
    for (final def in AppPaletteCatalog.all) {
      final scheme = def.buildScheme(
        brightness: Brightness.light,
        expressive: true,
      );
      final style = KeyboardKeycapStyle.fromScheme(
        scheme,
        keyCornerRadius: 4,
        caseCornerRadius: 12,
      );

      expect(style.keyTopAccent, isNot(style.keyTop));
      expect(
        style.keyTopAccent.computeLuminance(),
        lessThan(style.keyTop.computeLuminance()),
      );
    }
  });

  test('shiftLightness clamps instead of overflowing', () {
    expect(KeyboardKeycapStyle.shiftLightness(Colors.black, -1), Colors.black);
    expect(KeyboardKeycapStyle.shiftLightness(Colors.white, 1), Colors.white);
  });
}
