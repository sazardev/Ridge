// Unit tests for `BashSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `syntax_tokenizer_test.dart`'s Go coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = BashSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const dollar = r'$';
    const code =
        'if [ -f "${dollar}file" ]; then\n'
        '  echo "${dollar}file"\n'
        'fi';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes reserved words and builtins as whole words', () {
    const code = 'if iffy; then echo fi';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword); // if
    expect(types[1], SyntaxTokenType.keyword);
    final iffyStart = code.indexOf('iffy');
    expect(
      types.sublist(iffyStart, iffyStart + 4),
      everyElement(SyntaxTokenType.identifier),
    );
    final echoStart = code.indexOf('echo');
    expect(
      types.sublist(echoStart, echoStart + 4),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf('fi')], SyntaxTokenType.keyword);
  });

  test('a # at the start of a word opens a comment, mid-word does not', () {
    const code = 'echo a#b # real comment\nx';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('a#b') + 1], isNot(SyntaxTokenType.comment));
    final commentStart = code.indexOf('# real');
    expect(
      types.sublist(commentStart, commentStart + '# real comment'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('\n')], isNot(SyntaxTokenType.comment));
  });

  test('a shebang line is a comment', () {
    const code = '#!/bin/bash\necho hi';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '#!/bin/bash'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['#!/bin/bash\n'.length], SyntaxTokenType.keyword);
  });

  test(r'single quotes keep a string literal even with $ inside', () {
    const code = r"echo 'literal $HOME'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('double-quoted strings include escaped quotes', () {
    const code = r'echo "a \" b"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test(r'$expansions are keyword-colored: $name, ${...}, $1, $?', () {
    const code = r'echo $name ${other} $1 $?';
    final types = tokenizer.classify(code);
    final nameStart = code.indexOf(r'$name');
    expect(
      types.sublist(nameStart, nameStart + r'$name'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final bracedStart = code.indexOf(r'${other}');
    expect(
      types.sublist(bracedStart, bracedStart + r'${other}'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf(r'$1')], SyntaxTokenType.keyword);
    expect(types[code.indexOf(r'$?')], SyntaxTokenType.keyword);
    expect(types[code.indexOf(r'$?') + 1], SyntaxTokenType.keyword);
  });

  test('a backtick command substitution is string-colored', () {
    const code = 'echo `uname -r`';
    final types = tokenizer.classify(code);
    final start = code.indexOf('`');
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('numeric literals are number-colored', () {
    const code = 'sleep 42';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(code.indexOf('42'), code.indexOf('42') + 2),
      everyElement(SyntaxTokenType.number),
    );
  });

  test('punctuation/operators are classified per character', () {
    const code = '| & > < { } [ ] ( ) ;';
    final types = tokenizer.classify(code);
    for (var i = 0; i < code.length; i++) {
      if (code[i] == ' ') continue;
      expect(types[i], SyntaxTokenType.operatorOrPunctuation);
    }
  });

  test('whitespace stays plain', () {
    const code = 'a b';
    final types = tokenizer.classify(code);
    expect(types[1], SyntaxTokenType.plain);
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = '''
# count files in /usr/bin
if [ -d /usr/bin ]; then
  ls /usr/bin | wc -l
fi''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[0], SyntaxTokenType.comment);
    final ifStart = code.indexOf('if');
    expect(types[ifStart], SyntaxTokenType.keyword);
    final usrStart = code.lastIndexOf('/usr/bin');
    expect(types[usrStart], SyntaxTokenType.operatorOrPunctuation);
    final lsStart = code.indexOf('\n  ls') + 3;
    expect(types[lsStart], SyntaxTokenType.identifier);
    final wcStart = code.indexOf(' wc ') + 1;
    expect(types[wcStart], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves Bash', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.bash),
      isA<BashSyntaxTokenizer>(),
    );
  });
}
