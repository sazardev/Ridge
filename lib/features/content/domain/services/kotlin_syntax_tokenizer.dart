part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Kotlin — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, basic type names, string literals (including
/// triple-quoted raw strings and string templates), character literals,
/// comments (which nest in Kotlin), numbers, and punctuation; it never
/// builds an AST and never tries to tell a type name from a variable name.
class KotlinSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Hard keywords.
    'as', 'break', 'class', 'continue', 'do', 'else', 'false', 'for',
    'fun', 'if', 'in', 'interface', 'is', 'null', 'object', 'package',
    'return', 'super', 'this', 'throw', 'true', 'try', 'typealias',
    'typeof', 'val', 'var', 'when', 'while',
    // Modifiers and soft/contextual keywords that read as structure in
    // this catalog's code (`data`, `suspend`, `companion`, `by`, `get`,
    // `set`). A lexer cannot resolve their context, so they are colored
    // like keywords, exactly as the Java/TypeScript tokenizers do with
    // their own contextual keywords.
    'abstract', 'actual', 'annotation', 'by', 'catch', 'companion',
    'const', 'constructor', 'crossinline', 'data', 'dynamic', 'enum',
    'expect', 'external', 'field', 'final', 'finally', 'get', 'import',
    'infix', 'init', 'inline', 'inner', 'internal', 'lateinit',
    'noinline', 'open', 'operator', 'out', 'override', 'param',
    'private', 'property', 'protected', 'public', 'receiver', 'reified',
    'sealed', 'set', 'setparam', 'suspend', 'tailrec', 'vararg', 'where',
    // Foundational types from `kotlin`/`kotlin.text` — a distinct lexical
    // category from keywords, but colored the same: without them, ordinary
    // code reads as mostly plain text.
    'Any', 'Array', 'Boolean', 'Byte', 'Char', 'Double', 'Float', 'Int',
    'Long', 'Nothing', 'Short', 'String', 'Unit',
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

      // Unlike Java/C, Kotlin block comments NEST: `/* a /* b */ c */` is
      // one comment. Track depth so the inner `*/` does not close it.
      if (c == '/' && _peek(code, i + 1) == '*') {
        final start = i;
        i += 2;
        var depth = 1;
        while (i < code.length && depth > 0) {
          if (code[i] == '/' && _peek(code, i + 1) == '*') {
            depth++;
            i += 2;
          } else if (code[i] == '*' && _peek(code, i + 1) == '/') {
            depth--;
            i += 2;
          } else {
            i++;
          }
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      // A triple-quoted raw string may span lines and has no escapes (a
      // `$` still starts a template, which stays string-colored here).
      if (c == '"' && _peek(code, i + 1) == '"' && _peek(code, i + 2) == '"') {
        final start = i;
        i += 3;
        while (i < code.length &&
            !(code[i] == '"' &&
                _peek(code, i + 1) == '"' &&
                _peek(code, i + 2) == '"')) {
          i++;
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

      // Backticked identifiers (`` `fun name` ``) are legal Kotlin names —
      // colored as one identifier, not as a string.
      if (c == '`') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '`' && code[i] != '\n') {
          i++;
        }
        if (i < code.length && code[i] == '`') i++;
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

  bool _isHexDigit(String c) =>
      _isDigit(c) ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f

  /// Consumes a numeric literal starting at [start] (always a digit) and
  /// returns the index just past it. Handles hex/binary prefixes, digit
  /// separators (`1_000`), a single decimal point only when followed by a
  /// digit (so the range `1..3` is not swallowed), an optional exponent,
  /// and the `L`/`u`/`f`-style suffixes.
  int _scanNumber(String code, int start) {
    var i = start;
    if (code[i] == '0' &&
        i + 1 < code.length &&
        (code[i + 1] == 'x' || code[i + 1] == 'X')) {
      i += 2;
      while (i < code.length && (_isHexDigit(code[i]) || code[i] == '_')) {
        i++;
      }
    } else if (code[i] == '0' &&
        i + 1 < code.length &&
        (code[i + 1] == 'b' || code[i + 1] == 'B')) {
      i += 2;
      while (i < code.length &&
          (code[i] == '0' || code[i] == '1' || code[i] == '_')) {
        i++;
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
    if (i < code.length && 'uUlLfF'.contains(code[i])) i++;
    return i;
  }

  // Kotlin identifiers are letters/underscore plus digits; `$` is legal
  // only inside string templates, never in a plain identifier.
  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
