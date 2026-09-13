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
          ..._navSide(navGap, 'Ins', 'Home', 'PgUp'),
          ..._numpadRow(numGap, ['Num', '/', '*', '-']),
        ],
        [
          ..._topRow,
          ..._navSide(navGap, 'Del', 'End', 'PgDn'),
          ..._numpadRow(numGap, ['7', '8', '9', '+']),
        ],
        [
          ..._homeRow,
          ..._navBlank(navGap),
          ..._numpadRow(numGap, ['4', '5', '6', null]),
        ],
        [
          ..._bottomRow,
          ..._navCenteredKey(navGap, '↑'),
          ..._numpadRow(numGap, ['1', '2', '3', 'Enter']),
        ],
        [
          ..._spaceRow,
          ..._navSide(navGap, '←', '↓', '→'),
          ..._numpadRow(numGap, ['0', '.', null], wide: 2),
        ],
      ]);

    case KeyboardShapeFamily.splitErgo:
      return _splitErgoKeySpecs();
  }
}

/// One key-sized cell in a row: a drawn keycap when `isKey` is true,
/// otherwise a blank spacer of the same `width` — used both for the
/// small gaps between clusters and for the footprint of keys this
/// silhouette omits (e.g. the numpad's tall Plus/Enter keys). Key cells
/// carry the canonical QWERTY legends for their position (a primary
/// legend plus a shifted one where it exists), so a generic silhouette
/// still reads as a real keyboard; spacers have no legends.
typedef _Span = ({double width, bool isKey, String? label, String? label2});

_Span _key(double width, [String? label, String? label2]) =>
    (width: width, isKey: true, label: label, label2: label2);
_Span _gap(double width) =>
    (width: width, isKey: false, label: null, label2: null);

List<_Span> get _numberRow => [
  _key(1, '`', '~'),
  _key(1, '1', '!'),
  _key(1, '2', '@'),
  _key(1, '3', '#'),
  _key(1, '4', r'$'),
  _key(1, '5', '%'),
  _key(1, '6', '^'),
  _key(1, '7', '&'),
  _key(1, '8', '*'),
  _key(1, '9', '('),
  _key(1, '0', ')'),
  _key(1, '-', '_'),
  _key(1, '=', '+'),
  _key(2, 'Backspace'),
];

