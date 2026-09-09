/// A profile's chosen keyboard layout — purely self-expression, never
/// consulted for keystroke classification (`practice`'s
/// `PhysicalKeyId`/finger mapping is always physical-position-based,
/// layout-independent). Framework-free.
enum KeyboardLayout {
  /// QWERTY.
  qwerty,

  /// AZERTY.
  azerty,

  /// QWERTZ.
  qwertz,

  /// Dvorak.
  dvorak,

  /// Colemak.
  colemak,

  /// Workman.
  workman,

  /// Anything not covered above.
  other,
}
