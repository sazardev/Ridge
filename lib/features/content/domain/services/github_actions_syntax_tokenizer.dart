part of 'syntax_tokenizer.dart';

/// A single-pass lexer for GitHub Actions workflow YAML — enough to color
/// `#` comments, quoted scalars, `${{ ... }}` expressions, YAML/GitHub
/// Actions keys and literals, numbers, list markers and `gh` flags; it
/// never builds an AST and makes no attempt to resolve contexts or
/// validate references (that's `actionlint`'s job, not a lexer's).
///
/// Two YAML-specific rules matter here: a `#` only starts a comment at the
/// start of a word (so `run: echo "a # b"` stays a command), and the
/// indented body of a `key: |`/`key: >` block scalar is one string up to
/// the dedent — except `${{ ... }}` spans, which stay highlighted because
/// GitHub expands them there too.
class GithubActionsSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // Workflow structure and step vocabulary.
    'name', 'on', 'jobs', 'steps', 'runs-on', 'uses', 'run', 'with', 'env',
    'if', 'needs', 'strategy', 'matrix', 'include', 'exclude', 'fail-fast',
    'max-parallel', 'permissions', 'secrets', 'outputs', 'concurrency',
    'group', 'cancel-in-progress', 'environment', 'url', 'services',
    'container', 'image', 'options', 'ports', 'defaults', 'shell',
    'working-directory', 'timeout-minutes', 'continue-on-error', 'id',
    'path', 'key', 'restore-keys', 'retention-days', 'if-no-files-found',
    'value', 'description', 'required', 'default', 'type', 'inputs',
    'using', 'composite', 'filter', 'filters', 'language', 'languages',
    'files', 'body', 'script', 'github-token', 'registry', 'username',
    'password', 'registry-url', 'package-manager-cache', 'tags', 'branches',
    'paths', 'paths-ignore', 'types', 'cron', 'schedule',
    'workflow_dispatch', 'workflow_call', 'workflow_run',
    'repository_dispatch', 'release', 'pull_request', 'push', 'run-name',
    'fail-on-severity', 'package-ecosystem', 'directory', 'interval',
    'groups', 'patterns', 'open-pull-requests-limit', 'version', 'updates',
    'subject-path', 'generate_release_notes', 'draft', 'platforms',
    'context', 'cache-from', 'cache-to', 'mode', 'images', 'role-to-assume',
    'aws-region', 'workload_identity_provider', 'service_account',
    'client-id', 'tenant-id', 'subscription-id', 'app-id', 'private-key',
    'event_type', 'repo', 'owner', 'pages', 'artifact', 'artifacts',
    'commit', 'branch', 'ref', 'token',
    // YAML literals.
    'true', 'false', 'null',
    // `gh` CLI vocabulary for the operations lessons.
    'gh', 'list', 'view', 'watch', 'rerun', 'download', 'delete', 'cancel',
    'status', 'failure', 'limit',
  };

  @override
  List<SyntaxTokenType> classify(String code) {
    var blockIndent = -1;
    final types = List<SyntaxTokenType>.filled(
      code.length,
      SyntaxTokenType.plain,
    );
    var i = 0;
    while (i < code.length) {
      if (i == 0 || code[i - 1] == '\n') {
        final lineEnd = code.indexOf('\n', i);
        final end = lineEnd == -1 ? code.length : lineEnd;
        final line = code.substring(i, end);
        final trimmed = line.trimLeft();
        final indent = line.length - trimmed.length;
        if (blockIndent >= 0 && (trimmed.isEmpty || indent > blockIndent)) {
          _fillBlockScalar(types, code, i, end);
          i = lineEnd == -1 ? end : end + 1;
          continue;
        }
        blockIndent = _blockScalarHeaderIndent(line);
      }

      final c = code[i];

      // `#` opens a comment only at the start of a word — quoted scalars
      // are consumed whole before this can fire on their contents.
      if (c == '#' && (i == 0 || _isWhitespace(code[i - 1]))) {
        final start = i;
        while (i < code.length && code[i] != '\n') {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.comment);
        continue;
      }

      // `${{ ... }}` gets the keyword color so expressions visibly stand
      // out from the plain text around them.
      if (c == r'$' && _peek(code, i + 1) == '{' && _peek(code, i + 2) == '{') {
        i = _markExpression(types, code, i, code.length);
        continue;
      }

      if (c == '"' || c == "'") {
        i = _fillQuoted(types, code, i);
        continue;
      }

      if (_isDigit(c)) {
        final start = i;
        while (i < code.length && _isNumberChar(code, i)) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.number);
        continue;
      }

      // A word starting with `-` and no space after it is a flag or a
      // list marker (`- run:`); it reads better as one punctuation token.
      if (c == '-' && (i == 0 || _isWhitespace(code[i - 1]))) {
        final start = i;
        while (i < code.length && _isIdentPart(code[i])) {
          i++;
        }
        _fill(types, start, i, SyntaxTokenType.operatorOrPunctuation);
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

  /// Fills a quoted scalar starting at [start], honoring `\"` escapes in
  /// double quotes and `''` escapes in single quotes, and keeps
  /// `${{ ... }}` spans highlighted inside it. Returns the index just
  /// past the closing quote (or the end of the string).
  int _fillQuoted(List<SyntaxTokenType> types, String code, int start) {
    final quote = code[start];
    var i = start + 1;
    while (i < code.length && code[i] != quote) {
      if (quote == '"' && code[i] == r'\' && i + 1 < code.length) {
        i += 2;
      } else if (quote == "'" && code[i] == "'" && _peek(code, i + 1) == "'") {
        i += 2;
      } else {
        i++;
      }
    }
    if (i < code.length) i++;
    _fill(types, start, i, SyntaxTokenType.string);
    _markExpressionsIn(types, code, start, i);
    return i;
  }

  /// Fills one `key: |`/`key: >` block-scalar body line as a string, with
  /// its `${{ ... }}` spans kept as keywords.
  void _fillBlockScalar(
    List<SyntaxTokenType> types,
    String code,
    int start,
    int end,
  ) {
    _fill(types, start, end, SyntaxTokenType.string);
    _markExpressionsIn(types, code, start, end);
  }

  /// Highlights every `${{ ... }}` inside [start], [end). Returns the
  /// index after the expression it just consumed (for the main loop).
  int _markExpression(
    List<SyntaxTokenType> types,
    String code,
    int start,
    int end,
  ) {
    final close = code.indexOf('}}', start + 3);
    final stop = close == -1 || close + 2 > end ? end : close + 2;
    _fill(types, start, stop, SyntaxTokenType.keyword);
    return stop;
  }

  void _markExpressionsIn(
    List<SyntaxTokenType> types,
    String code,
    int start,
    int end,
  ) {
    var j = start;
    while (j < end - 2) {
      if (code[j] == r'$' && code[j + 1] == '{' && code[j + 2] == '{') {
        j = _markExpression(types, code, j, end);
      } else {
        j++;
      }
    }
  }

  /// Returns the indentation of [line] when it opens a block scalar
  /// (`key: |`, `key: >-`, ...), or -1 otherwise.
  int _blockScalarHeaderIndent(String line) {
    final stripped = line.trimRight();
    if (stripped.isEmpty) return -1;
    final trimmed = stripped.trimLeft();
    if (trimmed.startsWith('#')) return -1;
    final colon = trimmed.indexOf(':');
    if (colon == -1) return -1;
    final rest = trimmed.substring(colon + 1).trim();
    if (rest.isEmpty) return -1;
    if (rest[0] != '|' && rest[0] != '>') return -1;
    for (var j = 1; j < rest.length; j++) {
      final c = rest[j];
      if (c != '-' && c != '+' && !_isDigit(c)) return -1;
    }
    return line.length - trimmed.length;
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

  bool _isNumberChar(String code, int i) {
    final c = code[i];
    if (_isDigit(c) || c == '_') return true;
    return c == '.' && _peek(code, i + 1) != null && _isDigit(code[i + 1]);
  }

  bool _isIdentStart(String c) =>
      c == '_' ||
      (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
      (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

  bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c) || c == '-';
}