List<_Span> get _topRow => [
  _key(1.5, 'Tab'),
  _key(1, 'Q'),
  _key(1, 'W'),
  _key(1, 'E'),
  _key(1, 'R'),
  _key(1, 'T'),
  _key(1, 'Y'),
  _key(1, 'U'),
  _key(1, 'I'),
  _key(1, 'O'),
  _key(1, 'P'),
  _key(1, '['),
  _key(1, ']'),
  _key(1.5, r'\'),
];

List<_Span> get _homeRow => [
  _key(1.75, 'Caps'),
  _key(1, 'A'),
  _key(1, 'S'),
  _key(1, 'D'),
  _key(1, 'F'),
  _key(1, 'G'),
  _key(1, 'H'),
  _key(1, 'J'),
  _key(1, 'K'),
  _key(1, 'L'),
  _key(1, ';', ':'),
  _key(1, "'", '"'),
  _key(2.25, 'Enter'),
];

List<_Span> get _bottomRow => [
  _key(2.25, 'Shift'),
  _key(1, 'Z'),
  _key(1, 'X'),
  _key(1, 'C'),
  _key(1, 'V'),
  _key(1, 'B'),
  _key(1, 'N'),
  _key(1, 'M'),
  _key(1, ',', '<'),
  _key(1, '.', '>'),
  _key(1, '/', '?'),
  _key(2.75, 'Shift'),
];

List<_Span> get _spaceRow => [
  _key(1.25, 'Ctrl'),
  _key(1.25, 'Win'),
  _key(1.25, 'Alt'),
  _key(6.25, 'Space'),
  _key(1.25, 'Alt'),
  _key(1.25, 'Win'),
  _key(1.25, 'Menu'),
  _key(1.25, 'Ctrl'),
];

List<_Span> get _functionRow => [
  _key(1, 'Esc'),
  _gap(0.5),
  for (var i = 1; i <= 12; i++) _key(0.85, 'F$i'),
];

/// A 3-key nav-cluster column (e.g. Ins/Home/PgUp) offset by [gap].
List<_Span> _navSide(double gap, [String? a, String? b, String? c]) => [
  _gap(gap),
  _key(1, a),
  _key(1, b),
  _key(1, c),
];

/// The nav cluster's arrow row: a single centered key (e.g. Up).
List<_Span> _navCenteredKey(double gap, [String? label]) => [
  _gap(gap),
  _gap(1),
  _key(1, label),
  _gap(1),
];

/// Where a nav cluster exists on other rows but not this one (e.g. the
/// home row, between the two stacked nav-cluster rows) — a same-width
/// blank so clusters further right stay aligned.
List<_Span> _navBlank(double gap) => [_gap(gap), _gap(3)];

/// A numpad row's cells: a positive width draws a key, a negative width
/// is a blank spacer of that magnitude (used for the footprint of the
/// tall Plus/Enter keys, which only get a real key on the row they
/// visually start on). [legends] labels the drawn cells in order; a null
/// entry is a key with no printed legend. [wide] marks the first cell as
/// a double-width key (the numpad's 2u zero).
List<_Span> _numpadRow(double gap, List<String?> legends, {int wide = 1}) {
  final spans = <_Span>[_gap(gap)];
  for (var i = 0; i < legends.length; i++) {
    final legend = legends[i];
    if (legend == null) {
      spans.add(_gap(1));
    } else {
      spans.add(_key(i == 0 ? wide.toDouble() : 1, legend));
    }
  }
  return spans;
}

/// Converts row-relative spans into absolute [KeyboardKeySpec]s — row
/// index becomes `y`, and `x` accumulates across each row independently
/// (shorter rows, e.g. the function row, are left-aligned rather than
/// centered under the row below).
List<KeyboardKeySpec> _specsFromRows(List<List<_Span>> rows) {
  final specs = <KeyboardKeySpec>[];
  for (var r = 0; r < rows.length; r++) {
    var x = 0.0;
    for (final span in rows[r]) {
      if (span.isKey) {
        specs.add(
          _spec(
            x: x,
            y: r.toDouble(),
            w: span.width,
            label: span.label,
            label2: span.label2,
          ),
        );
      }
      x += span.width;
    }
  }
  return specs;
}

/// Two 5-column x 4-row staggered blocks side by side — a generic
/// split-ergonomic silhouette (e.g. ZSA Moonlander/Voyager, ErgoDox EZ,
/// Kinesis) for any split model with no curated real layout. The two
/// halves carry the canonical QWERTY columns they mirror: the left half
/// walks `` `1..4 / Tab QWER / Caps ASDF / Shift ZXCV `` and the right
/// half continues `5..9 / TYUI O / GHJKL / BNM,.`.
List<KeyboardKeySpec> _splitErgoKeySpecs() {
  const columns = 5;
  const rows = 4;
  const halfGap = 1.5;
  const leftLegends = [
    ['`', 'Tab', 'Caps', 'Shift'],
    ['1', 'Q', 'A', 'Z'],
    ['2', 'W', 'S', 'X'],
    ['3', 'E', 'D', 'C'],
    ['4', 'R', 'F', 'V'],
  ];
  const rightLegends = [
    ['5', 'T', 'G', 'B'],
    ['6', 'Y', 'H', 'N'],
    ['7', 'U', 'J', 'M'],
    ['8', 'I', 'K', ','],
    ['9', 'O', 'L', '.'],
  ];
  final specs = <KeyboardKeySpec>[];

  for (final (half, xOrigin) in [
    (leftLegends, 0.0),
    (rightLegends, columns + halfGap),
  ]) {
    for (var c = 0; c < columns; c++) {
      // Columnar stagger: middle columns (index/middle fingers) sit
      // slightly lower, evoking a split/ortholinear board's column
      // offsets instead of a flat row grid.
      final distanceFromCenter =
          (c - (columns - 1) / 2).abs() / ((columns - 1) / 2);
      final stagger = (1 - distanceFromCenter) * 0.5;
      for (var r = 0; r < rows; r++) {
        specs.add(_spec(x: xOrigin + c, y: r + stagger, label: half[c][r]));
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
  String? label,
  String? label2,
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
  label: label,
  label2: label2,
);
