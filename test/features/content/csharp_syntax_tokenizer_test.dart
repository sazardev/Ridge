// Unit tests for `CSharpSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `java_syntax_tokenizer_test.dart`'s coverage plus C#'s own lexical
// quirks: verbatim strings, interpolated strings, raw string literals,
// suffix-heavy numbers, and `@`-prefixed identifiers.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = CSharpSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'public class Program { }';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes C# keywords and built-in types as whole words', () {
    const code = 'string name = "x"; if (ready) { return; }';
    final types = tokenizer.classify(code);
    for (final word in ['string', 'if', 'return']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('name')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('ready')], SyntaxTokenType.identifier);
  });

  test('contextual keywords read as keywords', () {
    const code = 'var x = 1; record Point(int X); public required string Name;';
    final types = tokenizer.classify(code);
    for (final word in ['var', 'record', 'required']) {
      expect(types[code.indexOf(word)], SyntaxTokenType.keyword, reason: word);
    }
    expect(types[code.indexOf('Point')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('Name')], SyntaxTokenType.identifier);
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

  test('a /* */ block comment is fully classified', () {
    const code = '/* doc */ int x;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/* doc */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('int')], SyntaxTokenType.keyword);
  });

  test('a double-quoted string includes escaped quotes', () {
    const code = r'string s = "a \" b";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a verbatim string keeps backslashes and doubles quotes', () {
    const code = r'string path = @"C:\temp"; string q = @"a ""b"" c";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('@"');
    final end = code.indexOf(';', start);
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    final secondStart = code.indexOf('@"', start + 1);
    final secondEnd = code.indexOf(';', secondStart);
    expect(
      types.sublist(secondStart, secondEnd),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('an interpolated string is one string token, holes included', () {
    const code = r'string message = $"total: {count}";';
    final types = tokenizer.classify(code);
    final start = code.indexOf(r'$"');
    final end = code.indexOf(';', start);
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
  });

  test('an interpolated verbatim string combines both prefixes', () {
    const code = r'string s = $@"C:\{name}";';
    final types = tokenizer.classify(code);
    final start = code.indexOf(r'$@"');
    final end = code.indexOf(';', start);
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
  });

  test('a raw string literal is one string token spanning lines', () {
    const code = 'string s = """\nline one\nline two\n""";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"""');
    final end = code.lastIndexOf('"""') + 3;
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    expect(types[end], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a char literal with an escape is a string token', () {
    const code = r"char nl = '\n';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[code.indexOf('char')], SyntaxTokenType.keyword);
  });

  test('numeric literals (decimal, double, hex, binary, separated, '
      'suffixed) are number-colored', () {
    const code =
        'var y = 42 + 3.14 + 0xFF + 0b1010 + 1_000 + 8_100_000_000L + '
        '19.99m + 2.5f;';
    final types = tokenizer.classify(code);
    for (final literal in [
      '42',
      '3.14',
      '0xFF',
      '0b1010',
      '1_000',
      '8_100_000_000L',
      '19.99m',
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

  test('an @-prefixed identifier is an identifier, never a keyword', () {
    const code = 'int @class = 1;';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('@class')], SyntaxTokenType.identifier);
    expect(
      types.sublist(code.indexOf('@class'), code.indexOf(' =')),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('pattern combinators and/or/not are keyword-colored', () {
    const code = 'bool ok = value is not null and value > 0;';
    final types = tokenizer.classify(code);
    for (final word in ['not', 'and']) {
      expect(types[code.indexOf(word)], SyntaxTokenType.keyword, reason: word);
    }
    expect(types[code.indexOf('value')], SyntaxTokenType.identifier);
  });

  test('punctuation/operators are classified per character', () {
    const code = '=> ?. ?? :: ; { }';
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
using System;

string? nickname = null;
string display = nickname ?? "anonymous";
Console.WriteLine($"{display} {nickname?.Length ?? 0}"); // prints a line''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('using')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('string?')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('"anonymous"')], SyntaxTokenType.string);
    expect(types[code.indexOf('// prints')], SyntaxTokenType.comment);
    expect(types[code.indexOf('Console')], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves C#', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.csharp),
      isA<CSharpSyntaxTokenizer>(),
    );
  });
}
