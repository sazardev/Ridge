// Exercises the Settings screen's "danger zone" against a *real*
// in-memory drift (SQLite) database AND the real bundled curriculum
// JSON asset — proof that resetting a lesson/all lessons/everything
// really deletes the rows it claims to, leaves untouched data alone,
// and correctly recomputes the caches it just invalidated (mirrors
// `learning_paths_drift_integration_test.dart`'s style). `PinRepository`
// is the one hand-faked port here: `flutter_secure_storage` has no
// platform channel under plain `flutter test`.
import 'dart:async';

import 'package:drift/drift.dart';
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
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/data_management/presentation/providers/data_management_providers.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:just_in_time/features/learning_paths/presentation/providers/learning_paths_providers.dart';
import 'package:just_in_time/features/lock/domain/repositories/pin_repository.dart';
import 'package:just_in_time/features/lock/presentation/providers/lock_providers.dart';
import 'package:just_in_time/features/practice/domain/entities/practice_mode.dart';
import 'package:just_in_time/features/practice/domain/services/keystroke_stream_recorder.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/practice/presentation/providers/practice_providers.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/profile/presentation/providers/profile_providers.dart';
import 'package:just_in_time/features/progression/presentation/providers/progression_providers.dart';
import 'package:just_in_time/features/settings/domain/entities/app_settings.dart';
import 'package:just_in_time/features/settings/presentation/providers/settings_providers.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

// The real curriculum's first two lessons (see
// `assets/content/learning_paths/go_foundations_v1.json`).
const _lesson1Id = 'go-foundations-v1-o2-step01';
const _lesson2Id = 'go-foundations-v1-o2-step02';

