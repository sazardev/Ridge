// Unit tests for `CppSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's code display, mirroring
// `c_syntax_tokenizer_test.dart`'s coverage plus the C++-only literal
// forms (raw strings, digit separators, alternative operator spellings).
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = CppSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'auto answer = 42;';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('recognizes keywords as a whole word, not a substring match', () {
    const code = 'if iffy {}';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    expect(types.sublist(3, 7), everyElement(SyntaxTokenType.identifier));
  });

  test('primitive types and modern specifiers are keyword-colored', () {
    const code = 'const unsigned long count = 0;';
    final types = tokenizer.classify(code);
    for (final type in ['const', 'unsigned', 'long']) {
      final start = code.indexOf(type);
      expect(
        types.sublist(start, start + type.length),
        everyElement(SyntaxTokenType.keyword),
        reason: type,
      );
    }
  });

  test(
    'contextual identifiers like override and final are keyword-colored',
    () {
      const code = 'virtual void run() override final {}';
      final types = tokenizer.classify(code);
      for (final word in ['virtual', 'override', 'final']) {
        final start = code.indexOf(word);
        expect(
          types.sublist(start, start + word.length),
          everyElement(SyntaxTokenType.keyword),
          reason: word,
        );
      }
    },
  );

  test('alternative operator spellings are reserved words', () {
    const code = 'bool ok = ready and not done;';
    final types = tokenizer.classify(code);
    for (final word in ['and', 'not']) {
      final start = code.indexOf(word);
      expect(
        types.sublist(start, start + word.length),
        everyElement(SyntaxTokenType.keyword),
        reason: word,
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
    const code = r'std::cout << "a \" b\n";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a raw string literal is one string token, backslashes included', () {
    const code = r'std::string path = R"(C:\games\ridge)";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('R"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('a raw string with a delimiter tag is fully classified', () {
    const code = 'auto text = R"tag(no )" surprise)tag";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('R"tag');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('an R at the end of an identifier does not open a raw string', () {
    const code = 'int MYR = 1; std::string s = "x";';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('MYR')], SyntaxTokenType.identifier);
    final stringStart = code.indexOf('"');
    expect(types[stringStart], SyntaxTokenType.string);
  });

  test('a character literal is a string token, escapes included', () {
    const code = r"char c = '\n';";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'");
    final end = code.lastIndexOf("'");
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('numeric literals are number-colored, digit separators included', () {
    const code = "int a = 42 + 0xFF + 0b1010 + 3.14 + 100UL + 1'000;";
    final types = tokenizer.classify(code);
    for (final literal in ['42', '0xFF', '0b1010', '3.14', '100UL', "1'000"]) {
      final start = code.indexOf(literal);
      expect(
        types.sublist(start, start + literal.length),
        everyElement(SyntaxTokenType.number),
        reason: literal,
      );
    }
  });

  test('an #include colors the directive and the header name', () {
    const code = '#include <iostream>\nint main() { return 0; }';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '#include'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final headerStart = code.indexOf('<');
    expect(
      types.sublist(headerStart, headerStart + '<iostream>'.length),
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

  test('a # inside a string is not a directive', () {
    const code = 'std::cout << "#1";';
    final types = tokenizer.classify(code);
    final start = code.indexOf('"');
    final end = code.lastIndexOf('"');
    expect(types.sublist(start, end + 1), everyElement(SyntaxTokenType.string));
  });

  test('template punctuation and scope resolution stay punctuation', () {
    const code = 'std::vector<int> v;';
    final types = tokenizer.classify(code);
    for (final symbol in ['<', '>', ':']) {
      final start = code.indexOf(symbol);
      expect(
        types[start],
        SyntaxTokenType.operatorOrPunctuation,
        reason: symbol,
      );
    }
    expect(types[code.indexOf('vector')], SyntaxTokenType.identifier);
  });

  test('whitespace stays plain', () {
    const code = 'a b';
    final types = tokenizer.classify(code);
    expect(types[1], SyntaxTokenType.plain);
  });

  test('a realistic snippet mixes every category correctly', () {
    const code = r'''
#include <iostream>
#include <vector>

template <typename T>
T sum(const std::vector<T>& values) {
    // accumulate
    T total{};
    for (const T& value : values) {
        total += value;
    }
    return total;
}

int main() {
    std::vector<int> numbers{1, 2, 3};
    std::cout << "total: " << sum(numbers) << '\n';
    return 0;
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('#include')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('template')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('typename')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('// accumulate')], SyntaxTokenType.comment);
    expect(types[code.indexOf('"total: "')], SyntaxTokenType.string);
    expect(types[code.indexOf('sum')], SyntaxTokenType.identifier);
  });

  test('SyntaxTokenizers.forLanguage resolves C++', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.cpp),
      isA<CppSyntaxTokenizer>(),
    );
  });
}
