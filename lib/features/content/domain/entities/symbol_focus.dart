/// A specific symbol or key combination a Snippet is designed to force
/// practice of (SPEC.md §3.1's "foco de símbolos").
///
/// A snippet may target more than one of these at once (e.g. a struct
/// with both nested braces and backtick tags), so `Snippet.symbolFocus`
/// models this as a `Set<SymbolFocus>` rather than a single nullable
/// field.
enum SymbolFocus {
  /// Deeply nested `{`/`}` blocks.
  nestedBraces,

  /// The short variable declaration operator `:=`.
  shortVarDecl,

  /// Backtick-delimited struct field tags, e.g. `` `json:"name"` ``.
  backtickStructTags,

  /// The logical operators `&&`/`||`, or Zig's `and`/`or`.
  logicalOperators,

  /// The pointer operators `*`/`&`.
  pointerOperators,

  /// Generic type parameter syntax, e.g. `[T any]`.
  generics,
}
