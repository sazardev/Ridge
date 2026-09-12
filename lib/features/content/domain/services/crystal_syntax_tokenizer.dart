part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Crystal — just enough to color keywords,
/// primitive types, `#` comments, double-quoted strings (interpolation
/// included), single-quoted char literals, numbers, and punctuation; it
/// never builds an AST and never tries to tell a local variable from a
/// method call (that needs semantic analysis, not lexing).
///
/// Coarse trade-off, same as the JavaScript tokenizer's template literals:
/// a `"` nested inside `#{}` interpolation would end the string token
/// early. The catalog never nests quotes inside interpolation, and
/// tracking that nesting would stop this from being a flat single pass.
class CrystalSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Control flow and declaration keywords.
    'abstract', 'alias', 'annotation', 'asm', 'begin', 'break', 'case',
    'class', 'def', 'do', 'else', 'elsif', 'end', 'ensure', 'enum',
    'extend', 'for', 'fun', 'if', 'in', 'include', 'lib', 'macro',
    'module', 'next', 'of', 'out', 'private', 'protected', 'require',
    'rescue', 'return', 'select', 'struct', 'then', 'type', 'union',
    'unless', 'until', 'verbatim', 'when', 'while', 'with', 'yield',
    // Pseudo-methods and literals conventionally highlighted the same
    // way as keywords.
    'true', 'false', 'nil', 'self', 'super', 'typeof', 'sizeof',
    'instance_sizeof', 'offsetof', 'pointerof', 'uninitialized',
    // Attribute/property macros the catalog leans on to declare fields.
    'getter', 'setter', 'property', 'record', 'delegate', 'spawn',
    // Core types — a distinct lexical category from keywords in Crystal,
    // but colored the same: without these, ordinary code (whose keywords
    // are mostly `def`/`end`) reads as almost entirely "plain" text.
    'Int8', 'Int16', 'Int32', 'Int64', 'Int128',
    'UInt8', 'UInt16', 'UInt32', 'UInt64', 'UInt128',
    'Float32', 'Float64', 'Bool', 'Char', 'String', 'Symbol', 'Nil',
    'Array', 'Hash', 'Tuple', 'NamedTuple', 'Set', 'Deque', 'Range',
    'Proc', 'Pointer', 'StaticArray', 'Slice', 'Exception', 'Object',
    'Number', 'Comparable', 'Enumerable',
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

      // `#` opens a comment unless it is part of a string/char literal
      // (those are consumed above it in the scan) or an interpolation
      // like `#{name}`, which only appears inside a double-quoted string.
      if (c == '#') {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
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

      // A single quote always opens a character literal in Crystal —
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
          while (i < code.length &&
              (_isHexDigit(code[i]) ||
                  _isSeparatorBefore(code, i, _isHexDigit))) {
            i++;
          }
        } else if (c == '0' &&
            i + 1 < code.length &&
            (code[i + 1] == 'b' || code[i + 1] == 'B')) {
          i += 2;
          while (i < code.length &&
              (_isBinaryDigit(code[i]) ||
                  _isSeparatorBefore(code, i, _isBinaryDigit))) {
            i++;
          }
        } else if (c == '0' &&
            i + 1 < code.length &&
            (code[i + 1] == 'o' || code[i + 1] == 'O')) {
          i += 2;
          while (i < code.length &&
              (_isOctalDigit(code[i]) ||
                  _isSeparatorBefore(code, i, _isOctalDigit))) {
            i++;
          }
        } else {
          while (i < code.length &&
              (_isDigit(code[i]) || _isSeparatorBefore(code, i, _isDigit))) {
            i++;
          }
          // A `.` only continues the number when a digit follows, so the
          // range `1..5`, the dot-call `3.times`, and slices like
          // `items[1..]` keep their dots as punctuation.
          if (i + 1 < code.length && code[i] == '.' && _isDigit(code[i + 1])) {
            i++;
            while (i < code.length &&
                (_isDigit(code[i]) || _isSeparatorBefore(code, i, _isDigit))) {
              i++;
            }
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
        // Crystal type suffixes: 1_i64, 2_u32, 3.5_f32.
        if (i + 1 < code.length && code[i] == '_' && _isLetter(code[i + 1])) {
          i++;
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
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
      // single symbol is punctuation/an operator (`//`, `..`, `=>`,
      // `[]?`, `&.`, ... are classified one character at a time — coarse
      // by design, same as every other tokenizer here).
      if (!_isWhitespace(c)) {
        types[i] = SyntaxTokenType.operatorOrPunctuation;
      }
      i++;
    }
    return types;
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

  /// Whether `code[index]` is a numeric `_` separator whose next character
  /// satisfies [isDigit] — `1_000` consumes the `_`, `1_i64` does not (the
  /// suffix branch below handles it instead).
  bool _isSeparatorBefore(
    String code,
    int index,
    bool Function(String) isDigit,
  ) =>
      code[index] == '_' && index + 1 < code.length && isDigit(code[index + 1]);

  bool _isBinaryDigit(String c) => c == '0' || c == '1';

  bool _isOctalDigit(String c) =>
      c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x37;

  bool _isLetter(String c) =>
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isHexDigit(String c) {
    final lower = c.toLowerCase();
    return _isDigit(c) ||
        (lower.codeUnitAt(0) >= 0x61 && lower.codeUnitAt(0) <= 0x66);
  }

  bool _isIdentStart(String c) => c == '_' || _isLetter(c);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
