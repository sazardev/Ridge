/// Converts a Precision/learning-route-lesson session's raw accuracy
/// into a 1-10 score (SPEC.md §5.3) — a flat "98% or nothing" bar read
/// as punishing for anything short of a flawless run, especially since
/// the capture engine is already hard-locked (every committed character
/// is correct by construction; accuracy only ever drops from a *rejected
/// attempt* along the way, see `KeystrokeStreamRecorder`'s doc). Scoring
/// gives a strong-but-imperfect run a clear pass, while retrying for a
/// higher score is always available — every attempt is its own fresh,
/// immutable session (SPEC.md §8.1).
class PrecisionScoreCalculator {
  /// Creates the (stateless) calculator.
  const new();

  /// A score over this many points out of 10 passes.
  static const passingScore = 7;

  /// The score (1-10, inclusive) [accuracyPct] earns: one point per full
  /// 10-percentage-point band, floored at 1 so the scale never reads as
  /// literally zero — a 10 is reserved for a flawless 100% run (the next
  /// band down, 90-99.99%, already scores 9).
  int scoreFor(double accuracyPct) => (accuracyPct / 10).floor().clamp(1, 10);

  /// Whether [accuracyPct] passes — a score over [passingScore] (80%
  /// accuracy or better), not the old flat 98%.
  bool passes(double accuracyPct) => scoreFor(accuracyPct) > passingScore;
}
