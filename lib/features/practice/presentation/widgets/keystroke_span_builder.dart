import 'package:flutter/material.dart';

import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/presentation/syntax_colors.dart';

/// A char not yet reached is rendered in its real syntax color, just
/// dimmed — real syntax highlighting *and* an unambiguous "haven't typed
/// this yet" signal at once, without a second, competing color scheme
/// fighting the theme's own (SPEC.md §4.1's live feedback, reworked to
/// sit underneath syntax highlighting rather than replace it). A char
/// already committed (always correct — see `KeystrokeCaptureField`'s
/// hard-lock doc) renders at full strength.
const _untypedOpacity = 0.38;

/// Builds the per-character [TextSpan]s `KeystrokeCaptureField` renders:
/// syntax-colored, dimmed ahead of [liveCursorIndex], and highlighted at
/// the live/review cursor.
List<TextSpan> buildKeystrokeSpans({
  required ColorScheme colors,
  required SyntaxColors syntaxColors,
  required List<SyntaxTokenType> tokenTypes,
  required TextStyle base,
  required String code,
  required List<bool?> statuses,
  required int liveCursorIndex,
  required int? reviewCursorIndex,
}) {
  return [
    for (var i = 0; i < code.length; i++)
      TextSpan(
        text: code[i],
        style: base.copyWith(
          color: syntaxColors
              .forType(tokenTypes[i])
              .withValues(alpha: statuses[i] == true ? 1 : _untypedOpacity),
          backgroundColor: i == reviewCursorIndex
              ? colors.secondaryContainer
              : (i == liveCursorIndex ? colors.primaryContainer : null),
        ),
      ),
  ];
}
