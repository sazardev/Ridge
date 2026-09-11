part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Python — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, strings, comments, numbers, and punctuation,
/// no AST. The one Python-specific wrinkle is a string prefix (`f`, `r`,
/// `b`, case-insensitive, e.g. `f"{x}"`) immediately followed by a quote —
/// [classify] colors the prefix letter as part of the string rather than
/// as a bare identifier, and recognizes triple-quoted strings (`'''`/`"""`)
/// as a single token distinct from a single-quoted one.
class PythonSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    'False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await',
    'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except',
    'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is',
    'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try',
    'while', 'with', 'yield',
    // Common builtins conventionally highlighted like keywords, mirroring
    // GoSyntaxTokenizer's predeclared types (without these, ordinary code
    // reads as almost entirely "plain" text).
    'print', 'len', 'range', 'enumerate', 'str', 'int', 'float', 'bool',
    'list', 'dict', 'set', 'tuple', 'min', 'max', 'sum', 'sorted',
    'isinstance', 'self',
  };

  @override
  List<SyntaxTokenType> classify(String code) {
    final types = List<SyntaxTokenType>.filled(
      code.length,
      SyntaxTokenType.plain,
    );
    var i = 0;
    while (i < code.length) {
      final c = code[i];

      if (c == '#') {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      if (_isStringPrefix(c) && _isQuote(_peek(code, i + 1))) {
        final start = i;
        i = _scanString(code, i + 1);
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (_isQuote(c)) {
        final start = i;
        i = _scanString(code, i);
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isNumberChar(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.number);
        continue;
      }

      if (_isIdentStart(c)) {
        final start = i;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        final word = code.substring(start, i);
        _fill(
          types,
          start,
          i,
          _keywords.contains(word)
              ? SyntaxTokenType.keyword
              : SyntaxTokenType.identifier,
        );
        continue;
      }

      // Whitespace stays `plain` (the list's fill value); every other
      // single symbol is punctuation/an operator.
      if (!_isWhitespace(c)) {
        types[i] = SyntaxTokenType.operatorOrPunctuation;
      }
      i++;
    }
    return types;
  }

  /// Scans a (possibly triple-quoted) string starting at [quoteIndex]
  /// (which must hold the opening quote character) and returns the index
  /// just past its end.
  int _scanString(String code, int quoteIndex) {
    final quote = code[quoteIndex];
    final isTriple =
        _peek(code, quoteIndex + 1) == quote &&
        _peek(code, quoteIndex + 2) == quote;
    var i = quoteIndex + (isTriple ? 3 : 1);
    if (isTriple) {
      while (i < code.length &&
          !(code[i] == quote &&
              _peek(code, i + 1) == quote &&
              _peek(code, i + 2) == quote)) {
        i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
      }
      return (i + 3 <= code.length) ? i + 3 : code.length;
    }
    while (i < code.length && code[i] != quote && code[i] != '\n') {
      i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
    }
    if (i < code.length && code[i] == quote) i++;
    return i;
  }

  String? _peek(String code, int index) =>
      index < code.length ? code[index] : null;

  bool _isQuote(String? c) => c == '"' || c == "'";

  bool _isStringPrefix(String c) =>
      c == 'f' || c == 'F' || c == 'r' || c == 'R' || c == 'b' || c == 'B';

  void _fill(
    List<SyntaxTokenType> types,
    int start,
    int end,
    SyntaxTokenType type,
  ) {
    for (var j = start; j < end && j < types.length; j++) {
      types[j] = type;
    }
  }

  bool _isWhitespace(String c) =>
      c == ' ' || c == '\t' || c == '\n' || c == '\r';

  bool _isDigit(String c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

  bool _isNumberChar(String c) =>
      _isDigit(c) ||
      c == '.' ||
      c == '_' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x7A); // letters, e.g. hex/j/e

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
