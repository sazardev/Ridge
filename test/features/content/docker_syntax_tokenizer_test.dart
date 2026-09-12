// Unit tests for `DockerSyntaxTokenizer` — a single-pass lexer used
// purely for syntax-highlighting the capture field's display, mirroring
// the other per-language tokenizer tests plus Docker's own mix of
// Dockerfile instructions (`FROM`, `RUN`, `HEALTHCHECK`), CLI
// subcommands, Compose YAML keys, `$VAR` expansions, and flags.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = DockerSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'docker build -t hello .';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('`docker` and its subcommands are colored like keywords', () {
    const code = 'docker build -t hello .';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'docker'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final build = code.indexOf('build');
    expect(
      types.sublist(build, build + 'build'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('Dockerfile instructions are keywords, image names identifiers', () {
    const code = 'FROM alpine:3.22 AS builder';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'FROM'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final alpine = code.indexOf('alpine');
    expect(types[alpine], SyntaxTokenType.identifier);
    final as = code.indexOf('AS');
    expect(types[as], SyntaxTokenType.keyword);
  });

  test('`RUN` and the shell helpers inside it are keywords', () {
    const code = 'RUN echo "Hello from my image" > /message.txt';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, 'RUN'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final echo = code.indexOf('echo');
    expect(types[echo], SyntaxTokenType.keyword);
    final start = code.indexOf('"Hello from my image"');
    expect(
      types.sublist(start, start + '"Hello from my image"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('JSON-array `CMD` keeps every element a string', () {
    const code = 'CMD ["cat", "/message.txt"]';
    final types = tokenizer.classify(code);
    final cat = code.indexOf('"cat"');
    expect(
      types.sublist(cat, cat + '"cat"'.length),
      everyElement(SyntaxTokenType.string),
    );
    final path = code.indexOf('"/message.txt"');
    expect(
      types.sublist(path, path + '"/message.txt"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('`--from=builder` is one punctuation token', () {
    const code = 'COPY --from=builder /build/app /usr/local/bin/app';
    final types = tokenizer.classify(code);
    final flag = code.indexOf('--from=builder');
    expect(
      types.sublist(flag, flag + '--from=builder'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
  });

  test('`ARG APP_VERSION=1.0` keeps the value colored', () {
    const code = 'ARG APP_VERSION=1.0';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    final name = code.indexOf('APP_VERSION');
    expect(
      types.sublist(name, name + 'APP_VERSION'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    final equals = code.indexOf('=');
    expect(types[equals], SyntaxTokenType.operatorOrPunctuation);
    expect(types[equals + 1], SyntaxTokenType.number);
  });

  test('`HEALTHCHECK` flags and its `CMD test` are colored', () {
    const code = 'HEALTHCHECK --interval=1s --retries=3 CMD test -f /ready';
    final types = tokenizer.classify(code);
    expect(types[0], SyntaxTokenType.keyword);
    final interval = code.indexOf('--interval=1s');
    expect(
      types.sublist(interval, interval + '--interval=1s'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    final cmd = code.indexOf('CMD');
    expect(types[cmd], SyntaxTokenType.keyword);
    final test = code.indexOf('test');
    expect(types[test], SyntaxTokenType.keyword);
    final dashF = code.indexOf('-f');
    expect(types[dashF], SyntaxTokenType.operatorOrPunctuation);
  });

  test('Compose keys are keywords and service names identifiers', () {
    const code = 'services:\n  web:\n    image: nginx:alpine';
    final types = tokenizer.classify(code);
    final services = code.indexOf('services');
    expect(
      types.sublist(services, services + 'services'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final web = code.indexOf('web');
    expect(types[web], SyntaxTokenType.identifier);
    final image = code.indexOf('image');
    expect(types[image], SyntaxTokenType.keyword);
  });

  test('`depends_on`/`condition: service_healthy` are keywords', () {
    const code =
        '    depends_on:\n      db:\n        condition: '
        'service_healthy';
    final types = tokenizer.classify(code);
    final depends = code.indexOf('depends_on');
    expect(
      types.sublist(depends, depends + 'depends_on'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final condition = code.indexOf('condition');
    expect(
      types.sublist(condition, condition + 'condition'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final healthy = code.indexOf('service_healthy');
    expect(
      types.sublist(healthy, healthy + 'service_healthy'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('`#` at the start of a word opens a comment', () {
    const code = '# start the local registry\ndocker version';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# start the local registry'.length),
      everyElement(SyntaxTokenType.comment),
    );
    final docker = code.indexOf('docker');
    expect(types[docker], SyntaxTokenType.keyword);
  });

  test(r'`$PWD` and `${BASE}` expansions get the keyword color', () {
    const code = r'docker run -v $PWD/site:/site:ro ${BASE}';
    final types = tokenizer.classify(code);
    final pwd = code.indexOf(r'$PWD');
    expect(
      types.sublist(pwd, pwd + r'$PWD'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final base = code.indexOf(r'${BASE}');
    expect(
      types.sublist(base, base + r'${BASE}'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('a YAML list dash stays punctuation and the value a string', () {
    const code = '    ports:\n      - "8080:80"';
    final types = tokenizer.classify(code);
    final dash = code.indexOf('- "');
    expect(types[dash], SyntaxTokenType.operatorOrPunctuation);
    final value = code.indexOf('"8080:80"');
    expect(
      types.sublist(value, value + '"8080:80"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('`docker compose up -d` colors verb and flag correctly', () {
    const code = 'docker compose up -d';
    final types = tokenizer.classify(code);
    final compose = code.indexOf('compose');
    expect(
      types.sublist(compose, compose + 'compose'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final up = code.indexOf('up');
    expect(types[up], SyntaxTokenType.keyword);
    final dashD = code.indexOf('-d');
    expect(types[dashD], SyntaxTokenType.operatorOrPunctuation);
  });

  test('`--read-only` is one punctuation token', () {
    const code = 'docker run --read-only nginx:alpine';
    final types = tokenizer.classify(code);
    final flag = code.indexOf('--read-only');
    expect(
      types.sublist(flag, flag + '--read-only'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
  });

  test('hyphenated identifiers stay one identifier token', () {
    const code = 'docker run hello-world:latest';
    final types = tokenizer.classify(code);
    final hello = code.indexOf('hello-world');
    expect(
      types.sublist(hello, hello + 'hello-world'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('SyntaxTokenizers.forLanguage resolves Docker', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.docker),
      isA<DockerSyntaxTokenizer>(),
    );
  });
}
