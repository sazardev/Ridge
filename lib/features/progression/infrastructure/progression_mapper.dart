import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/value_objects/snippet_id.dart';
import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/progression/domain/entities/activity_report.dart';
import 'package:just_in_time/features/progression/domain/entities/category_activity_stat.dart';
import 'package:just_in_time/features/progression/domain/entities/exercise_activity_stat.dart';
import 'package:just_in_time/features/progression/domain/entities/key_transition_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/keystroke_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/mastery_status.dart';
import 'package:just_in_time/features/progression/domain/entities/ngram_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/personal_history_comparison.dart';
import 'package:just_in_time/features/progression/domain/entities/precision_result.dart';
import 'package:just_in_time/features/progression/domain/entities/progress_snapshot.dart';
import 'package:just_in_time/features/progression/domain/entities/session_activity_sample.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';
import 'package:just_in_time/features/progression/domain/entities/unprocessed_session.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_character.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_finger.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_key_transition.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_ngram.dart';
import 'package:just_in_time/features/progression/domain/entities/weakness_report.dart';
import 'package:just_in_time/features/progression/domain/entities/xp_summary.dart';
import 'package:just_in_time/features/progression/infrastructure/progression_dao.dart';

/// Converts a raw [TypingSessionRow] into the read views
/// `RecomputeProgressSnapshotUseCase`/`MasteryEvaluator` need, without
/// pulling in the rest of `TypingSession`.
extension TypingSessionRowProgressionMapper on TypingSessionRow {
  /// Converts this row into an [UnprocessedSession], given its
  /// already-queried `correctFirstTryChars` (a separate DAO call against
  /// `keystroke_events`).
  UnprocessedSession toUnprocessedSession({required int correctFirstTryChars}) {
    return UnprocessedSession(
      id: TypingSessionId(id),
      profileId: ProfileId(profileId),
      snippetId: SnippetId(snippetId),
      category: ContentCategory.values.byName(category),
      difficulty: Difficulty.values.byName(difficulty),
      mode: mode,
      accuracyPct: accuracyPct,
      correctFirstTryChars: correctFirstTryChars,
      startedAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        startedAtUtcMicros,
        isUtc: true,
      ),
    );
  }

  /// Converts this row into the two metrics `MasteryEvaluator` needs.
  PrecisionResult toPrecisionResult() {
    return PrecisionResult(accuracyPct: accuracyPct, netSpeedCpm: netSpeedCpm);
  }
}

