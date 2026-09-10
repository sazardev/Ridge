// Unit tests for `SqlSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `syntax_tokenizer_test.dart`'s Go coverage and
// `bash_syntax_tokenizer_test.dart`'s Bash coverage.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/syntax_token_type.dart';
import 'package:just_in_time/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = SqlSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'SELECT title FROM books WHERE rating IS NOT NULL;';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords case-insensitively as whole words', () {
    const code = 'select selected FROM books';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'select'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final selectedStart = code.indexOf('selected');
    expect(
      types.sublist(selectedStart, selectedStart + 'selected'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    final fromStart = code.indexOf('FROM');
    expect(
      types.sublist(fromStart, fromStart + 'FROM'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a -- sequence opens a line comment', () {
    const code = 'SELECT 1; -- one\nSELECT 2;';
    final types = tokenizer.classify(code);
    final commentStart = code.indexOf('-- one');
    expect(
      types.sublist(commentStart, commentStart + '-- one'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('\n')], isNot(SyntaxTokenType.comment));
  });

  test('a /* */ block comment includes a nested inner comment', () {
    const code = 'SELECT /* outer /* inner */ still */ 1;';
    final types = tokenizer.classify(code);
    final start = code.indexOf('/* outer');
    expect(
      types.sublist(start, code.indexOf('still */') + 'still */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.length - 2], SyntaxTokenType.number);
  });

  test("single-quoted strings treat a doubled '' as an escaped quote", () {
    const code = "SELECT 'it''s a book' AS title;";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
    expect(types[end + 1], SyntaxTokenType.plain);
  });

  test('double-quoted identifiers are identifier-colored', () {
    const code = 'SELECT "order" FROM "user table";';
    final types = tokenizer.classify(code);
    final firstStart = code.indexOf('"order"');
    expect(
      types.sublist(firstStart, firstStart + '"order"'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    final secondStart = code.indexOf('"user table"');
    expect(
      types.sublist(secondStart, secondStart + '"user table"'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('numeric literals are number-colored', () {
    const code = 'LIMIT 20 OFFSET 4';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(code.indexOf('20'), code.indexOf('20') + 2),
      everyElement(SyntaxTokenType.number),
    );
    expect(
      types.sublist(code.indexOf('4'), code.indexOf('4') + 1),
      everyElement(SyntaxTokenType.number),
    );
  });

  test('punctuation/operators are classified per character', () {
    const code = '= <> >= <= || ( ) , ; * . ::';
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

  test('built-in functions are keyword-colored', () {
    const code = 'SELECT COUNT(*), ROUND(AVG(rating), 1) FROM books;';
    final types = tokenizer.classify(code);
    final countStart = code.indexOf('COUNT');
    expect(
      types.sublist(countStart, countStart + 'COUNT'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final roundStart = code.indexOf('ROUND');
    expect(
      types.sublist(roundStart, roundStart + 'ROUND'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = '''
-- Top rated books
SELECT authors.name, books.title
FROM books
INNER JOIN authors ON authors.author_id = books.author_id
WHERE books.rating >= 4.5
ORDER BY books.rating DESC
LIMIT 3;''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[0], SyntaxTokenType.comment);
    final selectStart = code.indexOf('SELECT');
    expect(types[selectStart], SyntaxTokenType.keyword);
    final nameStart = code.indexOf('authors.name');
    expect(types[nameStart], SyntaxTokenType.identifier);
    final dotIndex = code.indexOf('authors.name') + 'authors'.length;
    expect(types[dotIndex], SyntaxTokenType.operatorOrPunctuation);
    final scoreStart = code.indexOf('4.5');
    expect(
      types.sublist(scoreStart, scoreStart + '4.5'.length),
      everyElement(SyntaxTokenType.number),
    );
  });

  test('SyntaxTokenizers.forLanguage resolves SQL', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.sql),
      isA<SqlSyntaxTokenizer>(),
    );
  });
}
