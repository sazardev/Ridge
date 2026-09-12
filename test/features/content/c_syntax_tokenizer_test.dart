// Unit tests for `CSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `typescript_syntax_tokenizer_test.dart`'s coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = CSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'int answer = 42;';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'if iffy {}';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    expect(types.sublist(3, 7), everyElement(SyntaxTokenType.identifier));
  });

  test('primitive types are keyword-colored', () {
    const code = 'unsigned long count = 0;';
    final types = tokenizer.classify(code);
    for (final type in ['unsigned', 'long']) {
      final start = code.indexOf(type);
      expect(
        types.sublist(start, start + type.length),
        everyElement(SyntaxTokenType.keyword),
        reason: type,
      );
    }
  });

  test('a // line comment runs to the end of the line, not past it', () {
    const code = '// a note\nint x = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// a note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// a note'.length], isNot(SyntaxTokenType.comment));
    expect(types[code.indexOf('int')], SyntaxTokenType.keyword);
  });

  test('a /* */ block comment is fully classified', () {
    const code = '/* note */ int x = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/* note */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('int')], SyntaxTokenType.keyword);
  });

  test('a double-quoted string includes escaped quotes', () {
    const code = r'printf("a \" b\n");';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a character literal is a string token, escapes included', () {
    const code = r"char c = '\n';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('numeric literals are number-colored', () {
    const code = 'int a = 42 + 0xFF + 3.14 + 100UL;';
    final types = tokenizer.classify(code);
    for (final literal in ['42', '0xFF', '3.14', '100UL']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('an #include colors the directive and the header name', () {
    const code = '#include <stdio.h>\nint main(void) { return 0; }';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '#include'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final headerStart = code.indexOf('<');
    expect(
      types.sublist(headerStart, headerStart + '<stdio.h>'.length),
      everyElement(SyntaxTokenType.string),
    );
    expect(types[code.indexOf('main')], SyntaxTokenType.identifier);
  });

  test('an indented directive still counts as a directive', () {
    const code = '  #define MAX 10';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.plain);
    expect(
      types.sublist(2, '#define'.length + 2),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a macro body keeps normal tokenization', () {
    const code = '#define SQUARE(x) ((x) * (x))';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '#define'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(types[code.indexOf('SQUARE')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('x)')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('*')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a # inside a string is not a directive', () {
    const code = 'printf("#1");';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('punctuation/operators are classified per character', () {
    const code = '-> & * % ;';
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
    const code = r'''
#include <stdio.h>

int main(void) {
    // greeting
    char *name = "Ridge";
    printf("Hello, %s!\n", name);
    return 0;
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('#include')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('int main')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('// greeting')], SyntaxTokenType.comment);
    expect(types[code.indexOf('"Ridge"')], SyntaxTokenType.string);
    expect(types[code.indexOf('printf')], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves C', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.c),
      isA<CSyntaxTokenizer>(),
    );
  });
}
