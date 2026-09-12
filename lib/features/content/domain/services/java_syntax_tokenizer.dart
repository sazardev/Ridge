part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Java — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, primitive type names, string literals
/// (including multi-line text blocks), character literals, comments,
/// numbers, and punctuation; it never builds an AST and never tries to
/// tell a type name from a variable name.
class JavaSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Reserved words.
    'abstract', 'assert', 'break', 'case', 'catch', 'class', 'const',
    'continue', 'default', 'do', 'else', 'enum', 'extends', 'final',
    'finally', 'for', 'goto', 'if', 'implements', 'import', 'instanceof',
    'interface', 'native', 'new', 'package', 'private', 'protected',
    'public', 'return', 'static', 'strictfp', 'super', 'switch',
    'synchronized', 'this', 'throw', 'throws', 'transient', 'try',
    'volatile', 'while',
    // Contextual keywords that read as structure in this catalog's code
    // (`record`, `sealed`, `yield` come from modern-Java features; `var`
    // introduces a local whose type is inferred). A bare `_` has been a
    // reserved keyword since Java 9.
    '_', 'permits', 'record', 'sealed', 'var', 'yield',
    // Literals.
    'true', 'false', 'null',
    // Primitive types — a distinct lexical category from keywords in
    // Java, but colored the same: without these, ordinary code (whose
    // keywords are mostly `public`/`return`) reads as almost entirely
    // "plain" text.
    'boolean', 'byte', 'char', 'double', 'float', 'int', 'long', 'short',
    'void',
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

      // A text block `"""..."""` may span lines, so it is detected before
      // the regular double-quoted string branch and consumes through its
      // own closing delimiter.
      if (c == '"' && _peek(code, i + 1) == '"' && _peek(code, i + 2) == '"') {
        final start = i;
        i += 3;
        while (i < code.length &&
            !(code[i] == '"' &&
                _peek(code, i + 1) == '"' &&
                _peek(code, i + 2) == '"')) {
          // A backslash escapes the next character: `\"""` does not close
          // the block.
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        i = (i + 2 < code.length) ? i + 3 : code.length;
        _fill(types, start, i, SyntaxTokenType.string);
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
      c == 'L' ||
      c == 'l' || // long suffix (`8_100_000_000L`)
      c == 'x' ||
      c == 'X' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  // `$` and `_` are both valid Java identifier characters (`$` is
  // generated-friendly and legal, `_` is conventional).
  bool _isIdentStart(String c) =>
      c == '_' ||
      c == r'$' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
