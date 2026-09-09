import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement.dart';
import 'package:just_in_time/features/achievements/domain/entities/achievement_id.dart';
import 'package:just_in_time/features/achievements/domain/entities/session_achievement_input.dart';
import 'package:just_in_time/features/achievements/infrastructure/achievement_dao.dart';
import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

/// Converts a raw [AchievementUnlockedRow] into its domain [Achievement].
extension AchievementUnlockedRowMapper on AchievementUnlockedRow {
  /// Maps this row to the domain [Achievement].
  Achievement toDomain() {
    return Achievement(
      id: AchievementId.fromStorageKey(achievementId),
      unlockedAt: DateTime.fromMicrosecondsSinceEpoch(
        unlockedAtUtcMicros,
        isUtc: true,
      ),
      triggerSessionId: triggerSessionId == null
          ? null
          : TypingSessionId(triggerSessionId!),
    );
  }
}

/// Converts an [Achievement] into its row-insert companion.
extension AchievementMapper on Achievement {
  /// Maps this entity to an insert companion for `profileId`.
  AchievementsUnlockedCompanion toCompanion(ProfileId profileId) {
    return AchievementsUnlockedCompanion.insert(
      profileId: profileId.value,
      achievementId: id.storageKey,
      unlockedAtUtcMicros: unlockedAt.toUtc().microsecondsSinceEpoch,
      triggerSessionId: Value(triggerSessionId?.value),
    );
  }
}

/// Converts a raw [SessionAchievementInputRow] into its domain
/// [SessionAchievementInput].
extension SessionAchievementInputRowMapper on SessionAchievementInputRow {
  /// Maps this row to the domain [SessionAchievementInput].
  SessionAchievementInput toDomain() {
    return SessionAchievementInput(
      sessionId: TypingSessionId(sessionId),
      accuracyPct: accuracyPct,
      handBalanceRatio: handBalanceRatio,
      correctionsCount: correctionsCount,
      forwardKeystrokeCount: forwardKeystrokeCount,
    );
  }
}
