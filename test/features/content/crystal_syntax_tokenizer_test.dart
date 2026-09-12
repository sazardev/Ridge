// Unit tests for `CrystalSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's code display,
// mirroring `c_syntax_tokenizer_test.dart`'s coverage. Crystal's comment
// marker is `#` (never `//`, which is integer division), so these tests
// pin that difference down too.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = CrystalSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'answer = 42';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'if iffy end';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    expect(types.sublist(3, 7), everyElement(SyntaxTokenType.identifier));
    expect(types.sublist(8, 11), everyElement(SyntaxTokenType.keyword));
  });

  test('core types and property macros are keyword-colored', () {
    const code = 'getter count : Int32';
    final types = tokenizer.classify(code);
    for (final word in ['getter', 'Int32']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('count')], SyntaxTokenType.identifier);
  });

  test('a # line comment runs to the end of the line, not past it', () {
    const code = '# a note\nputs "x"';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# a note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['# a note'.length], isNot(SyntaxTokenType.comment));
    expect(types[code.indexOf('puts')], SyntaxTokenType.identifier);
  });

  test('a trailing # comment after code is still a comment', () {
    const code = '3.times { } # loop';
    final types = tokenizer.classify(code);
    final start = code.indexOf('#');
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.comment),
    );
  });

  test('a // is integer division, never a comment', () {
    const code = 'mid = (low + high) // 2';
    final types = tokenizer.classify(code);
    final start = code.indexOf('//');
    expect(types[start], SyntaxTokenType.operatorOrPunctuation);
    expect(types[start + 1], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('2')], SyntaxTokenType.number);
  });

  test('a double-quoted string includes escapes and interpolation', () {
    const code = r'puts "say \"hi\" #{name}"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a # inside a string is not a comment', () {
    const code = 'puts "a # b"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a character literal is a string token, escapes included', () {
    const code = r"letter = '\n'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('numeric literals are number-colored', () {
    const code = 'a = 42 + 3.14 + 1_000 + 0xFF';
    final types = tokenizer.classify(code);
    for (final literal in ['42', '3.14', '1_000', '0xFF']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('hex, binary, octal, and suffixed literals are number-colored', () {
    const code = 'a = 0xAB_CD + 0b1010 + 0o17 + 1_i64';
    final types = tokenizer.classify(code);
    for (final literal in ['0xAB_CD', '0b1010', '0o17', '1_i64']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('a digit-dot range keeps both dots as punctuation', () {
    const code = '1..5';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.number);
    expect(types[1], SyntaxTokenType.operatorOrPunctuation);
    expect(types[2], SyntaxTokenType.operatorOrPunctuation);
    expect(types[3], SyntaxTokenType.number);
  });

  test('a digit-dot exclusive range keeps all three dots as punctuation', () {
    const code = '1...5';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.number);
    for (var i = 1; i <= 3; i++) {
      expect(types[i], SyntaxTokenType.operatorOrPunctuation, reason: '$i');
    }
    expect(types[4], SyntaxTokenType.number);
  });

  test('a dot-call on an integer keeps its dot as punctuation', () {
    const code = '3.times';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.number);
    expect(types[1], SyntaxTokenType.operatorOrPunctuation);
    expect(types.sublist(2), everyElement(SyntaxTokenType.identifier));
  });

  test('a begin-at slice after an integer is punctuation', () {
    const code = 'items[1..]';
    final types = tokenizer.classify(code);
    final start = code.indexOf('1');
    expect(types[start], SyntaxTokenType.number);
    expect(types[start + 1], SyntaxTokenType.operatorOrPunctuation);
    expect(types[start + 2], SyntaxTokenType.operatorOrPunctuation);
  });

  test('punctuation/operators are classified per character', () {
    const code = '.. => ? <<';
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
class Counter
  getter count

  def initialize(@count = 0)
  end

  def increment
    @count += 1 # bump
  end
end''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('class')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('getter')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('def initialize')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('# bump')], SyntaxTokenType.comment);
    expect(types[code.indexOf('Counter')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('0')], SyntaxTokenType.number);
  });

  test('SyntaxTokenizers.forLanguage resolves Crystal', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.crystal),
      isA<CrystalSyntaxTokenizer>(),
    );
  });
}
