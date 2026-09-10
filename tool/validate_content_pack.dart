// Validates a third-party content-pack JSON file against this app's
// *real* wire schema (`SnippetDto` / `LearningPathDto`, imported
// directly rather than re-implemented — a hand-maintained validator
// could silently drift from what the app actually accepts, this can't)
// before it's dropped into
// `contentPacksSnippetsDir()`/`contentPacksLearningPathsDir()`. Catches,
// with an actionable message, exactly what
// `CompositeSnippetCatalogSource`/`LearningPathRepositoryImpl` would
// otherwise silently skip at runtime (a `debugPrint` warning, easy to
// miss). See
// `.claude/skills/content-curriculum/references/external-content-packs.md`
// for the full external-pack contract this checks against.
//
// Usage:
//   dart run tool/validate_content_pack.dart --type=snippets path/to/file.json
//   dart run tool/validate_content_pack.dart --type=learning-path path/to/file.json
//
// Exit 0 and a single "OK" line on success; exit 1 and an itemized
// problem list otherwise. Exit 2 for a usage error (bad args, missing
// file).
import 'dart:convert';
import 'dart:io';

import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';
import 'package:ridge/features/learning_paths/infrastructure/learning_path_dto.dart';

const _maxTldrChars = 80;
const _maxExplanationChars = 950;

void main(List<String> args) {
  String? type;
  String? path;
  for (final arg in args) {
    if (arg.startsWith('--type=')) {
      type = arg.substring('--type='.length);
    } else {
      path = arg;
    }
  }

  if (type == null || path == null) {
    stderr.writeln(
      'Usage: dart run tool/validate_content_pack.dart '
      '--type=<snippets|learning-path> <path/to/file.json>',
    );
    exit(2);
  }

  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('validate_content_pack: file not found: $path');
    exit(2);
  }

  final problems = switch (type) {
    'snippets' => _validateSnippets(file),
    'learning-path' => _validateLearningPath(file),
    _ => ['Unknown --type "$type" (expected "snippets" or "learning-path").'],
  };

  if (problems.isEmpty) {
    // A CLI tool's whole purpose is printing to stdout — this isn't a
    // stray debug print left in library code.
    // ignore: avoid_print
    print('validate_content_pack: $path — OK');
    exit(0);
  }

  stderr.writeln(
    'validate_content_pack: $path — ${problems.length} problem(s):',
  );
  for (final problem in problems) {
    stderr.writeln('  - $problem');
  }
  exit(1);
}

List<Object?>? _decodeArray(File file, List<String> problems) {
  final Object? decoded;
  try {
    decoded = jsonDecode(file.readAsStringSync());
    // Broad catch: malformed JSON can throw `FormatException` (an
    // `Exception`) but a wrong file encoding or I/O failure can throw
    // other `Error`/`Exception` types too — any of them means "this
    // file is not usable," which is the one thing this function reports.
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    problems.add('File is not readable/valid JSON: $e');
    return null;
  }
  if (decoded is! List<Object?>) {
    problems.add(
      'Top level of the file must be a JSON array, got '
      '${decoded.runtimeType}.',
    );
    return null;
  }
  return decoded;
}

