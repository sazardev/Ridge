/// Which slice of the weakness report a warm-up drill targets
/// (SPEC.md §3.3/§4.3) — the "recommended lesson" activation, extended
/// beyond individual characters to the finger and hand profiles.
enum WarmUpTarget {
  /// The catalog snippet densest in the profile's weakest characters.
  characters,

  /// The snippet densest in characters typed by the profile's weakest
  /// finger (SPEC.md §4.2's per-finger profile as a drill).
  finger,

  /// The snippet densest in characters typed by the hand of the weakest
  /// finger — the "one hand needs work" drill.
  hand,
}
