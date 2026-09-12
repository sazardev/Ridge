part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Swift — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, standard-library type names, string literals
/// (including interpolations, multiline strings and raw `#"..."#` forms),
/// nested block comments, numbers, and punctuation; it never builds an AST
/// and never tries to tell a type name from a variable name.
class SwiftSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Declarations and structure.
    'actor', 'associatedtype', 'class', 'deinit', 'enum', 'extension',
    'fileprivate', 'func', 'import', 'init', 'internal', 'let', 'open',
    'operator', 'private', 'protocol', 'public', 'rethrows', 'static',
    'struct', 'subscript', 'throw', 'throws', 'typealias', 'var',
    // Statements and control flow.
    'async', 'await', 'break', 'case', 'catch', 'continue', 'default',
    'defer', 'do', 'else', 'fallthrough', 'for', 'guard', 'if', 'in',
    'is', 'repeat', 'return', 'switch', 'where', 'while',
    // Modifiers that read as structure in this catalog's code.
    'convenience', 'dynamic', 'final', 'indirect', 'infix', 'lazy',
    'mutating', 'nonisolated', 'nonmutating', 'override', 'postfix',
    'prefix', 'required', 'some', 'any', 'weak', 'unowned',
    // Literals.
    'false', 'nil', 'self', 'super', 'true',
    // Standard-library type names — a distinct lexical category, but
    // colored the same: without these, ordinary code (whose keywords are
    // mostly `let`/`return`) reads as almost entirely "plain" text.
    'Any', 'AnyObject', 'Bool', 'Character', 'Double', 'Error', 'Float',
    'Int', 'Never', 'Self', 'String', 'Void',
    // Property observers and contextual attribute names commonly used by
    // this catalog (`@escaping`, `@propertyWrapper`, `@MainActor`).
    'autoclosure', 'didSet', 'escaping', 'get', 'MainActor',
    'propertyWrapper', 'Sendable', 'set', 'willSet',
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

      // Swift block comments nest, so this tracks depth instead of
      // stopping at the first `*/`.
      if (c == '/' && _peek(code, i + 1) == '*') {
        final start = i;
        var depth = 0;
        while (i < code.length) {
          if (code[i] == '/' && _peek(code, i + 1) == '*') {
            depth++;
            i += 2;
          } else if (code[i] == '*' && _peek(code, i + 1) == '/') {
            depth--;
            i += 2;
            if (depth == 0) break;
          } else {
            i++;
          }
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      // Raw strings: `#"..."#`, `##"..."##`, ... A run of N hashes
      // followed by a quote opens a literal that only a quote followed by
      // the same N hashes closes, so embedded quotes are literal.
      if (c == '#') {
        var hashes = 0;
        var j = i;
        while (_peek(code, j) == '#') {
          hashes++;
          j++;
        }
        if (_peek(code, j) == '"') {
          final start = i;
          i = j + 1;
          while (i < code.length) {
            if (code[i] == '"' &&
                code.substring(i + 1).startsWith('#' * hashes)) {
              i += 1 + hashes;
              break;
            }
            i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
          }
          _fill(types, start, i, SyntaxTokenType.string);
          continue;
        }
        // A `#` directive (`#if`, `#available`, `#selector`, ...) reads
        // as one keyword-colored word.
        if (_isIdentStart(_peek(code, j) ?? '')) {
          final start = i;
          i = j;
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
          _fill(types, start, i, SyntaxTokenType.keyword);
          continue;
        }
      }

      // A multiline string `"""..."""` may span lines, so it is detected
      // before the regular string branch.
      if (c == '"' && _peek(code, i + 1) == '"' && _peek(code, i + 2) == '"') {
        final start = i;
        i += 3;
        while (i < code.length &&
            !(code[i] == '"' &&
                _peek(code, i + 1) == '"' &&
                _peek(code, i + 2) == '"')) {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        i = (i + 2 < code.length) ? i + 3 : code.length;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == '"') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '"' && code[i] != '\n') {
          // `\(...)` interpolation keeps the whole literal one string
          // token; escapes just skip the next character.
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length && code[i] == '"') i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // `$0`, `$1`, ... are the shorthand closure argument names.
      if (c == r'$' && _peek(code, i + 1) != null && _isDigit(code[i + 1])) {
        final start = i;
        i++;
        while (i < code.length && _isDigit(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.identifier);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isNumberChar(code[i])) {
          // A dot continues a number only when a digit follows, so ranges
          // like `1...3` and `0..<n` keep their dots as punctuation.
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
      c == 'b' ||
      c == 'B' ||
      c == 'o' ||
      c == 'O' ||
      c == 'e' ||
      c == 'E' ||
      c == 'p' ||
      c == 'P' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  bool _isIdentStart(String c) =>
      c.isNotEmpty &&
      (c == '_' ||
          (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
          (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A));

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
