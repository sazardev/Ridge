// Unit tests for `HaskellSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's code display,
// mirroring `bash_syntax_tokenizer_test.dart`'s coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = HaskellSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code =
        'double :: Int -> Int\n'
        'double x = x * 2';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords and predeclared names as whole words', () {
    const code = 'iffy if map mapper';
    final types = tokenizer.classify(code);
    final iffyStart = code.indexOf('iffy');
    expect(
      types.sublist(iffyStart, iffyStart + 4),
      everyElement(SyntaxTokenType.identifier),
    );
    final ifStart = code.indexOf('if', iffyStart + 4);
    expect(types[ifStart], SyntaxTokenType.keyword);
    final mapStart = code.indexOf('map');
    expect(
      types.sublist(mapStart, mapStart + 3),
      everyElement(SyntaxTokenType.keyword),
    );
    final mapperStart = code.indexOf('mapper');
    expect(
      types.sublist(mapperStart, mapperStart + 6),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('a -- line comment runs to the end of the line, not past it', () {
    const code = '-- a comment\nx = 1';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '-- a comment'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['-- a comment'.length], isNot(SyntaxTokenType.comment));
    final xStart = code.indexOf('x = 1');
    expect(types[xStart], SyntaxTokenType.identifier);
  });

  test('two dashes followed by a symbol are an operator, not a comment', () {
    const code = 'x --> y';
    final types = tokenizer.classify(code);
    final start = code.indexOf('-->');
    expect(
      types.sublist(start, start + 3),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    expect(types, isNot(contains(SyntaxTokenType.comment)));
  });

  test('a block comment is fully classified, including nested ones', () {
    const code = '{- outer {- inner -} still -}x = 1';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, code.indexOf('x = 1')),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('x = 1')], SyntaxTokenType.identifier);
  });

  test('a double-quoted string includes escaped quotes', () {
    const code = r'greeting = "a \" b"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('a character literal is a string token', () {
    const code = r"newline = '\n'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('an apostrophe inside an identifier stays an identifier', () {
    const code = "sum' xs = sum xs";
    final types = tokenizer.classify(code);
    final start = code.indexOf("sum'");
    expect(
      types.sublist(start, start + "sum'".length),
      everyElement(SyntaxTokenType.identifier),
    );
    final sumStart = code.indexOf('sum xs');
    expect(types[sumStart], SyntaxTokenType.keyword);
  });

  test('numeric literals are number-colored', () {
    const code = 'x = 42 + 3 + 0xFF';
    final types = tokenizer.classify(code);
    final first = code.indexOf('42');
    expect(
      types.sublist(first, first + 2),
      everyElement(SyntaxTokenType.number),
    );
    final hex = code.indexOf('0xFF');
    expect(types.sublist(hex, hex + 4), everyElement(SyntaxTokenType.number));
  });

  test('punctuation/operators are classified per character', () {
    const code = r'-> <- :: | \ => ++';
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
-- absolute value
absolute :: Int -> Int
absolute n = if n < 0 then -n else n''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[0], SyntaxTokenType.comment);
    final ifStart = code.indexOf('if');
    expect(types[ifStart], SyntaxTokenType.keyword);
    final intStart = code.indexOf('Int ->');
    expect(types[intStart], SyntaxTokenType.keyword);
    final absoluteStart = code.lastIndexOf('absolute');
    expect(types[absoluteStart], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves Haskell', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.haskell),
      isA<HaskellSyntaxTokenizer>(),
    );
  });
}
