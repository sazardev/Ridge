/// A programming language a Snippet is written in.
///
/// SPEC.md §18 scopes v1 to Go only; this enum is intentionally shaped so
/// adding a future language later is just a new case, never a redesign.
enum ProgrammingLanguage {
  /// The Go programming language — the only language supported in v1.
  go,
}
