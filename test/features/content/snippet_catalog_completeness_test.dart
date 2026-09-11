// Data-completeness guard for the bundled catalogs
// (`assets/content/snippets/go_v1.json`, `bash_v1.json`,
// `sql_v1.json`), independent of drift/seeding — a pure asset-parsing
// check (same `rootBundle` + `SnippetDto` pattern as
// `content_drift_integration_test.dart` and `key_layout_map_test.dart`)
// so a future content edit that accidentally thins out a
// (category, difficulty) cell, orphans a learning-path reference, or
// leaves two active rows sharing one id fails fast, in CI, without a
// full drift round-trip.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/infrastructure/snippet_dto.dart';
import 'package:ridge/features/content/infrastructure/snippet_mapper.dart';

/// One bundled catalog asset per language.
const Map<ProgrammingLanguage, String> _catalogAssetByLanguage = {
  ProgrammingLanguage.go: 'assets/content/snippets/go_v1.json',
  ProgrammingLanguage.bash: 'assets/content/snippets/bash_v1.json',
  ProgrammingLanguage.sql: 'assets/content/snippets/sql_v1.json',
  ProgrammingLanguage.rust: 'assets/content/snippets/rust_v1.json',
  ProgrammingLanguage.python: 'assets/content/snippets/python_v1.json',
  ProgrammingLanguage.javascript: 'assets/content/snippets/javascript_v1.json',
};

/// Languages whose catalog backs free practice (Zen/Sprint/Precision).
/// These are held to the DENSE-grid rules below: the five core categories
/// need >=3 active entries per difficulty, and no category they actually
/// use may have a zero-entry difficulty tier.
///
/// Bash is deliberately NOT here: it is a course-only language (its
/// snippets exist to compose `bash-foundations-v1`, never a free-standing
/// practice pool), so its catalog is held to the lighter rule that it
/// contains exactly the snippets its bundled paths use — see the
/// "course-only" test below. SQL, Rust, Python, and JavaScript follow the
/// same course-only rule.
const Set<ProgrammingLanguage> _freePracticeLanguages = {
  ProgrammingLanguage.go,
};

/// The five categories the Go `go-foundations-v1` route exercises — see
/// the content-model section requiring at least 3 entries per
/// (category, difficulty) cell for free-practice languages.
const Map<ProgrammingLanguage, Set<ContentCategory>> _coreCategoriesByLanguage =
    {
      ProgrammingLanguage.go: {
        ContentCategory.variablesAndTypes,
        ContentCategory.conditionals,
        ContentCategory.loops,
        ContentCategory.functions,
        ContentCategory.errorHandling,
      },
    };

/// The 10 architecture-layer categories represent a DDD/hexagonal or TUI
/// role, not a language feature, so unlike every other category there's
/// no meaningful notion of a "beginner" or "expert" tier: held to a
/// looser bar (>=1 active entry across ANY difficulty) than every other
/// category. See `.claude/skills/content-curriculum/references/content-model.md`.
const Set<ContentCategory> _architectureLayerCategories = {
  ContentCategory.domainModeling,
  ContentCategory.hexagonalPorts,
  ContentCategory.applicationUseCases,
  ContentCategory.persistenceAdapters,
  ContentCategory.restAdapters,
  ContentCategory.testingWithFakes,
  ContentCategory.tuiArchitecture,
  ContentCategory.tuiStyling,
  ContentCategory.tuiComponents,
  ContentCategory.tuiAdapter,
};

/// The 2 algorithm-topic categories back the `go-algorithms-v1` /
/// `rust-algorithms-v1` Learning Routes. Individual snippets in them DO
/// carry a real difficulty (e.g. bubble sort is `beginner`, heap sort is
/// `expert`) unlike an architecture-layer category, but the category
/// itself isn't a dense (category, difficulty) grid the way a
/// language-feature category is — held to the same looser total-count
/// bar as `_architectureLayerCategories` for that reason.
const Set<ContentCategory> _algorithmTopicCategories = {
  ContentCategory.searchingAlgorithms,
  ContentCategory.sortingAlgorithms,
  ContentCategory.graphAlgorithms,
};

Future<List<Snippet>> _loadCatalog(ProgrammingLanguage language) async {
  final raw = await rootBundle.loadString(_catalogAssetByLanguage[language]!);
  final decoded = jsonDecode(raw) as List<Object?>;
  return [
    for (final entry in decoded)
      SnippetDto.fromJson(entry! as Map<String, Object?>).toDomain(),
  ];
}

Future<List<Snippet>> _loadAllCatalogEntries() async {
  final all = <Snippet>[];
  for (final language in _catalogAssetByLanguage.keys) {
    all.addAll(await _loadCatalog(language));
  }
  return all;
}

