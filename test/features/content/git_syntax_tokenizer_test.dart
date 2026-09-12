// Unit tests for `GitSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's command display, mirroring
// the other per-language tokenizer tests plus Git's own quirks:
// hyphenated subcommands (`cat-file`), flag groups (`--amend`, `-nd`),
// ref spellings (`HEAD~1`, `HEAD^{tree}`, `stash@{0}`), and `#` comments.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = GitSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'git commit -m "Add README"';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('`git` and its subcommands are colored like keywords', () {
    const code = 'git commit -m "Add README"';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 3), everyElement(SyntaxTokenType.keyword));
    final commit = code.indexOf('commit');
    expect(
      types.sublist(commit, commit + 'commit'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('hyphenated subcommands are one keyword, not a hyphen plus a word', () {
    const code = 'git cat-file -p HEAD';
    final types = tokenizer.classify(code);
    final start = code.indexOf('cat-file');
    expect(
      types.sublist(start, start + 'cat-file'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final flag = code.indexOf('-p');
    expect(types[flag], SyntaxTokenType.operatorOrPunctuation);
  });

  test('flags read as single punctuation tokens', () {
    const code = 'git rebase --autosquash -i HEAD~4';
    final types = tokenizer.classify(code);
    final long = code.indexOf('--autosquash');
    expect(
      types.sublist(long, long + '--autosquash'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    final short = code.indexOf('-i');
    expect(types[short], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a flag does not swallow a following quoted string', () {
    const code = 'git log -S"login" --oneline';
    final types = tokenizer.classify(code);
    final flag = code.indexOf('-S');
    expect(types[flag], SyntaxTokenType.operatorOrPunctuation);
    expect(types[flag + 1], SyntaxTokenType.operatorOrPunctuation);
    final quote = code.indexOf('"login"');
    expect(
      types.sublist(quote, quote + '"login"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('double-quoted strings include their content', () {
    const code = 'git commit -m "Add login form"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"Add login form"');
    expect(
      types.sublist(start, start + '"Add login form"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('single-quoted strings stay one token', () {
    const code = "git tag -a v1.0.0 -m 'Release v1.0.0'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'Release v1.0.0'");
    expect(
      types.sublist(start, start + "'Release v1.0.0'".length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('`#` at the start of a word opens a comment', () {
    const code = '# set up hooks\ngit status';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# set up hooks'.length),
      everyElement(SyntaxTokenType.comment),
    );
    final git = code.indexOf('git');
    expect(types[git], SyntaxTokenType.keyword);
  });

  test(
    'relative refs keep `HEAD` an identifier and `~1` punctuation/number',
    () {
      const code = 'git reset --soft HEAD~1';
      final types = tokenizer.classify(code);
      final head = code.indexOf('HEAD');
      expect(
        types.sublist(head, head + 'HEAD'.length),
        everyElement(SyntaxTokenType.identifier),
      );
      expect(types[head + 4], SyntaxTokenType.operatorOrPunctuation);
      expect(types[head + 5], SyntaxTokenType.number);
    },
  );

  test('peeling syntax `HEAD^{tree}` is identifier plus punctuation', () {
    const code = 'git cat-file -p HEAD^{tree}';
    final types = tokenizer.classify(code);
    final head = code.indexOf('HEAD');
    expect(types[head], SyntaxTokenType.identifier);
    expect(types[head + 4], SyntaxTokenType.operatorOrPunctuation);
    expect(types[head + 5], SyntaxTokenType.operatorOrPunctuation);
    final tree = code.indexOf('tree');
    expect(
      types.sublist(tree, tree + 4),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('`HEAD:README.md` keeps the path an identifier', () {
    const code = 'git cat-file -p HEAD:README.md';
    final types = tokenizer.classify(code);
    final readme = code.indexOf('README');
    expect(
      types.sublist(readme, readme + 'README.md'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('`refs/heads/main` colors slashes as punctuation', () {
    const code = 'git update-ref refs/heads/checkpoint HEAD~1';
    final types = tokenizer.classify(code);
    final refs = code.indexOf('refs');
    expect(types[refs], SyntaxTokenType.identifier);
    expect(types[code.indexOf('/')], SyntaxTokenType.operatorOrPunctuation);
    final heads = code.indexOf('heads');
    expect(types[heads], SyntaxTokenType.identifier);
  });

  test('`stash@{0}` keeps the number colored', () {
    const code = 'git stash pop stash@{0}';
    final types = tokenizer.classify(code);
    final zero = code.indexOf('0');
    expect(types[zero], SyntaxTokenType.number);
    expect(types[code.indexOf('@{')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a format string is a string, its percent placeholders included', () {
    const code = 'git log --pretty=format:"%h %ad" --date=short';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"%h %ad"');
    expect(
      types.sublist(start, start + '"%h %ad"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('shell helpers used by the routes are keywords', () {
    const code = r'printf "#!/bin/sh\n" > .git/hooks/pre-commit';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    final dollar = code.indexOf('#!/bin');
    expect(types[dollar], SyntaxTokenType.string);
  });

  test('environment assignments keep the name an identifier', () {
    const code = 'GIT_SEQUENCE_EDITOR=: git rebase -i HEAD~2';
    final types = tokenizer.classify(code);
    final name = code.indexOf('GIT_SEQUENCE_EDITOR');
    expect(
      types.sublist(name, name + 'GIT_SEQUENCE_EDITOR'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    final git = code.indexOf('git');
    expect(types[git], SyntaxTokenType.keyword);
  });

  test('SyntaxTokenizers.forLanguage resolves Git', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.git),
      isA<GitSyntaxTokenizer>(),
    );
  });
}
