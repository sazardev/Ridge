/// How hard a Snippet is to type correctly (SPEC.md §3.1).
enum Difficulty {
  /// Suitable for someone new to the language/construct.
  beginner,

  /// Requires some familiarity with the language's core constructs.
  intermediate,

  /// Requires comfort with less common or more intricate constructs.
  advanced,

  /// The most demanding tier — dense, idiomatic, or rarely-typed code.
  expert,
}
