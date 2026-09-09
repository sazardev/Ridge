/// How long a Snippet is (SPEC.md §3.1).
enum SnippetLength {
  /// A single line or a function signature.
  short,

  /// A full block or function.
  medium,

  /// A small file or several related functions.
  long,
}
