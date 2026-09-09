// Unit tests for `LessonStatusResolver` — the shared, UI-facing "what's
// this lesson's status, and which one is next to work on" logic used by
// both the Lessons list and the Practice-tab roadmap card. No drift/
// clock/Flutter dependency, mirrors `lesson_progress_calculator_test.dart`'s
// hand-fabricated style.
import 'package:flutter_test/flutter_test.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson.dart';
import 'package:just_in_time/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:just_in_time/features/learning_paths/domain/services/lesson_status_resolver.dart';
import 'package:just_in_time/features/learning_paths/domain/value_objects/lesson_id.dart';

Lesson _lesson(String id, int order) {
  return Lesson(
    id: LessonId(id),
    snippetId: SnippetId('snippet-$id'),
    titleEn: 'Lesson $id',
    titleEs: 'Lección $id',
    order: order,
  );
}

final List<Lesson> _lessons = [
  _lesson('a', 0),
  _lesson('b', 1),
  _lesson('c', 2),
];

void main() {
  group('LessonStatusResolver.resolve', () {
    test('before any recompute has cached anything, only the first lesson '
        'is unlocked and every later one is locked', () {
      expect(
        LessonStatusResolver.resolve(_lessons[0], _lessons, const {}),
        LessonStatus.unlocked,
      );
      expect(
        LessonStatusResolver.resolve(_lessons[1], _lessons, const {}),
        LessonStatus.locked,
      );
      expect(
        LessonStatusResolver.resolve(_lessons[2], _lessons, const {}),
        LessonStatus.locked,
      );
    });

    test('a cached status always wins over the default guess', () {
      final progress = {_lessons[0].id: LessonStatus.completed};
      expect(
        LessonStatusResolver.resolve(_lessons[0], _lessons, progress),
        LessonStatus.completed,
      );
    });
  });

  group('LessonStatusResolver.findNextIndex', () {
    test('a brand-new profile with no cached progress is sent to lesson 0', () {
      expect(LessonStatusResolver.findNextIndex(_lessons, const {}), 0);
    });

    test('with some lessons completed, resolves to the first non-completed '
        'one', () {
      final progress = {
        _lessons[0].id: LessonStatus.completed,
        _lessons[1].id: LessonStatus.unlocked,
        _lessons[2].id: LessonStatus.locked,
      };
      expect(LessonStatusResolver.findNextIndex(_lessons, progress), 1);
    });

    test(
      'once every lesson is completed, there is nothing left to work on',
      () {
        final progress = {
          for (final lesson in _lessons) lesson.id: LessonStatus.completed,
        };
        expect(LessonStatusResolver.findNextIndex(_lessons, progress), isNull);
      },
    );
  });
}
