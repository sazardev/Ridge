/// Domain-level global corner/border style — drives both the desktop
/// window frame's radius (see `core/window`) and every Material
/// component's shape (see `core/theme/app_shapes`), so one dial keeps the
/// whole UI's roundedness coherent. Framework-free like `AppThemeMode`.
enum AppCornerStyle {
  /// Perfectly square corners everywhere, including normally-pill buttons.
  sharp,

  /// The app's original, moderately rounded default look.
  soft,

  /// Noticeably more rounded than [soft].
  round,

  /// Everything fully rounded into a pill/stadium shape.
  pill,
}
