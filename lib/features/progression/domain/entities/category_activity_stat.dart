import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/progression/domain/entities/trend.dart';

part 'category_activity_stat.freezed.dart';

/// One entry in a "most practiced"/"lowest scoring" category ranking —
/// unlike a weakness score (higher = worse), [performanceScore] reads
/// literally as a score: higher = better, 0-100. [trend] is therefore
/// the *inverse* of `Trend`'s usual weakness-score direction:
/// [Trend.improving] here means [performanceScore] went **up**.
@freezed
abstract class CategoryActivityStat with _$CategoryActivityStat {
  /// Creates an immutable category-activity snapshot.
  const factory({
    required ContentCategory category,
    required int sessionCount,
    required Duration totalPracticeTime,
    required double avgAccuracyPct,
    required double avgNetSpeedCpm,
    required double performanceScore,
    required Trend trend,
  }) = _CategoryActivityStat;
}
