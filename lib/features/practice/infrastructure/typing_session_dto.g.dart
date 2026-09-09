// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TypingSessionDto _$TypingSessionDtoFromJson(Map<String, dynamic> json) =>
    _TypingSessionDto(
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      mode: json['mode'] as String,
      snippetId: json['snippetId'] as String,
      snippetRevision: (json['snippetRevision'] as num).toInt(),
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      startedAtUtcMicros: (json['startedAtUtcMicros'] as num).toInt(),
      durationMicros: (json['durationMicros'] as num).toInt(),
      rawSpeedCpm: (json['rawSpeedCpm'] as num).toDouble(),
      netSpeedCpm: (json['netSpeedCpm'] as num).toDouble(),
      accuracyPct: (json['accuracyPct'] as num).toDouble(),
      consistencyScore: (json['consistencyScore'] as num).toDouble(),
      maxStreak: (json['maxStreak'] as num).toInt(),
      fatigueFirstThirdCpm: (json['fatigueFirstThirdCpm'] as num).toDouble(),
      fatigueMiddleThirdCpm: (json['fatigueMiddleThirdCpm'] as num).toDouble(),
      fatigueLastThirdCpm: (json['fatigueLastThirdCpm'] as num).toDouble(),
      handBalanceRatio: (json['handBalanceRatio'] as num).toDouble(),
      lessonId: json['lessonId'] as String?,
      passed: json['passed'] as bool?,
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      isFirstCompletion: json['isFirstCompletion'] as bool? ?? false,
    );

Map<String, dynamic> _$TypingSessionDtoToJson(_TypingSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'mode': instance.mode,
      'snippetId': instance.snippetId,
      'snippetRevision': instance.snippetRevision,
      'category': instance.category,
      'difficulty': instance.difficulty,
      'startedAtUtcMicros': instance.startedAtUtcMicros,
      'durationMicros': instance.durationMicros,
      'rawSpeedCpm': instance.rawSpeedCpm,
      'netSpeedCpm': instance.netSpeedCpm,
      'accuracyPct': instance.accuracyPct,
      'consistencyScore': instance.consistencyScore,
      'maxStreak': instance.maxStreak,
      'fatigueFirstThirdCpm': instance.fatigueFirstThirdCpm,
      'fatigueMiddleThirdCpm': instance.fatigueMiddleThirdCpm,
      'fatigueLastThirdCpm': instance.fatigueLastThirdCpm,
      'handBalanceRatio': instance.handBalanceRatio,
      'lessonId': instance.lessonId,
      'passed': instance.passed,
      'xpAwarded': instance.xpAwarded,
      'isFirstCompletion': instance.isFirstCompletion,
    };
