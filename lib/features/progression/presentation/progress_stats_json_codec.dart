import 'package:ridge/features/progression/domain/entities/activity_report.dart';
import 'package:ridge/features/progression/domain/entities/category_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/exercise_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/domain/entities/weakness_report.dart';
import 'package:ridge/features/progression/domain/entities/xp_summary.dart';

/// Builds the raw `Map` shape `StatsJsonScreen` renders/exports for
/// [snapshot] — every field the Progress screen's four tabs read from,
/// plus [topCategoryHistory] (the History tab's own per-category
/// comparison) when it's already been resolved. SPEC.md §15: the user
/// owns their metadata and can consult/export it at any time; this
/// exists so that "export" has a concrete, inspectable shape.
///
/// Enums and id value-objects serialize to their raw `.name`/`.value`
/// rather than a localized label — this is for debugging the underlying
/// data, not for display.
Map<String, Object?> progressSnapshotToJson(
  ProgressSnapshot snapshot, {
  PersonalHistoryComparison? topCategoryHistory,
}) {
  return {
    'profileId': snapshot.profileId.value,
    'computedAt': snapshot.computedAt.toIso8601String(),
    'currentStreakDays': snapshot.currentStreakDays,
    'xpSummary': _xpSummaryToJson(snapshot.xpSummary),
    'masteryStatuses': [
      for (final status in snapshot.masteryStatuses)
        _masteryStatusToJson(status),
    ],
    'weaknessReport': _weaknessReportToJson(snapshot.weaknessReport),
    'activityReport': _activityReportToJson(snapshot.activityReport),
    if (topCategoryHistory != null)
      'topCategoryPersonalHistory': _personalHistoryToJson(topCategoryHistory),
  };
}

Map<String, Object?> _xpSummaryToJson(XpSummary xp) => {
  'totalXp': xp.totalXp,
  'level': xp.level,
  'xpAtCurrentLevel': xp.xpAtCurrentLevel,
  'xpForNextLevel': xp.xpForNextLevel,
  'progressToNextLevel': xp.progressToNextLevel,
};

Map<String, Object?> _masteryStatusToJson(MasteryStatus status) => {
  'category': status.category.name,
  'difficulty': status.difficulty.name,
  'isMastered': status.isMastered,
  'evaluatedAt': status.evaluatedAt.toIso8601String(),
  'passCountInLastFive': status.passCountInLastFive,
};

Map<String, Object?> _weaknessReportToJson(WeaknessReport report) => {
  'weakCharacters': [
    for (final c in report.weakCharacters)
      {'character': c.character, 'score': c.score, 'trend': c.trend.name},
  ],
  'weakFingers': [
    for (final f in report.weakFingers)
      {'finger': f.finger.name, 'score': f.score, 'trend': f.trend.name},
  ],
  'weakNgrams': [
    for (final n in report.weakNgrams)
      {'text': n.text, 'score': n.score, 'trend': n.trend.name},
  ],
  'weakKeyTransitions': [
    for (final t in report.weakKeyTransitions)
      {
        'fromKey': t.fromKey.name,
        'toKey': t.toKey.name,
        'score': t.score,
        'trend': t.trend.name,
      },
  ],
};

Map<String, Object?> _activityReportToJson(ActivityReport report) => {
  'mostPracticedCategories': [
    for (final c in report.mostPracticedCategories) _categoryStatToJson(c),
  ],
  'lowestScoringCategories': [
    for (final c in report.lowestScoringCategories) _categoryStatToJson(c),
  ],
  'mostPracticedExercises': [
    for (final e in report.mostPracticedExercises) _exerciseStatToJson(e),
  ],
  'lowestScoringExercises': [
    for (final e in report.lowestScoringExercises) _exerciseStatToJson(e),
  ],
};

Map<String, Object?> _categoryStatToJson(CategoryActivityStat stat) => {
  'category': stat.category.name,
  'sessionCount': stat.sessionCount,
  'totalPracticeTimeSeconds': stat.totalPracticeTime.inSeconds,
  'avgAccuracyPct': stat.avgAccuracyPct,
  'avgNetSpeedCpm': stat.avgNetSpeedCpm,
  'performanceScore': stat.performanceScore,
  'trend': stat.trend.name,
};

Map<String, Object?> _exerciseStatToJson(ExerciseActivityStat stat) => {
  'snippetId': stat.snippetId.value,
  'sessionCount': stat.sessionCount,
  'totalPracticeTimeSeconds': stat.totalPracticeTime.inSeconds,
  'avgAccuracyPct': stat.avgAccuracyPct,
  'avgNetSpeedCpm': stat.avgNetSpeedCpm,
  'performanceScore': stat.performanceScore,
};

Map<String, Object?> _personalHistoryToJson(PersonalHistoryComparison h) => {
  'sampleSize': h.sampleSize,
  'averageNetSpeedCpm': h.averageNetSpeedCpm,
  'averageAccuracyPct': h.averageAccuracyPct,
  'recentNetSpeedCpm': h.recentNetSpeedCpm,
  'recentAccuracyPct': h.recentAccuracyPct,
};
