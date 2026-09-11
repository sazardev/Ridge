// Unit tests for `GetTodaysDailyChallengeUseCase` — resolving today's
// shared snippet from a fixed Go/beginner-intermediate pool (SPEC.md
// §5.4). A hand-written `_FakeSnippetRepository` (mirroring `tasks`'s
// established hand-fake-port test pattern), no widget/clock/drift
// needed.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/repositories/snippet_repository.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/application/usecases/get_todays_daily_challenge_usecase.dart';

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

  @override
  Future<Result<List<Snippet>, AppFailure>> getByIds(Set<SnippetId> ids) async {
    throw UnimplementedError();
  }
}

void main() {
  test('picks only from Go beginner/intermediate snippets, never advanced, '
      'expert or other languages', () async {
    final repository = _FakeSnippetRepository([
      _snippet('go-beginner'),
      _snippet('go-intermediate', difficulty: Difficulty.intermediate),
      _snippet('go-advanced', difficulty: Difficulty.advanced),
      _snippet('go-expert', difficulty: Difficulty.expert),
      _snippet('bash-beginner', language: ProgrammingLanguage.bash),
    ]);
    final useCase = GetTodaysDailyChallengeUseCase(repository);

    final result = await useCase(nowUtc: DateTime.utc(2026, 1, 10));

    expect(result.isOk, isTrue);
    final eligible = {
      const SnippetId('go-beginner'),
      const SnippetId('go-intermediate'),
    };
    expect(eligible, contains(result.valueOrNull!.snippet.id));
  });

  test('is deterministic: the same UTC day always resolves the same '
      'snippet', () async {
    final repository = _FakeSnippetRepository([
      _snippet('go-a'),
      _snippet('go-b', difficulty: Difficulty.intermediate),
      _snippet('go-c'),
    ]);
    final useCase = GetTodaysDailyChallengeUseCase(repository);
    final nowUtc = DateTime.utc(2026, 3, 4, 15, 30);

    final first = await useCase(nowUtc: nowUtc);
    final second = await useCase(
      nowUtc: DateTime.utc(2026, 3, 4, 2), // same UTC day, different time
    );

    expect(first.valueOrNull!.snippet.id, second.valueOrNull!.snippet.id);
    expect(
      first.valueOrNull!.challenge.date,
      second.valueOrNull!.challenge.date,
    );
  });

  test('an empty eligible pool is a NotFoundFailure, not a crash', () async {
    final repository = _FakeSnippetRepository([
      _snippet('go-advanced-only', difficulty: Difficulty.advanced),
    ]);
    final useCase = GetTodaysDailyChallengeUseCase(repository);

    final result = await useCase(nowUtc: DateTime.utc(2026, 1, 10));

    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test("the resolved challenge's snippetId/snippetRevision match the "
      'picked snippet', () async {
    final repository = _FakeSnippetRepository([_snippet('go-only')]);
    final useCase = GetTodaysDailyChallengeUseCase(repository);

    final result = await useCase(nowUtc: DateTime.utc(2026, 1, 10));

    final today = result.valueOrNull!;
    expect(today.challenge.snippetId, today.snippet.id);
    expect(today.challenge.snippetRevision, today.snippet.revision);
  });
}
