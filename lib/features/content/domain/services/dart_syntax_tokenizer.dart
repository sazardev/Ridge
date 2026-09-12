part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Dart — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, standard-library type names, string literals
/// (including interpolations and triple-quoted/raw forms), `//`/`///` and
/// `/* */` comments, numbers, and punctuation; it never builds an AST and
/// never tries to tell a type name from a variable name.
class DartSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Declarations and structure.
    'abstract', 'base', 'class', 'const', 'covariant', 'enum', 'export',
    'extends', 'extension', 'external', 'factory', 'final', 'get',
    'implements', 'import', 'interface', 'late', 'library', 'mixin', 'new',
    'on', 'operator', 'part', 'required', 'sealed', 'set', 'static',
    'super', 'this', 'typedef', 'var', 'with',
    // Statements and control flow.
    'as', 'assert', 'async', 'await', 'break', 'case', 'catch', 'continue',
    'default', 'deferred', 'do', 'else', 'finally', 'for', 'hide', 'if',
    'in', 'is', 'rethrow', 'return', 'show', 'switch', 'sync', 'throw',
    'try', 'when', 'while', 'yield',
    // Literals.
    'false', 'null', 'true',
    // Standard-library type names — a distinct lexical category, but
    // colored the same: without these, ordinary code (whose keywords are
    // mostly `final`/`return`) reads as almost entirely "plain" text.
    'ArgumentError', 'Comparable', 'Completer', 'DateTime', 'Duration',
    'Error', 'Exception', 'FormatException', 'Function', 'Future',
    'FutureOr', 'Iterable', 'List', 'Map', 'Never', 'Null', 'Object',
    'Set', 'Stream', 'StreamController', 'String', 'Symbol', 'Timer',
    'Type', 'bool', 'double', 'dynamic', 'int', 'num', 'void',
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

      // Dart block comments do NOT nest: the first `*/` closes them.
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

      // Raw strings: `r'...'`, `r"..."`, `r'''...'''`, `r"""..."""`. The
      // `r` only opens one when it is not the tail of an identifier.
      final isRawPrefix =
          c == 'r' &&
          (i == 0 || !_isIdentPart(code[i - 1])) &&
          (_peek(code, i + 1) == "'" || _peek(code, i + 1) == '"');
      if (isRawPrefix) {
        final start = i;
        final quote = code[i + 1];
        if (_peek(code, i + 2) == quote && _peek(code, i + 3) == quote) {
          i += 4;
          while (i < code.length &&
              !(code[i] == quote &&
                  _peek(code, i + 1) == quote &&
                  _peek(code, i + 2) == quote)) {
            i++;
          }
          i = (i + 2 < code.length) ? i + 3 : code.length;
        } else {
          i += 2;
          while (i < code.length && code[i] != quote && code[i] != '\n') {
            i++;
          }
          if (i < code.length && code[i] == quote) i++;
        }
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // Triple-quoted strings may span lines, so they are detected before
      // the single-quote branch.
      if ((c == "'" || c == '"') &&
          _peek(code, i + 1) == c &&
          _peek(code, i + 2) == c) {
        final start = i;
        i += 3;
        while (i < code.length &&
            !(code[i] == c &&
                _peek(code, i + 1) == c &&
                _peek(code, i + 2) == c)) {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        i = (i + 2 < code.length) ? i + 3 : code.length;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == "'" || c == '"') {
        final start = i;
        final quote = c;
        i++;
        while (i < code.length && code[i] != quote && code[i] != '\n') {
          // `$name` and `${...}` interpolation keeps the whole literal one
          // string token; escapes just skip the next character.
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length && code[i] == quote) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isNumberChar(code[i])) {
          // A dot continues a number only when a digit follows, so member
          // access like `1.isEven` keeps its dot as punctuation.
          if (code[i] == '.' && !_isDigit(_peek(code, i + 1) ?? '')) {
            break;
          }
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

  bool _isDigit(String c) =>
      c.isNotEmpty && c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

  bool _isNumberChar(String c) =>
      _isDigit(c) ||
      c == '.' ||
      c == '_' ||
      c == 'x' ||
      c == 'X' ||
      c == 'e' ||
      c == 'E' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  bool _isIdentStart(String c) =>
      c.isNotEmpty &&
      (c == '_' ||
          (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
          (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A));

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
