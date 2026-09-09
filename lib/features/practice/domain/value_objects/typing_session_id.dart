import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'typing_session_id.freezed.dart';

/// Type-safe identifier for a persisted `TypingSession`, never a bare
/// `String` (mirrors `ProfileId`).
@freezed
abstract class TypingSessionId with _$TypingSessionId {
  /// Wraps the raw identifier [value].
  const factory(String value) = _TypingSessionId;

  /// Generates a new random v4 UUID-backed identifier.
  factory generate() => TypingSessionId(const Uuid().v4());
}
