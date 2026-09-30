part of 'syntax_tokenizer.dart';

/// A single-pass lexer for TypeScript — same scope as
/// [GoSyntaxTokenizer]: just enough to color keywords, strings,
/// comments, numbers, and punctuation, no AST and no semantic
/// analysis. It shares [JavaScriptSyntaxTokenizer]'s shape (template
/// literals are colored as a single string token, `${...}`
/// interpolation isn't given its own coloring) and widens the keyword
/// set with the TypeScript-only words: type operators (`keyof`,
/// `infer`, `is`, `asserts`), declarations (`interface`, `type`,
/// `enum`, `namespace`, `declare`), visibility modifiers (`public`,
/// `private`, `protected`, `readonly`, `override`, `abstract`), and
/// the primitive type names, which are ordinary identifiers in
/// JavaScript but reserved type keywords here — colored like Go's
/// predeclared types so typed code doesn't read as almost entirely
/// plain text.
///
/// It also understands enough JSX/TSX for the React course
/// (`typescript-react-v1`): tag and attribute names — dotted
/// (`<ThemeContext.Provider>`), namespaced (`xlink:href`) and custom
/// (`data-*`) ones alike — read as identifiers, quoted attribute values
/// as strings, `{}` expressions as punctuation, `{/* ... */}` as
/// comments, and element text as the string literal it is, with the
/// whitespace around it left plain. That extra mode is a bounded,
/// single-pass frame stack (one frame per open element, fragment or
/// `{...}` expression) rather than a real parser, and it errs toward
/// not-JSX — a `<` that could be a type argument list
/// (`useState<number>`, `Array<T>`, `<T>(v: T): T => v`) keeps plain
/// TypeScript rules, since mistaking a generic for a tag is far uglier
/// than the reverse. The frame stack and the bounded lookahead that
/// decides what a `<` means live in `typescript_jsx_scanner.dart`.
class TypeScriptSyntaxTokenizer implements SyntaxTokenizer {
  /// Creates the (stateless) tokenizer.
  const new();

  static const _keywords = {
    // JavaScript keywords.
    'async', 'await', 'break', 'case', 'catch', 'class', 'const',
    'continue', 'debugger', 'default', 'delete', 'do', 'else', 'export',
    'extends', 'false', 'finally', 'for', 'from', 'function', 'get', 'if',
    'import', 'in', 'instanceof', 'let', 'new', 'null', 'of', 'return',
    'set', 'static', 'super', 'switch', 'this', 'throw', 'true', 'try',
    'typeof', 'undefined', 'var', 'void', 'while', 'with', 'yield',
    // TypeScript declarations and modifiers.
    'abstract', 'as', 'asserts', 'declare', 'enum', 'implements',
    'interface', 'namespace', 'override', 'private', 'protected', 'public',
    'readonly', 'satisfies', 'type',
    // Type operators.
    'infer', 'is', 'keyof', 'unique',
    // Primitive and built-in type names, colored like Go's predeclared
    // types so annotations stand out from the identifiers around them.
    'any', 'bigint', 'boolean', 'never', 'number',
    'object', 'string', 'symbol', 'unknown',
  };

  @override
  List<SyntaxTokenType> classify(String code) {
    final types = List<SyntaxTokenType>.filled(
      code.length,
      SyntaxTokenType.plain,
    );
    // The JSX mode is an explicit frame stack — one frame per open
    // element, fragment or `{...}` expression — rather than recursive
    // descent, so a deeply nested tree can't grow the Dart call stack.
    // The bottom frame is always plain TypeScript; every other frame is
    // dropped again by whatever closes it (or by a bail-out, see
    // [_bailToCode]).
    final frames = <_JsxFrame>[_JsxFrame(_JsxContext.code)];
    var i = 0;
    while (i < code.length) {
      switch (frames.last.context) {
        case _JsxContext.code:
          if (code[i] == '<' && _isJsxTagStart(code, i)) {
            i = _openTag(types, code, frames, i);
            continue;
          }
          i = _scanCode(types, code, i);
        case _JsxContext.tag:
          i = _scanTag(types, code, frames, i);
        case _JsxContext.children:
          i = _scanChildren(types, code, frames, i);
        case _JsxContext.expression:
          i = _scanExpression(types, code, frames, i);
      }
    }
    return types;
  }

