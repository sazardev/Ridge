import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_family.dart';

/// A decorative 2D silhouette of [family] — an unlabeled grid of keycap
/// rectangles approximating that physical layout's size and cluster
/// arrangement (numpad, nav cluster, function row) for the profile's
/// "About me" card. Not ANSI/ISO- or character-layout-accurate by design:
/// see `keyboard_shape_family.dart`'s doc comment for why.
class KeyboardShapePreview extends StatelessWidget {
  /// Creates the silhouette for [family], labeled for screen readers with
  /// the profile's free-text [modelLabel].
  const new({required this.family, required this.modelLabel, super.key});

  /// Which physical-layout silhouette to draw.
  final KeyboardShapeFamily family;

  /// The profile's free-text `keyboardModel`, used only for the
  /// [Semantics] label — this widget never displays it as text.
  final String modelLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final shapes = AppShapes.of(context);

    return Semantics(
      label: l10n.profileKeyboardShapePreviewSemanticLabel(modelLabel),
      child: SizedBox(
        height: 88,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, 88),
              painter: _KeyboardShapePainter(
                family: family,
                keyColor: colorScheme.surfaceContainerHighest,
                caseColor: colorScheme.surfaceContainer,
                borderColor: colorScheme.outlineVariant,
                keyCornerRadius: shapes.extraSmall,
                caseCornerRadius: shapes.medium,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// One key-sized cell in a row: a drawn keycap when `isKey` is true,
/// otherwise a blank spacer of the same `width` — used both for the
/// small gaps between clusters and for the footprint of keys this
/// silhouette omits (e.g. the numpad's tall Plus/Enter keys).
typedef _Span = ({double width, bool isKey});

_Span _key(double width) => (width: width, isKey: true);
_Span _gap(double width) => (width: width, isKey: false);

List<_Span> get _numberRow => [for (var i = 0; i < 13; i++) _key(1), _key(2)];

List<_Span> get _topRow => [
  _key(1.5),
  for (var i = 0; i < 12; i++) _key(1),
  _key(1.5),
];

List<_Span> get _homeRow => [
  _key(1.75),
  for (var i = 0; i < 11; i++) _key(1),
  _key(2.25),
];

List<_Span> get _bottomRow => [
  _key(2.25),
  for (var i = 0; i < 10; i++) _key(1),
  _key(2.75),
];

List<_Span> get _spaceRow => [
  _key(1.25),
  _key(1.25),
  _key(1.25),
  _key(6.25),
  _key(1.25),
  _key(1.25),
  _key(1.25),
  _key(1.25),
];

List<_Span> get _functionRow => [
  _key(1),
  _gap(0.5),
  for (var i = 0; i < 12; i++) _key(0.85),
];

/// A 3-key nav-cluster column (e.g. Ins/Home/PgUp) offset by [gap].
List<_Span> _navSide(double gap) => [_gap(gap), _key(1), _key(1), _key(1)];

/// The nav cluster's arrow row: a single centered key (e.g. Up).
List<_Span> _navCenteredKey(double gap) => [
  _gap(gap),
  _gap(1),
  _key(1),
  _gap(1),
];

/// Where a nav cluster exists on other rows but not this one (e.g. the
/// home row, between the two stacked nav-cluster rows) — a same-width
/// blank so clusters further right stay aligned.
List<_Span> _navBlank(double gap) => [_gap(gap), _gap(3)];

/// A numpad row's cells: a positive width draws a key, a negative width
/// is a blank spacer of that magnitude (used for the footprint of the
/// tall Plus/Enter keys, which only get a real key on the row they
/// visually start on).
List<_Span> _numpadRow(double gap, List<double> cells) => [
  _gap(gap),
  for (final cell in cells)
    if (cell > 0) _key(cell) else _gap(-cell),
];

List<List<_Span>> _rowsForFamily(KeyboardShapeFamily family) {
  switch (family) {
    case KeyboardShapeFamily.sixty:
      return [_numberRow, _topRow, _homeRow, _bottomRow, _spaceRow];

    case KeyboardShapeFamily.sixtyFive:
      const gap = 0.5;
      return [
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ];

    case KeyboardShapeFamily.seventyFive:
      const gap = 0.3;
      return [
        _functionRow,
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ];

    case KeyboardShapeFamily.tkl:
      const gap = 0.8;
      return [
        _functionRow,
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ];

    case KeyboardShapeFamily.fullSize:
      const navGap = 0.6;
      const numGap = 0.5;
      return [
        _functionRow,
        [
          ..._numberRow,
          ..._navSide(navGap),
          ..._numpadRow(numGap, [1, 1, 1, 1]),
        ],
        [
          ..._topRow,
          ..._navSide(navGap),
          ..._numpadRow(numGap, [1, 1, 1, 1]),
        ],
        [
          ..._homeRow,
          ..._navBlank(navGap),
          ..._numpadRow(numGap, [1, 1, 1, -1]),
        ],
        [
          ..._bottomRow,
          ..._navCenteredKey(navGap),
          ..._numpadRow(numGap, [1, 1, 1, 1]),
        ],
        [
          ..._spaceRow,
          ..._navSide(navGap),
          ..._numpadRow(numGap, [2, 1, -1]),
        ],
      ];

    case KeyboardShapeFamily.splitErgo:
      return const [];
  }
}

class _KeyboardShapePainter extends CustomPainter {
  new({
    required this.family,
    required this.keyColor,
    required this.caseColor,
    required this.borderColor,
    required this.keyCornerRadius,
    required this.caseCornerRadius,
  });

  final KeyboardShapeFamily family;
  final Color keyColor;
  final Color caseColor;
  final Color borderColor;
  final double keyCornerRadius;
  final double caseCornerRadius;

  static const _keyGapFraction = 0.12;

  /// How far the case extends past the outermost keys on every side, in
  /// logical pixels — the "bezel" that makes this read as a keyboard body
  /// rather than a loose grid of keycaps.
  static const _bezel = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (family == KeyboardShapeFamily.splitErgo) {
      _paintSplitErgo(canvas, size);
      return;
    }
    _paintRowBased(canvas, size, _rowsForFamily(family));
  }

  void _paintRowBased(Canvas canvas, Size size, List<List<_Span>> rows) {
    final maxRowWidth = rows
        .map((row) => row.fold<double>(0, (sum, span) => sum + span.width))
        .reduce(math.max);
    final unit = math.min(
      (size.width - _bezel * 2) / maxRowWidth,
      (size.height - _bezel * 2) / rows.length,
    );
    final gridWidth = unit * maxRowWidth;
    final gridHeight = unit * rows.length;
    final offsetX = (size.width - gridWidth) / 2;
    final offsetY = (size.height - gridHeight) / 2;

    _drawCase(
      canvas,
      Rect.fromLTWH(
        offsetX - _bezel,
        offsetY - _bezel,
        gridWidth + _bezel * 2,
        gridHeight + _bezel * 2,
      ),
    );

    final gap = unit * _keyGapFraction;
    final fill = Paint()..color = keyColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;

    for (var r = 0; r < rows.length; r++) {
      var x = offsetX;
      final y = offsetY + r * unit;
      for (final span in rows[r]) {
        final width = span.width * unit;
        if (span.isKey) {
          final rect = Rect.fromLTWH(
            x + gap / 2,
            y + gap / 2,
            width - gap,
            unit - gap,
          );
          final rrect = RRect.fromRectAndRadius(
            rect,
            Radius.circular(keyCornerRadius),
          );
          canvas
            ..drawRRect(rrect, fill)
            ..drawRRect(rrect, border);
        }
        x += width;
      }
    }
  }

  void _paintSplitErgo(Canvas canvas, Size size) {
    const columns = 5;
    const rows = 4;
    const halfGapFraction = 0.18;
    final drawableWidth = size.width - _bezel * 4;
    final drawableHeight = size.height - _bezel * 2;
    final halfWidth = drawableWidth * (1 - halfGapFraction) / 2;
    final unit = math.min(halfWidth / columns, drawableHeight / (rows + 1));
    final keySize = unit * 0.86;
    final fill = Paint()..color = keyColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;

    void paintHalf(double xOrigin) {
      final rects = <Rect>[];
      for (var c = 0; c < columns; c++) {
        // Columnar stagger: middle columns (index/middle fingers) sit
        // slightly lower, evoking a split/ortholinear board's column
        // offsets instead of a flat row grid.
        final distanceFromCenter =
            (c - (columns - 1) / 2).abs() / ((columns - 1) / 2);
        final stagger = (1 - distanceFromCenter) * unit * 0.5;
        for (var r = 0; r < rows; r++) {
          rects.add(
            Rect.fromLTWH(
              xOrigin + c * unit,
              _bezel + r * unit + stagger,
              keySize,
              keySize,
            ),
          );
        }
      }

      final bounds = rects
          .map((rect) => rect.inflate(_bezel))
          .reduce((a, b) => a.expandToInclude(b));
      _drawCase(canvas, bounds);
      for (final rect in rects) {
        final rrect = RRect.fromRectAndRadius(
          rect,
          Radius.circular(keyCornerRadius),
        );
        canvas
          ..drawRRect(rrect, fill)
          ..drawRRect(rrect, border);
      }
    }

    paintHalf(_bezel);
    paintHalf(size.width - _bezel - halfWidth);
  }

  void _drawCase(Canvas canvas, Rect rect) {
    final fill = Paint()..color = caseColor;
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = borderColor;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(caseCornerRadius),
    );
    canvas
      ..drawRRect(rrect, fill)
      ..drawRRect(rrect, border);
  }

  @override
  bool shouldRepaint(covariant _KeyboardShapePainter oldDelegate) =>
      family != oldDelegate.family ||
      keyColor != oldDelegate.keyColor ||
      caseColor != oldDelegate.caseColor ||
      borderColor != oldDelegate.borderColor ||
      keyCornerRadius != oldDelegate.keyCornerRadius ||
      caseCornerRadius != oldDelegate.caseCornerRadius;
}
