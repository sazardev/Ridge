/// The classification of a single typed character against the expected
/// snippet text (SPEC.md §4.1).
///
/// Only two outcomes are reachable: the capture engine hard-locks on a
/// mismatch (the buffer never advances past a wrong character, and no
/// character can ever be skipped or "inserted" ahead of where the cursor
/// is), so an omission/insertion/transposition taxonomy — meaningful only
/// under a free-flowing buffer that can diverge in length from the
/// expected text — cannot occur and isn't modeled. Every rejected attempt
/// is a [substitution]; how many attempts a position took before its
/// eventual [correct] keystroke is itself the richer signal (SPEC.md
/// §4.2's per-character error rate).
enum KeystrokeResult {
  /// Matches the expected character exactly.
  correct,

  /// A different character was typed in place of the expected one —
  /// rejected; the cursor does not advance.
  substitution,
}
