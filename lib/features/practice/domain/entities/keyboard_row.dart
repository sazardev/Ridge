/// Which horizontal row of the keyboard a key sits on (SPEC.md §4.1) —
/// used to detect whether a user struggles when reaching away from the
/// home row.
enum KeyboardRow {
  /// The number row (`` ` `` through `=`).
  numberRow,

  /// The row above home row (`q` through `\`).
  topRow,

  /// The home row (`a` through `'`), where resting fingers start.
  homeRow,

  /// The row below home row (`z` through `/`).
  bottomRow,

  /// The space bar's own row.
  spaceRow,
}
