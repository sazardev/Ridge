// Data-completeness guard for the bundled Go catalog
// (`assets/content/snippets/go_v1.json`), independent of drift/seeding —
// a pure asset-parsing check (same `rootBundle` + `SnippetDto` pattern as
// `content_drift_integration_test.dart` and `key_layout_map_test.dart`)
// so a future content edit that accidentally thins out a
// (category, difficulty) cell, orphans a learning-path reference, or
// leaves two active rows sharing one id fails fast, in CI, without a
// full drift round-trip.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_dto.dart';
import 'package:just_in_time/features/content/infrastructure/snippet_mapper.dart';

// The 5 categories the first Learning Route (`go_foundations_v1.json`)
// exercises — SPEC.md's content-model section requires at least 3
// entries per (category, difficulty) cell for these, vs. just "at least
// one" for the remaining 7 categories (see `fuzzy-exploring-raven.md`'s
// content section).
const Set<ContentCategory> _coreCategories = {
  ContentCategory.variablesAndTypes,
  ContentCategory.conditionals,
  ContentCategory.loops,
  ContentCategory.functions,
  ContentCategory.errorHandling,
};

// The 5 categories the go-ddd-hexagonal-notes Learning Route exercises —
// these represent an ARCHITECTURE LAYER (DDD/hexagonal role), not a Go
// language feature, so unlike every other category there's no meaningful
// notion of a "beginner" domain entity or an "expert" repository port:
// the whole route targets one intermediate/advanced backend audience.
// Held to a looser bar than every other category (≥1 active entry across
// ANY difficulty, not ≥1 per each of the 4 difficulty tiers) — see
// `.claude/skills/content-curriculum/references/content-model.md`.
const Set<ContentCategory> _architectureLayerCategories = {
  ContentCategory.domainModeling,
  ContentCategory.hexagonalPorts,
  ContentCategory.applicationUseCases,
  ContentCategory.persistenceAdapters,
  ContentCategory.restAdapters,
  ContentCategory.testingWithFakes,
};

Future<List<Snippet>> _loadCatalog() async {
  final raw = await rootBundle.loadString('assets/content/snippets/go_v1.json');
  final decoded = jsonDecode(raw) as List<Object?>;
  return [
    for (final entry in decoded)
      SnippetDto.fromJson(entry! as Map<String, Object?>).toDomain(),
  ];
}

// Every bundled Learning Path asset — a future third path just means
// adding its filename here, not touching the tests below.
const _learningPathAssetPaths = [
  'assets/content/learning_paths/go_foundations_v1.json',
  'assets/content/learning_paths/go_ddd_hexagonal_notes_v1.json',
];

Future<Map<String, Object?>> _loadLearningPath(String assetPath) async {
  final raw = await rootBundle.loadString(assetPath);
  final decoded = jsonDecode(raw) as List<Object?>;
  return decoded.single! as Map<String, Object?>;
}