// Every bundled Learning Path asset — a future fourth path just means
// adding its filename here, not touching the tests below.
const _learningPathAssetPaths = [
  'assets/content/learning_paths/go_foundations_v1.json',
  'assets/content/learning_paths/go_ddd_hexagonal_notes_v1.json',
  'assets/content/learning_paths/go_intermediate_syntax_v1.json',
  'assets/content/learning_paths/go_tui_notes_v1.json',
  'assets/content/learning_paths/go_algorithms_v1.json',
  'assets/content/learning_paths/bash_foundations_v1.json',
  'assets/content/learning_paths/bash_toolkit_v1.json',
  'assets/content/learning_paths/sql_foundations_v1.json',
  'assets/content/learning_paths/rust_foundations_v1.json',
  'assets/content/learning_paths/rust_algorithms_v1.json',
  'assets/content/learning_paths/python_foundations_v1.json',
  'assets/content/learning_paths/python_algorithms_v1.json',
  'assets/content/learning_paths/javascript_foundations_v1.json',
  'assets/content/learning_paths/javascript_algorithms_v1.json',
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

  test('no (category, difficulty) cell among the core categories of a '
      'free-practice language has fewer than 3 active entries', () async {
    final underStocked = <String>[];

    for (final language in _freePracticeLanguages) {
      final catalog = await _loadCatalog(language);
      final active = catalog.where((s) => s.isActive);

      final counts = <(ContentCategory, Difficulty), int>{};
      for (final snippet in active) {
        final key = (snippet.category, snippet.difficulty);
        counts[key] = (counts[key] ?? 0) + 1;
      }

      for (final category in _coreCategoriesByLanguage[language]!) {
        for (final difficulty in Difficulty.values) {
          final count = counts[(category, difficulty)] ?? 0;
          if (count < 3) {
            underStocked.add(
              '$language/$category/$difficulty has only '
              '$count',
            );
          }
        }
      }
    }

    expect(underStocked, isEmpty, reason: underStocked.join('\n'));
  });

  test(
    'no (category, difficulty) cell has zero active entries for a '
    'category a free-practice language actually uses, except '
    'architecture-layer categories which just need >=1 entry total',
    () async {
      final empty = <String>[];

      for (final language in _freePracticeLanguages) {
        final catalog = await _loadCatalog(language);
        final active = catalog.where((s) => s.isActive);

        final counts = <(ContentCategory, Difficulty), int>{};
        final totalsByCategory = <ContentCategory, int>{};
        for (final snippet in active) {
          final key = (snippet.category, snippet.difficulty);
          counts[key] = (counts[key] ?? 0) + 1;
          totalsByCategory[snippet.category] =
              (totalsByCategory[snippet.category] ?? 0) + 1;
        }

        for (final category in totalsByCategory.keys) {
          if (_architectureLayerCategories.contains(category) ||
              _algorithmTopicCategories.contains(category)) {
            if ((totalsByCategory[category] ?? 0) == 0) {
              empty.add('$language/$category has zero active entries');
            }
            continue;
          }
          for (final difficulty in Difficulty.values) {
            if ((counts[(category, difficulty)] ?? 0) == 0) {
              empty.add('$language/$category/$difficulty');
            }
          }
        }
      }

      expect(empty, isEmpty, reason: empty.join('\n'));
    },
  );

  test("a course-only language's catalog holds exactly the snippets its "
      'bundled learning paths use — no orphan practice material', () async {
    // Which snippet ids each language's bundled paths reference.
    final referencedByLanguage = <ProgrammingLanguage, Set<String>>{};
    for (final assetPath in _learningPathAssetPaths) {
      final path = await _loadLearningPath(assetPath);
      final language = ProgrammingLanguage.values.byName(
        path['language']! as String,
      );
      final lessons = await _loadLearningPathLessons(assetPath);
      referencedByLanguage.putIfAbsent(language, () => <String>{}).addAll([
        for (final lesson in lessons) lesson['snippetId']! as String,
      ]);
    }

    final problems = <String>[];
    for (final language in _catalogAssetByLanguage.keys) {
      if (_freePracticeLanguages.contains(language)) continue;

      final catalog = await _loadCatalog(language);
      final activeIds = {
        for (final snippet in catalog)
          if (snippet.isActive) snippet.id.value,
      };
      final referenced = referencedByLanguage[language] ?? const <String>{};

      final orphans = activeIds.difference(referenced);
      if (orphans.isNotEmpty) {
        problems.add(
          '$language has ${orphans.length} active snippet(s) no bundled '
          'learning path uses: ${orphans.join(', ')}',
        );
      }
    }

    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('every id has at most one active entry, and the active revision is '
      'the highest one for that id (immutable-versioning invariant)', () async {
    final violations = <String>[];

    for (final language in _catalogAssetByLanguage.keys) {
      final catalog = await _loadCatalog(language);
      final byId = <String, List<Snippet>>{};
      for (final snippet in catalog) {
        byId.putIfAbsent(snippet.id.value, () => []).add(snippet);
      }

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
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('every entry has a non-empty, reasonably sized bilingual '
      '"what did you just type?" explanation', () async {
    final catalog = await _loadAllCatalogEntries();

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
    final catalog = await _loadAllCatalogEntries();

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
    final catalog = await _loadAllCatalogEntries();

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
    final catalog = await _loadAllCatalogEntries();
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
