// Unit tests for `KotlinSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `java_syntax_tokenizer_test.dart`'s coverage plus Kotlin's own lexical
// quirks: nested block comments, triple-quoted raw strings, string
// templates, backticked identifiers, and `val`/`var`/`suspend`-style
// declaration modifiers.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = KotlinSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'fun main() { }';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes hard keywords as whole words', () {
    const code = 'val n = 1; if (ready) { when (n) { else -> return } }';
    final types = tokenizer.classify(code);
    for (final word in ['val', 'if', 'when', 'else', 'return']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('ready')], SyntaxTokenType.identifier);
  });

  test('declaration modifiers and soft keywords are keyword-colored', () {
    const code = 'data class User(val name: String); suspend fun load() {}';
    final types = tokenizer.classify(code);
    for (final word in ['data', 'class', 'val', 'suspend', 'fun']) {
      final start = code.indexOf(word);
      expect(types[start], SyntaxTokenType.keyword, reason: word);
    }
    expect(types[code.indexOf('User')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('String')], SyntaxTokenType.keyword);
  });

  test('a // line comment runs to the end of the line, not past it', () {
    const code = '// note\nval x = 1';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// note'.length], SyntaxTokenType.plain);
    expect(types[code.indexOf('val')], SyntaxTokenType.keyword);
  });

  test('block comments nest, so an inner close does not end them', () {
    const code = '/* a /* b */ c */ val x = 1';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/* a /* b */ c */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('val')], SyntaxTokenType.keyword);
  });

  test('a double-quoted string includes escaped quotes and templates', () {
    const code = r'val msg = "Hi \"$name\""';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf(r'$name')], SyntaxTokenType.string);
  });

  test('a triple-quoted raw string spans lines as one string token', () {
    const code = 'val sql = """\n  SELECT 1\n""" ';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"""');
    final end = code.lastIndexOf('"""') + 3;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    expect(types[end], SyntaxTokenType.plain);
  });

  test('a char literal with an escape is a string token', () {
    const code = r"val nl = '\n'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf('val')], SyntaxTokenType.keyword);
  });

  test('numeric literals (decimal, double, hex, binary, separated, '
      'suffixed) are number-colored', () {
    const code = 'val y = 42 + 3.14 + 0xFF + 0b1010 + 1_000 + 10L + 2.5f';
    final types = tokenizer.classify(code);
    for (final literal in [
      '42',
      '3.14',
      '0xFF',
      '0b1010',
      '1_000',
      '10L',
      '2.5f',
    ]) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('a backticked identifier is colored as an identifier', () {
    const code = 'val `fun name` = 1';
    final types = tokenizer.classify(code);
    final start = code.indexOf('`');
    final end = code.lastIndexOf('`');
    expect(
      types.sublist(start, end + 1),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('punctuation/operators are classified per character', () {
    const code = '-> ?: ?. :: !';
    final types = tokenizer.classify(code);
    for (var i = 0; i < code.length; i++) {
      if (code[i] == ' ') continue;
      expect(types[i], SyntaxTokenType.operatorOrPunctuation);
    }
    const loop = 'for (n in 1..3)';
    expect(
      tokenizer.classify(loop)[loop.indexOf('in')],
      SyntaxTokenType.keyword,
    );
  });

  test('whitespace stays plain', () {
    const code = 'a b';
    final types = tokenizer.classify(code);
    expect(types[1], SyntaxTokenType.plain);
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = '''
fun countEvens(limit: Int): Int {
    var count = 0
    for (n in 1..limit) {
        if (n % 2 == 0) {
            count++
        }
    }
    return count
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('fun')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('Int')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('countEvens')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('1..limit')], SyntaxTokenType.number);
    expect(types[code.indexOf('..')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('%')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('SyntaxTokenizers.forLanguage resolves Kotlin', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.kotlin),
      isA<KotlinSyntaxTokenizer>(),
    );
  });
}
