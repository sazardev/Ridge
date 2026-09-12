part of 'syntax_tokenizer.dart';

/// A single-pass lexer for C# — same scope as [GoSyntaxTokenizer]: just
/// enough to color keywords, built-in type names, string literals
/// (regular, verbatim `@"..."`, interpolated `$"..."`, and raw
/// `"""..."""`), character literals, comments, numbers, and punctuation;
/// it never builds an AST and never tries to tell a type name from a
/// variable name.
class CSharpSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Reserved words.
    'abstract', 'as', 'base', 'break', 'case', 'catch', 'checked',
    'class', 'const', 'continue', 'default', 'delegate', 'do', 'else',
    'enum', 'event', 'explicit', 'extern', 'finally', 'fixed', 'for',
    'foreach', 'goto', 'if', 'implicit', 'in', 'interface', 'internal',
    'is', 'lock', 'namespace', 'new', 'operator', 'out', 'override',
    'params', 'private', 'protected', 'public', 'readonly', 'ref',
    'return', 'sealed', 'sizeof', 'stackalloc', 'static', 'struct',
    'switch', 'this', 'throw', 'try', 'typeof', 'unchecked', 'unsafe',
    'using', 'virtual', 'volatile', 'while',
    // Contextual keywords that read as structure in this catalog's code
    // (`var`, `record`, `required`, `init`, `async`/`await`, LINQ query
    // syntax, and the pattern combinators `and`/`or`/`not`). A simple
    // lexer cannot know the context, so they are colored like keywords.
    'and', 'async', 'await', 'by', 'descending', 'equals', 'from', 'get',
    'group', 'init', 'into', 'join', 'let', 'nameof', 'not', 'on',
    'orderby', 'partial', 'record', 'remove', 'required', 'select',
    'set', 'var', 'when', 'where', 'with', 'yield',
    // Literals.
    'true', 'false', 'null',
    // Built-in value and reference types — a distinct lexical category
    // from keywords in C#, but colored the same: without these, ordinary
    // code (whose keywords are mostly `public`/`return`) reads as almost
    // entirely "plain" text.
    'bool', 'byte', 'sbyte', 'char', 'decimal', 'double', 'float',
    'int', 'uint', 'nint', 'nuint', 'long', 'ulong', 'short', 'ushort',
    'object', 'string', 'void', 'dynamic',
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

      // A raw string literal `"""..."""` may span lines and takes no
      // escapes, so it is detected before every other string form.
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

      // Interpolated (`$"`), verbatim (`@"`), and interpolated-verbatim
      // (`$@"` / `@$"`) forms: the whole literal is one string token, so
      // the `{...}` holes are not split apart.
      final prefixLength = _stringPrefixLength(code, i);
      if (prefixLength > 0) {
        final start = i;
        final verbatim =
            code[i] == '@' || (i + 1 < code.length && code[i + 1] == '@');
        i += prefixLength + 1;
        while (i < code.length) {
          if (verbatim && code[i] == '"' && _peek(code, i + 1) == '"') {
            i += 2; // a doubled quote is an escaped quote, not the end
            continue;
          }
          if (!verbatim && code[i] == r'\' && i + 1 < code.length) {
            i += 2;
            continue;
          }
          if (code[i] == '"') {
            i++;
            break;
          }
          if (!verbatim && code[i] == '\n') {
            break; // a regular literal cannot span a line
          }
          i++;
        }
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

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isNumberChar(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.number);
        continue;
      }

      // A leading `@` marks a verbatim identifier (`@class`); it is part
      // of the identifier, not punctuation, and never a keyword.
      final next = _peek(code, i + 1);
      if (_isIdentStart(c) ||
          (c == '@' && next != null && _isIdentStart(next))) {
        final start = i;
        final verbatimIdentifier = c == '@';
        if (verbatimIdentifier) i++;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        final word = code.substring(start, i);
        _fill(
          types,
          start,
          i,
          !verbatimIdentifier && _keywords.contains(word)
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

  /// Returns the length of the string prefix at [index] (`$`, `@`, or
  /// `$@`/`@$`), or 0 when no string literal starts there.
  int _stringPrefixLength(String code, int index) {
    final first = code[index];
    final second = _peek(code, index + 1);
    final third = _peek(code, index + 2);
    if (first == r'$' && second == '"') return 1;
    if (first == '@' && second == '"') return 1;
    if (first == r'$' && second == '@' && third == '"') return 2;
    if (first == '@' && second == r'$' && third == '"') return 2;
    return 0;
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
      c == 'x' ||
      c == 'X' ||
      c == 'b' ||
      c == 'B' ||
      c == 'e' ||
      c == 'E' ||
      c == 'u' ||
      c == 'U' ||
      c == 'l' ||
      c == 'L' ||
      c == 'f' ||
      c == 'F' ||
      c == 'd' ||
      c == 'D' ||
      c == 'm' ||
      c == 'M' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  // `_` is a valid identifier character (and the discard); `$` is not.
  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
