part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Zig — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, primitive types, identifiers, strings, comments,
/// numbers, and punctuation; it never builds an AST.
class ZigSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    'addrspace',
    'align',
    'allowzero',
    'and',
    'anyframe',
    'anytype',
    'asm',
    'async',
    'await',
    'break',
    'callconv',
    'catch',
    'comptime',
    'const',
    'continue',
    'defer',
    'else',
    'enum',
    'errdefer',
    'error',
    'export',
    'extern',
    'fn',
    'for',
    'if',
    'inline',
    'noalias',
    'noinline',
    'nosuspend',
    'opaque',
    'or',
    'orelse',
    'packed',
    'pub',
    'resume',
    'return',
    'linksection',
    'struct',
    'suspend',
    'switch',
    'test',
    'threadlocal',
    'try',
    'union',
    'unreachable',
    'usingnamespace',
    'var',
    'volatile',
    'while',
    'true',
    'false',
    'null',
    'undefined',
    'anyopaque',
    'anyerror',
    'bool',
    'comptime_float',
    'comptime_int',
    'f16',
    'f32',
    'f64',
    'f80',
    'f128',
    'i8',
    'i16',
    'i32',
    'i64',
    'i128',
    'isize',
    'noreturn',
    'type',
    'u8',
    'u16',
    'u32',
    'u64',
    'u128',
    'usize',
    'void',
    'c_char',
    'c_short',
    'c_ushort',
    'c_int',
    'c_uint',
    'c_long',
    'c_ulong',
    'c_longlong',
    'c_ulonglong',
    'c_longdouble',
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

      if (c == r'\' && _peek(code, i + 1) == r'\') {
        final start = i;
        i = _scanMultilineString(code, i);
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == '"' || c == "'") {
        final start = i;
        i = _scanQuotedLiteral(code, i);
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == '@' && _isAtIdentifierStart(code, i)) {
        final start = i;
        if (_peek(code, i + 1) == '"') {
          i = _scanQuotedLiteral(code, i + 1);
        } else {
          i++;
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
        }
        _fill(types, start, i, SyntaxTokenType.identifier);
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

      if (!_isWhitespace(c)) types[i] = SyntaxTokenType.operatorOrPunctuation;
      i++;
    }
    return types;
  }

  bool _isAtIdentifierStart(String code, int index) {
    final next = _peek(code, index + 1);
    if (next == null) return false;
    return next == '"' || _isIdentStart(next);
  }

  int _scanQuotedLiteral(String code, int start) {
    final quote = code[start];
    var i = start + 1;
    while (i < code.length) {
      final c = code[i];
      if (c == r'\') {
        i = _skipEscape(code, i);
        continue;
      }
      if (c == quote) return i + 1;
      if (c == '\n' || c == '\r') return i;
      i++;
    }
    return code.length;
  }

  int _skipEscape(String code, int index) {
    var i = index + 1;
    if (i >= code.length) return i;
    final c = code[i];
    if (c == '\n' || c == '\r') return i;
    if (c == 'x') {
      i++;
      var digits = 0;
      while (i < code.length && digits < 2 && _isHexDigit(code[i])) {
        i++;
        digits++;
      }
      return i;
    }
    if (c == 'u' && _peek(code, i + 1) == '{') {
      i += 2;
      while (i < code.length && code[i] != '}') {
        i++;
      }
      if (i < code.length) i++;
      return i;
    }
    return i + 1;
  }

  int _scanMultilineString(String code, int start) {
    var i = _consumeLine(code, start + 2);
    while (i < code.length) {
      final lineStart = i;
      var marker = i;
      while (marker < code.length &&
          (code[marker] == ' ' || code[marker] == '\t')) {
        marker++;
      }
      if (marker + 1 >= code.length ||
          code[marker] != r'\' ||
          code[marker + 1] != r'\') {
        return lineStart;
      }
      i = _consumeLine(code, marker + 2);
    }
    return code.length;
  }

  int _consumeLine(String code, int start) {
    var i = start;
    while (i < code.length && code[i] != '\n' && code[i] != '\r') {
      i++;
    }
    if (i < code.length) {
      final c = code[i];
      i++;
      if (c == '\r' && i < code.length && code[i] == '\n') i++;
    }
    return i;
  }

  int _scanNumber(String code, int start) {
    var i = start;
    final radix = _numberRadix(code, start);
    if (radix != null) {
      i += 2;
      while (i < code.length &&
          (code[i] == '_' || _isDigitForRadix(code[i], radix))) {
        i++;
      }
      if (radix == 'x' &&
          i + 1 < code.length &&
          code[i] == '.' &&
          _isHexDigit(code[i + 1])) {
        i++;
        while (i < code.length && (code[i] == '_' || _isHexDigit(code[i]))) {
          i++;
        }
      }
      if (radix == 'x' && i < code.length && _isExponentStart(code[i], 'p')) {
        final exponentEnd = _scanExponent(code, i);
        if (exponentEnd != null) i = exponentEnd;
      }
    } else {
      while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
        i++;
      }
      if (i + 1 < code.length && code[i] == '.' && _isDigit(code[i + 1])) {
        i++;
        while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
          i++;
        }
      }
      if (i < code.length && _isExponentStart(code[i], 'e')) {
        final exponentEnd = _scanExponent(code, i);
        if (exponentEnd != null) i = exponentEnd;
      }
    }
    while (i < code.length && _isIdentPart(code[i])) {
      i++;
    }
    return i;
  }

  int? _scanExponent(String code, int index) {
    var i = index + 1;
    if (i < code.length && (code[i] == '+' || code[i] == '-')) i++;
    if (i >= code.length || !_isDigit(code[i])) return null;
    while (i < code.length && (_isDigit(code[i]) || code[i] == '_')) {
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

  bool _isExponentStart(String c, String exponent) =>
      c.toLowerCase() == exponent;

  bool _isKeyword(String word) {
    if (_keywords.contains(word)) return true;
    if (word.length < 2 || (word[0] != 'i' && word[0] != 'u')) return false;
    for (var i = 1; i < word.length; i++) {
      if (!_isDigit(word[i])) return false;
    }
    return true;
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

  bool _isIdentStart(String c) {
    final unit = c.codeUnitAt(0);
    return c == '_' ||
        (unit >= 0x41 && unit <= 0x5A) ||
        (unit >= 0x61 && unit <= 0x7A);
  }

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
