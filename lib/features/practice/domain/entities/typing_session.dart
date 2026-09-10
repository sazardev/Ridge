import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

part 'typing_session.freezed.dart';

/// The persisted, immutable record of one finished practice session —
/// mirrors the `typing_sessions` drift table column-for-column.
///
/// [xpAwarded] and [isFirstCompletion] are the one narrow exception to
/// "sessions are immutable once written": they start at their placeholder
/// defaults (`0`/`false`) here because `practice` must not depend on
/// `progression`; `progression`'s `RecomputeProgressSnapshotUseCase`
/// computes the real values and backfills exactly these two columns,
/// once, immediately after computation. Every other field — every
/// keystroke, every timing, every correctness classification — is
/// written once and never touched again (SPEC.md §8.1).
@freezed
abstract class TypingSession with _$TypingSession {
  /// Creates an immutable finished-session record.
  const factory({
    required TypingSessionId id,
    required ProfileId profileId,
    required PracticeMode mode,
    required SnippetId snippetId,
    required int snippetRevision,
    required ContentCategory category,
    required Difficulty difficulty,
    required DateTime startedAtUtc,
    required Duration duration,
    required double rawSpeedCpm,
    required double netSpeedCpm,
    required double accuracyPct,
    required double consistencyScore,
    required int maxStreak,
    required double fatigueFirstThirdCpm,
    required double fatigueMiddleThirdCpm,
    required double fatigueLastThirdCpm,
    required double handBalanceRatio,
    // Always `null` for Zen sessions — pass/fail is meaningless without a
    // threshold (SPEC.md §5.1).
    bool? passed,
    @Default(0) int xpAwarded,
    @Default(false) bool isFirstCompletion,
  }) = _TypingSession;
}
