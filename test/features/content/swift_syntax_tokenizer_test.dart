// Unit tests for `SwiftSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `crystal_syntax_tokenizer_test.dart`'s coverage. Swift's block comments
// nest, raw strings can embed quotes behind `#` runs, and `$0` is a
// identifier-like shorthand, so those differences are pinned down here.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = SwiftSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'let answer = 42';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'let letter = 1';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 3), everyElement(SyntaxTokenType.keyword));
    expect(
      types.sublist(4, 10),
      everyElement(SyntaxTokenType.identifier),
      reason: 'letter is not the keyword let',
    );
    expect(types[code.indexOf('1')], SyntaxTokenType.number);
  });

  test('standard-library type names are keyword-colored', () {
    const code = 'let name: String = "Ada"';
    final types = tokenizer.classify(code);
    final start = code.indexOf('String');
    expect(
      types.sublist(start, start + 'String'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a // comment runs to the end of the line, not past it', () {
    const code = 'let x = 1 // note\nlet y = 2';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(code.indexOf('//'), code.indexOf('\n')),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('y')], SyntaxTokenType.identifier);
  });

  test('block comments nest instead of closing at the first */', () {
    const code = '/* outer /* inner */ still */ let x = 1';
    final types = tokenizer.classify(code);
    final end = code.indexOf(' let');
    expect(
      types.sublist(0, end),
      everyElement(SyntaxTokenType.comment),
      reason: 'the nested comment must close only at the second */',
    );
    expect(types[code.indexOf('x')], SyntaxTokenType.identifier);
  });

  test('a string with interpolation is one string token', () {
    const code = r'print("Hello, \(name)!")';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('an escaped quote does not end the string early', () {
    const code = r'let quote = "say \"hi\""';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a multiline string spans lines as one string token', () {
    const code = 'let text = """\nline one\nline two\n"""\nprint(text)';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"""');
    final end = code.lastIndexOf('"""') + 3;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf('print')], SyntaxTokenType.identifier);
  });

  test('a raw string can embed quotes behind its hash fence', () {
    const code = 'let json = #"{"key": "value"}"#';
    final types = tokenizer.classify(code);
    final start = code.indexOf('#"');
    final end = code.lastIndexOf('"#') + 2;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
  });

  test('a # directive is colored as one keyword word', () {
    const code = '#if DEBUG\nprint("x")\n#endif';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 3), everyElement(SyntaxTokenType.keyword));
    expect(
      types.sublist(code.indexOf('#endif'), code.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('numeric literals are number-colored', () {
    const code = 'let a = 42 + 3.14 + 1_000 + 0xFF';
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

  test('binary and octal literals are number-colored', () {
    const code = 'let flags = 0b1010 + 0o17';
    final types = tokenizer.classify(code);
    for (final literal in ['0b1010', '0o17']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('range dots after a number stay punctuation', () {
    const code = '1...3';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.number);
    for (var i = 1; i <= 3; i++) {
      expect(types[i], SyntaxTokenType.operatorOrPunctuation, reason: '$i');
    }
    expect(types[4], SyntaxTokenType.number);
  });

  test('a dot-dot-bracket range keeps its dots as punctuation', () {
    const code = '0..<n';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.number);
    expect(types[1], SyntaxTokenType.operatorOrPunctuation);
    expect(types[2], SyntaxTokenType.operatorOrPunctuation);
    expect(types[3], SyntaxTokenType.operatorOrPunctuation);
    expect(types[4], SyntaxTokenType.identifier);
  });

  test('a shorthand closure argument is identifier-colored', () {
    const code = r'names.map { $0.uppercased() }';
    final types = tokenizer.classify(code);
    final start = code.indexOf(r'$0');
    expect(
      types.sublist(start, start + 2),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('punctuation/operators are classified per character', () {
    const code = '?? ?. -> @ [ ]';
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
struct Counter {
    var value: Int = 0

    mutating func increment(by amount: Int = 1) {
        value += amount // bump
    }
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('struct')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('mutating')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('func')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('// bump')], SyntaxTokenType.comment);
    expect(types[code.indexOf('Counter')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('0')], SyntaxTokenType.number);
  });

  test('SyntaxTokenizers.forLanguage resolves Swift', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.swift),
      isA<SwiftSyntaxTokenizer>(),
    );
  });
}
