/// A lexical category a character of source code belongs to, for syntax
/// highlighting — deliberately coarse (no semantic "is this identifier
/// actually a type" distinction, which needs more than lexing) so it
/// stays a pure, fast, single-pass classification.
enum SyntaxTokenType {
  /// A reserved word (`func`, `if`, `return`, ...) or a predeclared
  /// constant conventionally highlighted the same way (`true`, `false`,
  /// `nil`, `iota`).
  keyword,

  /// A string/rune literal — `"..."`, `` `...` ``, or `'...'`.
  string,

  /// A `//` line comment or `/* */` block comment.
  comment,

  /// A numeric literal.
  number,

  /// A symbol — braces, brackets, operators, punctuation.
  operatorOrPunctuation,

  /// An identifier that isn't a keyword — a variable, function, type,
  /// or package name.
  identifier,

  /// Whitespace, or anything not otherwise classified.
  plain,
}