List<String> _validateSnippets(File file) {
  final problems = <String>[];
  final decoded = _decodeArray(file, problems);
  if (decoded == null) return problems;
  if (decoded.isEmpty) problems.add('The array is empty.');

  final seenIds = <String>{};
  for (var i = 0; i < decoded.length; i++) {
    final entry = decoded[i];
    if (entry is! Map<String, Object?>) {
      problems.add('Entry $i is not a JSON object.');
      continue;
    }

    final SnippetDto dto;
    try {
      dto = SnippetDto.fromJson(entry);
      // Broad catch: a missing/wrong-typed required field throws
      // `TypeError`/`Error` from json_serializable's generated code, not
      // always a plain `Exception`.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      problems.add('Entry $i: failed to parse — $e');
      continue;
    }

    final label = 'Entry $i ("${dto.id}")';
    if (!seenIds.add(dto.id)) {
      problems.add('$label: duplicate id within this file.');
    }
    _checkEnumName(
      problems,
      label,
      'category',
      dto.category,
      ContentCategory.values.map((c) => c.name),
    );
    _checkEnumName(
      problems,
      label,
      'difficulty',
      dto.difficulty,
      Difficulty.values.map((d) => d.name),
    );
    _checkEnumName(
      problems,
      label,
      'language',
      dto.language,
      ProgrammingLanguage.values.map((l) => l.name),
    );
    _checkEnumName(
      problems,
      label,
      'length',
      dto.length,
      SnippetLength.values.map((l) => l.name),
    );

    _checkNonEmpty(problems, label, 'titleEn', dto.titleEn);
    _checkNonEmpty(problems, label, 'titleEs', dto.titleEs);
    _checkNonEmpty(problems, label, 'code', dto.code);
    _checkNonEmpty(problems, label, 'explanationEn', dto.explanationEn);
    _checkNonEmpty(problems, label, 'explanationEs', dto.explanationEs);
    _checkNonEmpty(problems, label, 'tldrEn', dto.tldrEn);
    _checkNonEmpty(problems, label, 'tldrEs', dto.tldrEs);
    _checkMaxLength(problems, label, 'tldrEn', dto.tldrEn, _maxTldrChars);
    _checkMaxLength(problems, label, 'tldrEs', dto.tldrEs, _maxTldrChars);
    _checkMaxLength(
      problems,
      label,
      'explanationEn',
      dto.explanationEn,
      _maxExplanationChars,
    );
    _checkMaxLength(
      problems,
      label,
      'explanationEs',
      dto.explanationEs,
      _maxExplanationChars,
    );
  }

  return problems;
}

List<String> _validateLearningPath(File file) {
  final problems = <String>[];
  final decoded = _decodeArray(file, problems);
  if (decoded == null) return problems;
  if (decoded.isEmpty) problems.add('The array is empty.');

  for (var i = 0; i < decoded.length; i++) {
    final entry = decoded[i];
    if (entry is! Map<String, Object?>) {
      problems.add('Entry $i is not a JSON object.');
      continue;
    }

    final LearningPathDto dto;
    try {
      dto = LearningPathDto.fromJson(entry);
      // Broad catch: same reason as `_validateSnippets` above — a
      // missing/wrong-typed required field throws `TypeError`/`Error`,
      // not always a plain `Exception`.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      problems.add('Entry $i: failed to parse — $e');
      continue;
    }

    final label = 'Path $i ("${dto.id}")';
    _checkEnumName(
      problems,
      label,
      'language',
      dto.language,
      ProgrammingLanguage.values.map((l) => l.name),
    );
    _checkNonEmpty(problems, label, 'titleEn', dto.titleEn);
    _checkNonEmpty(problems, label, 'titleEs', dto.titleEs);
    _checkNonEmpty(problems, label, 'descriptionEn', dto.descriptionEn);
    _checkNonEmpty(problems, label, 'descriptionEs', dto.descriptionEs);
    _checkNonEmpty(problems, label, 'tagEn', dto.tagEn);
    _checkNonEmpty(problems, label, 'tagEs', dto.tagEs);

    if (dto.lessons.isEmpty) {
      problems.add('$label: has no lessons.');
    }
    final seenLessonIds = <String>{};
    for (var j = 0; j < dto.lessons.length; j++) {
      final lesson = dto.lessons[j];
      final lessonLabel = '$label lesson $j ("${lesson.id}")';
      if (!seenLessonIds.add(lesson.id)) {
        problems.add('$lessonLabel: duplicate lesson id within this path.');
      }
      _checkNonEmpty(problems, lessonLabel, 'titleEn', lesson.titleEn);
      _checkNonEmpty(problems, lessonLabel, 'titleEs', lesson.titleEs);
      _checkNonEmpty(problems, lessonLabel, 'snippetId', lesson.snippetId);
    }
  }

  return problems;
}

void _checkEnumName(
  List<String> problems,
  String label,
  String field,
  String value,
  Iterable<String> validValues,
) {
  if (validValues.contains(value)) return;
  final valid = validValues.join(', ');
  problems.add('$label: $field "$value" is not one of: $valid.');
}

void _checkNonEmpty(
  List<String> problems,
  String label,
  String field,
  String value,
) {
  if (value.trim().isEmpty) problems.add('$label: $field is empty.');
}

void _checkMaxLength(
  List<String> problems,
  String label,
  String field,
  String value,
  int maxLength,
) {
  if (value.length > maxLength) {
    problems.add('$label: $field is ${value.length} chars (max $maxLength).');
  }
}
