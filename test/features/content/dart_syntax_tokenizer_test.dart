// Unit tests for `DartSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `kotlin_syntax_tokenizer_test.dart`'s coverage. Dart's block comments do
// NOT nest, raw strings take an `r` prefix, interpolation stays inside the
// string token, and a digit followed by a dot is a member access, so those
// differences are pinned down here.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = DartSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'final answer = 42';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'class Classic {}';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'class'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(
      types.sublist(6, 13),
      everyElement(SyntaxTokenType.identifier),
      reason: 'Classic is not the keyword class',
    );
  });

  test('standard-library type names are keyword-colored', () {
    const code = 'Future<String> fetchName() async {}';
    final types = tokenizer.classify(code);
    for (final name in ['Future', 'String']) {
      final start = code.indexOf(name);
      expect(
        types.sublist(start, start + name.length),
        everyElement(SyntaxTokenType.keyword),
        reason: '$name should read as a type',
      );
    }
  });

  test('a // comment runs to the end of the line, not past it', () {
    const code = '// note\nfinal x = 1';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 6), everyElement(SyntaxTokenType.comment));
    expect(types[code.indexOf('x')], SyntaxTokenType.identifier);
  });

  test(
    'a block comment closes at the FIRST */ — Dart comments do not nest',
    () {
      const code = '/* outer /* inner */ class';
      final types = tokenizer.classify(code);
      final end = code.indexOf(' class');
      expect(
        types.sublist(0, end),
        everyElement(SyntaxTokenType.comment),
        reason: 'everything through the first */ is one comment',
      );
      expect(
        types[code.indexOf('class')],
        SyntaxTokenType.keyword,
        reason: 'code after the comment is classified normally',
      );
    },
  );

  test('a string with interpolation is one string token', () {
    const code = r"print('$name is ${user.age}');";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('an escaped quote does not end the string early', () {
    const code = r"final quote = 'don\'t';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a raw string ignores backslash escapes', () {
    const code = r"final path = r'C:\temp\new';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("r'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a triple-quoted string spans lines as one string token', () {
    const code = "final text = '''\nline one\nline two\n''';\nprint(text);";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'''");
    final end = code.lastIndexOf("'''");
    expect(
      types.sublist(start, end + "'''".length),
      everyElement(SyntaxTokenType.string),
    );
    expect(types[code.lastIndexOf('text')], SyntaxTokenType.identifier);
  });

  test('numbers accept separators and hex literals', () {
    const code = 'final mask = 0xFF_00;';
    final types = tokenizer.classify(code);
    final start = code.indexOf('0xFF_00');
    expect(
      types.sublist(start, start + '0xFF_00'.length),
      everyElement(SyntaxTokenType.number),
    );
  });

  test('a digit followed by a dot is a member access, not a number', () {
    const code = 'print(1.isEven);';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('1')], SyntaxTokenType.number);
    expect(types[code.indexOf('.')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('isEven')], SyntaxTokenType.identifier);
  });

  test('the dispatcher resolves Dart to this tokenizer', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.dart),
      isA<DartSyntaxTokenizer>(),
    );
  });
}
