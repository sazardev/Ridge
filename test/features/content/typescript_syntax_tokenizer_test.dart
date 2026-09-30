// Unit tests for `TypeScriptSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's code display,
// mirroring `haskell_syntax_tokenizer_test.dart`'s coverage. The JSX/TSX
// cases are the interesting half: the tokenizer deliberately errs toward
// plain TypeScript, so each one pins a *shape* (a sibling after a JSX
// expression, a fragment close, a generic that must not open children
// mode, an unterminated tag) rather than just the length invariant.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

/// Asserts that [name] — which must occur in [code] — is classified as
/// exactly one [type] token, character by character.
void expectToken(
  List<SyntaxTokenType> types,
  String code,
  String name,
  SyntaxTokenType type,
) {
  final start = code.indexOf(name);
  expect(start, isNot(-1), reason: '"$name" is missing from the probe');
  final span = types.sublist(start, start + name.length);
  expect(
    span,
    everyElement(type),
    reason: '"$name" should be $type, got $span at $start',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test(r'$ is an identifier character, as in JavaScript and TypeScript', () {
    const code = r'const $ref = $store.get(1);';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expectToken(types, code, r'$ref', SyntaxTokenType.identifier);
    expectToken(types, code, r'$store', SyntaxTokenType.identifier);
    expectToken(types, code, 'get', SyntaxTokenType.keyword);
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

  test('a TSX element colors tag, attribute, and event names', () {
    const code =
        'const view = <button className="btn" onClick={save}>Save</button>;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final name in ['button', 'className', 'onClick']) {
      final start = code.indexOf(name);
      expect(
        types.sublist(start, start + name.length),
        everyElement(SyntaxTokenType.identifier),
        reason: name,
      );
    }
    // A quoted attribute value is a string, the `{save}` braces are
    // punctuation, and the handler inside is a plain identifier.
    expect(types[code.indexOf('"btn"')], SyntaxTokenType.string);
    final value = code.indexOf('{save}');
    expect(types[value], SyntaxTokenType.operatorOrPunctuation);
    expect(
      types[value + 'save'.length + 1],
      SyntaxTokenType.operatorOrPunctuation,
    );
    final handler = code.lastIndexOf('save');
    expect(
      types.sublist(handler, handler + 'save'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    // Both tag delimiters are punctuation, and element text is the string
    // literal it is in the AST.
    expect(
      types[code.indexOf('<button')],
      SyntaxTokenType.operatorOrPunctuation,
    );
    final close = code.indexOf('</button>');
    expect(types[close], SyntaxTokenType.operatorOrPunctuation);
    expect(types[close + 2], SyntaxTokenType.identifier);
    final text = code.indexOf('>Save<') + 1;
    expect(
      types.sublist(text, text + 'Save'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test(
    'fragments and self-closing tags are delimited, not identifier text',
    () {
      const code = 'return <><br />{label}</>;';
      final types = tokenizer.classify(code);
      expect(types, hasLength(code.length));
      expect(types[code.indexOf('return')], SyntaxTokenType.keyword);
      for (final delimiter in ['<>', '<br', '/>', '</>']) {
        expect(
          types[code.indexOf(delimiter)],
          SyntaxTokenType.operatorOrPunctuation,
          reason: delimiter,
        );
      }
      for (final name in ['br', 'label']) {
        final start = code.indexOf(name);
        expect(
          types.sublist(start, start + name.length),
          everyElement(SyntaxTokenType.identifier),
          reason: name,
        );
      }
    },
  );

  test('a JSX comment inside braces stays a comment', () {
    const code = 'return <div>{/* skip: <b> */}</div>;';
    final types = tokenizer.classify(code);
    final comment = code.indexOf('/*');
    expect(
      types.sublist(comment, comment + '/* skip: <b> */'.length),
      everyElement(SyntaxTokenType.comment),
    );
    expect(types[code.indexOf('{/*')], SyntaxTokenType.operatorOrPunctuation);
    expect(
      types[code.indexOf('</div>') + 2],
      SyntaxTokenType.identifier,
      reason: 'the div of the closing tag',
    );
  });

  test("an apostrophe or quote in element text doesn't eat the markup", () {
    const code = "return <p>It's a \"quote</p>;\nconst after = 1;";
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    // The apostrophe and the unbalanced quote are just text...
    expect(types[code.indexOf("It's") + 3], SyntaxTokenType.string);
    expect(types[code.indexOf('"quote')], SyntaxTokenType.string);
    // ...the closing tag is still a tag...
    final close = code.indexOf('</p>');
    expect(types[close], SyntaxTokenType.operatorOrPunctuation);
    expect(types[close + 2], SyntaxTokenType.identifier);
    // ...and the TypeScript after the element is still TypeScript.
    expect(types[code.indexOf('const after')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('1')], SyntaxTokenType.number);
  });

  test('a generic argument list is not mistaken for a tag', () {
    const code =
        'const [v, setV] = useState<number>(0);\n'
        'function first<T extends Item>(items: T[]): T | undefined {';
    final types = tokenizer.classify(code);
    for (final generic in ['<number>', '<T extends']) {
      expect(
        types[code.indexOf(generic)],
        SyntaxTokenType.operatorOrPunctuation,
        reason: generic,
      );
    }
    // Type names and `extends` keep their TypeScript colors, so a generic
    // never reads as a tag plus attributes.
    expect(types[code.indexOf('number>')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('extends')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('useState')], SyntaxTokenType.identifier);
  });

  test('a comparison is never a tag, however it is spelled', () {
    const code =
        'const a = left < right && top > bottom;\n'
        'const b = items.length < 10;\n'
        'const c = first(1) < second(2);';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final name in [
      'left',
      'right',
      'top',
      'bottom',
      'items',
      'first',
      'second',
    ]) {
      expectToken(types, code, name, SyntaxTokenType.identifier);
    }
    expect(types[code.indexOf('<')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('>')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a nested element, a spread, and a dashed attribute all classify', () {
    const code =
        'return <ul {...rest} data-id={id} aria-label="Menu">\n'
        '  {items.map((i) => <li key={i.id}>{i.name}</li>)}</ul>;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final name in ['ul', 'rest', 'data-id', 'aria-label', 'li', 'name']) {
      final start = code.indexOf(name);
      expect(
        types.sublist(start, start + name.length),
        everyElement(SyntaxTokenType.identifier),
        reason: name,
      );
    }
    expect(
      types[code.indexOf('{...rest}')],
      SyntaxTokenType.operatorOrPunctuation,
    );
    expect(types[code.indexOf('"Menu"')], SyntaxTokenType.string);
    // `)}` closes the `.map()` call and the JSX expression, and `</ul>`
    // still reads as a tag: the braces were balanced, not leaked.
    final close = code.indexOf('>)}');
    expect(types[close + 1], SyntaxTokenType.operatorOrPunctuation);
    expect(types[close + 2], SyntaxTokenType.operatorOrPunctuation);
    expect(types[close + 3], SyntaxTokenType.operatorOrPunctuation);
  });

  test('a sibling element straight after a JSX expression is markup', () {
    // The `}` of the expression is not a JSX-preceding symbol, so this
    // shape used to read the whole sibling as element text.
    const code = '''
return <ul>
  {items.map((i) => <li key={i}>{i.name}</li>)}
  <li>static</li>
</ul>;''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    final sibling = code.indexOf('<li>static');
    expect(types[sibling], SyntaxTokenType.operatorOrPunctuation);
    expect(types[sibling + 1], SyntaxTokenType.identifier);
    expect(types[sibling + 2], SyntaxTokenType.identifier);
    expect(types[sibling + 3], SyntaxTokenType.operatorOrPunctuation);
    expect(
      types.sublist(sibling + '<li>'.length, sibling + '<li>static'.length),
      everyElement(SyntaxTokenType.string),
    );
    // Both closing tags are still real closing tags, and the
    // `.map()` expression above them never leaked into text.
    final closeList = code.indexOf('</li>\n</ul>;');
    expect(types[closeList], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('</ul>')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('items')], SyntaxTokenType.identifier);
  });

  test('a fragment close leaves the enclosing children in place', () {
    // `</>` used to drop the `<div>`'s children frame, after which the
    // text and the `<b>` sibling were lexed as plain TypeScript.
    const code =
        'const view = <div><><a href="/x" />one</>text<b>bold</b>'
        ' {v}</div>;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final delimiter in [
      '<div>',
      '<>',
      '<a ',
      '/>',
      '</>',
      '<b>',
      '</b>',
    ]) {
      expect(
        types[code.indexOf(delimiter)],
        SyntaxTokenType.operatorOrPunctuation,
        reason: delimiter,
      );
    }
    expectToken(types, code, 'a', SyntaxTokenType.identifier);
    expectToken(types, code, 'href', SyntaxTokenType.identifier);
    expectToken(types, code, 'b', SyntaxTokenType.identifier);
    expectToken(types, code, 'div', SyntaxTokenType.identifier);
    for (final text in ['"/x"', 'one', 'text', 'bold']) {
      expectToken(types, code, text, SyntaxTokenType.string);
    }
    // The expression after the last sibling is still an expression.
    expect(types[code.indexOf('{v}')], SyntaxTokenType.operatorOrPunctuation);
  });

  test('JSX whitespace, newlines, and indentation stay plain', () {
    const code = '''
const view = <div>
  <p>
    Count: <b>{n}</b>
  </p>
</div>;''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (var i = 0; i < code.length; i++) {
      final c = code[i];
      if (c != ' ' && c != '\n' && c != '\t' && c != '\r') continue;
      expect(
        types[i],
        SyntaxTokenType.plain,
        reason:
            'whitespace at $i should stay plain, '
            'like whitespace everywhere else',
      );
    }
    // ...while the text around it is still the string literal it is.
    expectToken(types, code, 'Count:', SyntaxTokenType.string);
  });

  test('a member tag name and a namespaced attribute keep the children', () {
    // `<Foo.Bar>` used to bail out of JSX mode at the `.`, and the text
    // inside it was then lexed as TypeScript.
    const code =
        'const v = <Theme.Provider value={v}>label</Theme.Provider>;\n'
        'const u = <svg><use xlink:href="#icon" data-x="1" '
        'aria-hidden="y" /></svg>;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expectToken(types, code, 'Theme.Provider', SyntaxTokenType.identifier);
    expectToken(types, code, 'xlink:href', SyntaxTokenType.identifier);
    expectToken(types, code, 'data-x', SyntaxTokenType.identifier);
    expectToken(types, code, 'aria-hidden', SyntaxTokenType.identifier);
    expectToken(types, code, 'svg', SyntaxTokenType.identifier);
    expectToken(types, code, 'use', SyntaxTokenType.identifier);
    // The children frame survived the dotted name: the text is text.
    expectToken(types, code, 'label', SyntaxTokenType.string);
    expect(
      types[code.indexOf('</Theme.Provider>')],
      SyntaxTokenType.operatorOrPunctuation,
    );
    expect(
      types[code.indexOf('</svg>')],
      SyntaxTokenType.operatorOrPunctuation,
    );
  });

  test('an unterminated element bails back to TypeScript', () {
    // The tag frame must not keep reading the rest of the file as
    // attributes: the `const` after the unclosed `<div` is TypeScript.
    const code = 'const view = <div className="open"\nconst after = 1;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expectToken(types, code, 'className', SyntaxTokenType.identifier);
    expectToken(types, code, '"open"', SyntaxTokenType.string);
    expect(types[code.lastIndexOf('const')], SyntaxTokenType.keyword);
    expectToken(types, code, 'after', SyntaxTokenType.identifier);
    expectToken(types, code, '1', SyntaxTokenType.number);
  });

  test('a blank line ends an unterminated tag safely', () {
    const code = 'const view = <div className="open"\n\nconst after = 1;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.lastIndexOf('const')], SyntaxTokenType.keyword);
    expectToken(types, code, 'after', SyntaxTokenType.identifier);
    expectToken(types, code, '1', SyntaxTokenType.number);
  });

  test('a generic arrow function after `=` never opens children mode', () {
    // Both shapes used to push a children frame and recolor the rest of
    // the file as one string: `<T extends object>` and a bare `<T>` whose
    // parameter list follows the `>`.
    const code =
        'const f = <T extends object>(v: T): T => v;\n'
        'const g = <T,>(v: T) => v;\n'
        'const h = <T>(v: T): T => v;\n'
        'const after = 1;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final word in ['extends', 'object', 'const']) {
      expectToken(types, code, word, SyntaxTokenType.keyword);
    }
    expectToken(types, code, 'T', SyntaxTokenType.identifier);
    expectToken(types, code, 'v', SyntaxTokenType.identifier);
    expectToken(types, code, 'after', SyntaxTokenType.identifier);
    expectToken(types, code, '1', SyntaxTokenType.number);
    // Nothing in the file is text, so no run was swallowed as a string.
    expect(types, isNot(contains(SyntaxTokenType.string)));
  });

  test('an angle-bracket type assertion after `=` stays TypeScript', () {
    const code = 'const n = <string>count;\nconst m = <number>total + 1;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expectToken(types, code, 'string', SyntaxTokenType.keyword);
    expectToken(types, code, 'number', SyntaxTokenType.keyword);
    expectToken(types, code, 'count', SyntaxTokenType.identifier);
    expectToken(types, code, 'total', SyntaxTokenType.identifier);
    expectToken(types, code, '1', SyntaxTokenType.number);
    expect(types, isNot(contains(SyntaxTokenType.string)));
  });

  test('an unbalanced JSX expression never swallows the rest of the file', () {
    const code = 'return <p>{value\nconst after = 1;';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types[code.indexOf('const')], SyntaxTokenType.keyword);
    expectToken(types, code, 'after', SyntaxTokenType.identifier);
    expectToken(types, code, '1', SyntaxTokenType.number);
  });

  test('a representative TSX component classifies', () {
    const code = '''
import { useState, type ReactElement } from "react";

type Props = { items: string[] };

export function List({ items }: Props): ReactElement {
  const [query, setQuery] = useState<string>("");
  const visible = items.filter((i) => i.includes(query));
  return (
    <section className="list" aria-label="Snippets">
      <p>
        Showing {visible.length} of {items.length}
      </p>
      <ul>
        {visible.map((item) => (
          <li key={item} onClick={() => setQuery(item)}>
            {item}
          </li>
        ))}
      </ul>
    </section>
  );
}''';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    for (final name in [
      'import',
      'export',
      'function',
      'return',
      'const',
      'type',
    ]) {
      expect(types[code.indexOf(name)], SyntaxTokenType.keyword, reason: name);
    }
    for (final name in [
      'useState',
      'visible',
      'items',
      'query',
      'setQuery',
      'ReactElement',
    ]) {
      expectToken(types, code, name, SyntaxTokenType.identifier);
    }
    // JSX: names are identifiers, attribute values are strings, the text
    // between the tags is a string, and the whitespace around it is plain.
    for (final name in ['className', 'aria-label', 'key', 'onClick']) {
      expectToken(types, code, name, SyntaxTokenType.identifier);
    }
    for (final (tag, nameOffset) in [
      ('<section ', 1),
      ('<p>', 1),
      ('<ul>', 1),
      ('<li ', 1),
      ('</ul>', 2),
    ]) {
      final start = code.indexOf(tag);
      expect(
        types[start],
        SyntaxTokenType.operatorOrPunctuation,
        reason: 'the delimiter of "$tag"',
      );
      expect(
        types[start + nameOffset],
        SyntaxTokenType.identifier,
        reason: 'the name of "$tag"',
      );
    }
    expectToken(types, code, '"react"', SyntaxTokenType.string);
    expectToken(types, code, '""', SyntaxTokenType.string);
    expectToken(types, code, '"Snippets"', SyntaxTokenType.string);
    expectToken(types, code, 'Showing', SyntaxTokenType.string);
    // The generic call in the component body is still a generic.
    expect(
      types[code.indexOf('useState<string>') + 'useState'.length],
      SyntaxTokenType.operatorOrPunctuation,
    );
  });

  test('deeply nested elements keep one token per character', () {
    // The JSX mode is an explicit frame stack, so depth costs heap, not
    // Dart stack: this is the termination/no-underflow guard.
    const depth = 400;
    final code = '${'<div>' * depth}deep${'</div>' * depth}';
    final types = tokenizer.classify(code);
    expect(types, hasLength(code.length));
    expect(types['<div>'.length * depth], SyntaxTokenType.string);
    expect(types.last, SyntaxTokenType.operatorOrPunctuation);
  });

  test('unbalanced and truncated JSX always terminates', () {
    const probes = [
      '<',
      '</',
      '<>',
      '</>',
      '<div',
      '<div className=',
      '<div className="open"',
      '{items.map((i) => <li',
      'const v = <div>{',
      'const v = <div>{{}}}}}',
      '<<<<>>>>',
      'const v = <T extends',
    ];
    for (final code in probes) {
      expect(tokenizer.classify(code), hasLength(code.length), reason: code);
    }
  });

  test('every bundled TypeScript snippet classifies one token per '
      'character', () async {
    // Catalog-driven smoke test: the real `typescript_v1.json` (both its
    // plain TypeScript entries and its TSX ones) must survive the JSX
    // heuristics — no assertion on how many entries there are, only on
    // the tokenizer's own invariant.
    final raw = await rootBundle.loadString(
      'assets/content/snippets/typescript_v1.json',
    );
    final entries = (jsonDecode(raw) as List<Object?>)
        .cast<Map<String, Object?>>();
    expect(entries, isNotEmpty);
    for (final entry in entries) {
      final code = entry['code']! as String;
      final types = tokenizer.classify(code);
      expect(
        types,
        hasLength(code.length),
        reason:
            '${entry['id']} must keep the one-token-per-character '
            'invariant',
      );
    }
  });
}
