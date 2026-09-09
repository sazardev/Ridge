// Exercises the full finish -> recompute -> lesson_progress_cache
// pipeline against a *real* in-memory drift (SQLite) database AND the
// *real* bundled curriculum JSON asset (not a hand-fake repository, not
// fabricated curriculum data) — proof that
// `RecomputeLessonProgressUseCase` really reads persisted
// `typing_sessions` rows written by the real `FinishPracticeSessionUseCase`
// (never faked), joins them against the real curriculum's ordered
// lessons, and gates each lesson's unlock exactly per SPEC.md §5.7's
// rule: the first lesson starts unlocked; a passing attempt completes
// its lesson and unlocks the next one; a failing attempt does neither.
// Mirrors `progression_drift_integration_test.dart`'s style.
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
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';

// The real curriculum's first three lessons (see
// `assets/content/learning_paths/go_foundations_v1.json`) — this test
// loads that file for real via `LearningPathRepositoryImpl`, it never
// fabricates its own curriculum.
const _lesson1Id = 'go-foundations-v1-o2-step01';
const _lesson2Id = 'go-foundations-v1-o2-step02';
const _lesson3Id = 'go-foundations-v1-o2-step03';

// The snippets these two lessons reference (`go-vars-001`/`go-vars-002`)
// are fabricated here with simple, short code — `FinishPracticeSessionUseCase`
// only needs a `Snippet` value, not one round-tripped through the real
// content catalog (mirrors `progression_drift_integration_test.dart`'s
// `_snippet` constant).
const _lesson1Snippet = Snippet(
  id: SnippetId('go-vars-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Lesson 1 test snippet',
  titleEs: 'Snippet de prueba de la lección 1',
  code: 'abcdefghij',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

const _lesson2Snippet = Snippet(
  id: SnippetId('go-vars-002'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Lesson 2 test snippet',
  titleEs: 'Snippet de prueba de la lección 2',
  code: 'klmno',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

/// Drives the real domain capture engine to type [correctCharCount]
/// characters from the start of `snippet.code` correctly, then
/// [wrongCharCount] deliberately-wrong characters, then finishes through
/// the real `FinishPracticeSessionUseCase` (never faked) tagged with
/// [lessonId].
Future<void> _finishLessonAttempt(
  ProviderContainer container, {
  required ProfileId profileId,
  required Snippet snippet,
  required String lessonId,
  required int correctCharCount,
  required int wrongCharCount,
}) async {
  final recorder = KeystrokeStreamRecorder(expectedSnippet: snippet.code);
  for (var i = 0; i < correctCharCount; i++) {
    recorder.ingestChar(
      physicalKeyId: PhysicalKeyId.keyA,
      char: snippet.code[i],
    );
  }
  for (var i = 0; i < wrongCharCount; i++) {
    // '#' never appears in either test snippet's code, so every one of
    // these is guaranteed to be classified a plain substitution error.
    recorder.ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: '#');
  }
  final keystrokes = recorder.finish();

  final result = await container.read(finishPracticeSessionUseCaseProvider)(
    id: TypingSessionId.generate(),
    profileId: profileId,
    mode: PracticeMode.learningRouteLesson(lessonId: lessonId),
    snippet: snippet,
    startedAtUtc: DateTime.utc(2026, 6, 15, 12),
    duration: const Duration(seconds: 5),
    keystrokes: keystrokes,
  );
  expect(result.isOk, isTrue);
}

void main() {
  // Loading the real bundled curriculum JSON via `rootBundle` requires a
  // real (test) binding to be initialized — this is what makes this an
  // *integration* test rather than a pure-Dart unit test.
  TestWidgetsFlutterBinding.ensureInitialized();

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

  /// Re-queries `lesson_progress_cache` fresh, straight off the drift
  /// table — independent of any use case's in-memory return value.
  Future<Map<String, String>> statusByLessonId(ProfileId profileId) async {
    final rows = await (database.select(
      database.lessonProgressCache,
    )..where((row) => row.profileId.equals(profileId.value))).get();
    return {for (final row in rows) row.lessonId: row.status};
  }

  test('a passing attempt completes its lesson and unlocks the next one; a '
      'failing attempt does neither', () async {
    final createResult = await container.read(
      createGuestProfileUseCaseProvider,
    )('learner');
    expect(createResult.isOk, isTrue);
    final profileId = createResult.valueOrNull!.id;

    // --- Baseline: before any session is ever played, only the first
    // lesson is unlocked. ---
    final baselineResult = await container.read(
      recomputeLessonProgressUseCaseProvider,
    )(profileId);
    expect(baselineResult.isOk, isTrue);

    final baseline = await statusByLessonId(profileId);
    expect(baseline[_lesson1Id], LessonStatus.unlocked.name);
    expect(baseline[_lesson2Id], LessonStatus.locked.name);
    expect(baseline[_lesson3Id], LessonStatus.locked.name);

    // --- A passing attempt at lesson 1: 10/10 correct = 100% accuracy,
    // comfortably above the score-8/80%-accuracy pass bar. ---
    await _finishLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson1Snippet,
      lessonId: _lesson1Id,
      correctCharCount: _lesson1Snippet.code.length,
      wrongCharCount: 0,
    );
    final afterPassResult = await container.read(
      recomputeLessonProgressUseCaseProvider,
    )(profileId);
    expect(afterPassResult.isOk, isTrue);

    final afterPass = await statusByLessonId(profileId);
    expect(afterPass[_lesson1Id], LessonStatus.completed.name);
    expect(
      afterPass[_lesson2Id],
      LessonStatus.unlocked.name,
      reason:
          'lesson 2 must unlock now that lesson 1 is completed '
          '(it was locked in the baseline)',
    );
    expect(afterPass[_lesson3Id], LessonStatus.locked.name);

    // Cross-check via the repository port too, independent of the raw
    // table query above.
    final progressRecords = await container
        .read(lessonProgressRepositoryProvider)
        .watchProgress(profileId)
        .first;
    final lesson1Record = progressRecords.singleWhere(
      (record) => record.lessonId.value == _lesson1Id,
    );
    expect(lesson1Record.status, LessonStatus.completed);
    expect(lesson1Record.bestAccuracyPct, 100);
    expect(lesson1Record.completedAt, isNotNull);

    // --- A failing attempt at lesson 2: 1/5 correct = 20% accuracy,
    // well below the score-8/80%-accuracy pass bar — must not complete
    // it or unlock lesson 3. ---
    await _finishLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson2Snippet,
      lessonId: _lesson2Id,
      correctCharCount: 1,
      wrongCharCount: 4,
    );
    final afterFailResult = await container.read(
      recomputeLessonProgressUseCaseProvider,
    )(profileId);
    expect(afterFailResult.isOk, isTrue);

    final afterFail = await statusByLessonId(profileId);
    expect(
      afterFail[_lesson2Id],
      LessonStatus.unlocked.name,
      reason: 'a failing attempt must not complete the lesson',
    );
    expect(
      afterFail[_lesson3Id],
      LessonStatus.locked.name,
      reason: 'lesson 3 must stay locked while lesson 2 is not completed',
    );
    expect(
      afterFail[_lesson1Id],
      LessonStatus.completed.name,
      reason: 'lesson 1 must stay completed regardless of later attempts',
    );
  });
}
