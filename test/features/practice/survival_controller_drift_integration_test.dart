// Exercises Survival mode's controller wiring end-to-end (SPEC.md §5.8):
// a *real* in-memory drift (SQLite) database for profile/session
// persistence, a hand-fake `SnippetRepository` standing in for the
// catalog stream, and the real `PracticeSessionController` — proof that
// rejected keystrokes drain lives, a cleared snippet advances the
// stream, the last life ends the run, the finished run persists like any
// other session, and Retry starts a genuinely fresh run.
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/repositories/snippet_repository.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/content/presentation/providers/content_providers.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_session_status.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';

const _snippet = Snippet(
  id: SnippetId('go-survival-test-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Survival test snippet',
  titleEs: 'Snippet de prueba de supervivencia',
  code: 'abc',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

/// The same-language/same-difficulty snippet Survival must advance to once
/// [_snippet] is completed.
const _nextSnippet = Snippet(
  id: SnippetId('go-survival-test-002'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.loops,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Next survival snippet',
  titleEs: 'Siguiente snippet de supervivencia',
  code: 'de',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

/// Minimal hand-fake port over two fixed snippets — keeps this test off
/// the bundled catalog asset (whose parser is shared with other,
/// unrelated work in flight) while still exercising the real
/// `GetNextSprintSnippetUseCase` selection logic.
class _FakeSnippetRepository implements SnippetRepository {
  const new(this.snippets);

  final List<Snippet> snippets;

  @override
  Stream<List<Snippet>> watchCatalog() => Stream.value(snippets);

  @override
  Future<Result<Snippet, AppFailure>> getById(SnippetId id) async {
    final match = snippets.where((s) => s.id == id);
    return match.isEmpty
        ? const Result.err(NotFoundFailure('No such snippet'))
        : Result.ok(match.first);
  }

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
            (difficulty == null || snippet.difficulty == difficulty) &&
            (category == null || snippet.category == category) &&
            (length == null || snippet.length == length))
          snippet,
    ]);
  }

  @override
  Future<Result<List<Snippet>, AppFailure>> findContainingSymbols(
    Set<String> characters,
  ) async => const Result.ok(<Snippet>[]);

  @override
  Future<Result<void, AppFailure>> upsertCatalogEntries(
    List<Snippet> entries,
  ) async => const Result.ok(null);
}

/// Polls [condition] until it holds, failing the test on timeout — used
/// instead of a bare `pump` because the controller's stream advance and
/// finish paths are genuinely async (drift queries + repo writes).
Future<void> _waitUntil(bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('condition never became true');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ProviderContainer container;

  const mode = PracticeMode.survival();
  final provider = practiceSessionControllerProvider(_snippet, mode);

  /// A (key, char) pair guaranteed *not* to match the character currently
  /// expected by the live recorder — the advanced-to snippet is picked by
  /// the real selection logic, so hardcoding a wrong character could
  /// accidentally be the right one.
  ({PhysicalKeyId key, String char}) wrongKey() {
    final state = container.read(provider);
    final expected = state.snippet.code[state.recorder.expectedCursor];
    return expected == 'x'
        ? (key: PhysicalKeyId.keyZ, char: 'z')
        : (key: PhysicalKeyId.keyX, char: 'x');
  }

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        snippetRepositoryProvider.overrideWithValue(
          const _FakeSnippetRepository([_snippet, _nextSnippet]),
        ),
      ],
    );
    addTearDown(() => database.close());
    addTearDown(container.dispose);

    // Riverpod only pumps a StreamNotifier's underlying subscription
    // while something actively listens (mirrors
    // `profile_drift_integration_test.dart`).
    container.listen(activeProfileControllerProvider, (_, _) {});
  });

  Future<GuestProfile> createProfile() async {
    final result = await container
        .read(activeProfileControllerProvider.notifier)
        .create('nova');
    expect(result.isOk, isTrue);
    await _waitUntil(
      () => container.read(activeProfileControllerProvider).value != null,
    );
    return container.read(activeProfileControllerProvider).value!;
  }

  test('lives drain per rejected keystroke, a cleared snippet advances the '
      'stream, and the last life ends the persisted run', () async {
    final profile = await createProfile();

    container.listen(provider, (_, _) {});
    // Type the starting snippet correctly: the combo and score grow,
    // no life is lost.
    final controller = container.read(provider.notifier)
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b')
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c');

    // Completing it must seamlessly advance to the next
    // same-language/difficulty snippet.
    await _waitUntil(() => container.read(provider).snippet.id != _snippet.id);
    final afterAdvance = container.read(provider);
    expect(afterAdvance.snippet.id, _nextSnippet.id);
    expect(afterAdvance.status, PracticeSessionStatus.running);
    expect(afterAdvance.survival!.snippetsCleared, 1);
    expect(afterAdvance.survival!.livesRemaining, 5);
    expect(afterAdvance.survival!.currentStreak, 3);
    expect(afterAdvance.survival!.score, 3);

    // Four rejected keystrokes leave one life; the fifth ends the run.
    for (var i = 0; i < 4; i++) {
      final wrong = wrongKey();
      controller.ingestChar(physicalKeyId: wrong.key, char: wrong.char);
    }
    expect(container.read(provider).survival!.livesRemaining, 1);

    final fatal = wrongKey();
    controller.ingestChar(physicalKeyId: fatal.key, char: fatal.char);
    expect(container.read(provider).survival!.isOver, isTrue);

    await _waitUntil(() => container.read(provider).finishedSession != null);
    final finished = container.read(provider).finishedSession!;
    expect(finished.session.passed, isNull);
    expect(finished.session.mode, mode);

    // The whole run is ONE session, denormalized onto the starting
    // snippet, with every keystroke (3 correct + 5 substitutions) in
    // one contiguous log.
    final sessionRows = await container
        .read(practiceDaoProvider)
        .watchSessionsForProfile(profile.id.value)
        .first;
    expect(sessionRows, hasLength(1));
    expect(sessionRows.single.mode, 'survival');
    expect(sessionRows.single.passed, isNull);
    expect(sessionRows.single.snippetId, _snippet.id.value);

    final keystrokeRows = await container
        .read(practiceDaoProvider)
        .getKeystrokesForSession(sessionRows.single.id);
    expect(keystrokeRows, hasLength(8));
    expect(keystrokeRows.map((r) => r.seq), [0, 1, 2, 3, 4, 5, 6, 7]);
    expect(
      keystrokeRows.where((r) => r.result == 'substitution'),
      hasLength(5),
    );
    expect(keystrokeRows.where((r) => r.result == 'correct'), hasLength(3));

    // Retry starts a genuinely fresh run.
    controller.retry();
    final fresh = container.read(provider);
    expect(fresh.status, PracticeSessionStatus.idle);
    expect(fresh.survival!.livesRemaining, 5);
    expect(fresh.survival!.score, 0);
    expect(fresh.survival!.snippetsCleared, 0);
  });
}
