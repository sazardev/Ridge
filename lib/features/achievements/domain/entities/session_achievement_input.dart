import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/practice/domain/value_objects/typing_session_id.dart';

part 'session_achievement_input.freezed.dart';

/// The per-session inputs "Cero Errores"/"Ambidiestro" need from one past
/// finished session — never the whole `TypingSession` (mirrors
/// `progression`'s `PrecisionResult`).
@freezed
abstract class SessionAchievementInput with _$SessionAchievementInput {
  /// Creates an immutable per-session achievement-rule read view.
  const factory({
    required TypingSessionId sessionId,
    required double accuracyPct,
    required double handBalanceRatio,
    required int correctionsCount,
    required int forwardKeystrokeCount,
  }) = _SessionAchievementInput;
}
