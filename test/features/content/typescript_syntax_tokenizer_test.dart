// Unit tests for `TypeScriptSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's code display,
// mirroring `haskell_syntax_tokenizer_test.dart`'s coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = TypeScriptSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'const n: number = 42;';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes TS keywords and type names as whole words', () {
    const code = 'interface Stringify { readonly value: string }';
    final types = tokenizer.classify(code);
    final interfaceStart = code.indexOf('interface');
    expect(types[interfaceStart], SyntaxTokenType.keyword);
    final nameStart = code.indexOf('Stringify');
    expect(
      types.sublist(nameStart, nameStart + 'Stringify'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    final readonlyStart = code.indexOf('readonly');
    expect(types[readonlyStart], SyntaxTokenType.keyword);
    final stringStart = code.indexOf('string }');
    expect(types[stringStart], SyntaxTokenType.keyword);
  });

  test('plain JavaScript keywords are still recognized', () {
    const code = 'if (ready) { run(); }';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('if')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('{')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a // line comment runs to the end of the line, not past it', () {
    const code = '// a comment\nlet x = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '// a comment'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types['// a comment'.length], isNot(SyntaxTokenType.comment));
    expect(types[code.indexOf('let')], SyntaxTokenType.keyword);
  });

  test('a /* */ block comment is fully classified', () {
    const code = '/* note */ let x = 1;';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '/* note */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('let')], SyntaxTokenType.keyword);
  });

  test('a double-quoted string includes escaped quotes', () {
    const code = r'const greeting = "a \" b";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a single-quoted string is a string token', () {
    const code = "const mode = 'idle';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    expect(
      types.sublist(start, code.length - 1),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('a template literal is one string token, interpolation included', () {
    const code = r'const label = `count: ${count}`;';
    final types = tokenizer.classify(code);
    final start = code.indexOf('`');
    final end = code.lastIndexOf('`');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('numeric literals are number-colored', () {
    const code = 'const x = 42 + 3.14 + 0xFF + 1_000;';
    final types = tokenizer.classify(code);
    for (final literal in ['42', '3.14', '0xFF', '1_000']) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('punctuation/operators are classified per character', () {
    const code = '?. ?? => | : ;';
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
// a typed union
type Status = "idle" | "done";
const status: Status = "idle";
console.log(status === "done");''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[0], SyntaxTokenType.comment);
    expect(types[code.indexOf('type Status')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('Status =')], SyntaxTokenType.identifier);
    expect(types[code.indexOf('"idle"')], SyntaxTokenType.string);
    expect(types[code.indexOf('console')], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves TypeScript', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.typescript),
      isA<TypeScriptSyntaxTokenizer>(),
    );
  });
}
