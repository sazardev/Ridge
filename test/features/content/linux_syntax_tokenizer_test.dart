// Unit tests for `LinuxSyntaxTokenizer` — a single-pass lexer used purely
// for syntax-highlighting the capture field's command display, mirroring
// the other per-language tokenizer tests plus this catalog's quirks:
// hyphenated commands (`systemd-analyze`, `is-enabled`), flag spellings
// (`--on-active=2`, `-lh`), systemd/nft verbs as keywords, and quoted
// `curl -w` format strings.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/syntax_token_type.dart';
import 'package:ridge/features/content/domain/services/syntax_tokenizer.dart';

void main() {
  const tokenizer = LinuxSyntaxTokenizer();

  test('classify always returns exactly one type per character', () {
    const code = 'ls -lh /usr/bin/bash /etc/pacman.conf';
    expect(tokenizer.classify(code), hasLength(code.length));
  });

  test('a command is colored like a keyword', () {
    const code = 'stat -c "%a %n" /tmp/demo/report.txt';
    final types = tokenizer.classify(code);
    final stat = code.indexOf('stat');
    expect(
      types.sublist(stat, stat + 'stat'.length),
      everyElement(SyntaxTokenType.keyword),
    );
  });

  test('hyphenated commands are one keyword, not a hyphen plus a word', () {
    const code = "systemd-analyze calendar 'Mon *-*-* 09:00:00'";
    final types = tokenizer.classify(code);
    final start = code.indexOf('systemd-analyze');
    expect(
      types.sublist(start, start + 'systemd-analyze'.length),
      everyElement(SyntaxTokenType.keyword),
    );
    final verb = code.indexOf('calendar');
    expect(types[verb], SyntaxTokenType.identifier);
  });

  test('flags read as single punctuation tokens', () {
    const code = 'journalctl -u dbus-broker -n 5 --no-pager';
    final types = tokenizer.classify(code);
    final long = code.indexOf('--no-pager');
    expect(
      types.sublist(long, long + '--no-pager'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    final short = code.indexOf('-u');
    expect(types[short], SyntaxTokenType.operatorOrPunctuation);
  });

  test('an inline flag value keeps the number colored', () {
    const code = 'sudo systemd-run --on-active=2 --unit=demo-timer';
    final types = tokenizer.classify(code);
    final flag = code.indexOf('--on-active');
    expect(
      types.sublist(flag, flag + '--on-active'.length),
      everyElement(SyntaxTokenType.operatorOrPunctuation),
    );
    final two = code.indexOf('=2');
    expect(types[two], SyntaxTokenType.operatorOrPunctuation);
    expect(types[two + 1], SyntaxTokenType.number);
  });

  test('a curl write-out format stays one string token', () {
    const code = r"curl -sS -w '%{http_code}\n' https://archlinux.org";
    final types = tokenizer.classify(code);
    final start = code.indexOf(r"'%{http_code}\n'");
    expect(
      types.sublist(start, start + r"'%{http_code}\n'".length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('double-quoted strings include their content', () {
    const code = r'printf "hello\n" > /tmp/demo/hello.txt';
    final types = tokenizer.classify(code);
    final start = code.indexOf(r'"hello\n"');
    expect(
      types.sublist(start, start + r'"hello\n"'.length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('single-quoted strings stay one token', () {
    const code = "mkdir -p '/tmp/demo notes'";
    final types = tokenizer.classify(code);
    final start = code.indexOf("'/tmp/demo notes'");
    expect(
      types.sublist(start, start + "'/tmp/demo notes'".length),
      everyElement(SyntaxTokenType.string),
    );
  });

  test('`#` at the start of a word opens a comment', () {
    const code = '# refresh the databases\nsudo pacman -Sy';
    final types = tokenizer.classify(code);
    expect(
      types.sublist(0, '# refresh the databases'.length),
      everyElement(SyntaxTokenType.comment),
    );
    final pacman = code.indexOf('pacman');
    expect(types[pacman], SyntaxTokenType.keyword);
  });

  test('path components stay identifiers around punctuation slashes', () {
    const code = 'cat /etc/os-release';
    final types = tokenizer.classify(code);
    final etc = code.indexOf('etc');
    expect(
      types.sublist(etc, etc + 'etc'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    expect(types[code.indexOf('/')], SyntaxTokenType.operatorOrPunctuation);
    final osRelease = code.indexOf('os-release');
    expect(
      types.sublist(osRelease, osRelease + 'os-release'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('`ip` keeps object and verb as keywords', () {
    const code = 'ip -brief address show dev lo';
    final types = tokenizer.classify(code);
    for (final word in ['ip', 'address', 'show', 'dev']) {
      expect(
        types[code.indexOf(word)],
        SyntaxTokenType.keyword,
        reason: '$word should be a keyword',
      );
    }
    expect(
      types[code.indexOf('-brief')],
      SyntaxTokenType.operatorOrPunctuation,
    );
  });

  test('nftables chain keywords and braces color correctly', () {
    const code =
        'sudo nft add chain inet demo input { type filter hook input '
        r'priority 0 \; policy accept \; }';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('nft')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('chain')], SyntaxTokenType.keyword);
    final brace = code.indexOf('{');
    expect(types[brace], SyntaxTokenType.operatorOrPunctuation);
    final semicolon = code.indexOf(';');
    expect(types[semicolon], SyntaxTokenType.operatorOrPunctuation);
  });

  test(r'a background PID keeps `$!` as punctuation', () {
    const code = 'sleep 300 &\nkill \$!';
    final types = tokenizer.classify(code);
    expect(types[code.indexOf('sleep')], SyntaxTokenType.keyword);
    expect(types[code.indexOf('kill')], SyntaxTokenType.keyword);
    expect(types[code.indexOf(r'$')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('!')], SyntaxTokenType.operatorOrPunctuation);
    expect(types[code.indexOf('300')], SyntaxTokenType.number);
  });

  test('every command used by the routes is a keyword', () {
    for (final code in const [
      'cd /etc',
      'tail -n 2 /etc/passwd',
      'echo hello',
      'tree --version',
    ]) {
      final types = tokenizer.classify(code);
      expect(types[0], SyntaxTokenType.keyword, reason: code);
    }
  });

  test('path components stay identifiers even when they read as commands', () {
    const code = 'curl -sS -o /dev/null https://archlinux.org';
    final types = tokenizer.classify(code);
    final dev = code.indexOf('dev');
    expect(
      types.sublist(dev, dev + 'dev'.length),
      everyElement(SyntaxTokenType.identifier),
    );
    const passwd = 'stat -c "%a" /etc/passwd';
    final passwdTypes = tokenizer.classify(passwd);
    final name = passwd.indexOf('passwd');
    expect(
      passwdTypes.sublist(name, name + 'passwd'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('an absolute command path is a path, not the command keyword', () {
    const code = '/usr/bin/tree --version';
    final types = tokenizer.classify(code);
    final tree = code.indexOf('tree');
    expect(
      types.sublist(tree, tree + 'tree'.length),
      everyElement(SyntaxTokenType.identifier),
    );
  });

  test('SyntaxTokenizers.forLanguage resolves Linux', () {
    expect(
      SyntaxTokenizers.forLanguage(ProgrammingLanguage.linux),
      isA<LinuxSyntaxTokenizer>(),
    );
  });
}
