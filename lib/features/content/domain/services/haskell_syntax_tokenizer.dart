part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Haskell — same scope as [GoSyntaxTokenizer]:
/// just enough to color keywords, strings, characters, comments, numbers,
/// and punctuation, no AST. The Haskell-specific wrinkles are `--` line
/// comments, `{- ... -}` block comments (which Haskell allows to nest, so
/// this scans with a depth counter), and apostrophes: they are legal
/// inside identifiers (`sum'`), so the identifier scanner consumes them
/// while a standalone `'` opens a character literal.
class HaskellSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Reserved words / keywords.
    'as', 'case', 'class', 'data', 'default', 'deriving', 'do', 'else',
    'foreign', 'hiding', 'if', 'import', 'in', 'infix', 'infixl', 'infixr',
    'instance', 'let', 'mdo', 'module', 'newtype', 'of', 'proc',
    'qualified', 'rec', 'then', 'type', 'where',
    // Predeclared types and constructors conventionally highlighted like
    // keywords, mirroring GoSyntaxTokenizer's predeclared types and
    // PythonSyntaxTokenizer's builtins (without these, ordinary code
    // reads as almost entirely "plain" text).
    'Bool', 'Char', 'Double', 'Either', 'False', 'Float', 'Int', 'Integer',
    'Just', 'Left', 'Maybe', 'Nothing', 'Ordering', 'Right', 'String',
    'True', 'Word',
    // Common Prelude functions and values.
    'abs', 'and', 'concat', 'div', 'drop', 'elem', 'even', 'filter',
    'flip', 'foldl', "foldl'", 'foldr', 'fst', 'head', 'id', 'length',
    'lookup', 'map', 'max', 'maximum', 'maybe', 'min', 'minimum', 'mod',
    'not', 'notElem', 'null', 'odd', 'otherwise', 'print', 'product',
    'putStr', 'putStrLn', 'reverse', 'show', 'snd', 'splitAt', 'sum',
    'tail', 'take', 'uncurry', 'zip', 'zipWith',
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

      // Two dashes open a comment only when they cannot be part of a
      // longer operator lexeme: `-->` and `---` are operators, not
      // comments, because a legal operator only contains symbol
      // characters.
      if (c == '-' &&
          _peek(code, i + 1) == '-' &&
          !_isSymbolChar(_peek(code, i + 2))) {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      if (c == '{' && _peek(code, i + 1) == '-') {
        final start = i;
        var depth = 1;
        i += 2;
        while (i < code.length && depth > 0) {
          if (code[i] == '{' && _peek(code, i + 1) == '-') {
            depth++;
            i += 2;
          } else if (code[i] == '-' && _peek(code, i + 1) == '}') {
            depth--;
            i += 2;
          } else {
            i++;
          }
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

      if (c == "'") {
        final start = i;
        i++;
        if (i < code.length && code[i] == r'\' && i + 1 < code.length) {
          i += 2; // an escape like '\n' or '\''
          if (i < code.length && code[i] == "'") i++;
        } else {
          if (i < code.length) i++; // the character itself
          if (i < code.length && code[i] == "'") i++;
        }
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

  // The Haskell report's `symbol` characters — a run of dashes followed by
  // one of these is a single operator lexeme (`-->`), not a comment.
  static const _symbolChars = r'!#$%&*+./<=>?@\^|-~:';

  bool _isSymbolChar(String? c) => c != null && _symbolChars.contains(c);

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
          c.toLowerCase().codeUnitAt(0) <= 0x7A); // letters, e.g. hex/exponents

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  // An apostrophe is legal inside a Haskell identifier (`sum'`), so it is
  // an identifier part, not a separator.
  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c) || c == "'";
}
