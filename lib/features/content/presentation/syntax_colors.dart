import 'package:flutter/material.dart';

import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';

/// Syntax-highlighting colors for one rendered code block, derived from
/// the *currently active* [ColorScheme] rather than a fixed palette-by-
/// name table — this is what makes highlighting automatically match
/// whichever theme/palette the user has picked (including any future
/// one) without a second, parallel color table to keep in sync.
class SyntaxColors {
  /// Creates an explicit set of role colors.
  const new({
    required this.keyword,
    required this.string,
    required this.comment,
    required this.number,
    required this.operatorColor,
    required this.plain,
  });

  /// Derives role colors from [colors]. Comments stay muted
  /// ([ColorScheme.onSurfaceVariant], the same "de-emphasized" role used
  /// elsewhere in this app) and plain text/operators stay at full
  /// [ColorScheme.onSurface] contrast — both conventionally neutral roles.
  ///
  /// Keyword/string/number are deliberately **not** [ColorScheme.primary]/
  /// [ColorScheme.secondary]/[ColorScheme.tertiary] directly: Material 3
  /// specs `secondary` as the *same hue as `primary`, just lower chroma*,
  /// so under most seeded schemes (including this app's own default) two
  /// of syntax highlighting's three "accent" categories would render as
  /// near-identical colors. Instead, every accent is a fixed hue rotation
  /// off `primary`'s actual hue, at a saturation/lightness tuned for
  /// legibility — still theme-derived (a warm-seeded palette gets warm
  /// accents, a cool-seeded one gets cool accents), but with guaranteed
  /// separation between categories regardless of how any given palette's
  /// own secondary/tertiary happen to be tuned.
  // ignore: unnecessary_type_name_in_constructor
  factory SyntaxColors.fromScheme(ColorScheme colors) {
    final baseHue = HSLColor.fromColor(colors.primary).hue;
    final lightness = colors.brightness == Brightness.dark ? 0.78 : 0.38;
    Color accent(double hueOffset) => HSLColor.fromAHSL(
      1,
      (baseHue + hueOffset) % 360,
      0.55,
      lightness,
    ).toColor();

    return SyntaxColors(
      keyword: accent(0),
      string: accent(130),
      number: accent(250),
      comment: colors.onSurfaceVariant,
      operatorColor: colors.onSurface,
      plain: colors.onSurface,
    );
  }

  /// Color for keywords/predeclared constants (`func`, `if`, `nil`, ...).
  final Color keyword;

  /// Color for string/rune literals.
  final Color string;

  /// Color for `//`/`/* */` comments.
  final Color comment;

  /// Color for numeric literals.
  final Color number;

  /// Color for operators/punctuation.
  final Color operatorColor;

  /// Color for identifiers and anything else uncategorized.
  final Color plain;

  /// The color for [type].
  Color forType(SyntaxTokenType type) => switch (type) {
    SyntaxTokenType.keyword => keyword,
    SyntaxTokenType.string => string,
    SyntaxTokenType.comment => comment,
    SyntaxTokenType.number => number,
    SyntaxTokenType.operatorOrPunctuation => operatorColor,
    SyntaxTokenType.identifier || SyntaxTokenType.plain => plain,
  };
}
