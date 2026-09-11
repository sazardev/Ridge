part of 'syntax_tokenizer.dart';

/// A single-pass lexer for JavaScript — same scope as [GoSyntaxTokenizer]:
/// just enough to color keywords, strings, comments, numbers, and
/// punctuation, no AST. Template literals (`` `...` ``) are colored as a
/// single string token like Go's raw strings — `${...}` interpolation
/// inside one isn't given its own coloring, the same simplification
/// [BashSyntaxTokenizer] makes for legacy backquote substitution.
class JavaScriptSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'debugger',
    'default',
    'delete',
    'do',
    'else',
    'export',
    'extends',
    'false',
    'finally',
    'for',
    'from',
    'function',
    'get',
    'if',
    'import',
    'in',
    'instanceof',
    'let',
    'new',
    'null',
    'of',
    'return',
    'set',
    'static',
    'super',
    'switch',
    'this',
    'throw',
    'true',
    'try',
    'typeof',
    'undefined',
    'var',
    'void',
    'while',
    'with',
    'yield',
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

      if (c == '/' && _peek(code, i + 1) == '/') {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      if (c == '/' && _peek(code, i + 1) == '*') {
        final start = i;
        i += 2;
        while (i < code.length &&
            !(code[i] == '*' && _peek(code, i + 1) == '/')) {
          i++;
        }
        i = (i + 1 < code.length) ? i + 2 : code.length;
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      if (c == '"' || c == "'") {
        final start = i;
        final quote = c;
        i++;
        while (i < code.length && code[i] != quote && code[i] != '\n') {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length && code[i] == quote) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == '`') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '`') {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++;
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

  String? _peek(String code, int index) =>
      index < code.length ? code[index] : null;

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
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  // `$` and `_` are both valid JS identifier characters (e.g. jQuery's
  // `$`, private-convention `_name`), alongside the usual letters.
  bool _isIdentStart(String c) =>
      c == '_' ||
      c == r'$' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
