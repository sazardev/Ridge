part of 'syntax_tokenizer.dart';

/// A single-pass lexer for PHP — same scope as [GoSyntaxTokenizer]: just
/// enough to color `<?php` tags, keywords, built-in types, `$variables`,
/// string literals (single-quoted, double-quoted, backtick, and
/// heredoc/nowdoc), comments (`//`, `#`, `/* */`), numbers, and
/// punctuation; it never builds an AST and never tries to tell a type
/// name from a variable name.
class PhpSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Reserved words.
    'abstract', 'and', 'array', 'as', 'break', 'callable', 'case', 'catch',
    'class', 'clone', 'const', 'continue', 'declare', 'default', 'do',
    'echo', 'else', 'elseif', 'empty', 'enddeclare', 'endfor', 'endforeach',
    'endif', 'endswitch', 'endwhile', 'enum', 'extends', 'final', 'finally',
    'fn', 'for', 'foreach', 'function', 'global', 'goto', 'if', 'implements',
    'include', 'include_once', 'instanceof', 'insteadof', 'interface',
    'isset', 'list', 'match', 'namespace', 'new', 'or', 'print', 'private',
    'protected', 'public', 'readonly', 'require', 'require_once', 'return',
    'static', 'switch', 'throw', 'trait', 'try', 'unset', 'use', 'var',
    'while', 'xor', 'yield',
    // Language constructs that read as structure in this catalog's code.
    'die', 'exit',
    // Literals.
    'false', 'null', 'true',
    // Type declarations — a distinct lexical category from keywords in
    // PHP, but colored the same: without these, ordinary code (whose
    // keywords are mostly `function`/`return`) reads as almost entirely
    // "plain" text.
    'bool', 'float', 'int', 'iterable', 'mixed', 'never', 'object',
    'parent', 'self', 'string', 'void',
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

      // `<?php` / `<?=` opening tags and the `?>` closing tag are
      // structure, colored like keywords.
      if (c == '<' && _peek(code, i + 1) == '?') {
        final start = i;
        i += 2;
        if (code.startsWith('php', i)) {
          i += 3;
        } else if (i < code.length && code[i] == '=') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.keyword);
        continue;
      }
      if (c == '?' && _peek(code, i + 1) == '>') {
        _fill(types, i, i + 2, SyntaxTokenType.keyword);
        i += 2;
        continue;
      }

      // `#` opens a comment, except `#[`, which starts an attribute.
      if (c == '#' && _peek(code, i + 1) != '[') {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

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

      // A heredoc `<<<ID` or nowdoc `<<<'ID'` is one string token: its
      // body runs until a line whose indentation is followed by the
      // closing identifier.
      if (c == '<' && _peek(code, i + 1) == '<' && _peek(code, i + 2) == '<') {
        final start = i;
        i += 3;
        var terminator = '';
        if (i < code.length && (code[i] == "'" || code[i] == '"')) {
          final quote = code[i];
          i++;
          final idStart = i;
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
          terminator = code.substring(idStart, i);
          if (i < code.length && code[i] == quote) i++;
        } else {
          final idStart = i;
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
          terminator = code.substring(idStart, i);
        }
        while (i < code.length) {
          while (i < code.length && code[i] != '\n') {
            i++;
          }
          if (i >= code.length) break;
          i++; // consume the newline
          var j = i;
          while (j < code.length && (code[j] == ' ' || code[j] == '\t')) {
            j++;
          }
          if (code.startsWith(terminator, j)) {
            i = j + terminator.length;
            break;
          }
        }
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // Single-quoted strings only escape the quote and the backslash.
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

      // Double-quoted and backtick strings honor backslash escapes; their
      // `$variables` stay inside the single string token.
      if (c == '"' || c == '`') {
        final start = i;
        final quote = c;
        i++;
        while (i < code.length && code[i] != quote) {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // `$name`, `$this`, and `${...}` get the keyword color so variables
      // visibly stand out from bare words.
      if (c == r'$') {
        final start = i;
        i++;
        if (i < code.length && code[i] == '{') {
          while (i < code.length && code[i] != '}') {
            i++;
          }
          if (i < code.length) i++;
        } else if (i < code.length && _isIdentStart(code[i])) {
          while (i < code.length && _isIdentPart(code[i])) {
            i++;
          }
        }
        _fill(types, start, i, SyntaxTokenType.keyword);
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
      c == 'x' ||
      c == 'X' ||
      c == 'b' ||
      c == 'B' ||
      c == 'o' ||
      c == 'O' ||
      c == 'e' ||
      c == 'E' ||
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
