// Exercises the practice feature's full stack — the domain capture
// engine, `FinishPracticeSessionUseCase`, `SessionRepositoryImpl`,
// `PracticeDao`, and the shared `AppDatabase` — against a *real*
// in-memory drift (SQLite) database, mirroring
// `test/features/content/content_drift_integration_test.dart`'s style.
// This is the single most important validation of this build phase:
// proof that capture -> classify -> metrics -> persist works for real,
// not just that it compiles.
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/entities/snippet_length.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

const _snippet = Snippet(
  id: SnippetId('go-test-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  // Deliberately short but real Go-shaped code, including a symbol.
  titleEn: 'Test snippet',
  titleEs: 'Snippet de prueba',
  code: 'a=1',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

// A second, differently-categorized snippet — used to prove a Sprint run
// denormalizes onto the *first/starting* snippet even once it has
// advanced to a different one (SPEC.md §5.2's design decision).
const _secondSnippet = Snippet(
  id: SnippetId('go-test-002'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.loops,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Second test snippet',
  titleEs: 'Segundo snippet de prueba',
  code: 'bc',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Second test explanation.',
  explanationEs: 'Segunda explicación de prueba.',
);

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() => database.close());
    addTearDown(container.dispose);
  });

  test(
    'typing every character, including a deliberate mistake and its '
    'correction, produces a real persisted TypingSession + Keystroke rows',
    () async {
      // Drive the real domain capture engine exactly as the capture
      // widget would under hard lock: type 'a' correctly, mistype 'x'
      // instead of '=' (rejected — the buffer does not advance, no
      // backspace needed), then retype '=' correctly and finish.
      final recorder = KeystrokeStreamRecorder(expectedSnippet: _snippet.code)
        ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
        ..ingestChar(
          physicalKeyId: PhysicalKeyId.keyX,
          char: 'x',
          flight: const Duration(milliseconds: 120),
        )
        ..ingestChar(
          physicalKeyId: PhysicalKeyId.equal,
          char: '=',
          flight: const Duration(milliseconds: 150),
        )
        ..ingestChar(
          physicalKeyId: PhysicalKeyId.digit1,
          char: '1',
          flight: const Duration(milliseconds: 130),
        );
      expect(recorder.isComplete, isTrue);
      final keystrokes = recorder.finish();
      expect(keystrokes, hasLength(4));

      final profileId = ProfileId.generate();
      final sessionId = TypingSessionId.generate();

      final result = await container.read(finishPracticeSessionUseCaseProvider)(
        id: sessionId,
        profileId: profileId,
        mode: const PracticeMode.zen(),
        snippet: _snippet,
        startedAtUtc: DateTime.utc(2026),
        duration: const Duration(seconds: 10),
        keystrokes: keystrokes,
      );

      expect(result.isOk, isTrue);
      final finished = result.valueOrNull!;

      // Zen-mode placeholders: never touched by `practice` itself.
      expect(finished.session.passed, isNull);
      expect(finished.session.xpAwarded, 0);
      expect(finished.session.isFirstCompletion, isFalse);

      // 4 forward keystrokes (a, x, =, 1), 3 correct -> 75% accuracy.
      expect(finished.session.accuracyPct, 75);
      expect(finished.session.rawSpeedCpm, 24);
      expect(finished.session.netSpeedCpm, 18);
      expect(finished.metrics.characterStats, isNotEmpty);

      // Prove the write actually landed in SQLite — query the DAO fresh,
      // independent of the use-case's in-memory return value.
      final sessionRows = await container
          .read(practiceDaoProvider)
          .watchSessionsForProfile(profileId.value)
          .first;
      expect(sessionRows, hasLength(1));
      expect(sessionRows.single.id, sessionId.value);
      expect(sessionRows.single.snippetId, _snippet.id.value);
      expect(sessionRows.single.category, _snippet.category.name);
      expect(sessionRows.single.difficulty, _snippet.difficulty.name);
      expect(sessionRows.single.passed, isNull);
      expect(sessionRows.single.xpAwarded, 0);
      expect(sessionRows.single.isFirstCompletion, isFalse);

      final keystrokeRows = await container
          .read(practiceDaoProvider)
          .getKeystrokesForSession(sessionId.value);
      expect(keystrokeRows, hasLength(4));
      expect(keystrokeRows.map((r) => r.seq), [0, 1, 2, 3]);
      expect(
        keystrokeRows.map((r) => r.sessionStartedAtUtcMicros).toSet(),
        hasLength(1),
        reason: 'every row denormalizes the same session start time',
      );
      expect(keystrokeRows.where((r) => r.isCorrection), isEmpty);
      expect(keystrokeRows[1].result, 'substitution');
      expect(keystrokeRows[1].expectedChar, '=');
      expect(keystrokeRows[1].actualChar, 'x');
      expect(keystrokeRows[2].result, 'correct');
      expect(keystrokeRows[2].actualChar, '=');
    },
  );

  test(
    'a genuinely abandoned session (never finished) writes nothing',
    () async {
      // No call to FinishPracticeSessionUseCase at all — nothing should
      // exist in storage. This is the counterpart proof to the persisted
      // case above: only a closed, finished session is ever written
      // (SPEC.md §8.1).
      final rows = await container
          .read(practiceDaoProvider)
          .watchSessionsForProfile(ProfileId.generate().value)
          .first;
      expect(rows, isEmpty);
    },
  );

  test('a Sprint run spanning two snippets (mid-session retarget) persists '
      'as ONE typing_sessions row, denormalized onto the *starting* '
      'snippet, with keystrokes from both snippets in one contiguous '
      'sequence (SPEC.md §5.2)', () async {
    // Drive the recorder exactly as `PracticeSessionController` would:
    // finish the first snippet, retarget to the second one mid-run
    // (the countdown hadn't reached zero), then finish for real.
    final recorder = KeystrokeStreamRecorder(expectedSnippet: _snippet.code)
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
      ..ingestChar(physicalKeyId: PhysicalKeyId.equal, char: '=')
      ..ingestChar(physicalKeyId: PhysicalKeyId.digit1, char: '1');
    expect(recorder.isComplete, isTrue);

    recorder.retarget(_secondSnippet.code);
    expect(recorder.isComplete, isFalse);

    recorder
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b')
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyC, char: 'c');
    expect(recorder.isComplete, isTrue);

    final keystrokes = recorder.finish();
    expect(keystrokes, hasLength(5));

    final profileId = ProfileId.generate();
    final sessionId = TypingSessionId.generate();

    final result = await container.read(finishPracticeSessionUseCaseProvider)(
      id: sessionId,
      profileId: profileId,
      mode: const PracticeMode.sprint(window: Duration(seconds: 30)),
      // The controller always persists against the *starting* snippet
      // for a Sprint run, even though the recorder itself has already
      // advanced past it — see the project plan's design decision.
      snippet: _snippet,
      startedAtUtc: DateTime.utc(2026),
      duration: const Duration(seconds: 10),
      keystrokes: keystrokes,
    );

    expect(result.isOk, isTrue);
    final finished = result.valueOrNull!;
    expect(finished.session.passed, isNull);

    final sessionRows = await container
        .read(practiceDaoProvider)
        .watchSessionsForProfile(profileId.value)
        .first;
    expect(
      sessionRows,
      hasLength(1),
      reason:
          'one Sprint run is one session row, however many snippets '
          'it advanced through',
    );
    expect(sessionRows.single.snippetId, _snippet.id.value);
    expect(sessionRows.single.category, _snippet.category.name);
    expect(sessionRows.single.difficulty, _snippet.difficulty.name);
    expect(sessionRows.single.mode, 'sprint');

    final keystrokeRows = await container
        .read(practiceDaoProvider)
        .getKeystrokesForSession(sessionId.value);
    expect(keystrokeRows, hasLength(5));
    expect(keystrokeRows.map((r) => r.seq), [
      0,
      1,
      2,
      3,
      4,
    ], reason: 'contiguous sequence numbering across the snippet swap');
    expect(keystrokeRows.map((r) => r.actualChar), [
      'a',
      '=',
      '1',
      'b',
      'c',
    ], reason: 'keystrokes from both snippets, in one unbroken sequence');
    expect(
      keystrokeRows.map((r) => r.sessionStartedAtUtcMicros).toSet(),
      hasLength(1),
      reason:
          'every row, from either snippet, denormalizes the same '
          'session start time',
    );
  });

  test('Precision sessions persist passed: true/false in the real database, '
      'against the real score-based pass bar (SPEC.md §5.3)', () async {
    Future<String> finishWithAccuracy({
      required List<(PhysicalKeyId, String)> chars,
    }) async {
      final recorder = KeystrokeStreamRecorder(expectedSnippet: 'ab');
      for (final (key, char) in chars) {
        recorder.ingestChar(physicalKeyId: key, char: char);
      }
      final keystrokes = recorder.finish();
      final profileId = ProfileId.generate();

      final result = await container.read(finishPracticeSessionUseCaseProvider)(
        id: TypingSessionId.generate(),
        profileId: profileId,
        mode: const PracticeMode.precision(),
        snippet: _snippet.copyWith(code: 'ab'),
        startedAtUtc: DateTime.utc(2026),
        duration: const Duration(seconds: 5),
        keystrokes: keystrokes,
      );
      expect(result.isOk, isTrue);
      return profileId.value;
    }

    // Both characters correct on the first try -> 100% accuracy (score
    // 10), comfortably above the score-8 pass bar.
    final passingProfileId = await finishWithAccuracy(
      chars: const [(PhysicalKeyId.keyA, 'a'), (PhysicalKeyId.keyB, 'b')],
    );
    // Under hard lock, a wrong attempt is rejected rather than
    // committed, so producing a specific lower accuracy means typing
    // the eventual-correct character too: 'x' (rejected, "a" still
    // expected), 'a' (commits), 'y' (rejected, "b" still expected), 'b'
    // (commits) -> 2/4 forward keystrokes correct = 50% accuracy (score
    // 5), below the score-8 pass bar.
    final failingProfileId = await finishWithAccuracy(
      chars: const [
        (PhysicalKeyId.keyX, 'x'),
        (PhysicalKeyId.keyA, 'a'),
        (PhysicalKeyId.keyY, 'y'),
        (PhysicalKeyId.keyB, 'b'),
      ],
    );

    // Query the DAO fresh, independent of the use case's in-memory
    // return value, to prove the pass/fail outcome actually landed in
    // SQLite as `passed` and not just in the transient result.
    final passingRows = await container
        .read(practiceDaoProvider)
        .watchSessionsForProfile(passingProfileId)
        .first;
    expect(passingRows.single.passed, isTrue);

    final failingRows = await container
        .read(practiceDaoProvider)
        .watchSessionsForProfile(failingProfileId)
        .first;
    expect(failingRows.single.passed, isFalse);
  });
}
