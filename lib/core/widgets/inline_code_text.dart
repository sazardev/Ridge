import 'package:flutter/material.dart';

import 'package:ridge/core/theme/app_shapes.dart';

/// Renders [text] as rich text, styling every `` `backtick` ``-delimited
/// fragment as inline code instead of showing the literal backticks.
///
/// The bundled snippet catalog's tl;dr/explanation copy consistently
/// wraps identifiers and operators this way (e.g. `` `:=` ``, `` `iota`
/// ``) — GitHub-flavored-markdown's inline-code convention, the only
/// markdown construct that copy ever uses. Since the whole app's type
/// scale is already monospace (`buildAppTextTheme`), a font-family
/// switch alone wouldn't read as emphasis, so each fragment also gets a
/// tinted background pill.
class InlineCodeText extends StatelessWidget {
  /// Creates a rich text with inline code spans parsed out of [text],
  /// laid out with [style] as the surrounding prose's style.
  ///
  /// [accentColor] defaults to [ColorScheme.primary] — the right choice
  /// against a plain surface, but pass the container's own "on" color
  /// (e.g. [ColorScheme.onPrimaryContainer]) when this sits on top of an
  /// already-tinted background, since `primary` isn't a guaranteed-
  /// contrast pair against every container color across this app's 20+
  /// selectable palettes.
  const new(this.text, {required this.style, this.accentColor, super.key});

  /// The raw copy, still containing its literal backtick delimiters.
  final String text;

  /// Style applied to the non-code prose; code fragments derive from it.
  final TextStyle? style;

  /// Foreground/background tint for code fragments; see class doc.
  final Color? accentColor;

  static final _pattern = RegExp('`([^`]+)`');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final accent = accentColor ?? theme.colorScheme.primary;
    final codeStyle = baseStyle.copyWith(
      color: accent,
      fontWeight: FontWeight.w700,
    );

    final spans = <InlineSpan>[];
    var last = 0;
    for (final match in _pattern.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: AppShapes.squircleRadius(AppRadius.extraSmall),
            ),
            child: Text(match.group(1)!, style: codeStyle),
          ),
        ),
      );
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    return Text.rich(TextSpan(style: baseStyle, children: spans));
  }
}
