part of 'syntax_tokenizer.dart';

/// A single-pass lexer for CSS — just enough to color `/* */` comments,
/// quoted strings, `@`-rules, property names, hex colors, numeric
/// literals with their units, function names (including functional
/// pseudo-classes like `:is()`), and punctuation; it never builds an AST
/// and never resolves the cascade (that needs computed styles, not
/// lexing).
///
/// Property names are recognized positionally rather than semantically:
/// an identifier inside a block that is immediately followed by `:` is a
/// declaration, which keeps a selector's `a:hover` from being mistaken
/// for one. Both heuristics stay lexical on purpose — a real parser is a
/// much bigger dependency for a highlighting-only concern.
class CssSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  @override
  List<SyntaxTokenType> classify(String code) {
    final types = List<SyntaxTokenType>.filled(
      code.length,
      SyntaxTokenType.plain,
    );
    var i = 0;
    // Tracks whether the scanner is inside a declaration block, and
    // whether a declaration is expected next (right after `{` or `;`).
    var blockDepth = 0;
    var expectProperty = false;

    while (i < code.length) {
      final c = code[i];

      // `/* ... */` comments — CSS comments never nest.
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
        while (i < code.length && code[i] != quote) {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++; // consume the closing quote
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // `@media`, `@keyframes`, `@layer`, `@import` — the whole at-rule
      // name reads as one keyword.
      if (c == '@') {
        final start = i;
        i++;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.keyword);
        continue;
      }

      // `#ff5a36` is a hex color, colored like a numeric literal. A `#id`
      // selector has a non-hex letter after the `#`, so it stays
      // punctuation plus an identifier.
      if (c == '#' && i + 1 < code.length && _isHexDigit(code[i + 1])) {
        final start = i;
        i++;
        while (i < code.length && _isHexDigit(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.number);
        continue;
      }

      if (_startsNumber(code, i)) {
        final start = i;
        if (code[i] == '-' || code[i] == '+') i++;
        while (i < code.length && (_isDigit(code[i]) || code[i] == '.')) {
          i++;
        }
        // The unit or keyword suffix: `px`, `rem`, `vh`, `ms`, `s`, `fr`,
        // `turn`, `%` — one token with the number it belongs to.
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        if (i < code.length && code[i] == '%') i++;
        _fill(types, start, i, SyntaxTokenType.number);
        continue;
      }

      if (_isIdentStart(code, i)) {
        final start = i;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        final SyntaxTokenType type;
        if (_peek(code, i) == '(') {
          // `rgb()`, `var()`, `calc()`, `translateY()`, `repeat()`, ...
          type = SyntaxTokenType.keyword;
        } else if (expectProperty && _nextNonWhitespace(code, i) == ':') {
          type = SyntaxTokenType.keyword;
        } else {
          type = SyntaxTokenType.identifier;
        }
        _fill(types, start, i, type);
        expectProperty = false;
        continue;
      }

      if (c == '{') {
        blockDepth++;
        expectProperty = true;
        types[i] = SyntaxTokenType.operatorOrPunctuation;
        i++;
        continue;
      }

      if (c == '}') {
        if (blockDepth > 0) blockDepth--;
        expectProperty = false;
        types[i] = SyntaxTokenType.operatorOrPunctuation;
        i++;
        continue;
      }

      if (c == ';') {
        // A `;` inside a block ends a declaration, so the next
        // identifier may be a property; at the top level it ends an
        // at-rule, so the next identifier is a selector.
        expectProperty = blockDepth > 0;
        types[i] = SyntaxTokenType.operatorOrPunctuation;
        i++;
        continue;
      }

      if (!_isWhitespace(c)) {
        types[i] = SyntaxTokenType.operatorOrPunctuation;
        expectProperty = false;
      }
      i++;
    }
    return types;
  }

  String? _peek(String code, int index) =>
      index < code.length ? code[index] : null;

  String? _nextNonWhitespace(String code, int from) {
    var j = from;
    while (j < code.length && _isWhitespace(code[j])) {
      j++;
    }
    return _peek(code, j);
  }

  bool _startsNumber(String code, int i) {
    final c = code[i];
    if (_isDigit(c)) return true;
    if ((c == '-' || c == '+') && i + 1 < code.length) {
      return _isDigit(code[i + 1]) ||
          (code[i + 1] == '.' && i + 2 < code.length && _isDigit(code[i + 2]));
    }
    if (c == '.') return i + 1 < code.length && _isDigit(code[i + 1]);
    return false;
  }

  bool _isIdentStart(String code, int i) {
    final c = code[i];
    if (_isLetter(c) || c == '_') return true;
    // Vendor prefixes and custom properties (`--brand`, `-webkit-...`)
    // start with `-`; `-4px` is handled by `_startsNumber` first.
    if (c == '-' && i + 1 < code.length) {
      final next = code[i + 1];
      return _isLetter(next) || next == '-' || next == '_';
    }
    return false;
  }

  bool _isIdentPart(String c) =>
      _isLetter(c) || _isDigit(c) || c == '_' || c == '-';

  bool _isLetter(String c) {
    final unit = c.codeUnitAt(0);
    return (unit >= 0x41 && unit <= 0x5A) || (unit >= 0x61 && unit <= 0x7A);
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

  bool _isHexDigit(String c) =>
      _isDigit(c) ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66);

  bool _isWhitespace(String c) =>
      c == ' ' || c == '\t' || c == '\n' || c == '\r';

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
}
