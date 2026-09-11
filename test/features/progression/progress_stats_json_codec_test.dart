// Unit tests for `progressSnapshotToJson` — the shape `StatsJsonScreen`
// renders/exports (SPEC.md §15). Covers every subsection at least once,
// and that the result actually round-trips through `jsonEncode`/
// `jsonDecode` unchanged, since that (not the map shape itself) is what
// would break silently if a future field held a non-JSON-safe value.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/progression/domain/entities/activity_report.dart';
import 'package:ridge/features/progression/domain/entities/category_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/exercise_activity_stat.dart';
import 'package:ridge/features/progression/domain/entities/mastery_status.dart';
import 'package:ridge/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:ridge/features/progression/domain/entities/progress_snapshot.dart';
import 'package:ridge/features/progression/domain/entities/trend.dart';
import 'package:ridge/features/progression/domain/entities/weak_character.dart';
import 'package:ridge/features/progression/domain/entities/weak_finger.dart';
import 'package:ridge/features/progression/domain/entities/weak_key_transition.dart';
import 'package:ridge/features/progression/domain/entities/weak_ngram.dart';
import 'package:ridge/features/progression/domain/entities/weakness_report.dart';
import 'package:ridge/features/progression/domain/entities/xp_summary.dart';
import 'package:ridge/features/progression/presentation/progress_stats_json_codec.dart';

void main() {
  final snapshot = ProgressSnapshot(
    profileId: const ProfileId('profile-1'),
    xpSummary: const XpSummary(
      totalXp: 7105,
      level: 14,
      xpAtCurrentLevel: 6820,
      xpForNextLevel: 7620,
    ),
    currentStreakDays: 2,
    weaknessReport: const WeaknessReport(
      weakCharacters: [
        WeakCharacter(character: 'S', score: 0.62, trend: Trend.stable),
      ],
      weakFingers: [
        WeakFinger(
          finger: Finger.leftPinky,
          score: 0.5,
          trend: Trend.worsening,
        ),
      ],
      weakNgrams: [WeakNgram(text: 'th', score: 0.4, trend: Trend.improving)],
      weakKeyTransitions: [
        WeakKeyTransition(
          fromKey: PhysicalKeyId.keyA,
          toKey: PhysicalKeyId.keyS,
          score: 0.3,
          trend: Trend.stable,
        ),
      ],
    ),
    activityReport: const ActivityReport(
      mostPracticedCategories: [
        CategoryActivityStat(
          category: ContentCategory.loops,
          sessionCount: 10,
          totalPracticeTime: Duration(minutes: 5),
          avgAccuracyPct: 95,
          avgNetSpeedCpm: 200,
          performanceScore: 80,
          trend: Trend.improving,
        ),
      ],
      lowestScoringCategories: [],
      mostPracticedExercises: [
        ExerciseActivityStat(
          snippetId: SnippetId('go-vars-001'),
          sessionCount: 3,
          totalPracticeTime: Duration(minutes: 1),
          avgAccuracyPct: 90,
          avgNetSpeedCpm: 180,
          performanceScore: 70,
        ),
      ],
      lowestScoringExercises: [],
    ),
    masteryStatuses: [
      MasteryStatus(
        category: ContentCategory.errorHandling,
        difficulty: Difficulty.beginner,
        isMastered: false,
        evaluatedAt: DateTime.utc(2026, 9, 9, 22, 38, 10),
        passCountInLastFive: 3,
      ),
    ],
    computedAt: DateTime.utc(2026, 9, 10, 20, 28, 4),
  );

  test('serializes every subsection with raw, undecorated enum names', () {
    final json = progressSnapshotToJson(snapshot);

    expect(json['profileId'], 'profile-1');
    expect(json['currentStreakDays'], 2);
    expect(json['xpSummary'], {
      'totalXp': 7105,
      'level': 14,
      'xpAtCurrentLevel': 6820,
      'xpForNextLevel': 7620,
      'progressToNextLevel': snapshot.xpSummary.progressToNextLevel,
    });
    expect((json['masteryStatuses']! as List<Object?>).single, {
      'category': 'errorHandling',
      'difficulty': 'beginner',
      'isMastered': false,
      'evaluatedAt': '2026-09-09T22:38:10.000Z',
      'passCountInLastFive': 3,
    });
    final weaknessReport = json['weaknessReport']! as Map<String, Object?>;
    expect((weaknessReport['weakCharacters']! as List<Object?>).single, {
      'character': 'S',
      'score': 0.62,
      'trend': 'stable',
    });
    expect((weaknessReport['weakFingers']! as List<Object?>).single, {
      'finger': 'leftPinky',
      'score': 0.5,
      'trend': 'worsening',
    });
    final activityReport = json['activityReport']! as Map<String, Object?>;
    expect(
      (activityReport['mostPracticedExercises']! as List<Object?>).single,
      {
        'snippetId': 'go-vars-001',
        'sessionCount': 3,
        'totalPracticeTimeSeconds': 60,
        'avgAccuracyPct': 90.0,
        'avgNetSpeedCpm': 180.0,
        'performanceScore': 70.0,
      },
    );
    expect(json.containsKey('topCategoryPersonalHistory'), isFalse);
  });

  test('includes the personal-history section only when it is passed', () {
    const history = PersonalHistoryComparison(
      sampleSize: 5,
      averageNetSpeedCpm: 210,
      averageAccuracyPct: 96,
      recentNetSpeedCpm: [200, 210, 220],
      recentAccuracyPct: [95, 96, 97],
    );

    final json = progressSnapshotToJson(snapshot, topCategoryHistory: history);

    expect(json['topCategoryPersonalHistory'], {
      'sampleSize': 5,
      'averageNetSpeedCpm': 210.0,
      'averageAccuracyPct': 96.0,
      'recentNetSpeedCpm': [200.0, 210.0, 220.0],
      'recentAccuracyPct': [95.0, 96.0, 97.0],
    });
  });

  test('round-trips through jsonEncode/jsonDecode unchanged', () {
    const history = PersonalHistoryComparison.empty;
    final json = progressSnapshotToJson(snapshot, topCategoryHistory: history);

    final decoded = jsonDecode(jsonEncode(json)) as Map<String, Object?>;

    expect(decoded, json);
  });
}
