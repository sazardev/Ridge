import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_session_dto.freezed.dart';
part 'typing_session_dto.g.dart';

/// Wire/storage shape for a `TypingSession`. Kept separate from the
/// domain entity so a future storage-format change never leaks into
/// business logic — only `PracticeMapper` needs to change.
@freezed
abstract class TypingSessionDto with _$TypingSessionDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String id,
    required String profileId,
    required String mode,
    required String snippetId,
    required int snippetRevision,
    required String category,
    required String difficulty,
    required int startedAtUtcMicros,
    required int durationMicros,
    required double rawSpeedCpm,
    required double netSpeedCpm,
    required double accuracyPct,
    required double consistencyScore,
    required int maxStreak,
    required double fatigueFirstThirdCpm,
    required double fatigueMiddleThirdCpm,
    required double fatigueLastThirdCpm,
    required double handBalanceRatio,
    String? lessonId,
    bool? passed,
    @Default(0) int xpAwarded,
    @Default(false) bool isFirstCompletion,
  }) = _TypingSessionDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) =>
      _$TypingSessionDtoFromJson(json);
}