Future<List<Map<String, Object?>>> _loadLearningPathLessons(
  String assetPath,
) async {
  final path = await _loadLearningPath(assetPath);
  return (path['lessons']! as List<Object?>)
      .cast<Map<String, Object?>>()
      .toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('no (category, difficulty) cell among the 5 core categories has '
      'fewer than 3 active entries', () async {
    final catalog = await _loadCatalog();
    final active = catalog.where((s) => s.isActive);

    final counts = <(ContentCategory, Difficulty), int>{};
    for (final snippet in active) {
      final key = (snippet.category, snippet.difficulty);
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final underStocked = <String>[];
    for (final category in _coreCategories) {
      for (final difficulty in Difficulty.values) {
        final count = counts[(category, difficulty)] ?? 0;
        if (count < 3) {
          underStocked.add('$category/$difficulty has only $count');
        }
      }
    }

    expect(underStocked, isEmpty, reason: underStocked.join('\n'));
  });

  test(
    'no (category, difficulty) cell overall has zero active entries, '
    'except architecture-layer categories which just need >=1 entry total',
    () async {
      final catalog = await _loadCatalog();
      final active = catalog.where((s) => s.isActive);

      final counts = <(ContentCategory, Difficulty), int>{};
      final totalsByCategory = <ContentCategory, int>{};
      for (final snippet in active) {
        final key = (snippet.category, snippet.difficulty);
        counts[key] = (counts[key] ?? 0) + 1;
        totalsByCategory[snippet.category] =
            (totalsByCategory[snippet.category] ?? 0) + 1;
      }

      final empty = <String>[];
      for (final category in ContentCategory.values) {
        if (_architectureLayerCategories.contains(category)) {
          if ((totalsByCategory[category] ?? 0) == 0) {
            empty.add('$category has zero active entries (any difficulty)');
          }
          continue;
        }
        for (final difficulty in Difficulty.values) {
          if ((counts[(category, difficulty)] ?? 0) == 0) {
            empty.add('$category/$difficulty');
          }
        }
      }

      expect(empty, isEmpty, reason: empty.join('\n'));
    },
  );

  test('every id has at most one active entry, and the active revision is '
      'the highest one for that id (immutable-versioning invariant)', () async {
    final catalog = await _loadCatalog();
    final byId = <String, List<Snippet>>{};
    for (final snippet in catalog) {
      byId.putIfAbsent(snippet.id.value, () => []).add(snippet);
    }

    final violations = <String>[];
    for (final entry in byId.entries) {
      final revisions = entry.value;
      final activeOnes = revisions.where((s) => s.isActive).toList();
      if (activeOnes.length > 1) {
        violations.add(
          '${entry.key} has ${activeOnes.length} active revisions',
        );
        continue;
      }
      if (activeOnes.isEmpty) {
        violations.add('${entry.key} has no active revision at all');
        continue;
      }
      final highestRevision = revisions
          .map((s) => s.revision)
          .reduce((a, b) => a > b ? a : b);
      if (activeOnes.single.revision != highestRevision) {
        violations.add(
          '${entry.key} active revision '
          '${activeOnes.single.revision} is not the highest '
          '($highestRevision)',
        );
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('every entry has a non-empty, reasonably sized bilingual '
      '"what did you just type?" explanation', () async {
    final catalog = await _loadCatalog();

    final problems = <String>[];
    for (final snippet in catalog) {
      for (final MapEntry(key: label, value: text) in {
        'explanationEn': snippet.explanationEn,
        'explanationEs': snippet.explanationEs,
      }.entries) {
        if (text.trim().isEmpty) {
          problems.add('${snippet.id.value}: $label is empty');
        } else if (text.length > 950) {
          problems.add(
            '${snippet.id.value}: $label is ${text.length} chars '
            '(expected a tight three sentences: what, why, and when/why '
            "it's used)",
          );
        }
      }
    }

    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('every entry has a non-empty bilingual title', () async {
    final catalog = await _loadCatalog();

    final problems = <String>[];
    for (final snippet in catalog) {
      for (final MapEntry(key: label, value: text) in {
        'titleEn': snippet.titleEn,
        'titleEs': snippet.titleEs,
      }.entries) {
        if (text.trim().isEmpty) {
          problems.add('${snippet.id.value}: $label is empty');
        }
      }
    }

    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('every entry has a non-empty, skimmable bilingual tl;dr', () async {
    final catalog = await _loadCatalog();

    final problems = <String>[];
    for (final snippet in catalog) {
      for (final MapEntry(key: label, value: text) in {
        'tldrEn': snippet.tldrEn,
        'tldrEs': snippet.tldrEs,
      }.entries) {
        if (text.trim().isEmpty) {
          problems.add('${snippet.id.value}: $label is empty');
        } else if (text.length > 80) {
          problems.add(
            '${snippet.id.value}: $label is ${text.length} chars '
            '(expected a short skimmable fragment)',
          );
        }
      }
    }

    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('every snippet id referenced by every bundled learning path '
      'resolves to an active catalog entry', () async {
    final catalog = await _loadCatalog();
    final activeIds = catalog
        .where((s) => s.isActive)
        .map((s) => s.id.value)
        .toSet();

    final unresolved = <String>[];
    for (final assetPath in _learningPathAssetPaths) {
      final lessons = await _loadLearningPathLessons(assetPath);
      for (final lesson in lessons) {
        final snippetId = lesson['snippetId']! as String;
        if (!activeIds.contains(snippetId)) {
          unresolved.add('${lesson['id']} -> $snippetId');
        }
      }
    }

    expect(unresolved, isEmpty, reason: unresolved.join('\n'));
  });

  test('every bundled learning path and every lesson in it has a '
      'non-empty bilingual title', () async {
    final problems = <String>[];

    for (final assetPath in _learningPathAssetPaths) {
      final path = await _loadLearningPath(assetPath);

      for (final MapEntry(key: label, value: text) in {
        'titleEn': path['titleEn'],
        'titleEs': path['titleEs'],
        'descriptionEn': path['descriptionEn'],
        'descriptionEs': path['descriptionEs'],
        'tagEn': path['tagEn'],
        'tagEs': path['tagEs'],
      }.entries) {
        if ((text! as String).trim().isEmpty) {
          problems.add('${path['id']}: $label is empty');
        }
      }

      final lessons = await _loadLearningPathLessons(assetPath);
      for (final lesson in lessons) {
        for (final MapEntry(key: label, value: text) in {
          'titleEn': lesson['titleEn'],
          'titleEs': lesson['titleEs'],
        }.entries) {
          if ((text! as String).trim().isEmpty) {
            problems.add('${lesson['id']}: $label is empty');
          }
        }
      }
    }

    expect(problems, isEmpty, reason: problems.join('\n'));
  });
}
