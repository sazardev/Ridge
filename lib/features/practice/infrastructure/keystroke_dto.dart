import 'package:freezed_annotation/freezed_annotation.dart';

part 'keystroke_dto.freezed.dart';
part 'keystroke_dto.g.dart';

/// Wire/storage shape for a `Keystroke`, plus the session-scoping columns
/// (`sessionId`/`sessionStartedAtUtcMicros`/`thirdIndex`) that only exist
/// once a keystroke is attached to a persisted session — the pure domain
/// `Keystroke` entity has no notion of these.
@freezed
abstract class KeystrokeDto with _$KeystrokeDto {
  /// Creates a DTO snapshot ready for JSON serialization.
  const factory({
    required String sessionId,
    required int seq,
    required int sessionStartedAtUtcMicros,
    required String result,
    required bool isCorrection,
    required String physicalKeyId,
    required String finger,
    required String keyboardRow,
    required int thirdIndex,
    String? expectedChar,
    String? actualChar,
    int? dwellMicros,
    int? flightMicros,
  }) = _KeystrokeDto;

  /// Deserializes a DTO from decoded JSON.
  factory fromJson(Map<String, Object?> json) => _$KeystrokeDtoFromJson(json);
}
