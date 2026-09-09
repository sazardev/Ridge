/// "Maratonista" achievement tiers (SPEC.md §12): how many lifetime
/// correct-first-try characters a profile has typed, with no recency
/// window — a true career total, unlike `progression`'s windowed
/// weakness queries.
enum MaratonistaTier {
  /// 50,000 lifetime correct-first-try characters.
  bronze(50000),

  /// 250,000 lifetime correct-first-try characters.
  silver(250000),

  /// 1,000,000 lifetime correct-first-try characters.
  gold(1000000);

  new(this.lifetimeCorrectCharsThreshold);

  /// The lifetime correct-first-try character count this tier requires.
  final int lifetimeCorrectCharsThreshold;
}
