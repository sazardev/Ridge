import 'package:drift/drift.dart';

import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/value_objects/snippet_id.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/keyboard_row.dart';
import 'package:ridge/features/practice/domain/entities/keystroke.dart';
import 'package:ridge/features/practice/domain/entities/keystroke_result.dart';
import 'package:ridge/features/practice/domain/entities/practice_mode.dart';
import 'package:ridge/features/practice/domain/entities/typing_session.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/typing_session_id.dart';
import 'package:ridge/features/practice/infrastructure/keystroke_dto.dart';
import 'package:ridge/features/practice/infrastructure/typing_session_dto.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Reconstructs a [PracticeMode] from its persisted discriminator name.
///
/// The `typing_sessions` schema only persists the mode name and
/// [lessonId] — `sprint`'s window isn't a column, so that case round-trips
/// with a placeholder value even though the mode is genuinely played (see
/// `PracticeSessionController`). `dailyChallenge`'s `challengeDate`
/// round-trips the same way, with the epoch as its placeholder: the
/// authoritative day↔snippet mapping lives in
/// `daily_challenge_completions`, never reconstructed from this row.
/// This is safe because nothing reads a persisted session back into a
/// *live* `PracticeMode` for re-display: the Progress screen's personal-
/// history comparison and mastery queries go through
/// `ProgressionRepository`'s own SQL views instead, never through this
/// mapper. Should a future feature need to re-hydrate a real
/// `PracticeMode` from a row, it should extend the schema rather than
/// rely on these placeholders.
PracticeMode _practiceModeFromName(String mode, String? lessonId) {
  return switch (mode) {
    'zen' => const PracticeMode.zen(),
    'sprint' => const PracticeMode.sprint(window: Duration.zero),
    'precision' => const PracticeMode.precision(),
    'survival' => const PracticeMode.survival(),
    'learningRouteLesson' => PracticeMode.learningRouteLesson(
      lessonId: lessonId ?? '',
    ),
    'dailyChallenge' => PracticeMode.dailyChallenge(
      challengeDate: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
    ),
    _ => throw StateError('Unknown PracticeMode name: $mode'),
  };
}

/// Extracts the persisted discriminator fields from a [PracticeMode].
extension PracticeModeMapper on PracticeMode {
  /// This mode's storage `mode` name and (if applicable) `lessonId`.
  ({String mode, String? lessonId}) toDtoFields() {
    return when(
      zen: () => (mode: 'zen', lessonId: null),
      sprint: (window) => (mode: 'sprint', lessonId: null),
      precision: () => (mode: 'precision', lessonId: null),
      survival: () => (mode: 'survival', lessonId: null),
      learningRouteLesson: (lessonId) =>
          (mode: 'learningRouteLesson', lessonId: lessonId),
      dailyChallenge: (challengeDate) =>
          (mode: 'dailyChallenge', lessonId: null),
    );
  }
}

/// Converts a [TypingSessionDto] into its domain representation and into
/// a drift row-insert companion.
extension TypingSessionDtoMapper on TypingSessionDto {
  /// Maps this DTO to the domain entity.
  TypingSession toDomain() {
    return TypingSession(
      id: TypingSessionId(id),
      profileId: ProfileId(profileId),
      mode: _practiceModeFromName(mode, lessonId),
      snippetId: SnippetId(snippetId),
      snippetRevision: snippetRevision,
      category: ContentCategory.values.byName(category),
      difficulty: Difficulty.values.byName(difficulty),
      startedAtUtc: DateTime.fromMicrosecondsSinceEpoch(
        startedAtUtcMicros,
        isUtc: true,
      ),
      duration: Duration(microseconds: durationMicros),
      rawSpeedCpm: rawSpeedCpm,
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      consistencyScore: consistencyScore,
      maxStreak: maxStreak,
      fatigueFirstThirdCpm: fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: fatigueLastThirdCpm,
      handBalanceRatio: handBalanceRatio,
      passed: passed,
      xpAwarded: xpAwarded,
      isFirstCompletion: isFirstCompletion,
    );
  }

  /// Maps this DTO to a drift row-insert companion.
  TypingSessionsCompanion toCompanion() {
    return TypingSessionsCompanion.insert(
      id: id,
      profileId: profileId,
      mode: mode,
      lessonId: Value(lessonId),
      snippetId: snippetId,
      snippetRevision: snippetRevision,
      category: category,
      difficulty: difficulty,
      startedAtUtcMicros: startedAtUtcMicros,
      durationMicros: durationMicros,
      rawSpeedCpm: rawSpeedCpm,
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      consistencyScore: consistencyScore,
      maxStreak: maxStreak,
      fatigueFirstThirdCpm: fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: fatigueLastThirdCpm,
      handBalanceRatio: handBalanceRatio,
      passed: Value(passed),
      xpAwarded: Value(xpAwarded),
      isFirstCompletion: Value(isFirstCompletion),
    );
  }
}

