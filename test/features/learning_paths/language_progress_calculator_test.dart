import 'package:flutter_test/flutter_test.dart';

import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/learning_paths/domain/entities/learning_path.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson.dart';
import 'package:ridge/features/learning_paths/domain/entities/lesson_status.dart';
import 'package:ridge/features/learning_paths/domain/services/language_progress_calculator.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/learning_path_id.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';

LearningPath _path(
  String id,
  ProgrammingLanguage language,
  List<String> lessonIds,
) {
  return LearningPath(
    id: LearningPathId(id),
    language: language,
    titleEn: 'Path',
    titleEs: 'Ruta',
    descriptionEn: 'Description.',
    descriptionEs: 'Descripción.',
    tagEn: 'Tag',
    tagEs: 'Etiqueta',
    lessons: [
      for (var index = 0; index < lessonIds.length; index++)
        Lesson(
          id: LessonId(lessonIds[index]),
          snippetId: SnippetId('snippet-${lessonIds[index]}'),
          titleEn: 'Lesson',
          titleEs: 'Lección',
          order: index,
        ),
    ],
  );
}

void main() {
  const calculator = LanguageProgressCalculator();

  test('aggregates only the requested language across its paths', () {
    final paths = [
      _path('go-foundations-v1', ProgrammingLanguage.go, ['a', 'b']),
      _path('go-algorithms-v1', ProgrammingLanguage.go, ['c']),
      _path('rust-foundations-v1', ProgrammingLanguage.rust, ['d']),
    ];
    final progress = {
      const LessonId('a'): LessonStatus.completed,
      const LessonId('b'): LessonStatus.unlocked,
      const LessonId('c'): LessonStatus.completed,
      const LessonId('d'): LessonStatus.completed,
    };

    final result = calculator.compute(
      language: ProgrammingLanguage.go,
      paths: paths,
      progress: progress,
    );

    expect(result.totalLessons, 3);
    expect(result.completedLessons, 2);
    expect(result.fraction, closeTo(2 / 3, 0.0001));
    expect(result.hasStarted, isTrue);
    expect(result.isComplete, isFalse);
  });

  test('a language with no paths is empty, zero, and not complete', () {
    final result = calculator.compute(
      language: ProgrammingLanguage.python,
      paths: const [],
      progress: const {},
    );

    expect(result.totalLessons, 0);
    expect(result.completedLessons, 0);
    expect(result.fraction, 0);
    expect(result.hasStarted, isFalse);
    expect(result.isComplete, isFalse);
  });

  test('isComplete only when every lesson is completed', () {
    final paths = [
      _path('bash-foundations-v1', ProgrammingLanguage.bash, ['a']),
    ];
    final result = calculator.compute(
      language: ProgrammingLanguage.bash,
      paths: paths,
      progress: {const LessonId('a'): LessonStatus.completed},
    );

    expect(result.fraction, 1);
    expect(result.hasStarted, isTrue);
    expect(result.isComplete, isTrue);
  });
}