/// Converts a raw [KeystrokeEventRow] into a [KeystrokeSample] for
/// weakness ranking.
extension KeystrokeEventRowProgressionMapper on KeystrokeEventRow {
  /// Maps this row to a [KeystrokeSample].
  KeystrokeSample toKeystrokeSample() {
    return KeystrokeSample(
      character: expectedChar ?? actualChar ?? '',
      finger: Finger.values.byName(finger),
      isError: result != 'correct',
      flightMs: (flightMicros ?? 0) / 1000,
      occurredAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        sessionStartedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a raw [NgramSampleRow] into an [NgramSample] for weakness
/// ranking.
extension NgramSampleRowProgressionMapper on NgramSampleRow {
  /// Maps this row to an [NgramSample].
  NgramSample toNgramSample() {
    return NgramSample(
      text: text,
      isError: isError,
      flightMs: flightMicros / 1000,
      occurredAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        sessionStartedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a raw [KeyTransitionSampleRow] into a [KeyTransitionSample]
/// for weakness ranking.
extension KeyTransitionSampleRowProgressionMapper on KeyTransitionSampleRow {
  /// Maps this row to a [KeyTransitionSample].
  KeyTransitionSample toKeyTransitionSample() {
    return KeyTransitionSample(
      fromKey: PhysicalKeyId.values.byName(fromKey),
      toKey: PhysicalKeyId.values.byName(toKey),
      isError: isError,
      flightMs: flightMicros / 1000,
      occurredAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        sessionStartedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a raw [TypingSessionRow] into a [SessionActivitySample] for
/// activity ranking.
extension TypingSessionRowActivityMapper on TypingSessionRow {
  /// Maps this row to a [SessionActivitySample].
  SessionActivitySample toSessionActivitySample() {
    return SessionActivitySample(
      snippetId: SnippetId(snippetId),
      category: ContentCategory.values.byName(category),
      duration: Duration(microseconds: durationMicros),
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      occurredAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        startedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a cached [MasteryStatusCacheRow] into its domain
/// [MasteryStatus].
extension MasteryStatusCacheRowMapper on MasteryStatusCacheRow {
  /// Maps this row to the domain [MasteryStatus].
  MasteryStatus toDomain() {
    return MasteryStatus(
      category: ContentCategory.values.byName(category),
      difficulty: Difficulty.values.byName(difficulty),
      isMastered: isMastered,
      passCountInLastFive: passCountInLastFive,
      evaluatedAt: DateTime.fromMicrosecondsSinceEpoch(
        evaluatedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a [MasteryStatus] into its cache-table companion.
extension MasteryStatusMapper on MasteryStatus {
  /// Maps this entity to a row-upsert companion for `profileId`.
  MasteryStatusCacheCompanion toCompanion(ProfileId profileId) {
    return MasteryStatusCacheCompanion.insert(
      profileId: profileId.value,
      category: category.name,
      difficulty: difficulty.name,
      isMastered: isMastered,
      passCountInLastFive: Value(passCountInLastFive),
      evaluatedAtUtcMicros: evaluatedAt.toUtc().microsecondsSinceEpoch,
    );
  }
}

/// Converts a cached [ProgressSnapshotCacheRow] into its domain
/// [ProgressSnapshot].
extension ProgressSnapshotCacheRowMapper on ProgressSnapshotCacheRow {
  /// Maps this row to the domain [ProgressSnapshot], given its
  /// `masteryStatuses` (queried separately, from a different cache
  /// table).
  ProgressSnapshot toDomain({required List<MasteryStatus> masteryStatuses}) {
    return ProgressSnapshot(
      profileId: ProfileId(profileId),
      xpSummary: XpSummary(
        totalXp: totalXp,
        level: level,
        xpAtCurrentLevel: xpAtCurrentLevel,
        xpForNextLevel: xpForNextLevel,
      ),
      currentStreakDays: currentStreakDays,
      weaknessReport: decodeWeaknessReport(weaknessReportJson),
      activityReport: activityReportJson == null
          ? ActivityReport.empty
          : decodeActivityReport(activityReportJson!),
      masteryStatuses: masteryStatuses,
      computedAt: DateTime.fromMicrosecondsSinceEpoch(
        computedAtUtcMicros,
        isUtc: true,
      ),
    );
  }
}

/// Converts a [ProgressSnapshot] into its cache-table companion.
extension ProgressSnapshotMapper on ProgressSnapshot {
  /// Maps this entity to a row-upsert companion.
  ProgressSnapshotCacheCompanion toCompanion() {
    return ProgressSnapshotCacheCompanion.insert(
      profileId: profileId.value,
      totalXp: xpSummary.totalXp,
      level: xpSummary.level,
      xpAtCurrentLevel: xpSummary.xpAtCurrentLevel,
      xpForNextLevel: xpSummary.xpForNextLevel,
      currentStreakDays: currentStreakDays,
      weaknessReportJson: encodeWeaknessReport(weaknessReport),
      activityReportJson: Value(encodeActivityReport(activityReport)),
      computedAtUtcMicros: computedAt.toUtc().microsecondsSinceEpoch,
    );
  }
}

/// Encodes [report] as JSON text for `progress_snapshot_cache`'s
/// `weaknessReportJson` column — a JSON blob rather than normalized rows
/// since it's never queried at the SQL level, only ever read back
/// wholesale for display (see that table's class doc).
String encodeWeaknessReport(WeaknessReport report) {
  return jsonEncode({
    'weakCharacters': [
      for (final w in report.weakCharacters)
        {'character': w.character, 'score': w.score, 'trend': w.trend.name},
    ],
    'weakFingers': [
      for (final w in report.weakFingers)
        {'finger': w.finger.name, 'score': w.score, 'trend': w.trend.name},
    ],
    'weakNgrams': [
      for (final w in report.weakNgrams)
        {'text': w.text, 'score': w.score, 'trend': w.trend.name},
    ],
    'weakKeyTransitions': [
      for (final w in report.weakKeyTransitions)
        {
          'fromKey': w.fromKey.name,
          'toKey': w.toKey.name,
          'score': w.score,
          'trend': w.trend.name,
        },
    ],
  });
}

/// Decodes a JSON string produced by [encodeWeaknessReport] back into a
/// [WeaknessReport].
WeaknessReport decodeWeaknessReport(String json) {
  final map = jsonDecode(json) as Map<String, dynamic>;
  return WeaknessReport(
    weakCharacters: [
      for (final e
          in (map['weakCharacters']! as List).cast<Map<String, dynamic>>())
        WeakCharacter(
          character: e['character']! as String,
          score: (e['score']! as num).toDouble(),
          trend: Trend.values.byName(e['trend']! as String),
        ),
    ],
    weakFingers: [
      for (final e
          in (map['weakFingers']! as List).cast<Map<String, dynamic>>())
        WeakFinger(
          finger: Finger.values.byName(e['finger']! as String),
          score: (e['score']! as num).toDouble(),
          trend: Trend.values.byName(e['trend']! as String),
        ),
    ],
    weakNgrams: [
      for (final e in (map['weakNgrams']! as List).cast<Map<String, dynamic>>())
        WeakNgram(
          text: e['text']! as String,
          score: (e['score']! as num).toDouble(),
          trend: Trend.values.byName(e['trend']! as String),
        ),
    ],
    // Absent from any blob encoded before this field was added — an old
    // cached snapshot simply has no key-transition ranking until the
    // next recompute backfills one.
    weakKeyTransitions: [
      for (final e
          in (map['weakKeyTransitions'] as List? ?? [])
              .cast<Map<String, dynamic>>())
        WeakKeyTransition(
          fromKey: PhysicalKeyId.values.byName(e['fromKey']! as String),
          toKey: PhysicalKeyId.values.byName(e['toKey']! as String),
          score: (e['score']! as num).toDouble(),
          trend: Trend.values.byName(e['trend']! as String),
        ),
    ],
  );
}

/// Encodes [report] as JSON text for `progress_snapshot_cache`'s
/// `activityReportJson` column — same JSON-blob reasoning as
/// [encodeWeaknessReport].
String encodeActivityReport(ActivityReport report) {
  return jsonEncode({
    'mostPracticedCategories': [
      for (final c in report.mostPracticedCategories) _categoryStatJson(c),
    ],
    'lowestScoringCategories': [
      for (final c in report.lowestScoringCategories) _categoryStatJson(c),
    ],
    'mostPracticedExercises': [
      for (final e in report.mostPracticedExercises) _exerciseStatJson(e),
    ],
    'lowestScoringExercises': [
      for (final e in report.lowestScoringExercises) _exerciseStatJson(e),
    ],
  });
}

Map<String, dynamic> _categoryStatJson(CategoryActivityStat stat) {
  return {
    'category': stat.category.name,
    'sessionCount': stat.sessionCount,
    'totalPracticeTimeMicros': stat.totalPracticeTime.inMicroseconds,
    'avgAccuracyPct': stat.avgAccuracyPct,
    'avgNetSpeedCpm': stat.avgNetSpeedCpm,
    'performanceScore': stat.performanceScore,
    'trend': stat.trend.name,
  };
}

Map<String, dynamic> _exerciseStatJson(ExerciseActivityStat stat) {
  return {
    'snippetId': stat.snippetId.value,
    'sessionCount': stat.sessionCount,
    'totalPracticeTimeMicros': stat.totalPracticeTime.inMicroseconds,
    'avgAccuracyPct': stat.avgAccuracyPct,
    'avgNetSpeedCpm': stat.avgNetSpeedCpm,
    'performanceScore': stat.performanceScore,
  };
}

/// Decodes a JSON string produced by [encodeActivityReport] back into an
/// [ActivityReport].
ActivityReport decodeActivityReport(String json) {
  final map = jsonDecode(json) as Map<String, dynamic>;
  CategoryActivityStat categoryFromJson(Map<String, dynamic> e) {
    return CategoryActivityStat(
      category: ContentCategory.values.byName(e['category']! as String),
      sessionCount: e['sessionCount']! as int,
      totalPracticeTime: Duration(
        microseconds: e['totalPracticeTimeMicros']! as int,
      ),
      avgAccuracyPct: (e['avgAccuracyPct']! as num).toDouble(),
      avgNetSpeedCpm: (e['avgNetSpeedCpm']! as num).toDouble(),
      performanceScore: (e['performanceScore']! as num).toDouble(),
      trend: Trend.values.byName(e['trend']! as String),
    );
  }

  ExerciseActivityStat exerciseFromJson(Map<String, dynamic> e) {
    return ExerciseActivityStat(
      snippetId: SnippetId(e['snippetId']! as String),
      sessionCount: e['sessionCount']! as int,
      totalPracticeTime: Duration(
        microseconds: e['totalPracticeTimeMicros']! as int,
      ),
      avgAccuracyPct: (e['avgAccuracyPct']! as num).toDouble(),
      avgNetSpeedCpm: (e['avgNetSpeedCpm']! as num).toDouble(),
      performanceScore: (e['performanceScore']! as num).toDouble(),
    );
  }

  return ActivityReport(
    mostPracticedCategories: [
      for (final e
          in (map['mostPracticedCategories']! as List)
              .cast<Map<String, dynamic>>())
        categoryFromJson(e),
    ],
    lowestScoringCategories: [
      for (final e
          in (map['lowestScoringCategories']! as List)
              .cast<Map<String, dynamic>>())
        categoryFromJson(e),
    ],
    mostPracticedExercises: [
      for (final e
          in (map['mostPracticedExercises']! as List)
              .cast<Map<String, dynamic>>())
        exerciseFromJson(e),
    ],
    lowestScoringExercises: [
      for (final e
          in (map['lowestScoringExercises']! as List)
              .cast<Map<String, dynamic>>())
        exerciseFromJson(e),
    ],
  );
}

/// Builds a [PersonalHistoryComparison] from [rows] (newest first, as
/// the DAO's `ORDER BY`/`LIMIT` already produced) — computes the
/// aggregate and exposes the chronological (oldest-first) sample lists a
/// sparkline needs.
PersonalHistoryComparison toPersonalHistoryComparison(
  List<TypingSessionRow> rows,
) {
  if (rows.isEmpty) return PersonalHistoryComparison.empty;
  final oldestFirst = rows.reversed.toList();
  final netSpeeds = [for (final r in oldestFirst) r.netSpeedCpm];
  final accuracies = [for (final r in oldestFirst) r.accuracyPct];
  return PersonalHistoryComparison(
    sampleSize: rows.length,
    averageNetSpeedCpm: netSpeeds.reduce((a, b) => a + b) / netSpeeds.length,
    averageAccuracyPct: accuracies.reduce((a, b) => a + b) / accuracies.length,
    recentNetSpeedCpm: netSpeeds,
    recentAccuracyPct: accuracies,
  );
}
