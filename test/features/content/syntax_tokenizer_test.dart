// Unit tests for `GoSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display (SPEC.md
// §4.1's live feedback layers on top of this, unaffected by it).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = GoSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'func main() {\n\tfmt.Println("hi")\n}';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'if iffy {}';
    final types = tokenizer.classify(code);
    // "if" (0-1) is a keyword; "iffy" (3-6) must NOT be, even though it
    // starts with the keyword's letters.
    expect(types[0], SyntaxTokenType.keyword);
    expect(types[1], SyntaxTokenType.keyword);
    expect(types.sublist(3, 7), everyElement(SyntaxTokenType.identifier));
  });

  test('recognizes predeclared constants as keyword-colored', () {
    const code = 'true false nil iota';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword); // t of true
    expect(types[5], SyntaxTokenType.keyword); // f of false
    expect(types[11], SyntaxTokenType.keyword); // n of nil
    expect(types[15], SyntaxTokenType.keyword); // i of iota
  });

  test('a double-quoted string is one string token, escapes included', () {
    const code = r'x := "a \" b"';
    final types = tokenizer.classify(code);
    // The string starts at the first '"' (index 5) and runs through the
    // matching closing '"', including the escaped quote in between.
    expect(types[5], SyntaxTokenType.string);
    expect(types.sublist(5, code.length), everyElement(SyntaxTokenType.string));
  });

  test('a backtick raw string is one string token', () {
    const code = 'x := `raw \n string`';
    final types = tokenizer.classify(code);
    expect(types.sublist(5, code.length), everyElement(SyntaxTokenType.string));
  });

  test('a single-quoted rune literal is a string token', () {
    const code = "c := 'a'";
    final types = tokenizer.classify(code);
    expect(types.sublist(5, 8), everyElement(SyntaxTokenType.string));
  });

  test('a line comment runs to the end of the line, not past it', () {
    const code = '// comment\nx';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 10), everyElement(SyntaxTokenType.comment));
    expect(types[10], isNot(SyntaxTokenType.comment)); // the newline
    expect(types[11], SyntaxTokenType.identifier); // x
  });

  test('a block comment is fully classified, including its close', () {
    const code = '/* a\nb */x';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 9), everyElement(SyntaxTokenType.comment));
    expect(types[9], SyntaxTokenType.identifier);
  });

  test('numeric literals, including hex', () {
    const code = '42 0xFF 3.14';
    final types = tokenizer.classify(code);
    expect(types.sublist(0, 2), everyElement(SyntaxTokenType.number));
    expect(types.sublist(3, 7), everyElement(SyntaxTokenType.number));
    expect(types.sublist(8, 12), everyElement(SyntaxTokenType.number));
  });

  test('punctuation/operators are classified per character', () {
    const code = '{}()[]:=+-';
    final types = tokenizer.classify(code);
    expect(types, everyElement(SyntaxTokenType.operatorOrPunctuation));
  });

  test('whitespace stays plain', () {
    const code = 'a b';
    final types = tokenizer.classify(code);
    expect(types[1], SyntaxTokenType.plain);
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = '''
func add(a, b int) int {
	// sums two ints
	return a + b
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[0], SyntaxTokenType.keyword); // f of func
    expect(types[5], SyntaxTokenType.identifier); // a of add
    final commentStart = code.indexOf('// sums');
    expect(types[commentStart], SyntaxTokenType.comment);
    final returnStart = code.indexOf('return');
    expect(types[returnStart], SyntaxTokenType.keyword);
  });

  test('predeclared types are keyword-colored, not plain identifiers', () {
    const code = 'var x int, s string, ok bool';
    final types = tokenizer.classify(code);
    final intStart = code.indexOf('int');
    expect(
      types.sublist(intStart, intStart + 3),
      everyElement(SyntaxTokenType.keyword),
    );
    final stringStart = code.indexOf('string');
    expect(
      types.sublist(stringStart, stringStart + 6),
      everyElement(SyntaxTokenType.keyword),
    );
    final boolStart = code.indexOf('bool');
    expect(
      types.sublist(boolStart, boolStart + 4),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('SyntaxTokenizers.forLanguage resolves Go', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.go),
      isA<GoSyntaxTokenizer>(),
    );
  });
}
