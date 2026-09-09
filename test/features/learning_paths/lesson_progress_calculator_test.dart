// Unit-tests the pure lesson-status derivation logic (SPEC.md §5.7): no
// drift/clock/Flutter dependency, just hand-fabricated `Lesson`/
// `LessonAttempt` values — mirrors `progression`'s calculator tests'
// style (e.g. `mastery_evaluator_test.dart`).
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_attempt.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/services/lesson_progress_calculator.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';

const _calculator = LessonProgressCalculator();

Lesson _lesson(String id, int order) {
  return Lesson(
    id: LessonId(id),
    snippetId: SnippetId('snippet-$id'),
    titleEn: 'Lesson $id',
    titleEs: 'Lección $id',
    order: order,
  );
}

LessonAttempt _attempt(
  String lessonId, {
  required bool passed,
  double accuracyPct = 100,
  DateTime? startedAtUtc,
}) {
  return LessonAttempt(
    lessonId: LessonId(lessonId),
    passed: passed,
    accuracyPct: accuracyPct,
    startedAtUtc: startedAtUtc ?? DateTime.utc(2026),
  );
}

void main() {
  group('LessonProgressCalculator', () {
    test('the first lesson is unlocked by default, every later lesson is '
        'locked, when there are no attempts at all', () {
      final lessons = [_lesson('l1', 1), _lesson('l2', 2), _lesson('l3', 3)];
      final result = _calculator.compute(
        orderedLessons: lessons,
        attempts: const [],
      );
      expect(result[const LessonId('l1')]!.status, LessonStatus.unlocked);
      expect(result[const LessonId('l2')]!.status, LessonStatus.locked);
      expect(result[const LessonId('l3')]!.status, LessonStatus.locked);
    });

    test(
      'a subsequent lesson unlocks only once the previous one is completed',
      () {
        final lessons = [_lesson('l1', 1), _lesson('l2', 2), _lesson('l3', 3)];
        final attempts = [_attempt('l1', passed: true)];
        final result = _calculator.compute(
          orderedLessons: lessons,
          attempts: attempts,
        );
        expect(result[const LessonId('l1')]!.status, LessonStatus.completed);
        expect(result[const LessonId('l2')]!.status, LessonStatus.unlocked);
        expect(result[const LessonId('l3')]!.status, LessonStatus.locked);
      },
    );

    test('failing attempts leave a lesson unlocked (not completed) and keep '
        'the next lesson locked', () {
      final lessons = [_lesson('l1', 1), _lesson('l2', 2)];
      final attempts = [
        _attempt('l1', passed: false, accuracyPct: 80),
        _attempt('l1', passed: false, accuracyPct: 90),
      ];
      final result = _calculator.compute(
        orderedLessons: lessons,
        attempts: attempts,
      );
      expect(result[const LessonId('l1')]!.status, LessonStatus.unlocked);
      expect(result[const LessonId('l1')]!.bestAccuracyPct, 90);
      expect(result[const LessonId('l1')]!.completedAt, isNull);
      expect(result[const LessonId('l2')]!.status, LessonStatus.locked);
    });

    test('bestAccuracyPct is the max across every attempt, passed or not', () {
      final lessons = [_lesson('l1', 1)];
      final attempts = [
        _attempt('l1', passed: false, accuracyPct: 70),
        _attempt('l1', passed: true, accuracyPct: 99),
        _attempt('l1', passed: false, accuracyPct: 85),
      ];
      final result = _calculator.compute(
        orderedLessons: lessons,
        attempts: attempts,
      );
      expect(result[const LessonId('l1')]!.bestAccuracyPct, 99);
    });

    test('completedAt is the earliest passing attempt, even if a later '
        'passing attempt also exists', () {
      final lessons = [_lesson('l1', 1)];
      final earliest = DateTime.utc(2026);
      final later = DateTime.utc(2026, 2);
      final attempts = [
        _attempt('l1', passed: true, startedAtUtc: later),
        _attempt('l1', passed: true, startedAtUtc: earliest),
      ];
      final result = _calculator.compute(
        orderedLessons: lessons,
        attempts: attempts,
      );
      expect(result[const LessonId('l1')]!.completedAt, earliest);
    });

    test('attempts against a different lesson never affect this one', () {
      final lessons = [_lesson('l1', 1), _lesson('l2', 2)];
      final attempts = [_attempt('some-other-lesson', passed: true)];
      final result = _calculator.compute(
        orderedLessons: lessons,
        attempts: attempts,
      );
      expect(result[const LessonId('l1')]!.status, LessonStatus.unlocked);
      expect(result[const LessonId('l2')]!.status, LessonStatus.locked);
    });
  });
}
