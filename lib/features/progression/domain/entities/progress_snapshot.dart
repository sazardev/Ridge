import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/progression/domain/entities/activity_report.dart';
import 'package:just_in_time/features/progression/domain/entities/mastery_status.dart';
import 'package:just_in_time/features/progression/domain/entities/weakness_report.dart';
import 'package:just_in_time/features/progression/domain/entities/xp_summary.dart';

part 'progress_snapshot.freezed.dart';

/// The full, rebuildable progression picture for one profile (SPEC.md
/// §4.3/§6) — XP/level, streak, weakness diagnostic, activity report,
/// and per-category mastery, all recomputed together by
/// `RecomputeProgressSnapshotUseCase` from the raw `typing_sessions`/
/// `keystroke_events` history and cached for fast reads (never itself
/// the source of truth).
@freezed
abstract class ProgressSnapshot with _$ProgressSnapshot {
  /// Creates an immutable progress-snapshot.
  const factory({
    required ProfileId profileId,
    required XpSummary xpSummary,
    required int currentStreakDays,
    required WeaknessReport weaknessReport,
    required ActivityReport activityReport,
    required List<MasteryStatus> masteryStatuses,
    required DateTime computedAt,
  }) = _ProgressSnapshot;
}
