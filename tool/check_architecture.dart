// Enforces structural rules that analysis_options.yaml cannot express:
// a hard line-count ceiling per file and the inward-only dependency
// direction of the hexagonal architecture described in README.md.
// See CODE_STANDARDS.md for the full rationale behind each rule.
//
// Usage: dart run tool/check_architecture.dart
//
// Hard rules (exit code 1 — block commit/push/CI):
//   - No non-generated file under lib/ may exceed [_maxLines] lines.
//   - Files under a domain/ or application/ layer may not import
//     package:flutter, an infrastructure/ path, or a presentation/ path.
//
// Soft rules (printed, never fail the build):
//   - More than one public top-level type per file is flagged for manual
//     review — sealed-class hierarchies legitimately need this, so it is
//     never a hard failure.
import 'dart:io';

const _maxLines = 500;

const _innerLayers = ['domain', 'application'];
const _forbiddenForInnerLayers = ['/infrastructure/', '/presentation/'];

final _topLevelTypeRegExp = RegExp(
  r'^(?:abstract\s+|base\s+|final\s+|sealed\s+|interface\s+)*'
  r'(?:class|mixin|enum)\s+([A-Za-z_$][\w$]*)',
);

bool _isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.freezed.dart') ||
    path.contains('/core/i18n/gen/');

List<String> _layerSegmentsOf(String path) => path.split('/');

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('check_architecture: lib/ not found, nothing to check.');
    exit(0);
  }

  final files =
      libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !_isGenerated(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final errors = <String>[];
  final warnings = <String>[];

  for (final file in files) {
    final relativePath = file.path.replaceFirst(
      '${Directory.current.path}/',
      '',
    );
    final lines = file.readAsLinesSync();

    if (lines.length > _maxLines) {
      errors.add(
        '$relativePath has ${lines.length} lines (limit: $_maxLines). '
        'Split it — a file should do one thing.',
      );
    }

    final segments = _layerSegmentsOf(relativePath);
    final isInnerLayer = segments.any(_innerLayers.contains);
    if (isInnerLayer) {
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (!line.trimLeft().startsWith('import ')) continue;
        final touchesFlutter = line.contains('package:flutter/');
        final touchesOuterLayer = _forbiddenForInnerLayers.any(line.contains);
        if (touchesFlutter || touchesOuterLayer) {
          errors.add(
            '$relativePath:${i + 1} — domain/application code must not '
            'depend on Flutter or on infrastructure/presentation: `${line.trim()}`',
          );
        }
      }
    }

    final publicTypes = <String>[];
    for (final line in lines) {
      if (line.startsWith(RegExp(r'\s'))) continue;
      final match = _topLevelTypeRegExp.firstMatch(line);
      if (match == null) continue;
      final name = match.group(1)!;
      if (!name.startsWith('_')) publicTypes.add(name);
    }
    if (publicTypes.length > 1) {
      warnings.add(
        '$relativePath declares ${publicTypes.length} public top-level '
        'types (${publicTypes.join(', ')}) — consider one file per type '
        'unless this is an intentional sealed-class hierarchy.',
      );
    }
  }

  if (warnings.isNotEmpty) {
    stdout.writeln('check_architecture: ${warnings.length} warning(s):');
    for (final warning in warnings) {
      stdout.writeln('  - $warning');
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('check_architecture: ${errors.length} violation(s):');
    for (final error in errors) {
      stderr.writeln('  - $error');
    }
    exit(1);
  }

  stdout.writeln(
    'check_architecture: ${files.length} files checked, no hard violations.',
  );
}
