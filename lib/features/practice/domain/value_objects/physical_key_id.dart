/// Our own domain identifier for a *physical* keyboard key — mirroring
/// Flutter's `PhysicalKeyboardKey` debug-name space, but scoped to exactly
/// the keys a standard US-QWERTY layout needs to type real Go source code
/// (SPEC.md §4.2's symbol list, plus letters, digits, and control keys).
///
/// This models the *physical location* of a key, not the character it
/// produces — the same physical key produces different characters
/// depending on whether Shift is held (e.g. [digit1] produces `1`
/// unshifted and `!` shifted). That distinction is what lets
/// `KeyLayoutMap` assign a stable finger/row to a key regardless of which
/// character ends up on screen.
enum PhysicalKeyId {
  /// The `A` key.
  keyA,

  /// The `B` key.
  keyB,

  /// The `C` key.
  keyC,

  /// The `D` key.
  keyD,

  /// The `E` key.
  keyE,

  /// The `F` key.
  keyF,

  /// The `G` key.
  keyG,

  /// The `H` key.
  keyH,

  /// The `I` key.
  keyI,

  /// The `J` key.
  keyJ,

  /// The `K` key.
  keyK,

  /// The `L` key.
  keyL,

  /// The `M` key.
  keyM,

  /// The `N` key.
  keyN,

  /// The `O` key.
  keyO,

  /// The `P` key.
  keyP,

  /// The `Q` key.
  keyQ,

  /// The `R` key.
  keyR,

  /// The `S` key.
  keyS,

  /// The `T` key.
  keyT,

  /// The `U` key.
  keyU,

  /// The `V` key.
  keyV,

  /// The `W` key.
  keyW,

  /// The `X` key.
  keyX,

  /// The `Y` key.
  keyY,

  /// The `Z` key.
  keyZ,

  /// The `0` key on the number row (unshifted `0`, shifted `)`).
  digit0,

  /// The `1` key on the number row (unshifted `1`, shifted `!`).
  digit1,

  /// The `2` key on the number row (unshifted `2`, shifted `@`).
  digit2,

  /// The `3` key on the number row (unshifted `3`, shifted `#`).
  digit3,

  /// The `4` key on the number row (unshifted `4`, shifted `$`).
  digit4,

  /// The `5` key on the number row (unshifted `5`, shifted `%`).
  digit5,

  /// The `6` key on the number row (unshifted `6`, shifted `^`).
  digit6,

  /// The `7` key on the number row (unshifted `7`, shifted `&`).
  digit7,

  /// The `8` key on the number row (unshifted `8`, shifted `*`).
  digit8,

  /// The `9` key on the number row (unshifted `9`, shifted `(`).
  digit9,

  /// Unshifted `-`, shifted `_`.
  minus,

  /// Unshifted `=`, shifted `+`.
  equal,

  /// Unshifted `[`, shifted `{`.
  bracketLeft,

  /// Unshifted `]`, shifted `}`.
  bracketRight,

  /// Unshifted `\`, shifted `|`.
  backslash,

  /// Unshifted `;`, shifted `:`.
  semicolon,

  /// Unshifted `'`, shifted `"`.
  quote,

  /// Unshifted `` ` ``, shifted `~`.
  backquote,

  /// Unshifted `,`, shifted `<`.
  comma,

  /// Unshifted `.`, shifted `>`.
  period,

  /// Unshifted `/`, shifted `?`.
  slash,

  /// The space bar.
  space,

  /// Backspace/delete-back.
  backspace,

  /// Forward-delete — truncates from the review cursor to the live end.
  delete,

  /// Left arrow — moves the review cursor back through already-typed
  /// text, for read-only navigation.
  arrowLeft,

  /// Right arrow — moves the review cursor forward, back towards the
  /// live end.
  arrowRight,

  /// The left Shift key.
  shiftLeft,

  /// The right Shift key.
  shiftRight,

  /// The Tab key.
  tab,

  /// The Enter/Return key.
  enter,
}
