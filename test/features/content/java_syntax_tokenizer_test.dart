// Unit tests for `JavaSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `typescript_syntax_tokenizer_test.dart`'s coverage plus Java's own
// lexical quirks: text blocks, primitive type keywords, and `$` in
// identifiers.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = JavaSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'public class Main { }';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes Java keywords and primitive types as whole words', () {
    const code = 'int volume = 3; if (ready) { return; }';
    final types = tokenizer.classify(code);
    for (final word in ['int', 'if', 'return']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('volume')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('ready')], SyntaxTokenType.identifier);
  });

  test('contextual keywords var and record are keyword-colored', () {
    const code = 'var x = 1; record Point(int x, int y) {}';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('var')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('record')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('Point')], SyntaxTokenType.identifier);
  });

  test('a // line comment runs to the end of the line, not past it', () {
    const code = '// note\nint x;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// note'.length], SyntaxTokenType.plain);
    expect(types[code.indexOf('int')], SyntaxTokenType.keyword);
  });

  test('a /* */ block comment is fully classified, Javadoc included', () {
    const code = '/** doc */ int x;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/** doc */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('int')], SyntaxTokenType.keyword);
  });

  test('a double-quoted string includes escaped quotes', () {
    const code = r'String s = "a \" b";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a text block is one string token spanning lines', () {
    const code = 'String sql = """\n  SELECT 1\n  """;';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"""');
    final end = code.lastIndexOf('"""') + 3;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    expect(types[end], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('String')], SyntaxTokenType.identifier);
  });

  test('an escaped triple quote does not close a text block', () {
    const code = 'String s = """\na \\""" b\n""";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"""');
    final end = code.lastIndexOf('"""') + 3;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
  });

  test('a bare underscore is keyword-colored (reserved since Java 9)', () {
    final types = tokenizer.classify('_ = 1;');
    expect(types[0], SyntaxTokenType.keyword);
  });

  test('a char literal with an escape is a string token', () {
    const code = r"char nl = '\n';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf('char')], SyntaxTokenType.keyword);
  });

  test('numeric literals (decimal, double, hex, separated, long) are '
      'number-colored', () {
    const code = 'int y = 42 + 3.14 + 0xFF + 1_000 + 8_100_000_000L;';
    final types = tokenizer.classify(code);
    for (final literal in ['42', '3.14', '0xFF', '1_000', '8_100_000_000L']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test(r'$ and _ are identifier characters', () {
    const code = r'int $cache_size = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(code.indexOf(r'$cache_size'), code.indexOf(' =')),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('punctuation/operators are classified per character', () {
    const code = '-> :: ? : ; { }';
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
public class Main {
    public static void main(String[] args) {
        var total = List.of(1, 2, 3).size();
        System.out.println("total: " + total); // prints a line
    }
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('public')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('Main')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('var')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('"total: "')], SyntaxTokenType.string);
    expect(types[code.indexOf('// prints')], SyntaxTokenType.comment);
  });

  test('SyntaxTokenizers.forLanguage resolves Java', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.java),
      isA<JavaSyntaxTokenizer>(),
    );
  });
}
