// Computes the next SemVer version from Conventional Commits made since the
// last `vX.Y.Z` tag, then updates `pubspec.yaml` and `CHANGELOG.md` to match.
// This is the single place that decides "what is the next version" — see
// STACK.md §10.4 for the contract: fix → PATCH, feat → MINOR, `!` or a
// `BREAKING CHANGE:` footer → MAJOR. The build number is a monotonic count
// of releases (tags), shared across every platform in STACK.md §12.
//
// Usage:
//   dart run tool/version_bump.dart            # apply: edit the two files
//   dart run tool/version_bump.dart --check    # dry run: decide, don't write
//
// On success both modes print a trailing `NEW_VERSION=X.Y.Z+B` line.
// Exit codes: 0 = release computed; 3 = nothing to release (not an error).
import 'dart:io';

final _conventionalCommitPattern = RegExp(
  '^(feat|fix|perf|refactor|docs|style|test|chore|build|ci|revert)'
  r'(\(([^)]+)\))?(!)?:\s*(.+)$',
);
final _breakingFooterPattern = RegExp(r'BREAKING CHANGE:\s*(.+)');

class _Commit {
  new(this.hash, this.subject, this.body);
  final String hash;
  final String subject;
  final String body;
}

class _ParsedCommit {
  new({
    required this.hash,
    required this.type,
    required this.scope,
    required this.breaking,
    required this.description,
    required this.breakingDescription,
  });
  final String hash;
  final String type;
  final String? scope;
  final bool breaking;
  final String description;
  final String? breakingDescription;

  String get entry => scope != null
      ? '**$scope:** $description ($hash)'
      : '$description ($hash)';
}

ProcessResult _git(List<String> args, {required String repoRoot}) {
  return Process.runSync('git', args, workingDirectory: repoRoot);
}

String _repoRoot() {
  final result = Process.runSync('git', ['rev-parse', '--show-toplevel']);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(1);
  }
  return (result.stdout as String).trim();
}

(int, int, int) _parseSemver(String version) {
  final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)').firstMatch(version);
  if (match == null) {
    stderr.writeln('version_bump: cannot parse SemVer from "$version"');
    exit(1);
  }
  return (
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
  );
}

bool _isGreater((int, int, int) a, (int, int, int) b) {
  if (a.$1 != b.$1) return a.$1 > b.$1;
  if (a.$2 != b.$2) return a.$2 > b.$2;
  return a.$3 > b.$3;
}

List<String> _releaseTagsSortedDesc(String repoRoot) {
  final result = _git(['tag', '--list', 'v*.*.*'], repoRoot: repoRoot);
  return (result.stdout as String)
      .split('\n')
      .map((t) => t.trim())
      .where((t) => RegExp(r'^v\d+\.\d+\.\d+$').hasMatch(t))
      .toList()
    ..sort((a, b) {
      final va = _parseSemver(a.substring(1));
      final vb = _parseSemver(b.substring(1));
      return _isGreater(va, vb) ? -1 : (va == vb ? 0 : 1);
    });
}

List<_Commit> _commitsSince(String? tag, String repoRoot) {
  const unitSep = '\x01';
  const recordSep = '\x02';
  final range = tag != null ? '$tag..HEAD' : 'HEAD';
  final result = _git([
    'log',
    range,
    '--no-merges',
    '--pretty=format:%H$unitSep%s$unitSep%b$recordSep',
  ], repoRoot: repoRoot);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(1);
  }
  final raw = result.stdout as String;
  return raw
      .split(recordSep)
      .map((r) => r.trim())
      .where((r) => r.isNotEmpty)
      .map((record) {
        final parts = record.split(unitSep);
        return _Commit(
          parts[0],
          parts.length > 1 ? parts[1] : '',
          parts.length > 2 ? parts[2] : '',
        );
      })
      .toList();
}

