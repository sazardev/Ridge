import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';

part 'achievement.freezed.dart';

/// One unlocked SPEC.md §12 achievement — a permanent, monotonic record.
/// Once unlocked, never revoked, even if the underlying condition that
/// triggered it later stops holding (e.g. a category-mastery badge
/// stays earned even if `progression`'s mastery later decays per SPEC.md
/// §6.4) — SPEC.md §12 frames every achievement as a permanent
/// "insignia de hito", and all of them are cosmetic/prestige-only, never
/// a gameplay advantage.
@freezed
abstract class Achievement with _$Achievement {
  /// Creates an immutable unlock record.
  const factory({
    required AchievementId id,
    required DateTime unlockedAt,
    // `null` for badges not tied to one specific session (streak,
    // mastery, marathon tiers) — only "Cero Errores"/"Ambidiestro" ever
    // set this, since those are inherently single-session milestones.
    TypingSessionId? triggerSessionId,
  }) = _Achievement;
}
