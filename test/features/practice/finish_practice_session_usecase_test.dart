// Unit tests for `FinishPracticeSessionUseCase`'s Precision pass/fail
// evaluation (SPEC.md §5.3, via `PrecisionScoreCalculator`) — a
// hand-written `_FakeSessionRepository` (mirroring `tasks`'s established
// hand-fake-port test pattern) and fabricated keystrokes, no drift/
// widget/clock needed. Covers the exact 80%-accuracy/score-8 pass
// boundary, just above, and just below, plus confirming Zen/Sprint/
// Survival always persist `passed: null`.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';
import 'package:ridge/features/content/domain/entities/snippet_length.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
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
  id: SnippetId('go-test-precision'),
  revision: 1,
  language: ProgrammingLanguage.go,
  difficulty: Difficulty.beginner,
  category: ContentCategory.variablesAndTypes,
  symbolFocus: {},
  length: SnippetLength.short,
  titleEn: 'Test snippet',
  titleEs: 'Snippet de prueba',
  code: 'abcd',
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
  TypingSession? lastPersisted;

  @override
  Future<Result<void, AppFailure>> persistSession({
    required TypingSession session,
    required List<Keystroke> keystrokes,
  }) async {
    lastPersisted = session;
    return const Result.ok(null);
  }

  @override
  Stream<List<TypingSession>> watchSessionsForProfile(ProfileId profileId) =>
      const Stream.empty();
}

void main() {
  late _FakeSessionRepository repository;
  late FinishPracticeSessionUseCase useCase;

  setUp(() {
    repository = _FakeSessionRepository();
    useCase = FinishPracticeSessionUseCase(repository);
  });

  Future<TypingSession> finish({
    required PracticeMode mode,
    required int correctCount,
  }) async {
    final result = await useCase(
      id: TypingSessionId.generate(),
      profileId: ProfileId.generate(),
      mode: mode,
      snippet: _snippet,
      startedAtUtc: DateTime.utc(2026),
      duration: const Duration(seconds: 10),
      keystrokes: _keystrokesWithAccuracy(correctCount),
    );
    expect(result.isOk, isTrue);
    return result.valueOrNull!.session;
  }

  group('Precision pass/fail (SPEC.md §5.3, score-based)', () {
    test('accuracy exactly at 80% (score 8) passes', () async {
      final session = await finish(
        mode: const PracticeMode.precision(),
        correctCount: 8,
      );
      expect(session.accuracyPct, 80);
      expect(session.passed, isTrue);
    });

    test('accuracy just below 80% (score 7) fails', () async {
      final session = await finish(
        mode: const PracticeMode.precision(),
        correctCount: 7,
      );
      expect(session.accuracyPct, 70);
      expect(session.passed, isFalse);
    });

    test('a flawless run scores 10 and passes', () async {
      final session = await finish(
        mode: const PracticeMode.precision(),
        correctCount: 10,
      );
      expect(session.accuracyPct, 100);
      expect(session.passed, isTrue);
    });
  });

  group('learningRouteLesson pass/fail reuses the same evaluation', () {
    test('accuracy at or above the score-8 bar passes', () async {
      final session = await finish(
        mode: const PracticeMode.learningRouteLesson(lessonId: 'lesson-1'),
        correctCount: 9,
      );
      expect(session.passed, isTrue);
    });

    test('accuracy below the score-8 bar fails', () async {
      final session = await finish(
        mode: const PracticeMode.learningRouteLesson(lessonId: 'lesson-1'),
        correctCount: 6,
      );
      expect(session.passed, isFalse);
    });
  });

  group('dailyChallenge pass/fail reuses the same evaluation', () {
    test('accuracy at or above the score-8 bar passes', () async {
      final session = await finish(
        mode: PracticeMode.dailyChallenge(challengeDate: DateTime.utc(2026)),
        correctCount: 9,
      );
      expect(session.passed, isTrue);
    });

    test('accuracy below the score-8 bar fails', () async {
      final session = await finish(
        mode: PracticeMode.dailyChallenge(challengeDate: DateTime.utc(2026)),
        correctCount: 6,
      );
      expect(session.passed, isFalse);
    });
  });

  group('Zen, Sprint and Survival never gate on accuracy', () {
    test('Zen always persists passed: null, regardless of accuracy', () async {
      final session = await finish(
        mode: const PracticeMode.zen(),
        correctCount: 2,
      );
      expect(session.accuracyPct, 20);
      expect(session.passed, isNull);
    });

    test(
      'Sprint always persists passed: null, regardless of accuracy',
      () async {
        final session = await finish(
          mode: const PracticeMode.sprint(window: Duration(seconds: 30)),
          correctCount: 10,
        );
        expect(session.passed, isNull);
      },
    );

    test(
      'Survival always persists passed: null, regardless of accuracy',
      () async {
        final session = await finish(
          mode: const PracticeMode.survival(),
          correctCount: 4,
        );
        expect(session.accuracyPct, 40);
        expect(session.passed, isNull);
      },
    );
  });
}