  /// Plain TypeScript/JavaScript lexing — comments, strings, numbers,
  /// identifiers/keywords, punctuation — starting at [from] and returning
  /// the next index. Shared verbatim by the JSX expression state.
  int _scanCode(List<SyntaxTokenType> types, String code, int from) {
    var i = from;
    final c = code[i];

    if (c == '/' && _peek(code, i + 1) == '/') {
      final start = i;
      while (i < code.length && code[i] != '\n') {
        i++;
      }
      _fill(types, start, i, SyntaxTokenType.comment);
      return i;
    }

    if (c == '/' && _peek(code, i + 1) == '*') {
      final start = i;
      i += 2;
      while (i < code.length &&
          !(code[i] == '*' && _peek(code, i + 1) == '/')) {
        i++;
      }
      i = (i + 1 < code.length) ? i + 2 : code.length;
      _fill(types, start, i, SyntaxTokenType.comment);
      return i;
    }

    if (c == '"' || c == "'") {
      return _scanQuoted(types, code, i);
    }

    if (c == '`') {
      final start = i;
      i++;
      while (i < code.length && code[i] != '`') {
        i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
      }
      if (i < code.length) i++;
      _fill(types, start, i, SyntaxTokenType.string);
      return i;
    }

    if (_isDigit(c)) {
      final start = i;
      while (i < code.length && _isNumberChar(code[i])) {
        i++;
      }
      _fill(types, start, i, SyntaxTokenType.number);
      return i;
    }

    if (_isIdentStart(c)) {
      final start = i;
      while (i < code.length && _isIdentPart(code[i])) {
        i++;
      }
      final word = code.substring(start, i);
      _fill(
        types,
        start,
        i,
        _keywords.contains(word)
            ? SyntaxTokenType.keyword
            : SyntaxTokenType.identifier,
      );
      return i;
    }

    // Whitespace stays `plain` (the list's fill value); every other
    // single symbol is punctuation/an operator.
    if (!_isWhitespace(c)) {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
    }
    return i + 1;
  }

  /// Consumes a `<` (or `</`) already recognized as JSX markup and pushes
  /// the tag frame that reads the name and attributes after it. `<>` and
  /// `</>` are nameless, so the frame remembers that too: their `>`
  /// opens or closes a fragment's children instead of an element's.
  int _openTag(
    List<SyntaxTokenType> types,
    String code,
    List<_JsxFrame> frames,
    int i,
  ) {
    final closing = code[i + 1] == '/';
    final nameStart = i + (closing ? 2 : 1);
    _fill(types, i, nameStart, SyntaxTokenType.operatorOrPunctuation);
    frames.add(
      _JsxFrame(
        _JsxContext.tag,
        isClosing: closing,
        isFragment: _peek(code, nameStart) == '>',
      ),
    );
    return nameStart;
  }

  /// Inside a tag: its name, then attributes, `=` values (quoted strings
  /// or `{...}` expressions) and `{...props}` spreads, until `>` or `/>`.
  /// A character that can't appear in a tag at all — a `<`, `;`, `,` or
  /// `(`, a blank line, or a word that can only belong to a type
  /// expression (`<T extends object>`) — means the `<` was never JSX, so
  /// [_bailToCode] hands the file back to [_scanCode] at that boundary.
  int _scanTag(
    List<SyntaxTokenType> types,
    String code,
    List<_JsxFrame> frames,
    int from,
  ) {
    var i = from;
    final frame = frames.last;
    final c = code[i];

    if (c == '>') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      i++;
      frames.removeLast();
      if (frame.isFragment) {
        // `<>` opens a fragment's children; `</>` closes them, and is a
        // no-op for the element that encloses the fragment.
        if (!frame.isClosing) {
          frames.add(_JsxFrame(_JsxContext.children, isFragment: true));
        } else if (frames.last.isFragment) {
          frames.removeLast();
        }
        return i;
      }
      // A `/` consumed since the name makes this tag self-closing, and
      // a parameter list right after the `>` means the `<T>` was a type
      // parameter list rather than an element with children.
      final empty = frame.isClosing || frame.sawSlash;
      if (!empty && !_opensParameterList(code, i)) {
        frames.add(_JsxFrame(_JsxContext.children));
      }
      return i;
    }

    // `/>`, remembered so the matching `>` knows the tag was empty.
    if (c == '/') {
      frame.sawSlash = true;
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      return i + 1;
    }

