part of 'syntax_tokenizer.dart';

/// A single-pass lexer for Git command lines — same scope as
/// [BashSyntaxTokenizer]: just enough to color `#` comments, quoted
/// strings, `git` and its subcommands plus the shell helpers this catalog
/// uses (`cat`, `echo`, `printf`, `chmod`), numbers, and punctuation; it
/// never builds an AST and makes no attempt to tell a path from a ref.
class GitSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // The binary itself plus every subcommand in the catalog.
    'git', 'add', 'am', 'bisect', 'blame', 'branch', 'cat-file', 'checkout',
    'cherry-pick', 'clean', 'clone', 'commit', 'config', 'count-objects',
    'fetch', 'gc', 'hash-object', 'init', 'log', 'ls-files', 'ls-tree',
    'merge', 'pull', 'push', 'rebase', 'reflog', 'remote', 'reset',
    'restore', 'rev-parse', 'revert', 'show', 'show-ref', 'stash', 'status',
    'switch', 'symbolic-ref', 'tag', 'update-ref', 'worktree',
    // `git bisect` verbs.
    'start', 'good', 'bad', 'run',
    // Shell helpers used by the learning routes.
    'cat', 'chmod', 'echo', 'printf',
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

      // `#` opens a comment only at the start of a word — the shebang and
      // strings stay untouched.
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

      // A word that starts with `-` is a flag (`--amend`, `-nd`, `-1`) and
      // reads better as one punctuation token; a hyphen inside a word is
      // part of the subcommand name (`cat-file`).
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
}
