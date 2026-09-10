part of 'syntax_tokenizer.dart';

/// A single-pass lexer for SQL (PostgreSQL flavor) — just enough to color
/// `--` line and `/* */` block comments, single-quoted strings, quoted
/// identifiers, keywords/functions, numbers, and punctuation; it never
/// builds an AST and makes no attempt to resolve a table from a column
/// name (that needs a catalog lookup, not lexing).
///
/// Keywords are matched case-insensitively: SQL itself is
/// case-insensitive, but the course teaches uppercase keywords as the
/// readable convention, so a learner typing `select` should still see it
/// highlighted as a keyword.
class SqlSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Core query clauses.
    'select', 'from', 'where', 'as', 'distinct', 'order', 'by', 'asc',
    'desc', 'nulls', 'first', 'last', 'limit', 'offset', 'group', 'having',
    'union', 'all', 'with', 'on', 'using', 'returning', 'values', 'into',
    'set',
    // Predicates and operators spelled as words.
    'and', 'or', 'not', 'in', 'between', 'like', 'ilike', 'is', 'null',
    'true', 'false', 'exists', 'case', 'when', 'then', 'else', 'end',
    // Joins.
    'join', 'inner', 'left', 'right', 'full', 'outer', 'cross',
    // Data modification.
    'insert', 'update', 'delete',
    // Schema definition.
    'create', 'table', 'database', 'drop', 'serial', 'primary', 'key',
    'unique', 'default', 'references', 'constraint', 'check',
    // Types.
    'integer', 'int', 'bigint', 'smallint', 'text', 'varchar', 'char',
    'numeric', 'decimal', 'real', 'boolean', 'date', 'timestamp',
    'timestamptz', 'interval', 'uuid', 'json', 'jsonb', 'serial4',
    'serial8', 'bytea',
    // Built-in functions, highlighted so a beginner can tell a call from
    // a bare column name.
    'count', 'sum', 'avg', 'min', 'max', 'round', 'abs', 'upper', 'lower',
    'length', 'trim', 'coalesce', 'concat', 'substring', 'now',
    'current_date', 'current_time', 'current_timestamp', 'extract', 'cast',
    'greatest', 'least',
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

      // `--` opens a line comment.
      if (c == '-' && _peek(code, i + 1) == '-') {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      // `/* ... */` opens a block comment (PostgreSQL also nests them;
      // this lexer tracks depth so an inner `/* */` does not end the
      // outer one early).
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

      // A single-quoted string literal; a doubled `''` is an escaped
      // quote, not the end of the literal.
      if (c == "'") {
        final start = i;
        i++;
        while (i < code.length) {
          if (code[i] == "'" && _peek(code, i + 1) == "'") {
            i += 2;
            continue;
          }
          if (code[i] == "'") {
            i++;
            break;
          }
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // A double-quoted identifier (`"order"` to reference a column whose
      // name collides with a keyword) — an identifier, not a string.
      if (c == '"') {
        final start = i;
        i++;
        while (i < code.length) {
          if (code[i] == '"' && _peek(code, i + 1) == '"') {
            i += 2;
            continue;
          }
          if (code[i] == '"') {
            i++;
            break;
          }
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.identifier);
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
          _keywords.contains(word.toLowerCase())
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

  bool _isNumberChar(String c) => _isDigit(c) || c == '.' || c == '_';

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c) || c == r'$';
}
