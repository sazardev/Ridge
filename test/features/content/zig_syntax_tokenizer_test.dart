import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = ZigSyntaxTokenizer();

  test('classifies every UTF-16 code unit', () {
    const code = 'const emoji = "😀";';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    final start = code.indexOf('"');
    expect(
      types.sublist(start, code.length - 1),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('recognizes keywords and primitive types as whole words', () {
    const code =
        'const value: i32 = true; const generic: anytype = value; '
        'if (anytype_value == null) { return; }';
    final types = tokenizer.classify(code);
    for (final word in [
      'const',
      'i32',
      'true',
      'if',
      'anytype',
      'null',
      'return',
    ]) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('value')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('anytype_value')], SyntaxTokenType.identifier);
  });

  test('classifies a // comment through the end of its line', () {
    const code = '// note\nconst value = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// note'.length], SyntaxTokenType.plain);
    expect(types[code.indexOf('const')], SyntaxTokenType.keyword);
  });

  test('classifies Zig multiline string lines as one string', () {
    const code = r'''
const message =
    \\first line
    \\second line
;''';
    final types = tokenizer.classify(code);
    final start = code.indexOf(r'\\');
    final end = code.indexOf(';');
    expect(types.sublist(start, end), everyElement(SyntaxTokenType.string));
    expect(types[end], SyntaxTokenType.operatorOrPunctuation);
  });

  test('keeps escaped string and character literals intact', () {
    const code =
        r'''const text = "a \" b"; const nl = '\n'; const point = '\u{1F4A9}';''';
    final types = tokenizer.classify(code);
    for (final literal in [r'"a \" b"', r"'\n'", r"'\u{1F4A9}'"]) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.string),
        reason: literal,
      );
    }
  });

  test('classifies Zig number forms', () {
    const code =
        'const values = [_]u32{ 1_000, 0xFF_FFu8, 0b1010_0101, 0o755, '
        '1.2e-3, 42i32, 3.14f64, 0x1.a827999fcef32p+1022 };';
    final types = tokenizer.classify(code);
    for (final literal in [
      '1_000',
      '0xFF_FFu8',
      '0b1010_0101',
      '0o755',
      '1.2e-3',
      '42i32',
      '3.14f64',
      '0x1.a827999fcef32p+1022',
    ]) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('classifies escaped and builtin identifiers', () {
    const code =
        '''const @"identifier with spaces" = value_2; const std = @import("std");''';
    final types = tokenizer.classify(code);
    for (final identifier in [
      '@"identifier with spaces"',
      'value_2',
      '@import',
    ]) {
      final start = code.indexOf(identifier);
      expect(
        types.sublist(start, start + identifier.length),
        everyElement(SyntaxTokenType.identifier),
        reason: identifier,
      );
    }
  });

  test('classifies punctuation and operators per code unit', () {
    const code = r'(){}[]<>+-*/%=&|^~?:;,.@\';
    final types = tokenizer.classify(code);
    for (var i = 0; i < code.length; i++) {
      expect(types[i], SyntaxTokenType.operatorOrPunctuation, reason: '$i');
    }
  });

  test('SyntaxTokenizers.forLanguage resolves Zig', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.zig),
      isA<ZigSyntaxTokenizer>(),
    );
  });
}
