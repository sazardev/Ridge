// Unit tests for `RecordDailyChallengeCompletionUseCase` — recording a
// finished session as today's Daily Challenge completion if, and only
// if, its mode actually was `PracticeMode.dailyChallenge` (SPEC.md
// §5.4). Drives the real `FinishPracticeSessionUseCase` (over a fake
// `SessionRepository`, mirroring `finish_practice_session_usecase_test
// .dart`) to produce a genuine `FinishedPracticeSession`, then feeds it
// into the use case under test against a fake
// `DailyChallengeRepository`.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/daily_challenge/application/usecases/record_daily_challenge_completion_usecase.dart';
import 'package:ridge/features/daily_challenge/domain/entities/daily_challenge_completion.dart';
import 'package:ridge/features/daily_challenge/domain/repositories/daily_challenge_repository.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';
import 'package:ridge/features/practice/application/usecases/finish_practice_session_usecase.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/repositories/session_repository.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

const _snippet = Snippet(
  id: SnippetId('go-test-daily'),
  revision: 3,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Test snippet',
  titleEs: 'Snippet de prueba',
  code: 'abcdefghij',
  sourceAttribution: 'hand-authored for test',
  isActive: true,
  tldrEn: 'Test tl;dr.',
  tldrEs: 'Tl;dr de prueba.',
  explanationEn: 'Test explanation.',
  explanationEs: 'Explicación de prueba.',
);

Keystroke _keystroke(int seq, KeystrokeResult result) {
  return Keystroke(
    physicalKeyId: PhysicalKeyId.keyA,
    expectedChar: 'a',
    actualChar: result == KeystrokeResult.correct ? 'a' : 'x',
    result: result,
    isCorrection: false,
    finger: Finger.leftIndex,
    keyboardRow: KeyboardRow.homeRow,
    sequenceIndex: seq,
  );
}

/// 10 forward keystrokes with exactly [correctCount] correct — a plain,
/// predictable accuracyPct of `correctCount * 10`.
List<Keystroke> _keystrokesWithAccuracy(int correctCount) {
  return [
    for (var i = 0; i < 10; i++)
      _keystroke(
        i,
        i < correctCount
            ? KeystrokeResult.correct
            : KeystrokeResult.substitution,
      ),
  ];
}

class _FakeSessionRepository implements SessionRepository {
  @override
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  }) async {
    return const Result.ok(null);
  }

  @override
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId) =>
      const Stream.empty();
}

class _FakeDailyChallengeRepository implements DailyChallengeRepository {
  DailyChallengeCompletion? recorded;

  @override
  Future<Result<void, AppFailure>> recordCompletion(
    DailyChallengeCompletion completion,
  ) async {
    recorded = completion;
    return const Result.ok(null);
  }

  @override
  Future<Result<DailyChallengeCompletion?, AppFailure>> getCompletion({
    required ProfileId profileId,
    required ChallengeDate date,
  }) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<ChallengeDate>> watchCompletedDates(ProfileId profileId) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<DailyChallengeCompletion>, AppFailure>>
  getRecentCompletions({
    required ProfileId profileId,
    required int limit,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late _FakeDailyChallengeRepository dailyChallengeRepository;
  late RecordDailyChallengeCompletionUseCase useCase;
  late FinishPracticeSessionUseCase finishUseCase;

  setUp(() {
    dailyChallengeRepository = _FakeDailyChallengeRepository();
    useCase = RecordDailyChallengeCompletionUseCase(dailyChallengeRepository);
    finishUseCase = FinishPracticeSessionUseCase(_FakeSessionRepository());
  });

  Future<FinishedPracticeSession> finish({
    required PracticeMode mode,
    required int correctCount,
    required ProfileId profileId,
  }) async {
    final result = await finishUseCase(
      id: TypingSessionId.generate(),
      profileId: profileId,
      mode: mode,
      snippet: _snippet,
      startedAtUtc: DateTime.utc(2026, 3, 4, 10),
      duration: const Duration(seconds: 10),
      keystrokes: _keystrokesWithAccuracy(correctCount),
    );
    expect(result.isOk, isTrue);
    return result.valueOrNull!;
  }

  test('a dailyChallenge-mode session is recorded with the matching '
      'profile, date, snippet and score', () async {
    final profileId = ProfileId.generate();
    final challengeDate = DateTime.utc(2026, 3, 4);
    final finished = await finish(
      mode: PracticeMode.dailyChallenge(challengeDate: challengeDate),
      correctCount: 9,
      profileId: profileId,
    );

    final result = await useCase(finished);

    expect(result.isOk, isTrue);
    final recorded = dailyChallengeRepository.recorded;
    expect(recorded, isNotNull);
    expect(recorded!.profileId, profileId);
    expect(recorded.date, ChallengeDate.fromUtc(challengeDate));
    expect(recorded.snippetId, _snippet.id);
    expect(recorded.snippetRevision, _snippet.revision);
    expect(recorded.sessionId, finished.session.id);
    expect(recorded.score, 9);
    expect(recorded.passed, isTrue);
  });

  test('a low-accuracy dailyChallenge session records passed: false', () async {
    final finished = await finish(
      mode: PracticeMode.dailyChallenge(challengeDate: DateTime.utc(2026)),
      correctCount: 5,
      profileId: ProfileId.generate(),
    );

    await useCase(finished);

    final recorded = dailyChallengeRepository.recorded;
    expect(recorded!.score, 5);
    expect(recorded.passed, isFalse);
  });

  test('every other mode is a no-op — nothing is recorded', () async {
    final finished = await finish(
      mode: const PracticeMode.zen(),
      correctCount: 10,
      profileId: ProfileId.generate(),
    );

    final result = await useCase(finished);

    expect(result.isOk, isTrue);
    expect(dailyChallengeRepository.recorded, isNull);
  });
}
