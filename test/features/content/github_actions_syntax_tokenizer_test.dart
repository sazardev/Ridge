// Unit tests for `GithubActionsSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's YAML display, covering
// GitHub Actions' quirks: YAML keys with hyphens (`runs-on`), `${{ }}`
// expressions kept visible inside quoted and block scalars, `#` comments
// that only start at the start of a word, and the `gh` CLI vocabulary of
// the operations lessons.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = GithubActionsSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code =
        'name: CI\non: push\njobs:\n  hello:\n    runs-on: ubuntu-latest';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('workflow keys are colored like keywords', () {
    const code = 'name: CI\non: push\njobs:\n  hello:';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 4), everyElement(SyntaxTokenType.keyword));
    final on = code.indexOf('on');
    expect(types.sublist(on, on + 2), everyElement(SyntaxTokenType.keyword));
    expect(types[code.indexOf('jobs')], SyntaxTokenType.keyword);
  });

  test('hyphenated keys stay one keyword token', () {
    const code = 'runs-on: ubuntu-latest';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'runs-on'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final ubuntu = code.indexOf('ubuntu-latest');
    expect(
      types.sublist(ubuntu, ubuntu + 'ubuntu-latest'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test(
    'a step action reference is identifier and punctuation, not keyword',
    () {
      const code = 'uses: actions/checkout@v7';
      final types = tokenizer.classify(code);
      expect(types.sublist(0, 4), everyElement(SyntaxTokenType.keyword));
      final actions = code.indexOf('actions');
      expect(types[actions], SyntaxTokenType.identifier);
      expect(types[code.indexOf('/')], SyntaxTokenType.operatorOrPunctuation);
      expect(types[code.indexOf('@')], SyntaxTokenType.operatorOrPunctuation);
      final version = code.indexOf('v7');
      expect(types[version], SyntaxTokenType.identifier);
    },
  );

  test('YAML literals are keyword-colored', () {
    const code = 'continue-on-error: true\noptional: false\nempty: null';
    final types = tokenizer.classify(code);
    for (final word in ['true', 'false', 'null']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
  });

  test('a double-quoted scalar is one string token', () {
    const code = 'node-version: "24"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"24"');
    expect(
      types.sublist(start, start + 4),
      everyElement(SyntaxTokenType.string),
    );
  });

  test(
    'a single-quoted scalar keeps doubled-quote escapes inside one token',
    () {
      const code = "title: 'it''s here'";
      final types = tokenizer.classify(code);
      final start = code.indexOf("'it''s here'");
      expect(
        types.sublist(start, start + "it''s here".length + 2),
        everyElement(SyntaxTokenType.string),
      );
    },
  );

  test('an expression inside a quoted scalar stays highlighted', () {
    const code = r'run: echo "Building ${{ github.ref_name }}"';
    final types = tokenizer.classify(code);
    final expression = code.indexOf(r'${{');
    expect(
      types.sublist(expression, expression + r'${{'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf('"Building')], SyntaxTokenType.string);
  });

  test('a standalone expression is keyword-colored end to end', () {
    const code = r'key: cache-${{ runner.os }}-${{ hashFiles("x") }}';
    final types = tokenizer.classify(code);
    final first = code.indexOf(r'${{');
    final firstEnd = code.indexOf('}}') + 2;
    expect(
      types.sublist(first, firstEnd),
      everyElement(SyntaxTokenType.keyword),
    );
    final second = code.indexOf(r'${{', first + 3);
    expect(
      types.sublist(second, second + r'${{'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('`#` opens a comment only at the start of a word', () {
    const code = '# setup\nrun: echo a#b # comment';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# setup'.length),
      everyElement(SyntaxTokenType.comment),
    );
    final insideWord = code.indexOf('a#b');
    expect(types[insideWord + 1], isNot(SyntaxTokenType.comment));
    final afterSpace = code.indexOf('# comment');
    expect(
      types.sublist(afterSpace, afterSpace + '# comment'.length),
      everyElement(SyntaxTokenType.comment),
    );
  });

  test('a `#` inside a quoted scalar is not a comment', () {
    const code = 'run: echo "issue #123"';
    final types = tokenizer.classify(code);
    final hash = code.indexOf('#');
    expect(types[hash], SyntaxTokenType.string);
  });

  test('a block scalar body is one string up to the dedent', () {
    const code = 'run: |\n  echo "hi"\ntimeout-minutes: 5';
    final types = tokenizer.classify(code);
    final body = code.indexOf('echo "hi"');
    expect(
      types.sublist(body, body + 'echo "hi"'.length),
      everyElement(SyntaxTokenType.string),
    );
    final next = code.indexOf('timeout-minutes');
    expect(types[next], SyntaxTokenType.keyword);
  });

  test('an expression inside a block scalar is still highlighted', () {
    const code = r'''
run: |
  echo ${{ github.sha }}
  ls''';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('echo')], SyntaxTokenType.string);
    final expression = code.indexOf(r'${{');
    expect(
      types.sublist(expression, expression + r'${{ github.sha }}'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf('ls')], SyntaxTokenType.string);
  });

  test('numbers are colored separately from words', () {
    const code = 'ports:\n  - 5432:5432';
    final types = tokenizer.classify(code);
    final port = code.indexOf('5432');
    expect(types.sublist(port, port + 4), everyElement(SyntaxTokenType.number));
  });

  test('a list marker reads as punctuation, the step key as a keyword', () {
    const code = 'steps:\n  - run: echo yes';
    final types = tokenizer.classify(code);
    final dash = code.indexOf('- run');
    expect(types[dash], SyntaxTokenType.operatorOrPunctuation);
    expect(types[dash + 2], SyntaxTokenType.keyword);
  });

  test('`gh` subcommands and flags are colored for the operations lessons', () {
    const code = 'gh run list --limit 10';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 2), everyElement(SyntaxTokenType.keyword));
    final run = code.indexOf('run');
    expect(types.sublist(run, run + 3), everyElement(SyntaxTokenType.keyword));
    final list = code.indexOf('list');
    expect(
      types.sublist(list, list + 4),
      everyElement(SyntaxTokenType.keyword),
    );
    final flag = code.indexOf('--limit');
    expect(
      types.sublist(flag, flag + '--limit'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    final ten = code.indexOf('10');
    expect(types.sublist(ten, ten + 2), everyElement(SyntaxTokenType.number));
  });

  test('SyntaxTokenizers.forLanguage resolves GitHub Actions', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.githubActions),
      isA<GithubActionsSyntaxTokenizer>(),
    );
  });
}
