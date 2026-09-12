// Unit tests for `CssSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `crystal_syntax_tokenizer_test.dart`'s coverage. CSS has no keywords in
// the usual sense, so these tests pin down the two positional
// heuristics: a declaration property (identifier followed by `:` inside a
// block) reads as a keyword, while a selector pseudo-class (`a:hover`)
// stays an identifier.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = CssSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'color: red;';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('at-rules are keyword-colored', () {
    const code = '@media (min-width: 768px)';
    final types = tokenizer.classify(code);
    final start = code.indexOf('@media');
    expect(
      types.sublist(start, start + '@media'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a media feature name is not mistaken for a declaration property', () {
    const code = '@media (min-width: 768px)';
    final types = tokenizer.classify(code);
    final start = code.indexOf('min-width');
    expect(
      types.sublist(start, start + 'min-width'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('a property inside a block is keyword-colored', () {
    const code = '.button {\n  color: #ff5a36;\n}';
    final types = tokenizer.classify(code);
    final start = code.indexOf('color');
    expect(
      types.sublist(start, start + 'color'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a pseudo-class in a selector stays an identifier', () {
    const code = '.button:hover {\n  color: #ff5a36;\n}';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('button')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('hover')], SyntaxTokenType.identifier);
  });

  test('custom properties and vendor-prefixed properties are one token', () {
    const code =
        ':root {\n  --brand: #ff5a36;\n  -webkit-user-select: none;\n}';
    final types = tokenizer.classify(code);
    for (final word in ['--brand', '-webkit-user-select']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
  });

  test('a hex color is number-colored', () {
    const code = 'color: #ff5a36;';
    final types = tokenizer.classify(code);
    final start = code.indexOf('#ff5a36');
    expect(
      types.sublist(start, start + '#ff5a36'.length),
      everyElement(SyntaxTokenType.number),
    );
  });

  test('an id selector is punctuation plus an identifier, never a color', () {
    const code = '#intro {\n  color: #fff;\n}';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.operatorOrPunctuation);
    expect(types[1], SyntaxTokenType.identifier);
    final hex = code.indexOf('#fff');
    expect(types[hex], SyntaxTokenType.number);
  });

  test('numbers keep their unit or percent sign', () {
    const code = 'padding: 12px 10vw 0.875em 100% -4px 200ms 1fr;';
    final types = tokenizer.classify(code);
    for (final literal in [
      '12px',
      '10vw',
      '0.875em',
      '100%',
      '-4px',
      '200ms',
      '1fr',
    ]) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('function names, including functional pseudo-classes, are keywords', () {
    const code =
        'color: rgb(255, 90, 54);\nwidth: calc(100% - 32px);\n'
        ':is(.card, .panel) > h2 {\n  margin: 0;\n}';
    final types = tokenizer.classify(code);
    for (final word in ['rgb', 'calc', 'is']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
      );
    }
  });

  test('quoted strings are string-colored, escapes included', () {
    const code = 'font-family: "Geist", "Helvetica Neue", sans-serif;';
    final types = tokenizer.classify(code);
    for (final literal in ['"Geist"', '"Helvetica Neue"']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.string),
        reason: literal,
      );
    }
  });

  test('a /* */ comment is comment-colored and does not nest', () {
    const code = '.card {\n  /* note */\n  color: red;\n}';
    final types = tokenizer.classify(code);
    final start = code.indexOf('/* note */');
    expect(
      types.sublist(start, start + '/* note */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('color')], SyntaxTokenType.keyword);
  });

  test('punctuation/operators are classified per character', () {
    const code = '{ ; : , > + ~ * ( ) }';
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

  test('a keyframes block colors from/to as selectors, not properties', () {
    const code =
        '@keyframes pulse {\n  from {\n    opacity: 1;\n  }\n\n'
        '  to {\n    opacity: 0.4;\n  }\n}';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('@keyframes')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('from')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('to')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('opacity')], SyntaxTokenType.keyword);
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = '''
@media (min-width: 768px) {
  .card:hover {
    display: flex;
    gap: 12px;
    background-color: #ff5a36;
    transform: translateY(-4px);
    animation: fade-up 240ms ease-out both;
  }
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('@media')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('card')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('hover')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('display')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('flex')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('12px')], SyntaxTokenType.number);
    expect(types[code.indexOf('#ff5a36')], SyntaxTokenType.number);
    expect(types[code.indexOf('translateY')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('-4px')], SyntaxTokenType.number);
    expect(types[code.indexOf('animation')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('fade-up')], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves CSS', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.css),
      isA<CssSyntaxTokenizer>(),
    );
  });
}
