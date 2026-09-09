/// Which keystroke sound effects (`KeystrokeSoundPlayer`) the app plays —
/// each value names an `assets/sounds/<name>/` folder holding that pack's
/// `key_click.wav`/`key_reject.wav`. Framework-free like `AppThemeMode`.
enum AppSoundPack {
  /// The original recorded click/thud pair.
  mechanical,

  /// A gentle, muted tone pair.
  soft,

  /// A clacky noise-burst pair mimicking a mechanical typewriter.
  typewriter,

  /// Retro 8-bit chiptune blips.
  arcade,

  /// A bubbly pitch-swept pop pair.
  pop,
}
