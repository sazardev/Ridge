// Exercises the full finish -> evaluate -> achievements_unlocked
// pipeline against a *real* in-memory drift (SQLite) database — proof
// that `EvaluateAchievementsUseCase` really reads persisted
// `typing_sessions`/`keystroke_events` written by the real
// `FinishPracticeSessionUseCase` (never faked), consumes the real
// `ProgressSnapshot` that `progression`'s own
// `RecomputeProgressSnapshotUseCase` computes, and unlocks exactly the
// achievements SPEC.md §12's rules call for — then proves a second
// evaluate never double-processes or duplicates anything. Mirrors
// `progression_drift_integration_test.dart`'s style.
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/domain/entities/maratonista_tier.dart';
import 'package:just_in_time/features/achievements/presentation/providers/achievements_providers.dart';
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
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';

/// Builds a `Snippet` whose `code` is [length] copies of `'a'` — perfect
/// completion is then just "type 'a' [length] times", with no need to
/// reason about a real code sample's exact characters (mirrors
/// `progression`/`learning_paths`' hand-authored test snippets, just
/// longer, since "Maratonista"'s bronze tier genuinely requires 50,000
/// real correct characters).
Snippet _allACodeSnippet({required String id, required int length}) {
  return Snippet(
    id: SnippetId(id),
    revision: 1,
    language: ProgrammingLanguage.go,
    difficulty: Difficulty.beginner,
    category: ContentCategory.errorHandling,
    symbolFocus: const {},
    length: SnippetLength.short,
    titleEn: 'Achievements test snippet ($id)',
    titleEs: 'Snippet de prueba de logros ($id)',
    code: ''.padRight(length, 'a'),
    sourceAttribution: 'hand-authored for test',
    isActive: true,
    tldrEn: 'Test tl;dr.',
    tldrEs: 'Tl;dr de prueba.',
    explanationEn: 'Test explanation.',
    explanationEs: 'Explicación de prueba.',
  );
}

/// Drives the real domain capture engine to type every character of
/// [snippet]'s code perfectly (zero corrections, 100% accuracy), then
/// finishes through the real `FinishPracticeSessionUseCase` (never
/// faked) — mirrors `progression_drift_integration_test.dart`'s style.
/// Every keystroke uses the same [PhysicalKeyId.keyA] — irrelevant to
/// correctness (which only compares characters), and deliberately skews
/// `handBalanceRatio` away from "Ambidiestro"'s 0.95 floor so this
/// helper never accidentally also triggers that achievement.
Future<void> _finishPerfectSession(
  ProviderContainer container, {
  required ProfileId profileId,
  required Snippet snippet,
  required DateTime startedAtUtc,
  required Duration duration,
}) async {
  final recorder = KeystrokeStreamRecorder(expectedSnippet: snippet.code);
  for (var i = 0; i < snippet.code.length; i++) {
    recorder.ingestChar(
      physicalKeyId: PhysicalKeyId.keyA,
      char: snippet.code[i],
    );
  }
  final keystrokes = recorder.finish();

  final result = await container.read(finishPracticeSessionUseCaseProvider)(
    id: TypingSessionId.generate(),
    profileId: profileId,
    mode: const PracticeMode.zen(),
    snippet: snippet,
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

  /// Re-queries `achievements_unlocked` fresh, straight off the drift
  /// table — independent of any use case's in-memory return value.
  Future<Set<String>> unlockedIds(ProfileId profileId) async {
    final rows = await (database.select(
      database.achievementsUnlocked,
    )..where((row) => row.profileId.equals(profileId.value))).get();
    return {for (final row in rows) row.achievementId};
  }

  test('a zero-correction session unlocks Cero Errores, enough lifetime '
      'correct characters unlock the first Maratonista tier, and a second '
      'evaluate never double-processes anything', () async {
    final createResult = await container.read(
      createGuestProfileUseCaseProvider,
    )('tester');
    expect(createResult.isOk, isTrue);
    final profileId = createResult.valueOrNull!.id;

    // A fixed, comfortably-mid-day UTC instant so both sessions land
    // on the same local calendar day regardless of the test machine's
    // timezone (streak stays a deterministic "1", well under every
    // streak tier's floor).
    final day = DateTime.utc(2026, 6, 15, 12);

    // Session 1: short, perfect, zero corrections -> "Cero Errores".
    // Far too few characters (20) to move the needle on any
    // Maratonista tier on its own.
    await _finishPerfectSession(
      container,
      profileId: profileId,
      snippet: _allACodeSnippet(id: 'go-achv-short', length: 20),
      startedAtUtc: day,
      duration: const Duration(seconds: 5),
    );

    // Session 2: long, also perfect -> pushes the lifetime correct-
    // character total past Maratonista bronze's 50,000 threshold
    // (comfortably short of silver's 250,000).
    await _finishPerfectSession(
      container,
      profileId: profileId,
      snippet: _allACodeSnippet(id: 'go-achv-long', length: 50000),
      startedAtUtc: day.add(const Duration(minutes: 1)),
      duration: const Duration(minutes: 5),
    );

    final evaluate = container.read(evaluateAchievementsUseCaseProvider);
    final firstEvaluate = await evaluate(
      profileId,
      now: day.add(const Duration(hours: 1)),
    );
    expect(firstEvaluate.isOk, isTrue);

    final expectedUnlocked = {
      const AchievementId.ceroErrores().storageKey,
      const AchievementId.maratonista(MaratonistaTier.bronze).storageKey,
    };
    final newlyUnlockedFirstKeys = {
      for (final a in firstEvaluate.valueOrNull!) a.id.storageKey,
    };
    expect(
      newlyUnlockedFirstKeys,
      expectedUnlocked,
      reason:
          'exactly these two should newly unlock — no mastery, streak, '
          'ambidiestro, or higher-marathon-tier badge qualifies yet',
    );

    // --- Re-query fresh from the DB, independent of the use case's
    // in-memory return value. ---
    final unlocked = await unlockedIds(profileId);
    expect(unlocked, expectedUnlocked);
    expect(
      unlocked.contains(
        const AchievementId.maratonista(MaratonistaTier.silver).storageKey,
      ),
      isFalse,
      reason: "far short of silver's 250,000-character threshold",
    );
    expect(
      unlocked.contains(
        const AchievementId.maratonista(MaratonistaTier.gold).storageKey,
      ),
      isFalse,
    );

    // Cross-check via the repository port too, independent of the raw
    // table query above.
    final repoUnlocked = await container
        .read(achievementRepositoryProvider)
        .watchUnlocked(profileId)
        .first;
    expect({for (final a in repoUnlocked) a.id.storageKey}, unlocked);

    // --- Idempotency: a second evaluate must not double-process or
    // duplicate anything. ---
    final secondEvaluate = await evaluate(
      profileId,
      now: day.add(const Duration(hours: 2)),
    );
    expect(secondEvaluate.isOk, isTrue);
    expect(
      secondEvaluate.valueOrNull,
      isEmpty,
      reason: 'everything that currently qualifies was already unlocked',
    );

    final unlockedAfterSecond = await unlockedIds(profileId);
    expect(
      unlockedAfterSecond,
      unlocked,
      reason: 'a second evaluate must not add or remove any rows',
    );
  });
}