const _lesson1Snippet = Snippet(
  id: SnippetId('go-vars-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Lesson 1 test snippet',
  titleEs: 'Snippet de prueba 1',
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
  titleEs: 'Snippet de prueba 2',
  code: 'klmno',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

/// Hand-fake for [PinRepository] — `flutter_secure_storage` has no
/// platform channel under plain `flutter test`, and `wipeAllData`'s
/// orchestration (see `DataManagementController`) always clears the PIN
/// alongside the database.
class _FakePinRepository implements PinRepository {
  bool stored = true;

  @override
  Future<bool> hasPin() async => stored;

  @override
  Future<Result<void, AppFailure>> setPin(String pin) async {
    stored = true;
    return const Result.ok(null);
  }

  @override
  Future<Result<bool, AppFailure>> verifyPin(String pin) async =>
      const Result.ok(true);

  @override
  Future<Result<void, AppFailure>> clearPin() async {
    stored = false;
    return const Result.ok(null);
  }
}

/// Creates the Guest Profile and waits for `activeProfileControllerProvider`
/// to actually deliver it — in the real app, that stream is already warm
/// by the time any Settings action can run (the router's own redirect
/// gate watches it from app start), but a bare `ProviderContainer` in a
/// test never warms it unless asked to, so `DataManagementController`'s
/// `ref.read(...).value` would otherwise still see `null` here. Uses
/// `container.listen` rather than the generated `.future` — the latter
/// never resolves against a `StreamNotifier` under a bare
/// `ProviderContainer` with no widget tree pumping it, even though a
/// plain `listen` callback fires correctly.
Future<ProfileId> _createWarmProfile(ProviderContainer container) async {
  final profileId = (await container.read(createGuestProfileUseCaseProvider)(
    'learner',
  )).valueOrNull!.id;

  final completer = Completer<void>();
  final subscription = container.listen(activeProfileControllerProvider, (
    _,
    next,
  ) {
    if (next.value != null && !completer.isCompleted) completer.complete();
  });
  if (subscription.read().value == null) {
    await completer.future.timeout(const Duration(seconds: 5));
  }
  subscription.close();
  return profileId;
}

/// Waits for `settingsControllerProvider`'s stream to settle on its
/// latest write — same `container.listen`-over-`.future` rationale as
/// [_createWarmProfile].
Future<AppSettings> _settledSettings(ProviderContainer container) async {
  final completer = Completer<AppSettings>();
  final subscription = container.listen(settingsControllerProvider, (_, next) {
    final value = next.value;
    if (value != null && !completer.isCompleted) completer.complete(value);
  });
  final current = subscription.read().value;
  if (current != null) {
    subscription.close();
    return current;
  }
  final result = await completer.future.timeout(const Duration(seconds: 5));
  subscription.close();
  return result;
}

/// Drives the real domain capture engine to type every character of
/// [snippet]'s code correctly, then finishes through the real
/// `FinishPracticeSessionUseCase` (never faked) tagged with [lessonId].
Future<void> _passLessonAttempt(
  ProviderContainer container, {
  required ProfileId profileId,
  required Snippet snippet,
  required String lessonId,
}) async {
  final recorder = KeystrokeStreamRecorder(expectedSnippet: snippet.code);
  for (var i = 0; i < snippet.code.length; i++) {
    recorder.ingestChar(
      physicalKeyId: PhysicalKeyId.keyA,
      char: snippet.code[i],
    );
  }
  final result = await container.read(finishPracticeSessionUseCaseProvider)(
    id: TypingSessionId.generate(),
    profileId: profileId,
    mode: PracticeMode.learningRouteLesson(lessonId: lessonId),
    snippet: snippet,
    startedAtUtc: DateTime.utc(2026, 6, 15, 12),
    duration: const Duration(seconds: 5),
    keystrokes: recorder.finish(),
  );
  expect(result.isOk, isTrue);
}

void main() {
  // Loading the real bundled curriculum JSON via `rootBundle` requires a
  // real (test) binding to be initialized.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ProviderContainer container;
  late _FakePinRepository fakePinRepository;

  setUp(() {
    // `SettingsController`/`wipeAllData` touch `shared_preferences`, which
    // has no platform channel under plain `flutter test` either — an
    // in-memory fake, same rationale as `_FakePinRepository` above.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    database = AppDatabase(NativeDatabase.memory());
    fakePinRepository = _FakePinRepository();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        pinRepositoryProvider.overrideWithValue(fakePinRepository),
      ],
    );
    addTearDown(() => database.close());
    addTearDown(container.dispose);
  });

  Future<Map<String, String>> statusByLessonId(ProfileId profileId) async {
    final rows = await (database.select(
      database.lessonProgressCache,
    )..where((row) => row.profileId.equals(profileId.value))).get();
    return {for (final row in rows) row.lessonId: row.status};
  }

  Future<int> lessonSessionCount({
    required ProfileId profileId,
    String? lessonId,
  }) async {
    final query = database.select(database.typingSessions)
      ..where((row) {
        final lessonCondition = lessonId == null
            ? row.lessonId.isNotNull()
            : row.lessonId.equals(lessonId);
        return row.profileId.equals(profileId.value) & lessonCondition;
      });
    return (await query.get()).length;
  }

  test("resetLesson deletes only that lesson's sessions/keystrokes and "
      're-derives lesson progress + XP', () async {
    final profileId = await _createWarmProfile(container);

    await _passLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson1Snippet,
      lessonId: _lesson1Id,
    );
    await container.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await _passLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson2Snippet,
      lessonId: _lesson2Id,
    );
    await container.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await container.read(recomputeProgressSnapshotUseCaseProvider)(
      profileId: profileId,
      now: DateTime.utc(2026, 6, 15, 12),
    );

    final before = await statusByLessonId(profileId);
    expect(before[_lesson1Id], LessonStatus.completed.name);
    expect(before[_lesson2Id], LessonStatus.completed.name);
    final xpBefore =
        (await container
                .read(progressionRepositoryProvider)
                .watchSnapshot(profileId)
                .first)!
            .xpSummary
            .totalXp;
    expect(xpBefore, greaterThan(0));

    final resetResult = await container
        .read(dataManagementControllerProvider.notifier)
        .resetLesson(const LessonId(_lesson2Id));
    expect(resetResult.isOk, isTrue);

    expect(
      await lessonSessionCount(profileId: profileId, lessonId: _lesson2Id),
      0,
    );
    expect(
      await lessonSessionCount(profileId: profileId, lessonId: _lesson1Id),
      1,
      reason: "lesson 1's own session must be untouched",
    );

    final after = await statusByLessonId(profileId);
    expect(
      after[_lesson1Id],
      LessonStatus.completed.name,
      reason: 'unaffected lesson stays completed',
    );
    expect(
      after[_lesson2Id],
      LessonStatus.unlocked.name,
      reason: 'reset lesson goes back to unlocked/not-started',
    );

    final xpAfter =
        (await container
                .read(progressionRepositoryProvider)
                .watchSnapshot(profileId)
                .first)!
            .xpSummary
            .totalXp;
    expect(
      xpAfter,
      lessThan(xpBefore),
      reason: 'XP from the deleted lesson 2 session must no longer count',
    );
  });

  test('resetAllLessons clears every lesson-tagged session for the '
      'profile', () async {
    final profileId = await _createWarmProfile(container);

    await _passLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson1Snippet,
      lessonId: _lesson1Id,
    );
    await container.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await _passLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson2Snippet,
      lessonId: _lesson2Id,
    );
    await container.read(recomputeLessonProgressUseCaseProvider)(profileId);

    final resetResult = await container
        .read(dataManagementControllerProvider.notifier)
        .resetAllLessons();
    expect(resetResult.isOk, isTrue);

    expect(await lessonSessionCount(profileId: profileId), 0);

    final after = await statusByLessonId(profileId);
    expect(after[_lesson1Id], LessonStatus.unlocked.name);
    expect(after[_lesson2Id], LessonStatus.locked.name);
  });

  test("wipeAllData deletes every table's rows, including the guest "
      'profile, and disarms the app lock', () async {
    final profileId = await _createWarmProfile(container);
    await _passLessonAttempt(
      container,
      profileId: profileId,
      snippet: _lesson1Snippet,
      lessonId: _lesson1Id,
    );
    await container.read(recomputeLessonProgressUseCaseProvider)(profileId);
    await container.read(recomputeProgressSnapshotUseCaseProvider)(
      profileId: profileId,
      now: DateTime.utc(2026, 6, 15, 12),
    );
    await container
        .read(settingsControllerProvider.notifier)
        .setAppLockEnabled(value: true);
    fakePinRepository.stored = true;

    final wipeResult = await container
        .read(dataManagementControllerProvider.notifier)
        .wipeAllData();
    expect(wipeResult.isOk, isTrue);

    expect(await database.select(database.guestProfiles).get(), isEmpty);
    expect(await database.select(database.typingSessions).get(), isEmpty);
    expect(await database.select(database.keystrokeEvents).get(), isEmpty);
    expect(
      await database.select(database.progressSnapshotCache).get(),
      isEmpty,
    );
    expect(await database.select(database.lessonProgressCache).get(), isEmpty);
    expect(await database.select(database.processedSessions).get(), isEmpty);

    expect(fakePinRepository.stored, isFalse);
    final settings = await _settledSettings(container);
    expect(settings.appLockEnabled, isFalse);
  });
}
