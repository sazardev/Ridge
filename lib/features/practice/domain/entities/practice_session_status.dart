/// The state machine every practice session moves through, regardless of
/// `PracticeMode` (only the transition rules differ per mode).
enum PracticeSessionStatus {
  /// Nothing has been typed yet; the session hasn't started its clock.
  idle,

  /// The session is actively capturing keystrokes.
  running,

  /// Every keystroke has been captured; metrics are being computed.
  finished,

  /// `SessionMetrics` are computed and shown to the user.
  result,
}
