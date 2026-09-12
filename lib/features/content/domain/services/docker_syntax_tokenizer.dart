part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Docker — Dockerfile instructions, `docker`
/// command lines, and Compose YAML — just enough to color instructions
/// and subcommands, `#` comments, quoted strings, `$VAR` expansions,
/// flags, and numbers; it never builds an AST and makes no attempt to
/// tell a service name from an image name.
class DockerSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Dockerfile instructions.
    'FROM', 'AS', 'RUN', 'CMD', 'ENTRYPOINT', 'COPY', 'ADD', 'WORKDIR',
    'ENV', 'ARG', 'EXPOSE', 'LABEL', 'USER', 'VOLUME', 'HEALTHCHECK',
    'SHELL', 'STOPSIGNAL', 'ONBUILD',
    // Docker CLI, its subcommands, and the compose lifecycle verbs.
    'docker', 'run', 'ps', 'images', 'pull', 'push', 'build', 'history',
    'tag', 'inspect', 'image', 'stop', 'start', 'rm', 'exec', 'logs',
    'volume', 'network', 'system', 'stats', 'top', 'diff', 'create',
    'export', 'import', 'save', 'load', 'login', 'logout', 'compose',
    'info', 'version', 'df', 'config', 'up', 'down',
    // Compose keys.
    'services', 'command', 'ports', 'environment', 'env_file',
    'depends_on', 'healthcheck', 'deploy', 'replicas', 'condition',
    'service_healthy', 'volumes', 'networks', 'restart',
    // Shell helpers used by the catalog's `RUN`/`CMD` lines.
    'sh', 'echo', 'cat', 'mkdir', 'touch', 'sleep', 'test', 'chmod',
    'true', 'id', 'adduser', 'httpd', 'wget', 'printenv', 'curl', 'ls',
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

      // `$name`, `${...}`, `$?` — expansions get the keyword color so
      // variables visibly stand out from literal values.
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
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.keyword);
        continue;
      }

      // A word that starts with `-` is a flag (`-t`, `--read-only`,
      // `--from=builder`) and reads better as one punctuation token; a
      // hyphen inside a word stays part of the identifier
      // (`hello-world`, `redis-cli`).
      if (c == '-' && (i == 0 || _isWhitespace(code[i - 1]))) {
        final start = i;
        while (i < code.length && _isFlagPart(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.operatorOrPunctuation);
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

      // Whitespace stays `plain` (the list's fill value); every other
      // single symbol is punctuation/an operator.
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
      c == '-' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c) || c == '.';

  bool _isFlagPart(String c) => _isIdentPart(c) || c == '=';
}