_ParsedCommit? _parse(_Commit commit) {
  final match = _conventionalCommitPattern.firstMatch(commit.subject);
  if (match == null) return null;
  final type = match.group(1)!;
  final scope = match.group(3);
  final bang = match.group(4) == '!';
  final description = match.group(5)!;
  final footerMatch = _breakingFooterPattern.firstMatch(commit.body);
  final breaking = bang || footerMatch != null;
  return _ParsedCommit(
    hash: commit.hash.substring(0, 7),
    type: type,
    scope: scope,
    breaking: breaking,
    description: description,
    breakingDescription: footerMatch?.group(1),
  );
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final repoRoot = _repoRoot();

  final pubspecFile = File('$repoRoot/pubspec.yaml');
  final pubspecText = pubspecFile.readAsStringSync();
  final pubspecVersionMatch = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspecText);
  if (pubspecVersionMatch == null) {
    stderr.writeln('version_bump: no `version:` field found in pubspec.yaml');
    exit(1);
  }
  final pubspecVersion = _parseSemver(pubspecVersionMatch.group(1)!);

  final tags = _releaseTagsSortedDesc(repoRoot);
  final latestTag = tags.isEmpty ? null : tags.first;
  final latestTagVersion = latestTag == null
      ? null
      : _parseSemver(latestTag.substring(1));

  final baseline =
      latestTagVersion != null && _isGreater(latestTagVersion, pubspecVersion)
      ? latestTagVersion
      : pubspecVersion;
  if (latestTagVersion != null &&
      baseline == pubspecVersion &&
      pubspecVersion != latestTagVersion) {
    stdout.writeln(
      'version_bump: note — tag $latestTag is behind pubspec.yaml '
      '(${pubspecVersionMatch.group(1)}); using pubspec.yaml as the baseline.',
    );
  }

  final commits = _commitsSince(latestTag, repoRoot);
  final parsed = commits.map(_parse).whereType<_ParsedCommit>().toList();

  final added = <_ParsedCommit>[];
  final fixed = <_ParsedCommit>[];
  final changed = <_ParsedCommit>[];
  final breaking = <_ParsedCommit>[];

  var hasFeat = false;
  var hasPatchTrigger = false; // fix or perf
  var hasBreaking = false;

  for (final commit in parsed) {
    if (commit.breaking) {
      hasBreaking = true;
      breaking.add(commit);
    }
    switch (commit.type) {
      case 'feat':
        hasFeat = true;
        added.add(commit);
      case 'fix':
        hasPatchTrigger = true;
        fixed.add(commit);
      case 'perf':
        hasPatchTrigger = true;
        changed.add(commit);
      case 'refactor':
      case 'revert':
        changed.add(commit); // changelog only, doesn't trigger a release
    }
  }

  if (!hasFeat && !hasPatchTrigger && !hasBreaking) {
    stdout.writeln(
      'version_bump: no release-worthy Conventional Commits since '
      '${latestTag ?? "the start of history"} — nothing to release.',
    );
    exit(3);
  }

  final (major, minor, patch) = baseline;
  final next = hasBreaking
      ? (major + 1, 0, 0)
      : hasFeat
      ? (major, minor + 1, 0)
      : (major, minor, patch + 1);
  final newBuild = tags.length + 1;
  final newVersion = '${next.$1}.${next.$2}.${next.$3}';
  final newVersionFull = '$newVersion+$newBuild';

  stdout.writeln(
    'version_bump: ${pubspecVersionMatch.group(1)} -> $newVersionFull '
    '(feat: ${added.length}, fix: ${fixed.length}, '
    'changed: ${changed.length}, breaking: ${breaking.length})',
  );

  if (!checkOnly) {
    final updatedPubspec = pubspecText.replaceFirst(
      RegExp(r'^version:\s*\S+', multiLine: true),
      'version: $newVersionFull',
    );
    pubspecFile.writeAsStringSync(updatedPubspec);

    final changelogFile = File('$repoRoot/CHANGELOG.md');
    final changelogText = changelogFile.readAsStringSync();
    const unreleasedHeader = '## [Unreleased]';
    final unreleasedIndex = changelogText.indexOf(unreleasedHeader);
    if (unreleasedIndex == -1) {
      stderr.writeln(
        'version_bump: CHANGELOG.md has no "## [Unreleased]" section',
      );
      exit(1);
    }
    final insertAt = unreleasedIndex + unreleasedHeader.length;
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final section = StringBuffer()
      ..writeln()
      ..writeln()
      ..writeln('## [$newVersion] - $date');
    if (breaking.isNotEmpty) {
      section
        ..writeln()
        ..writeln('### Breaking Changes');
      for (final c in breaking) {
        final description = c.breakingDescription ?? c.description;
        section.writeln('- $description (${c.hash})');
      }
    }
    if (added.isNotEmpty) {
      section
        ..writeln()
        ..writeln('### Added');
      for (final c in added) {
        section.writeln('- ${c.entry}');
      }
    }
    if (fixed.isNotEmpty) {
      section
        ..writeln()
        ..writeln('### Fixed');
      for (final c in fixed) {
        section.writeln('- ${c.entry}');
      }
    }
    if (changed.isNotEmpty) {
      section
        ..writeln()
        ..writeln('### Changed');
      for (final c in changed) {
        section.writeln('- ${c.entry}');
      }
    }
    final updatedChangelog = changelogText
        .replaceRange(insertAt, insertAt, section.toString())
        .replaceAll(RegExp(r'\n{3,}'), '\n\n');
    changelogFile.writeAsStringSync(updatedChangelog);

    stdout.writeln('version_bump: updated pubspec.yaml and CHANGELOG.md');
  }

  stdout.writeln('NEW_VERSION=$newVersionFull');
}
