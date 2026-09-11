// Exercises `PracticeSessionController.retryPersist` end-to-end against a
// *real* in-memory drift (SQLite) database: a hand-fake `SessionRepository`
// wrapper fails the very first `persistSession` call (simulating a
// transient local-write failure, e.g. a full disk) then delegates to the
// real `SessionRepositoryImpl` — proof that a failed write surfaces as
// `state.error` without losing the already-typed session, and that
// `retryPersist` resubmits the exact same session (same id/start time)
// rather than re-running any typing, landing exactly one row once it
// succeeds.
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/practice_session_status.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/infrastructure/session_repository_impl.dart';
import 'package:ridge/features/practice/presentation/providers/practice_providers.dart';
import 'package:ridge/features/practice/presentation/providers/practice_session_controller.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';

const _snippet = Snippet(
  id: SnippetId('go-persist-retry-test-001'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Persist-retry test snippet',
  titleEs: 'Snippet de prueba de reintento',
  code: 'ab',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

// A successful `retryPersist` fires `_notifyDownstreamFeatures`, which
// includes `RecomputeLessonProgressUseCase` — it reads the bundled +
// external learning-path catalog, and the latter scans a content-packs
// directory via `path_provider`, a plugin `flutter_test`'s binding
// doesn't implement (see `learning_paths_drift_integration_test.dart`'s
// header for the same substitution).
class _FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  new(this._path);

  final String _path;

  @override
  Future<String?> getApplicationSupportPath() async => _path;
}

/// Wraps a real [SessionRepository], failing the very first call to
/// [persistSession] with [failure] before delegating every call after
/// that to [_delegate] — simulates a transient local-write failure
/// (full disk, momentarily locked database) that a retry can outlive.
class _FlakySessionRepository implements SessionRepository {
  new(this._delegate);

  final SessionRepository _delegate;
  int callCount = 0;
  final List<TypingSession> attemptedSessions = [];
  static const failure = StorageFailure('Simulated disk full');

  @override
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  }) async {
    callCount++;
    attemptedSessions.add(session);
    if (callCount == 1) return const Result.err(failure);
    return await _delegate.persistSession(
      session: session,
      keystrokes: keystrokes,
    );
  }

  @override
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId) =>
      _delegate.watchSessionsForProfile(profileId);
}

/// Polls [condition] until it holds, failing the test on timeout — the
/// controller's finish/persist path is genuinely async (drift writes),
/// mirroring `survival_controller_drift_integration_test.dart`.
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

  late Directory supportDir;
  late AppDatabase database;
  late ProviderContainer container;
  late _FlakySessionRepository flakyRepository;

  const mode = PracticeMode.zen();
  final provider = practiceSessionControllerProvider(_snippet, mode);

  setUp(() async {
    supportDir = await Directory.systemTemp.createTemp(
      'persist_retry_test_support_',
    );
    PathProviderPlatform.instance = _FakePathProviderPlatform(supportDir.path);

    database = AppDatabase(NativeDatabase.memory());
    flakyRepository = _FlakySessionRepository(
      SessionRepositoryImpl(database.practiceDao),
    );
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        sessionRepositoryProvider.overrideWithValue(flakyRepository),
      ],
    );
    addTearDown(() {
      if (supportDir.existsSync()) supportDir.deleteSync(recursive: true);
    });
    addTearDown(() => database.close());
    addTearDown(container.dispose);

    container.listen(activeProfileControllerProvider, (_, _) {});
  });

  Future<String> createProfile() async {
    final result = await container
        .read(activeProfileControllerProvider.notifier)
        .create('nova');
    expect(result.isOk, isTrue);
    await _waitUntil(
      () => container.read(activeProfileControllerProvider).value != null,
    );
    return container.read(activeProfileControllerProvider).value!.id.value;
  }

  test('a failed persist surfaces as state.error without losing the session, '
      'and retryPersist resubmits it unchanged until it lands', () async {
    final profileId = await createProfile();
    container.listen(provider, (_, _) {});
    final controller = container.read(provider.notifier)
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyA, char: 'a')
      ..ingestChar(physicalKeyId: PhysicalKeyId.keyB, char: 'b');

    await _waitUntil(() => container.read(provider).error != null);
    final failedState = container.read(provider);
    expect(failedState.status, PracticeSessionStatus.result);
    expect(failedState.error, 'Simulated disk full');
    expect(failedState.finishedSession, isNull);
    expect(controller.canRetryPersist, isTrue);
    expect(
      await container
          .read(practiceDaoProvider)
          .watchSessionsForProfile(profileId)
          .first,
      isEmpty,
      reason: 'the failed attempt must leave nothing behind',
    );

    await controller.retryPersist();
    // A successful persist fires `_notifyDownstreamFeatures` fire-and-
    // forget (progression/lesson-progress/achievements/daily-challenge
    // recomputes) — let those in-flight background calls actually
    // finish before this test's `tearDown` closes the database out
    // from under them.
    await pumpEventQueue();

    final resolvedState = container.read(provider);
    expect(resolvedState.error, isNull);
    expect(resolvedState.finishedSession, isNotNull);
    expect(controller.canRetryPersist, isFalse);

    expect(flakyRepository.callCount, 2);
    expect(
      flakyRepository.attemptedSessions[0].id,
      flakyRepository.attemptedSessions[1].id,
      reason: 'retryPersist resubmits the exact same session, not a new one',
    );
    expect(
      flakyRepository.attemptedSessions[0].startedAtUtc,
      flakyRepository.attemptedSessions[1].startedAtUtc,
    );

    final rows = await container
        .read(practiceDaoProvider)
        .watchSessionsForProfile(profileId)
        .first;
    expect(
      rows,
      hasLength(1),
      reason: 'exactly one row: the failed first attempt wrote nothing',
    );
  });

  test('retryPersist is a no-op when nothing has failed', () async {
    await createProfile();
    final controller = container.read(provider.notifier);
    expect(controller.canRetryPersist, isFalse);
    await controller.retryPersist();
    expect(container.read(provider).status, PracticeSessionStatus.idle);
    expect(flakyRepository.callCount, 0);
  });
}
