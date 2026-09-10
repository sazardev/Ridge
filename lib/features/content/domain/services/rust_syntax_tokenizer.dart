part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Rust — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, strings, comments, numbers, and punctuation,
/// no AST. The one Rust-specific wrinkle is that a leading `'` starts
/// either a char literal (`'a'`, closed by a matching `'`) or a lifetime
/// (`'a`, `'static`, never closed) — [classify] disambiguates by checking
/// whether a closing `'` immediately follows the identifier characters.
class RustSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Strict + 2018-edition keywords.
    'as', 'async', 'await', 'break', 'const', 'continue', 'crate', 'dyn',
    'else', 'enum', 'extern', 'false', 'fn', 'for', 'if', 'impl', 'in',
    'let', 'loop', 'match', 'mod', 'move', 'mut', 'pub', 'ref', 'return',
    'self', 'Self', 'static', 'struct', 'super', 'trait', 'true', 'type',
    'unsafe', 'use', 'where', 'while',
    // Reserved for future use, and the `union` weak keyword.
    'abstract', 'become', 'box', 'do', 'final', 'macro', 'override', 'priv',
    'try', 'typeof', 'unsized', 'virtual', 'yield', 'union',
    // Primitive types — a distinct lexical category from keywords in Rust,
    // but colored the same, mirroring GoSyntaxTokenizer's predeclared
    // types (without these, ordinary code reads as almost entirely
    // "plain" text).
    'bool', 'char', 'str',
    'i8', 'i16', 'i32', 'i64', 'i128', 'isize',
    'u8', 'u16', 'u32', 'u64', 'u128', 'usize',
    'f32', 'f64',
    // Prelude items conventionally highlighted like keywords.
    'Some', 'None', 'Ok', 'Err', 'Option', 'Result', 'Vec', 'String', 'Box',
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

      if (c == '"') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '"') {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++; // consume the closing quote
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == "'") {
        final start = i;
        i++;
        if (i < code.length && code[i] == r'\') {
          i += 2; // escape sequence: backslash + escaped char
          if (i < code.length && code[i] == "'") i++;
          _fill(types, start, i, SyntaxTokenType.string);
          continue;
        }
        var j = i;
        while (j < code.length && _isIdentPart(code[j])) {
          j++;
        }
        if (j > i && j < code.length && code[j] == "'") {
          // 'a' — one or more ident chars immediately closed: char literal.
          i = j + 1;
          _fill(types, start, i, SyntaxTokenType.string);
        } else if (j > i) {
          // 'static / 'a — ident chars with no closing quote: a lifetime.
          i = j;
          _fill(types, start, i, SyntaxTokenType.keyword);
        } else if (i < code.length) {
          // A literal non-identifier char, e.g. `'('` or `' '`.
          i++;
          if (i < code.length && code[i] == "'") i++;
          _fill(types, start, i, SyntaxTokenType.string);
        } else {
          _fill(types, start, i, SyntaxTokenType.operatorOrPunctuation);
        }
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
          c.toLowerCase().codeUnitAt(0) <= 0x7A); // letters, for type suffixes

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