/// Converts a [TypingSession] domain entity into its storage
/// [TypingSessionDto].
extension TypingSessionMapper on TypingSession {
  /// Maps this entity to its wire/storage shape.
  TypingSessionDto toDto() {
    final modeFields = mode.toDtoFields();
    return TypingSessionDto(
      id: id.value,
      profileId: profileId.value,
      mode: modeFields.mode,
      lessonId: modeFields.lessonId,
      snippetId: snippetId.value,
      snippetRevision: snippetRevision,
      category: category.name,
      difficulty: difficulty.name,
      startedAtUtcMicros: startedAtUtc.toUtc().microsecondsSinceEpoch,
      durationMicros: duration.inMicroseconds,
      rawSpeedCpm: rawSpeedCpm,
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      consistencyScore: consistencyScore,
      maxStreak: maxStreak,
      fatigueFirstThirdCpm: fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: fatigueLastThirdCpm,
      handBalanceRatio: handBalanceRatio,
      passed: passed,
      xpAwarded: xpAwarded,
      isFirstCompletion: isFirstCompletion,
    );
  }
}

/// Converts a drift [TypingSessionRow] into its storage
/// [TypingSessionDto].
extension TypingSessionRowMapper on TypingSessionRow {
  /// Maps this row to the storage DTO.
  TypingSessionDto toDto() {
    return TypingSessionDto(
      id: id,
      profileId: profileId,
      mode: mode,
      lessonId: lessonId,
      snippetId: snippetId,
      snippetRevision: snippetRevision,
      category: category,
      difficulty: difficulty,
      startedAtUtcMicros: startedAtUtcMicros,
      durationMicros: durationMicros,
      rawSpeedCpm: rawSpeedCpm,
      netSpeedCpm: netSpeedCpm,
      accuracyPct: accuracyPct,
      consistencyScore: consistencyScore,
      maxStreak: maxStreak,
      fatigueFirstThirdCpm: fatigueFirstThirdCpm,
      fatigueMiddleThirdCpm: fatigueMiddleThirdCpm,
      fatigueLastThirdCpm: fatigueLastThirdCpm,
      handBalanceRatio: handBalanceRatio,
      passed: passed,
      xpAwarded: xpAwarded,
      isFirstCompletion: isFirstCompletion,
    );
  }
}

/// Converts a [Keystroke] domain entity — plus the session-scoping
/// context it doesn't itself carry — into its storage [KeystrokeDto].
extension KeystrokeMapper on Keystroke {
  /// Maps this entity to its wire/storage shape.
  KeystrokeDto toDto({
    required String sessionId,
    required int sessionStartedAtUtcMicros,
    required int thirdIndex,
  }) {
    return KeystrokeDto(
      sessionId: sessionId,
      seq: sequenceIndex,
      sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
      expectedChar: expectedChar,
      actualChar: actualChar,
      result: result.name,
      isCorrection: isCorrection,
      physicalKeyId: physicalKeyId.name,
      finger: finger.name,
      keyboardRow: keyboardRow.name,
      dwellMicros: dwell?.inMicroseconds,
      flightMicros: flight?.inMicroseconds,
      thirdIndex: thirdIndex,
    );
  }
}

/// Converts a [KeystrokeDto] into its domain representation and into a
/// drift row-insert companion.
extension KeystrokeDtoMapper on KeystrokeDto {
  /// Maps this DTO to the domain entity, dropping the session-scoping
  /// columns [KeystrokeDto] carries but `Keystroke` itself has no field
  /// for.
  Keystroke toDomain() {
    return Keystroke(
      physicalKeyId: PhysicalKeyId.values.byName(physicalKeyId),
      expectedChar: expectedChar,
      actualChar: actualChar,
      result: KeystrokeResult.values.byName(result),
      isCorrection: isCorrection,
      finger: Finger.values.byName(finger),
      keyboardRow: KeyboardRow.values.byName(keyboardRow),
      dwell: dwellMicros == null ? null : Duration(microseconds: dwellMicros!),
      flight: flightMicros == null
          ? null
          : Duration(microseconds: flightMicros!),
      sequenceIndex: seq,
    );
  }

  /// Maps this DTO to a drift row-insert companion.
  KeystrokeEventsCompanion toCompanion() {
    return KeystrokeEventsCompanion.insert(
      sessionId: sessionId,
      seq: seq,
      sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
      expectedChar: Value(expectedChar),
      actualChar: Value(actualChar),
      result: result,
      isCorrection: isCorrection,
      physicalKeyId: physicalKeyId,
      finger: finger,
      keyboardRow: keyboardRow,
      dwellMicros: Value(dwellMicros),
      flightMicros: Value(flightMicros),
      thirdIndex: thirdIndex,
    );
  }
}

/// Converts a drift [KeystrokeEventRow] into its storage [KeystrokeDto].
extension KeystrokeEventRowMapper on KeystrokeEventRow {
  /// Maps this row to the storage DTO.
  KeystrokeDto toDto() {
    return KeystrokeDto(
      sessionId: sessionId,
      seq: seq,
      sessionStartedAtUtcMicros: sessionStartedAtUtcMicros,
      expectedChar: expectedChar,
      actualChar: actualChar,
      result: result,
      isCorrection: isCorrection,
      physicalKeyId: physicalKeyId,
      finger: finger,
      keyboardRow: keyboardRow,
      dwellMicros: dwellMicros,
      flightMicros: flightMicros,
      thirdIndex: thirdIndex,
    );
  }
}
