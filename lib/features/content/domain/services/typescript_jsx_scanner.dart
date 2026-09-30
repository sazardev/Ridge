part of 'syntax_tokenizer.dart';

/// The JSX layer of [TypeScriptSyntaxTokenizer], split out of
/// `typescript_syntax_tokenizer.dart` to keep both files inside the
/// 500-line limit: the frame stack's state ([_JsxContext],
/// [_JsxFrame]) plus the bounded, deliberately conservative lookahead
/// that decides what a `<` means.
///
/// None of this is a parser. Every decision here is a lookbehind of one
/// whitespace run and a lookahead of one tag name, so a deeply nested
/// tree costs neither Dart stack nor unbounded scanning, and the worst
/// case for a wrong guess is a recolored token, never a hang.

/// Which context a [TypeScriptSyntaxTokenizer] JSX frame is in: plain
/// TypeScript (the bottom frame, and the only one a `.ts` file ever
/// reaches), a tag being read, an element's or fragment's children, or
/// the inside of a `{...}` expression.
enum _JsxContext { code, tag, children, expression }

/// One entry of that frame stack: the context plus the state it has to
/// remember — `isClosing` for a `</name>` rather than a `<name>`,
/// `isFragment` for the nameless `<>`/`</>`, `sawSlash` for the
/// self-closing `/` read at the `>`, and `braceDepth` for the nested
/// `{`s of an expression.
final class _JsxFrame {
  new(this.context, {this.isClosing = false, this.isFragment = false});

  final _JsxContext context;
  final bool isClosing;
  final bool isFragment;
  bool sawSlash = false;
  int braceDepth = 0;
}

// Symbols and words that can precede an expression but never a type
// argument list: a `<` right after one of them opens JSX, while one
// right after a plain identifier is a generic (`useState<number>`).
// `}` is deliberately absent — it can precede a generic in TypeScript,
// so it only counts as JSX-preceding inside a `{...}` expression, where
// a `}` can only have closed a block or an object literal.
const Set<String> _jsxPreceding = {
  '=',
  '(',
  ',',
  '{',
  '[',
  ':',
  ';',
  '?',
  '!',
  '&',
  '|',
  '>',
  '~',
  'return',
  'yield',
  'case',
  'default',
  'await',
  'else',
  'do',
  'of',
  'in',
  'typeof',
  'void',
  'new',
};

// Words that can only belong to a type expression, so one of them
// inside a `<...>` means the `<` opened a generic (`<T extends Item>`)
// rather than a tag. The ones that are also real HTML/SVG attribute
// names — `type`, `class`, `for`, `is`, `default`, `readonly` — are
// deliberately absent.
const Set<String> _notJsxWords = {
  'abstract',
  'as',
  'asserts',
  'await',
  'const',
  'declare',
  'enum',
  'export',
  'extends',
  'function',
  'implements',
  'import',
  'infer',
  'interface',
  'keyof',
  'let',
  'namespace',
  'new',
  'private',
  'protected',
  'public',
  'return',
  'satisfies',
  'static',
  'super',
  'this',
  'throw',
  'typeof',
  'undefined',
  'var',
  'void',
  'yield',
};

// Primitive type names: `const n = <number>count;` is a type assertion,
// and no JSX element is ever named after one, so a `<` followed by one
// of these is TypeScript even after a symbol that would otherwise open
// a tag.
const Set<String> _assertionNames = {
  'any',
  'bigint',
  'boolean',
  'never',
  'number',
  'object',
  'string',
  'symbol',
  'unknown',
};

