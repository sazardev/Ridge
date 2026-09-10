import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';

part 'rust_syntax_tokenizer.dart';
part 'sql_syntax_tokenizer.dart';

/// Classifies every character of a source-code string for syntax
/// highlighting (SPEC.md-adjacent presentation concern, not itself part
/// of SPEC — a per-language capability, mirroring how [ProgrammingLanguage]
/// itself is designed so a second language is a new case, never a
/// redesign).
abstract interface class SyntaxTokenizer {
  /// Returns one [SyntaxTokenType] per character of [code] — the
  /// returned list's length always exactly equals `code.length`.
  List<SyntaxTokenType> classify(String code);
}

/// Resolves the right [SyntaxTokenizer] for a [ProgrammingLanguage].
abstract final class SyntaxTokenizers {
  /// The tokenizer for [language].
  static SyntaxTokenizer forLanguage(ProgrammingLanguage language) =>
      switch (language) {
        ProgrammingLanguage.go => const GoSyntaxTokenizer(),
        ProgrammingLanguage.bash => const BashSyntaxTokenizer(),
        ProgrammingLanguage.sql => const SqlSyntaxTokenizer(),
        ProgrammingLanguage.rust => const RustSyntaxTokenizer(),
      };
}

/// A single-pass lexer for Go — just enough to color keywords, strings,
/// comments, numbers, and punctuation; it never builds an AST and never
/// tries to tell a type name from a variable name (that needs semantic
/// analysis, not lexing).
class GoSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    'break', 'case', 'chan', 'const', 'continue', 'default', 'defer',
    'else', 'fallthrough', 'for', 'func', 'go', 'goto', 'if', 'import',
    'interface', 'map', 'package', 'range', 'return', 'select', 'struct',
    'switch', 'type', 'var',
    // Predeclared identifiers conventionally highlighted like keywords.
    'true', 'false', 'nil', 'iota',
    // Predeclared types — a distinct lexical category from keywords in Go,
    // but colored the same: without these, ordinary code (whose keywords
    // are mostly `func`/`return`) reads as almost entirely "plain" text.
    'bool', 'string', 'error', 'byte', 'rune',
    'int', 'int8', 'int16', 'int32', 'int64',
    'uint', 'uint8', 'uint16', 'uint32', 'uint64', 'uintptr',
    'float32', 'float64', 'complex64', 'complex128',
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

      if (c == '`') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '`') {
          i++;
        }
        if (i < code.length) i++;
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
      (c.toLowerCase().codeUnitAt(0) >= 0x61 &&
          c.toLowerCase().codeUnitAt(0) <= 0x66); // a-f, for hex literals

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}

/// A single-pass lexer for Bash — just enough to color `#` comments,
/// quoted strings, `$variable`/`${...}` expansions, reserved words and
/// common builtins, numbers, and punctuation; it never builds an AST and
/// makes no attempt to tell a command name from an argument.
class BashSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Reserved words.
    'if', 'then', 'else', 'elif', 'fi', 'for', 'in', 'do', 'done',
    'while', 'until', 'case', 'esac', 'function', 'select', 'time',
    // Builtins and ubiquitous commands, highlighted so a beginner can
    // tell structure (`if`, `for`) from the words around it.
    'alias', 'cd', 'command', 'continue', 'declare', 'echo', 'eval',
    'exec', 'exit', 'export', 'false', 'kill', 'local', 'printf',
    'pwd', 'read', 'readonly', 'return', 'set', 'shift', 'source',
    'test', 'trap', 'true', 'type', 'typeset', 'unset', 'wait',
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

      // `#` opens a comment only at the start of a word — `echo a#b`
      // keeps the `#` literal, `echo a # b` starts a comment.
      if (c == '#' && (i == 0 || _isWhitespace(code[i - 1]))) {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      // `$'...'` ANSI-C quoting and `$"..."` locale strings: the `$`
      // plus the whole quoted literal reads as one string.
      if (c == r'$' &&
          i + 1 < code.length &&
          (code[i + 1] == "'" || code[i + 1] == '"')) {
        final start = i;
        final quote = code[i + 1];
        i += 2;
        while (i < code.length && code[i] != quote) {
          i += (quote == '"' && code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == "'") {
        final start = i;
        i++;
        while (i < code.length && code[i] != "'") {
          i++;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      if (c == '"') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '"') {
          i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // Backquotes are legacy command substitution; colored like a
      // string since everything between them is shell text.
      if (c == '`') {
        final start = i;
        i++;
        while (i < code.length && code[i] != '`') {
          i++;
        }
        if (i < code.length) i++;
        _fill(types, start, i, SyntaxTokenType.string);
        continue;
      }

      // `$name`, `${...}`, `$1`, `$?`, `$@` — expansions get the keyword
      // color so variables visibly stand out from bare words.
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
        } else if (i < code.length) {
          i++; // `$?`, `$#`, `$@`, `$$`, ...
        }
        _fill(types, start, i, SyntaxTokenType.keyword);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isDigit(code[i])) {
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

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
}
