import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/progression/domain/entities/category_activity_stat.dart';
import 'package:just_in_time/features/progression/domain/entities/exercise_activity_stat.dart';

part 'activity_report.freezed.dart';

/// The "dónde practicas más / dónde tienes el puntaje más bajo"
/// diagnostic — four separately ranked lists, mirroring
/// `WeaknessReport`'s "never flatten dissimilar rankings" rule: a
/// category's sample size isn't comparable to an individual exercise's.
@freezed
abstract class ActivityReport with _$ActivityReport {
  /// Creates an immutable activity-report snapshot.
  const factory({
    required List<CategoryActivityStat> mostPracticedCategories,
    required List<CategoryActivityStat> lowestScoringCategories,
    required List<ExerciseActivityStat> mostPracticedExercises,
    required List<ExerciseActivityStat> lowestScoringExercises,
  }) = _ActivityReport;

  /// An empty report — no session history yet.
  static const empty = ActivityReport(
    mostPracticedCategories: [],
    lowestScoringCategories: [],
    mostPracticedExercises: [],
    lowestScoringExercises: [],
  );
}
