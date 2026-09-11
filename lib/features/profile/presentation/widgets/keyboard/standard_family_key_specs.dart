import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_family.dart';

/// The generic fallback geometry for every [KeyboardShapeFamily] — an
/// unlabeled grid of keycaps approximating that physical layout's size
/// and cluster arrangement (numpad, nav cluster, function row), for
/// models with no curated real layout in the data bank (see
/// `keyboard_visual_layout_local_data_source.dart`). Not ANSI/ISO- or
/// character-layout-accurate by design: see `keyboard_shape_family.dart`'s
/// doc comment for why. Fed into the same `KeyboardLayoutPainter` a
/// curated layout would be.
List<KeyboardKeySpec> standardFamilyKeySpecsFor(KeyboardShapeFamily family) {
  switch (family) {
    case KeyboardShapeFamily.sixty:
      return _specsFromRows([
        _numberRow,
        _topRow,
        _homeRow,
        _bottomRow,
        _spaceRow,
      ]);

    case KeyboardShapeFamily.sixtyFive:
      const gap = 0.5;
      return _specsFromRows([
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ]);

    case KeyboardShapeFamily.seventyFive:
      const gap = 0.3;
      return _specsFromRows([
        _functionRow,
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ]);

    case KeyboardShapeFamily.tkl:
      const gap = 0.8;
      return _specsFromRows([
        _functionRow,
        [..._numberRow, ..._navSide(gap)],
        [..._topRow, ..._navSide(gap)],
        _homeRow,
        [..._bottomRow, ..._navCenteredKey(gap)],
        [..._spaceRow, ..._navSide(gap)],
      ]);

    case KeyboardShapeFamily.fullSize:
      const navGap = 0.6;
      const numGap = 0.5;
      return _specsFromRows([
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
      ]);

    case KeyboardShapeFamily.splitErgo:
      return _splitErgoKeySpecs();
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

/// Converts row-relative spans into absolute [KeyboardKeySpec]s — row
/// index becomes `y`, and `x` accumulates across each row independently
/// (shorter rows, e.g. the function row, are left-aligned rather than
/// centered under the row below).
List<KeyboardKeySpec> _specsFromRows(List<List<_Span>> rows) {
  final specs = <KeyboardKeySpec>[];
  for (var r = 0; r < rows.length; r++) {
    var x = 0.0;
    for (final span in rows[r]) {
      if (span.isKey) specs.add(_spec(x: x, y: r.toDouble(), w: span.width));
      x += span.width;
    }
  }
  return specs;
}

/// Two 5-column x 4-row staggered blocks side by side — a generic
/// split-ergonomic silhouette (e.g. ZSA Moonlander/Voyager, ErgoDox EZ,
/// Kinesis) for any split model with no curated real layout.
List<KeyboardKeySpec> _splitErgoKeySpecs() {
  const columns = 5;
  const rows = 4;
  const halfGap = 1.5;
  final specs = <KeyboardKeySpec>[];

  for (final xOrigin in [0.0, columns + halfGap]) {
    for (var c = 0; c < columns; c++) {
      // Columnar stagger: middle columns (index/middle fingers) sit
      // slightly lower, evoking a split/ortholinear board's column
      // offsets instead of a flat row grid.
      final distanceFromCenter =
          (c - (columns - 1) / 2).abs() / ((columns - 1) / 2);
      final stagger = (1 - distanceFromCenter) * 0.5;
      for (var r = 0; r < rows; r++) {
        specs.add(_spec(x: xOrigin + c, y: r + stagger));
      }
    }
  }
  return specs;
}

KeyboardKeySpec _spec({
  required double x,
  required double y,
  double w = 1,
  double h = 1,
}) => KeyboardKeySpec(
  x: x,
  y: y,
  w: w,
  h: h,
  x2: 0,
  y2: 0,
  w2: w,
  h2: h,
  rotationAngle: 0,
  rotationX: x,
  rotationY: y,
);
