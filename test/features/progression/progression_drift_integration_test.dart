// Exercises the full finish -> backfill -> snapshot pipeline against a
// *real* in-memory drift (SQLite) database — the single most important
// validation of this build phase: proof that
// `RecomputeProgressSnapshotUseCase` really reads persisted
// `typing_sessions`/`keystroke_events` written by the real
// `FinishPracticeSessionUseCase` (never faked), backfills
// `xp_awarded`/`is_first_completion` correctly, and produces a snapshot
// (XP/level/streak/mastery) that matches hand-computed expectations —
// then proves a second recompute never double-counts anything.
//
// Scenario, all on the same local calendar day (so streak math stays a
// simple, deterministic "1"):
// - 1 Zen session on a fresh snippet -> its first-ever completion.
// - 5 Precision sessions on the same snippet, each well above the
//   mastery floor for Beginner (accuracy >= 98%, net speed >= 150 cpm)
//   -> a clean 5/5 newly certifies mastery for (errorHandling, beginner).
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/progression/presentation/providers/progression_providers.dart';

const _snippet = Snippet(
  id: SnippetId('go-mastery-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.errorHandling,
  symbolFocus: {},
  length: SnippetLength.short,
  // 5 characters, no corrections -> 100% accuracy every time.
  titleEn: 'Mastery test snippet',
  titleEs: 'Snippet de prueba de maestría',
  code: 'abcde',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

const List<PhysicalKeyId> _keysForSnippet = [
  PhysicalKeyId.keyA,
  PhysicalKeyId.keyB,
  PhysicalKeyId.keyC,
  PhysicalKeyId.keyD,
  PhysicalKeyId.keyE,
];

/// Drives the real domain capture engine to type `_snippet.code`
/// perfectly, then finishes through the real `FinishPracticeSessionUseCase`
/// (never faked) — mirrors `practice_drift_integration_test.dart`'s style.
Future<void> _finishPerfectSession(
  ProviderContainer container, {
  required ProfileId profileId,
  required PracticeMode mode,
  required DateTime startedAtUtc,
  required Duration duration,
}) async {
  final recorder = KeystrokeStreamRecorder(expectedSnippet: _snippet.code);
  for (var i = 0; i < _snippet.code.length; i++) {
    recorder.ingestChar(
      physicalKeyId: _keysForSnippet[i],
      char: _snippet.code[i],
    );
  }
  final keystrokes = recorder.finish();

  final result = await container.read(finishPracticeSessionUseCaseProvider)(
    id: TypingSessionId.generate(),
    profileId: profileId,
    mode: mode,
    snippet: _snippet,
    startedAtUtc: startedAtUtc,
    duration: duration,
    keystrokes: keystrokes,
  );
  expect(result.isOk, isTrue);
}

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

  test('finish -> backfill -> snapshot: real XP/level/streak/mastery are '
      'computed from persisted sessions, and a second recompute never '
      'double-counts anything', () async {
    final createResult = await container.read(
      createGuestProfileUseCaseProvider,
    )('tester');
    expect(createResult.isOk, isTrue);
    final profileId = createResult.valueOrNull!.id;

    // A fixed, comfortably-mid-day UTC instant so every session lands
    // on the same local calendar day regardless of the test machine's
    // timezone.
    final day = DateTime.utc(2026, 6, 15, 12);

    // Session 1: Zen — the snippet's first-ever completion.
    // xp = floor(5 correct * 1.0 difficulty * 1.0 accuracy) = 5
    //    + 50 first-completion bonus
    //    + 5 streak bonus (day 1 of the streak)
    //    = 60.
    await _finishPerfectSession(
      container,
      profileId: profileId,
      mode: const PracticeMode.zen(),
      startedAtUtc: day,
      duration: const Duration(seconds: 10),
    );

    // Sessions 2-6: Precision, 1-second duration -> 5 correct chars in
    // 1/60 minute = 300 cpm, comfortably above Beginner's 150 cpm
    // mastery floor; 100% accuracy clears the 98% mastery floor too.
    // xp = floor(5*1.0*1.0) + 0 (not first) + 5 (streak) = 10 each.
    for (var i = 0; i < 5; i++) {
      await _finishPerfectSession(
        container,
        profileId: profileId,
        mode: const PracticeMode.precision(),
        startedAtUtc: day.add(Duration(minutes: i + 1)),
        duration: const Duration(seconds: 1),
      );
    }

    final recompute = container.read(recomputeProgressSnapshotUseCaseProvider);
    final now = day.add(const Duration(hours: 6));
    final firstRecompute = await recompute(profileId: profileId, now: now);
    expect(firstRecompute.isOk, isTrue);

    // --- Re-query fresh from the DB, independent of the use cases'
    // in-memory return values. ---
    final practiceDao = container.read(practiceDaoProvider);
    final sessionRows = await practiceDao
        .watchSessionsForProfile(profileId.value)
        .first;
    expect(sessionRows, hasLength(6));

    final zenRow = sessionRows.singleWhere((r) => r.mode == 'zen');
    expect(zenRow.isFirstCompletion, isTrue);
    expect(zenRow.xpAwarded, 60);

    final precisionRows = sessionRows.where((r) => r.mode == 'precision');
    expect(precisionRows, hasLength(5));
    expect(precisionRows.every((r) => !r.isFirstCompletion), isTrue);
    expect(precisionRows.every((r) => r.xpAwarded == 10), isTrue);

    final totalXpBackfilled = sessionRows.fold<int>(
      0,
      (sum, r) => sum + r.xpAwarded,
    );
    expect(totalXpBackfilled, 110);

    final processedRows = await database
        .select(database.processedSessions)
        .get();
    expect(
      processedRows,
      hasLength(6),
      reason: 'every finished session should now have a processed_sessions row',
    );
    expect(processedRows.every((r) => r.profileId == profileId.value), isTrue);

    final progressionRepository = container.read(progressionRepositoryProvider);
    final snapshot = await progressionRepository.watchSnapshot(profileId).first;
    expect(snapshot, isNotNull);
    expect(snapshot!.xpSummary.totalXp, 110);
    expect(snapshot.xpSummary.level, 1);
    expect(snapshot.currentStreakDays, 1);

    expect(snapshot.masteryStatuses, hasLength(1));
    final mastery = snapshot.masteryStatuses.single;
    expect(mastery.category, ContentCategory.errorHandling);
    expect(mastery.difficulty, Difficulty.beginner);
    expect(mastery.isMastered, isTrue);
    expect(mastery.passCountInLastFive, 5);

    // Each of the 6 perfect runs types 'abcde' via keys A-B-C-D-E, so
    // every session contributes the same 4 error-free physical key
    // transitions — proof `getKeyTransitionSamplesRaw`'s self-join
    // really reads `physical_key_id`, not `actual_char`.
    final transitionPairs = {
      for (final t in snapshot.weaknessReport.weakKeyTransitions)
        (t.fromKey, t.toKey),
    };
    expect(transitionPairs, {
      (PhysicalKeyId.keyA, PhysicalKeyId.keyB),
      (PhysicalKeyId.keyB, PhysicalKeyId.keyC),
      (PhysicalKeyId.keyC, PhysicalKeyId.keyD),
      (PhysicalKeyId.keyD, PhysicalKeyId.keyE),
    });

    // All 6 sessions land in the one category/snippet practiced.
    final mostPracticedCategory =
        snapshot.activityReport.mostPracticedCategories.single;
    expect(mostPracticedCategory.category, ContentCategory.errorHandling);
    expect(mostPracticedCategory.sessionCount, 6);

    final mostPracticedExercise =
        snapshot.activityReport.mostPracticedExercises.single;
    expect(mostPracticedExercise.snippetId, _snippet.id);
    expect(mostPracticedExercise.sessionCount, 6);

    // --- Idempotency: recomputing again must not double-count. ---
    final secondRecompute = await recompute(
      profileId: profileId,
      now: now.add(const Duration(minutes: 1)),
    );
    expect(secondRecompute.isOk, isTrue);

    final sessionRowsAfter = await practiceDao
        .watchSessionsForProfile(profileId.value)
        .first;
    final totalXpAfter = sessionRowsAfter.fold<int>(
      0,
      (sum, r) => sum + r.xpAwarded,
    );
    expect(
      totalXpAfter,
      110,
      reason: 'a second recompute must not double-award XP',
    );

    final processedRowsAfter = await database
        .select(database.processedSessions)
        .get();
    expect(
      processedRowsAfter,
      hasLength(6),
      reason: 'a second recompute must not duplicate processed_sessions rows',
    );

    final snapshotAfter = await progressionRepository
        .watchSnapshot(profileId)
        .first;
    expect(snapshotAfter!.xpSummary.totalXp, 110);
    expect(snapshotAfter.currentStreakDays, 1);
    expect(snapshotAfter.masteryStatuses.single.isMastered, isTrue);
    expect(snapshotAfter.masteryStatuses.single.passCountInLastFive, 5);
  });
}
