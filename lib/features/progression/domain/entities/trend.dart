/// Direction a weakness-ranking score has moved between two adjacent
/// 14-day windows (SPEC.md §4.2's "tendencia (mejorando/empeorando/
/// estable)").
///
/// A weakness *score* is framed as "how bad is this" (higher = worse), so
/// [improving] means the score went down, not up.
enum Trend {
  /// The score dropped by more than the stable band — genuinely better.
  improving,

  /// The score rose by more than the stable band — genuinely worse.
  worsening,

  /// Within the stable band, or not enough data in one of the two
  /// windows to compare at all.
  stable,
}
