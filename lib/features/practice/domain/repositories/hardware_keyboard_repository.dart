/// Driven port for detecting whether a physical/Bluetooth keyboard is
/// currently attached. `KeystrokeCaptureField` (STACK.md §2.8) only ever
/// reacts to real hardware key events, never the on-screen IME, so without
/// one connected typing capture cannot function at all — SPEC.md §13.2's
/// touch-only mode is a distinct, not-yet-implemented category, not a
/// fallback this app can silently drop into today. Every platform but
/// Android ships with a real keyboard as a baseline assumption (STACK.md
/// §1: mouse/keyboard desktops), so this only meaningfully varies there.
abstract interface class HardwareKeyboardRepository {
  /// Emits the current connected/disconnected state immediately, then
  /// again whenever it changes — a Bluetooth keyboard pairing or dropping
  /// mid-session. Platforms with no way (or need) to detect this emit a
  /// single `true` and never change. Never throws; a detection failure
  /// resolves to `true` so it can never wrongly hide a working capture
  /// field behind this notice.
  Stream<bool> watchConnected();
}