    // A `{...props}` spread or an `attr={...}` value: the braces are
    // punctuation and the inside is plain TypeScript again.
    if (c == '{') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      frames.add(_JsxFrame(_JsxContext.expression));
      return i + 1;
    }

    if (c == '=') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      return i + 1;
    }

    // `title="Save"` — a quoted attribute value is a string.
    if (c == '"' || c == "'") {
      return _scanQuoted(types, code, i);
    }

    // The tag name and every attribute name — `className`, `onClick`,
    // `aria-label`, `xlink:href`, `ThemeContext.Provider` — is an
    // identifier; `-`, `.` and `:` are part of it, as in custom
    // elements, `data-*`, member names and namespaced names. A word
    // that can only belong to a type expression bails instead.
    if (_isIdentStart(c)) {
      final start = i;
      while (i < code.length && _isTagNameChar(code[i])) {
        i++;
      }
      final word = code.substring(start, i);
      if (_notJsxWords.contains(word)) {
        _bailToCode(frames);
        return start;
      }
      _fill(types, start, i, SyntaxTokenType.identifier);
      return i;
    }

    if (_isWhitespace(c)) {
      // A blank line can't sit inside a tag either: bailing here is what
      // keeps an unclosed `<div` from recoloring the file as tag
      // contents.
      if (c == '\n' && _isBlankLineAt(code, i)) {
        _bailToCode(frames);
      }
      return i + 1;
    }

    _bailToCode(frames);
    return i;
  }

  /// Between an open tag and its closing one: nested elements, fragments,
  /// `{...}` expressions, and text. Text runs to the next `<`, `{` or `}`
  /// and is colored as a string — deliberately not re-scanned for
  /// quotes, so the apostrophe in `Don't stop` can't swallow the markup
  /// after it — while the whitespace inside it stays `plain`, like
  /// whitespace everywhere else.
  ///
  /// Nothing a `}` can end sits between an element's own tags, so a `}`
  /// here means the `<` that opened this region wasn't JSX. A `<` with a
  /// name or a `/` after it, on the other hand, is always markup: JSX
  /// text has no other way to spell a tag (`<` is written `&lt;`), so
  /// the sibling that follows a `{expression}` is an element, not a
  /// generic.
  int _scanChildren(
    List<SyntaxTokenType> types,
    String code,
    List<_JsxFrame> frames,
    int from,
  ) {
    final i = from;
    final c = code[i];

    if (c == '{') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      frames.add(_JsxFrame(_JsxContext.expression));
      return i + 1;
    }

    if (c == '}') {
      _bailToCode(frames);
      return i;
    }

    if (c == '<') {
      final next = _peek(code, i + 1);
      if (next == null) {
        types[i] = SyntaxTokenType.string;
        return i + 1;
      }
      // `</>` closes the fragment its `<>` opened — a no-op for the
      // element around the fragment, whose own children keep going.
      if (next == '/' && _peek(code, i + 2) == '>') {
        _fill(types, i, i + 3, SyntaxTokenType.operatorOrPunctuation);
        if (frames.last.isFragment) {
          frames.removeLast();
        }
        return i + 3;
      }
      if (next == '>' || next == '/' || _isIdentStart(next)) {
        // `</name>` closes this element: leave its children behind and
        // read the closing name as a tag.
        if (next == '/') {
          frames.removeLast();
        }
        return _openTag(types, code, frames, i);
      }
      // A literal `<` in the text.
      types[i] = SyntaxTokenType.string;
      return i + 1;
    }

    // Indentation and the newlines between elements stay `plain`.
    if (_isWhitespace(c)) {
      return i + 1;
    }

    var j = i;
    while (j < code.length && !'<{}'.contains(code[j])) {
      if (!_isWhitespace(code[j])) {
        types[j] = SyntaxTokenType.string;
      }
      j++;
    }
    return j;
  }

  /// Inside a JSX `{...}` expression: ordinary TypeScript, except that
  /// braces nest (so an object literal doesn't end it early), a
  /// `{/* ... */}` comment stays a comment, and a nested element
  /// (`{items.map((i) => <li key={i} />)}`) gets its own frames. A
  /// `<` right after a `}` is a sibling element rather than a type
  /// argument list, because inside an expression that `}` closed a
  /// block, an object literal or a nested expression.
  int _scanExpression(
    List<SyntaxTokenType> types,
    String code,
    List<_JsxFrame> frames,
    int i,
  ) {
    final frame = frames.last;
    final c = code[i];

    if (c == '{') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      frame.braceDepth++;
      return i + 1;
    }

    if (c == '}') {
      types[i] = SyntaxTokenType.operatorOrPunctuation;
      if (frame.braceDepth == 0) {
        frames.removeLast();
      } else {
        frame.braceDepth--;
      }
      return i + 1;
    }

    if (c == '<' && _isJsxTagStart(code, i, afterBrace: true)) {
      return _openTag(types, code, frames, i);
    }

    return _scanCode(types, code, i);
  }

  /// Drops every JSX frame, leaving the bottom TypeScript frame, so the
  /// character at the current index is rescanned as plain code.
  void _bailToCode(List<_JsxFrame> frames) {
    if (frames.length > 1) {
      frames.removeRange(1, frames.length);
    }
  }

  /// A single- or double-quoted string literal, escapes included. Stops at
  /// a newline so an unterminated quote can't recolor the rest of the file.
  int _scanQuoted(List<SyntaxTokenType> types, String code, int from) {
    var i = from;
    final start = i;
    final quote = code[i];
    i++;
    while (i < code.length && code[i] != quote && code[i] != '\n') {
      i += (code[i] == r'\' && i + 1 < code.length) ? 2 : 1;
    }
    if (i < code.length && code[i] == quote) i++;
    _fill(types, start, i, SyntaxTokenType.string);
    return i;
  }

  void _fill(
    List<SyntaxTokenType> types,
    int start,
    int end,
    SyntaxTokenType type,
  ) {
    for (var j = start; j < end && j < types.length; j++) {
      types[j] = type;
    }
  }
}
