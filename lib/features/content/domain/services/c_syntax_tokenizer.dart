part of 'syntax_tokenizer.dart';

/// A single-pass lexer for C — just enough to color keywords, primitive
/// types, strings and character literals, comments, numbers, and `#`
/// preprocessor directives; it never builds an AST and never tries to
/// tell a type name from a variable name (that needs semantic analysis,
/// not lexing).
class CSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Control flow and declaration keywords.
    'auto', 'break', 'case', 'const', 'continue', 'default', 'do',
    'else', 'enum', 'extern', 'for', 'goto', 'if', 'inline', 'register',
    'restrict', 'return', 'sizeof', 'static', 'struct', 'switch',
    'typedef', 'union', 'volatile', 'while',
    // C11 alignment/atomic/generic keywords, still valid in C17.
    '_Alignas', '_Alignof', '_Atomic', '_Generic', '_Noreturn',
    '_Static_assert', '_Thread_local',
    // C23 spellings the catalog teaches alongside the classic ones.
    'bool', 'true', 'false', 'nullptr', 'constexpr', 'typeof', 'typeof_unqual',
    // Primitive types — a distinct lexical category from keywords in C,
    // but colored the same: without these, ordinary code (whose keywords
    // are mostly `int`/`char`/`return`) reads as almost entirely "plain"
    // text.
    'char', 'double', 'float', 'int', 'long', 'short', 'signed',
    'unsigned', 'void', '_Bool',
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

      // A `#` that opens a line (possibly indented) starts a preprocessor
      // directive. Only the directive itself is keyword-colored; for
      // `#include`, the header name in `<...>` or `"..."` is a string.
      // The rest of the line keeps normal tokenization, so a macro body
      // like `#define SQUARE(x) ((x) * (x))` still colors its arguments
      // and operators correctly.
      if (c == '#' && _opensLine(code, i)) {
        final start = i;
        i++;
        while (i < code.length && (code[i] == ' ' || code[i] == '\t')) {
          i++;
        }
        final directiveStart = i;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        final directive = code.substring(directiveStart, i);
        _fill(types, start, i, SyntaxTokenType.keyword);
        if (directive == 'include' || directive == 'include_next') {
          while (i < code.length && (code[i] == ' ' || code[i] == '\t')) {
            i++;
          }
          final headerStart = i;
          if (i < code.length && code[i] == '<') {
            while (i < code.length && code[i] != '>' && code[i] != '\n') {
              i++;
            }
            if (i < code.length && code[i] == '>') i++;
            _fill(types, headerStart, i, SyntaxTokenType.string);
          } else if (i < code.length && code[i] == '"') {
            i++;
            while (i < code.length && code[i] != '"' && code[i] != '\n') {
              i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
            }
            if (i < code.length && code[i] == '"') i++;
            _fill(types, headerStart, i, SyntaxTokenType.string);
          }
        }
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

      // A single quote always opens a character literal in C —
      // identifiers can't contain an apostrophe.
      if (c == "'") {
        final start = i;
        i++;
        while (i < code.length && code[i] != "'") {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        if (c == '0' &&
            i + 1 < code.length &&
            (code[i + 1] == 'x' || code[i + 1] == 'X')) {
          i += 2;
          while (i < code.length && _isHexDigit(code[i])) {
            i++;
          }
        } else if (c == '0' &&
            i + 1 < code.length &&
            (code[i + 1] == 'b' || code[i + 1] == 'B')) {
          i += 2;
          while (i < code.length && (code[i] == '0' || code[i] == '1')) {
            i++;
          }
        } else {
          while (i < code.length && (_isDigit(code[i]) || code[i] == '.')) {
            i++;
          }
          if (i < code.length && (code[i] == 'e' || code[i] == 'E')) {
            var exponentEnd = i + 1;
            if (exponentEnd < code.length &&
                (code[exponentEnd] == '+' || code[exponentEnd] == '-')) {
              exponentEnd++;
            }
            if (exponentEnd < code.length && _isDigit(code[exponentEnd])) {
              i = exponentEnd;
              while (i < code.length && _isDigit(code[i])) {
                i++;
              }
            }
          }
        }
        // Integer/float suffixes: 42U, 10L, 2ULL, 3.14f.
        while (i < code.length && 'uUlLfF'.contains(code[i])) {
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

  /// Whether [index]'s character is the first non-whitespace character on
  /// its line — the only place C allows a `#` directive to start.
  bool _opensLine(String code, int index) {
    for (var i = index - 1; i >= 0; i--) {
      if (code[i] == '\n') return true;
      if (!_isWhitespace(code[i])) return false;
    }
    return true;
  }

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

  bool _isHexDigit(String c) {
    final lower = c.toLowerCase();
    return _isDigit(c) ||
        (lower.codeUnitAt(0) >= 0x61 && lower.codeUnitAt(0) <= 0x66);
  }

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
