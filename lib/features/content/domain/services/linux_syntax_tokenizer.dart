part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Linux command lines — same scope as
/// [GitSyntaxTokenizer]: just enough to color `#` comments, quoted
/// strings, the commands and `systemd`/`nft` verbs this catalog uses,
/// numbers, and punctuation; it never builds an AST and makes no attempt
/// to tell a path component from a flag argument beyond keeping a word
/// that follows `/` or `.` plain (`/dev/null` is a path, not a verb).
class LinuxSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Core commands and tools used by the learning routes.
    'cat', 'cd', 'chmod', 'chown', 'cp', 'curl', 'df', 'du', 'echo',
    'export', 'find', 'getent', 'getfacl', 'gpasswd', 'groupadd', 'head',
    'id', 'ip', 'journalctl', 'kill', 'ln', 'ls', 'lsblk', 'mkdir', 'mv',
    'nft', 'nice', 'pacman', 'passwd', 'pgrep', 'ping', 'printenv',
    'printf', 'ps', 'pwd', 'resolvectl', 'rm', 'setfacl', 'sleep', 'ss',
    'stat', 'sudo', 'systemctl', 'systemd-analyze', 'systemd-run', 'tail',
    'tar', 'tee', 'touch', 'tree', 'umask', 'uname', 'uptime', 'useradd',
    'userdel', 'visudo', 'whoami',
    // Subcommands and verbs (`systemctl`, `ip`, `nft`, `getent`).
    'accept', 'add', 'address', 'brief', 'chain', 'delete', 'dev', 'dport',
    'drop', 'enable', 'filter', 'get', 'hook', 'hosts', 'inet', 'input',
    'is-active', 'is-enabled', 'link', 'list', 'list-timers',
    'list-units', 'policy', 'priority', 'query', 'route', 'rule', 'show',
    'start', 'status', 'stop', 'table', 'type',
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

      // `#` opens a comment only at the start of a word (e.g. a future
      // shebang stays untouched).
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

      // A word that starts with `-` is a flag (`--no-pager`, `-lh`,
      // `--on-active=2`) and reads better as one punctuation token; a
      // hyphen inside a word is part of the command name
      // (`systemd-analyze`, `is-enabled`).
      if (c == '-' && (i == 0 || _isWhitespace(code[i - 1]))) {
        final start = i;
        while (i < code.length && _isIdentPart(code[i])) {
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
        // A word that follows a path separator or a dot is a file name
        // or path component (`/dev/null`, `/etc/passwd`, `demo.service`),
        // never a verb — even when it collides with a command name.
        final isPathComponent =
            start > 0 && (code[start - 1] == '/' || code[start - 1] == '.');
        _fill(
          types,
          start,
          i,
          _keywords.contains(word) && !isPathComponent
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
}