/// Bounded "does this `<` open a JSX element?": a fragment (`<>`) or
/// closing tag (`</name>`) always does, and every other case turns on
/// what precedes the `<`. After a plain identifier it's a type argument
/// list (`useState<number>`, `first<T extends Item>`); after an operator
/// or a control-flow word it can only be an element (`return <Card />`,
/// `=> <li key={id} />`). [afterBrace] is the context-sensitive part:
/// inside a `{...}` expression a `<` after `}` is a sibling element,
/// because a `}` there closed a block, an object literal or a nested
/// expression and never a type argument list. The lookahead reads one
/// tag name and the lookbehind one whitespace run, so there is no
/// unbounded scan; anything the tag frame can't support afterwards
/// bails back to plain TypeScript (see `_scanTag`).
bool _isJsxTagStart(String code, int i, {bool afterBrace = false}) {
  final next = _peek(code, i + 1);
  if (next == null) return false;
  if (next == '>' || next == '/') return true;
  if (!_isIdentStart(next)) return false;
  if (_assertionNames.contains(_tagNameAt(code, i))) return false;

  final prevIndex = _previousNonWhitespace(code, i);
  if (prevIndex == null) return true; // the snippet starts with an element
  final prev = code[prevIndex];
  if (afterBrace && prev == '}') return true;
  if (!_isIdentPart(prev)) return _jsxPreceding.contains(prev);
  return _jsxPreceding.contains(_wordBefore(code, prevIndex));
}

/// The tag name at the already-known `<` or `</` at [i] — one dotted,
/// dashed or namespaced name, or null when there is no name at all.
/// Reading it here is what keeps `<string>value` out of tag mode.
String? _tagNameAt(String code, int i) {
  final start = code[i + 1] == '/' ? i + 2 : i + 1;
  if (start >= code.length || !_isIdentStart(code[start])) return null;
  var end = start;
  while (end < code.length && _isTagNameChar(code[end])) {
    end++;
  }
  return code.substring(start, end);
}

/// Whether what follows [i] opens a parameter list, which is how a type
/// parameter list continues: `const identity = <T>(value: T): T => v;`.
/// A JSX element's children never start with one, so this is the last
/// check before a tag's `>` is allowed to open a children frame.
bool _opensParameterList(String code, int i) {
  var j = i;
  while (j < code.length && _isWhitespace(code[j])) {
    j++;
  }
  return j < code.length && (code[j] == '(' || code[j] == '`');
}

/// Whether a blank line starts at [i] (a newline followed by a line
/// holding nothing but indentation). No JSX tag spans one, so it is the
/// safe boundary where an unterminated `<` hands the file back to
/// plain TypeScript instead of recoloring the rest of it.
bool _isBlankLineAt(String code, int i) {
  var j = i + 1;
  while (j < code.length && _isWhitespace(code[j]) && code[j] != '\n') {
    j++;
  }
  return j < code.length && code[j] == '\n';
}

String _wordBefore(String code, int index) {
  var start = index;
  while (start > 0 && _isIdentPart(code[start - 1])) {
    start--;
  }
  return code.substring(start, index + 1);
}

int? _previousNonWhitespace(String code, int i) {
  var j = i - 1;
  while (j >= 0 && _isWhitespace(code[j])) {
    j--;
  }
  return j < 0 ? null : j;
}

String? _peek(String code, int index) =>
    index < code.length ? code[index] : null;

/// A tag or attribute name character: an identifier part plus the `-`,
/// `.` and `:` of custom elements (`data-*`), member names
/// (`<ThemeContext.Provider>`) and namespaced names (`xlink:href`).
bool _isTagNameChar(String c) =>
    _isIdentPart(c) || c == '-' || c == '.' || c == ':';

bool _isWhitespace(String c) => c == ' ' || c == '\t' || c == '\n' || c == '\r';

bool _isDigit(String c) => c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

bool _isNumberChar(String c) =>
    _isDigit(c) || '._xabcdef'.contains(c.toLowerCase());

// `$` and `_` are both valid identifier characters in JavaScript, and
// TypeScript keeps that rule (e.g. `$` in libraries, `_` in private
// naming conventions).
bool _isIdentStart(String c) =>
    c == '_' ||
    c == r'$' ||
    (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) ||
    (c.codeUnitAt(0) >= 0x61 && c.codeUnitAt(0) <= 0x7A);

bool _isIdentPart(String c) => _isIdentStart(c) || _isDigit(c);
