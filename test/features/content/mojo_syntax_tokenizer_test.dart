import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = MojoSyntaxTokenizer();

  test('classifies every UTF-16 code unit', () {
    const code = 'var label = "Mojo🔥"';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    final start = code.indexOf('"');
    expect(
      types.sublist(start, code.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('resolves through SyntaxTokenizers.forLanguage', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.mojo),
      isA<MojoSyntaxTokenizer>(),
    );
  });

  test('recognizes keywords and core types as whole words', () {
    const code =
        'def add(a: Int, b: Float64) -> Int: var v: SIMD[DType.float32, 4]';
    final types = tokenizer.classify(code);
    for (final word in ['def', 'Int', 'Float64', 'SIMD', 'DType', 'var']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
    expect(types[code.indexOf('add')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('b: ')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('float32')], SyntaxTokenType.identifier);
  });

  test('recognizes argument conventions, traits and dunder methods', () {
    const code =
        'def take(mut x: Int, var s: String, out r: Int): '
        'struct Pair(Copyable): def __init__(out self):';
    final types = tokenizer.classify(code);
    for (final word in ['mut', 'var', 'out', 'Copyable', '__init__']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
  });

  test('classifies a # comment through the end of its line', () {
    const code = '# note\nvar value = 1';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# note'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['# note'.length], SyntaxTokenType.plain);
    expect(types[code.indexOf('var')], SyntaxTokenType.keyword);
  });

  test('colors a known decorator as one keyword token', () {
    const code = '@fieldwise_init\nstruct MyPair(Copyable):';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '@fieldwise_init'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    expect(
      types.sublist(
        code.indexOf('MyPair'),
        code.indexOf('MyPair') + 'MyPair'.length,
      ),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('classifies t-strings, raw strings and triple quotes', () {
    const code = 'var a = t"count is {n}"\nvar b = r"raw\\n"';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(code.indexOf('t"'), code.indexOf('{n}"') + 4),
      everyElement(SyntaxTokenType.string),
    );
    final rawStart = code.indexOf('r"');
    expect(
      types.sublist(rawStart, code.length),
      everyElement(SyntaxTokenType.string),
    );

    const multi = 'var doc = """\nline one\nline two\n"""';
    final multiTypes = tokenizer.classify(multi);
    final bodyStart = multi.indexOf('"""') + 3;
    expect(
      multiTypes.sublist(bodyStart, multi.length - 3),
      everyElement(SyntaxTokenType.string),
    );
  });

  test(
    'classifies a single-quoted string that never closes at the newline',
    () {
      const code = "var a = 'open\nvar b = 2";
      final types = tokenizer.classify(code);
      expect(
        types.sublist(code.indexOf("'"), code.indexOf('\n')),
        everyElement(SyntaxTokenType.string),
      );
      expect(types[code.indexOf('var b')], SyntaxTokenType.keyword);
    },
  );

  test('classifies hex, binary and float literals as numbers', () {
    const code = 'var a = 0xFF\nvar b = 0b0111\nvar c = 1.2e9\nvar d = 1_000';
    final types = tokenizer.classify(code);
    for (final literal in ['0xFF', '0b0111', '1.2e9', '1_000']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('colors punctuation and keeps identifiers plain', () {
    const code = 'for ref value in values:';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf(':')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('value')], SyntaxTokenType.identifier);
  });
}
