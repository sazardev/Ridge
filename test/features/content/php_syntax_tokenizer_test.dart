// Unit tests for `PhpSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring the
// other per-language tokenizer tests plus PHP's own lexical quirks:
// `<?php` tags, `$variables` and `${...}`, heredoc/nowdoc strings, the
// `#` comment vs `#[` attribute, and `.`-aware numbers.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = PhpSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = '<?php echo "hi";';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('PHP opening and closing tags are colored like keywords', () {
    const code = '<?php echo "hi"; ?>';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '<?php'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf('echo')], SyntaxTokenType.keyword);
    final close = code.indexOf('?>');
    expect(
      types.sublist(close, close + 2),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('the shorthand `<?=` tag is a keyword too', () {
    const code = r'<?= $name ?>';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '<?='.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('recognizes PHP keywords and built-in types as whole words', () {
    const code = r'function add(int $a): void { return; }';
    final types = tokenizer.classify(code);
    for (final word in ['function', 'int', 'void', 'return']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('add')], SyntaxTokenType.identifier);
  });

  test('a // line comment runs to the end of the line, not past it', () {
    const code = '// note\nif (true) { }';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// note'.length], SyntaxTokenType.plain);
    expect(types[code.indexOf('if')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('true')], SyntaxTokenType.keyword);
  });

  test('a # line comment stops before a #[ attribute', () {
    const code = '# note\n#[Route]';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('#[')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a /* */ block comment is fully classified', () {
    const code = '/* doc */ function f() { }';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/* doc */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('function')], SyntaxTokenType.keyword);
  });

  test('a single-quoted string escapes only the quote and backslash', () {
    const code = r"$a = 'it\'s';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test(r'a double-quoted string keeps its $interpolation inside the token', () {
    const code = r'echo "$name works as a {$role}.";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf('echo')], SyntaxTokenType.keyword);
  });

  test('a heredoc body and its terminator are one string token', () {
    const code = '<<<TEXT\nHello, \$name!\nTEXT;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, code.length - 1),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('a nowdoc body is one string token as well', () {
    const code = "<<<'TEXT'\nno \$interpolation\nTEXT;";
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, code.length - 1),
      everyElement(SyntaxTokenType.string),
    );
  });

  test(r'$variables and ${...} are colored like keywords', () {
    const code = r'$_SESSION["visits"] = ${expr};';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, r'$_SESSION'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(
      types.sublist(code.indexOf(r'${'), code.indexOf('}') + 1),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('numbers cover hex, binary, separators, and floats', () {
    const code = '0x1F 0b101 1_000 19.99 1e3';
    final types = tokenizer.classify(code);
    for (final number in ['0x1F', '0b101', '1_000', '19.99', '1e3']) {
      final start = code.indexOf(number);
      expect(
        types.sublist(start, start + number.length),
        everyElement(SyntaxTokenType.number),
        reason: number,
      );
    }
  });

  test('object and nullsafe operators are punctuation', () {
    const code = r'$user->name; $user?->email; User::class;';
    final types = tokenizer.classify(code);
    for (final operator in ['->', '?->', '::']) {
      final start = code.indexOf(operator);
      expect(
        types.sublist(start, start + operator.length),
        everyElement(SyntaxTokenType.operatorOrPunctuation),
        reason: operator,
      );
    }
  });

  test('forLanguage resolves the PHP tokenizer', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.php),
      isA<PhpSyntaxTokenizer>(),
    );
  });
}
