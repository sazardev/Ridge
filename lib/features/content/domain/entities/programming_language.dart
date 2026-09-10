/// A programming language a Snippet is written in.
///
/// SPEC.md §18 originally scoped v1 to Go only; this enum was shaped from
/// the start so adding a language later is just a new case, never a
/// redesign — Bash (the `bash-foundations-v1` Learning Route) is the
/// first proof of that.
enum ProgrammingLanguage {
  /// The Go programming language.
  go,

  /// The Bash shell (POSIX-ish shell scripting on Linux), taught by the
  /// Arch-Linux-flavored `bash-foundations-v1` Learning Route.
  bash,

  /// SQL, taught against PostgreSQL by the library-themed
  /// `sql-foundations-v1` Learning Route — course-only, like Bash.
  sql,

  /// The Rust programming language, taught by the beginner-focused
  /// `rust-foundations-v1` Learning Route — course-only, like Bash/SQL.
  rust,
}
