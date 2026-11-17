part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Mojo 1.1 — same scope as
/// [GoSyntaxTokenizer]/[PythonSyntaxTokenizer]: just enough to color
/// keywords, types, dunder methods, decorators, strings (including
/// t-strings and raw strings), comments, numbers, and punctuation; no
/// AST. Mojo reads like Python and compiles like a systems language, so
/// the lexer is the Python one's shape plus three Mojo wrinkles:
/// decorators (`@fieldwise_init`) are colored as keywords, a leading
/// `@`-name is one token, and the language's type vocabulary
/// (`SIMD[DType.float32, 4]`, `Pointer`, `comptime`) would otherwise
/// read as plain text.
class MojoSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Declarations and compile-time machinery.
    'def', 'struct', 'trait', 'var', 'comptime',
    // Argument conventions (Mojo ownership).
    'mut', 'ref', 'out', 'deinit',
    // Effects.
    'raises', 'except', 'finally', 'try',
    // Control flow.
    'if', 'elif', 'else', 'for', 'while', 'break', 'continue', 'return',
    'pass', 'with',
    // Operators, membership, booleans.
    'and', 'or', 'not', 'in', 'is',
    // Imports.
    'import', 'from', 'as',
    // Literals and special names.
    'None', 'True', 'False', 'Self',
    // Core types colored like keywords, mirroring
    // GoSyntaxTokenizer's predeclared types.
    'Bool', 'Error',
    'Int', 'Int8', 'Int16', 'Int32', 'Int64', 'Int128', 'Int256',
    'UInt', 'UInt8', 'UInt16', 'UInt32', 'UInt64', 'UInt128', 'UInt256',
    'Float16', 'Float32', 'Float64', 'BFloat16',
    'Byte', 'DType', 'SIMD', 'Scalar', 'SIMDLength',
    'List', 'Dict', 'Set', 'Optional', 'Tuple', 'Variant', 'Array',
    'Counter', 'Span', 'Pointer', 'VariadicPack', 'PythonObject',
    // Traits every Mojo program leans on.
    'Movable', 'Copyable', 'ImplicitlyCopyable', 'Deinitable', 'KeyElement',
    'Comparable', 'Intable', 'Boolable', 'Defaultable', 'Hashable',
    'Writable', 'Writer',
    // Common builtins conventionally highlighted like keywords, mirroring
    // PythonSyntaxTokenizer's predeclared set.
    'print', 'len', 'range', 'reversed', 'chr', 'String', 'StringLiteral',
    'StringSpan', 'sort', 'hash', 'self',
  };

  static const _decorators = {
    'always_inline',
    'no_inline',
    'fieldwise_init',
    'staticmethod',
    'implicit',
    'export',
    'deprecated',
    'doc_hidden',
    'align',
    'inline',
    'parameter',
    '__doc_inline',
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

      if (c == '@' && _isIdentStart(_peek(code, i + 1) ?? '')) {
        final start = i;
        final end = _scanDecorator(code, i);
        final name = code.substring(start + 1, end);
        // A known decorator reads as a keyword; an unknown `@name` still
        // lexes as one token so matmul can't fuse with what follows, but
        // only its name is colored, the `@` staying punctuation.
        if (_decorators.contains(name)) {
          _fill(types, start, end, SyntaxTokenType.keyword);
        } else {
          _fill(types, start + 1, end, SyntaxTokenType.identifier);
        }
        i = end;
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
        i = _scanNumber(code, i);
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
          _isKeyword(word)
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

  /// Scans `@name` starting at the `@` (index [atIndex]) and returns the
  /// index just past the decorator's name. Only known Mojo decorators
  /// take the keyword color; an unknown `@name` still lexes as one token
  /// so a matmul operator can't fuse with the following identifier.
  int _scanDecorator(String code, int atIndex) {
    var i = atIndex + 1;
    while (i < code.length && _isIdentPart(code[i])) {
      i++;
    }
    return i;
  }

  bool _isKeyword(String word) => _keywords.contains(word) || _isDunder(word);

  bool _isDunder(String word) =>
      word.length > 4 && word.startsWith('__') && word.endsWith('__');

  /// Scans a (possibly triple-quoted) string starting at [quoteIndex]
  /// (which must hold the opening quote character) and returns the index
  /// just past its end. A triple-quoted string may span lines; a
  /// single-quoted one may not, so an unterminated literal stops at the
  /// newline instead of swallowing the rest of the file.
  int _scanString(String code, int quoteIndex) {
    final quote = code[quoteIndex];
    final isTriple =
        _peek(code, quoteIndex + 1) == quote &&
        _peek(code, quoteIndex + 2) == quote;
    var i = quoteIndex + (isTriple ? 3 : 1);
    while (i < code.length) {
      final c = code[i];
      if (c == r'\') {
        i += 2;
        continue;
      }
      if (c == quote) {
        if (isTriple) {
          if (_peek(code, i + 1) == quote && _peek(code, i + 2) == quote) {
            return i + 3;
          }
        } else {
          return i + 1;
        }
      }
      if (!isTriple && (c == '\n' || c == '\r')) return i;
      i++;
    }
    return code.length;
  }

  /// Mojo's numeric literals: decimal, `0x`/`0o`/`0b` radix forms,
  /// floats with a fraction and/or an `e` exponent, and `_` separators
  /// — the same shapes Python programmers arrive with, plus the typed
  /// suffixes the numeric-types page documents (none of which exist in
  /// Python, so trailing identifier characters are consumed as one
  /// number token).
  int _scanNumber(String code, int start) {
    var i = start;
    final radix = _numberRadix(code, start);
    if (radix != null) {
      i += 2;
      while (i < code.length &&
          (code[i] == '_' || _isDigitForRadix(code[i], radix))) {
        i++;
      }
    } else {
      while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
        i++;
      }
      if (i < code.length &&
          code[i] == '.' &&
          _isDigit(_peek(code, i + 1) ?? '')) {
        i++;
        while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
          i++;
        }
      }
      if (i < code.length && (code[i] == 'e' || code[i] == 'E')) {
        var j = i + 1;
        if (j < code.length && (code[j] == '+' || code[j] == '-')) j++;
        if (j < code.length && _isDigit(code[j])) {
          i = j;
          while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
            i++;
          }
        }
      }
    }
    while (i < code.length && _isIdentPart(code[i])) {
      i++;
    }
    return i;
  }

  String? _numberRadix(String code, int index) {
    if (index + 1 >= code.length || code[index] != '0') return null;
    final prefix = code[index + 1].toLowerCase();
    if (prefix == 'x' || prefix == 'o' || prefix == 'b') return prefix;
    return null;
  }

  bool _isDigitForRadix(String c, String radix) {
    if (radix == 'x') return _isHexDigit(c);
    if (radix == 'b') return c == '0' || c == '1';
    return _isDigit(c) && c.codeUnitAt(0) <= 0x37;
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

  bool _isHexDigit(String c) {
    final unit = c.codeUnitAt(0);
    return (unit >= 0x30 && unit <= 0x39) ||
        (unit >= 0x41 && unit <= 0x46) ||
        (unit >= 0x61 && unit <= 0x66);
  }

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);

  bool _isQuote(String? c) => c == '"' || c == "'";

  bool _isStringPrefix(String c) =>
      c == 't' || c == 'T' || c == 'r' || c == 'R';
}
