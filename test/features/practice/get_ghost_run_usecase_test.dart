// Unit tests for `GetGhostRunUseCase` — a fake repository controls which
// sessions and keystrokes exist, so the "no prior attempt", "fastest
// wins" and "empty fold" branches are asserted exactly.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/application/usecases/get_ghost_run_usecase.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/ghost_run.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

final _profileId = ProfileId.generate();
const _snippetId = SnippetId('go-test-001');

TypingSession _session({required double netSpeedCpm, required String id}) {
  return TypingSession(
    id: TypingSessionId(id),
    profileId: _profileId,
    mode: const PracticeMode.zen(),
    snippetId: _snippetId,
    snippetRevision: 1,
    category: ContentCategory.variablesAndTypes,
    difficulty: Difficulty.beginner,
    startedAtUtc: DateTime.utc(2026, 1, 10),
    duration: const Duration(seconds: 30),
    rawSpeedCpm: netSpeedCpm + 5,
    netSpeedCpm: netSpeedCpm,
    accuracyPct: 98,
    consistencyScore: 80,
    maxStreak: 10,
    fatigueFirstThirdCpm: netSpeedCpm,
    fatigueMiddleThirdCpm: netSpeedCpm,
    fatigueLastThirdCpm: netSpeedCpm,
    handBalanceRatio: 1,
  );
}

Keystroke _correctKeystroke(int seq) {
  return Keystroke(
    physicalKeyId: PhysicalKeyId.keyA,
    expectedChar: 'a',
    actualChar: 'a',
    result: KeystrokeResult.correct,
    isCorrection: false,
    finger: Finger.leftPinky,
    keyboardRow: KeyboardRow.homeRow,
    sequenceIndex: seq,
  );
}

class _FakeSessionRepository implements SessionRepository {
  List<TypingSession> sessions = [];
  Map<String, List<Keystroke>> keystrokesBySession = {};
  AppFailure? failure;

  @override
  Future<Result<List<TypingSession>, AppFailure>> getSessionsForSnippet({
    required ProfileId profileId,
    required SnippetId snippetId,
  }) async {
    final failure = this.failure;
    if (failure != null) return Result.err(failure);
    return Result.ok(sessions);
  }

  @override
  Future<Result<List<Keystroke>, AppFailure>> getKeystrokesForSession(
    TypingSessionId sessionId,
  ) async => Result.ok(keystrokesBySession[sessionId.value] ?? const []);

  @override
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  }) async => const Result.ok(null);

  @override
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId) =>
      const Stream.empty();
}

void main() {
  late _FakeSessionRepository repository;
  late GetGhostRunUseCase useCase;

  setUp(() {
    repository = _FakeSessionRepository();
    useCase = GetGhostRunUseCase(repository);
  });

  Future<Result<GhostRun?, AppFailure>> run() =>
      useCase(profileId: _profileId, snippetId: _snippetId);

  test('no prior attempt resolves to null', () async {
    final result = await run();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, isNull);
  });

  test('the fastest prior attempt becomes the ghost', () async {
    repository
      ..sessions = [
        _session(netSpeedCpm: 40, id: 'slow'),
        _session(netSpeedCpm: 90, id: 'fast'),
        _session(netSpeedCpm: 70, id: 'mid'),
      ]
      ..keystrokesBySession = {
        'fast': [_correctKeystroke(0), _correctKeystroke(1)],
      };

    final result = await run();

    expect(result.isOk, isTrue);
    final ghost = result.valueOrNull;
    expect(ghost, isNotNull);
    expect(ghost!.sessionId.value, 'fast');
    expect(ghost.steps.length, 2);
    expect(ghost.netSpeedCpm, 90);
  });

  test(
    'a fastest attempt with no committed characters resolves to null',
    () async {
      repository
        ..sessions = [_session(netSpeedCpm: 90, id: 'empty')]
        ..keystrokesBySession = {'empty': const []};

      final result = await run();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isNull);
    },
  );

  test('a read failure propagates', () async {
    repository.failure = const StorageFailure('boom');

    final result = await run();

    expect(result.isErr, isTrue);
  });
}
