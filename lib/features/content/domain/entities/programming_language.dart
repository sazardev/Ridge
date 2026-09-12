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

  /// The Python programming language, taught by `python-foundations-v1`
  /// (beginner) and `python-algorithms-v1` — course-only, like Bash/SQL/
  /// Rust.
  python,

  /// JavaScript, taught by `js-foundations-v1` (beginner) and
  /// `js-algorithms-v1` — course-only, like Bash/SQL/Rust/Python.
  javascript,

  /// TypeScript, taught by `typescript-foundations-v1` (beginner) and
  /// `typescript-algorithms-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions` categories for
  /// the typed core, plus two of its own (`classesAndObjects`, `modules`)
  /// for the class/module tour the JavaScript route doesn't cover.
  typescript,

  /// Haskell, taught by `haskell-foundations-v1` (beginner) and
  /// `haskell-algorithms-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`functions` categories (there is
  /// no `loops` block: recursion is introduced as the functional
  /// substitute for iteration).
  haskell,
}
