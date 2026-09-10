// Unit tests for `GetNextSprintSnippetUseCase` — the Sprint
// snippet-advancement logic (SPEC.md §5.2): fabricated `Snippet`s and a
// hand-written `_FakeSnippetRepository` (mirroring `tasks`'s established
// hand-fake-port test pattern), no widget/clock/drift needed.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/practice/application/usecases/get_next_sprint_snippet_usecase.dart';

Snippet _snippet(
  String id, {
  Difficulty difficulty = Difficulty.beginner,
  ProgrammingLanguage language = ProgrammingLanguage.go,
}) {
  return Snippet(
    id: SnippetId(id),
    revision: 1,
    language: language,
    difficulty: difficulty,
    category: ContentCategory.variablesAndTypes,
    symbolFocus: const {},
    length: SnippetLength.short,
    titleEn: id,
    titleEs: id,
    code: 'x',
    sourceAttribution: 'hand-authored for test',
    isActive: true,
    tldrEn: 'Test tl;dr.',
    tldrEs: 'Tl;dr de prueba.',
    explanationEn: 'Test explanation.',
    explanationEs: 'Explicación de prueba.',
  );
}

class _FakeSnippetRepository implements SnippetRepository {
  new(this.snippets);

  final List<Snippet> snippets;

  @override
  Future<Result<List<Snippet>, AppFailure>> findByFilters({
    ProgrammingLanguage? language,
    Difficulty? difficulty,
    ContentCategory? category,
    SnippetLength? length,
  }) async {
    return Result.ok([
      for (final snippet in snippets)
        if ((language == null || snippet.language == language) &&
            (difficulty == null || snippet.difficulty == difficulty))
          snippet,
    ]);
  }

  @override
  Stream<List<Snippet>> watchCatalog() => const Stream.empty();

  @override
  Future<Result<Snippet, AppFailure>> getById(SnippetId id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Snippet>, AppFailure>> findContainingSymbols(
    Set<String> characters,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<void, AppFailure>> upsertCatalogEntries(
    List<Snippet> entries,
  ) async {
    throw UnimplementedError();
  }
}

void main() {
  test(
    'prefers a snippet of the same difficulty not already used this run',
    () async {
      final repository = _FakeSnippetRepository([
        _snippet('a'),
        _snippet('b'),
        _snippet('c'),
      ]);
      final useCase = GetNextSprintSnippetUseCase(repository);

      final result = await useCase(
        language: ProgrammingLanguage.go,
        difficulty: Difficulty.beginner,
        usedSnippetIds: {const SnippetId('a'), const SnippetId('b')},
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.id, const SnippetId('c'));
    },
  );

  test('allows repeats once every candidate of that difficulty has been used '
      'rather than dead-ending the Sprint timer', () async {
    final repository = _FakeSnippetRepository([
      _snippet('a', difficulty: Difficulty.intermediate),
      _snippet('b', difficulty: Difficulty.intermediate),
    ]);
    final useCase = GetNextSprintSnippetUseCase(repository);

    final result = await useCase(
      language: ProgrammingLanguage.go,
      difficulty: Difficulty.intermediate,
      usedSnippetIds: {const SnippetId('a'), const SnippetId('b')},
    );

    expect(result.isOk, isTrue);
    expect({
      const SnippetId('a'),
      const SnippetId('b'),
    }, contains(result.valueOrNull!.id));
  });

  test(
    'only a genuinely empty catalog for that difficulty is an error',
    () async {
      final repository = _FakeSnippetRepository([]);
      final useCase = GetNextSprintSnippetUseCase(repository);

      final result = await useCase(
        language: ProgrammingLanguage.go,
        difficulty: Difficulty.expert,
        usedSnippetIds: const {},
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<NotFoundFailure>());
    },
  );

  test('an injected random source makes the pick deterministic', () async {
    final repository = _FakeSnippetRepository([
      _snippet('a'),
      _snippet('b'),
      _snippet('c'),
    ]);
    // A fixed seed always produces the same first `nextInt` draw for a
    // given pool size, so this pins down exactly which unused candidate
    // is picked without depending on real randomness.
    final useCase = GetNextSprintSnippetUseCase(
      repository,
      random: const _FixedRandom(1),
    );

    final result = await useCase(
      language: ProgrammingLanguage.go,
      difficulty: Difficulty.beginner,
      usedSnippetIds: const {},
    );

    expect(result.valueOrNull!.id, const SnippetId('b'));
  });

  test('never crosses languages: a Go Sprint run only advances to Go '
      'snippets', () async {
    final repository = _FakeSnippetRepository([
      _snippet('go-a'),
      _snippet('bash-a', language: ProgrammingLanguage.bash),
    ]);
    final useCase = GetNextSprintSnippetUseCase(repository);

    final result = await useCase(
      language: ProgrammingLanguage.go,
      difficulty: Difficulty.beginner,
      usedSnippetIds: const {},
    );

    expect(result.valueOrNull!.id, const SnippetId('go-a'));
  });
}

/// A `Random` stand-in that always returns [index] from `nextInt` — the
/// only method [GetNextSprintSnippetUseCase] actually calls — for a fully
/// deterministic pick in tests.
class _FixedRandom implements Random {
  const new(this.index);

  final int index;

  @override
  int nextInt(int max) => index;

  @override
  double nextDouble() => throw UnimplementedError();

  @override
  bool nextBool() => throw UnimplementedError();
}
