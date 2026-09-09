import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'profile_id.freezed.dart';

/// Type-safe identifier for a Guest Profile, never a bare `String`.
@freezed
abstract class ProfileId with _$ProfileId {
  /// Wraps the raw identifier [value].
  const factory(String value) = _ProfileId;

  /// Generates a new random v4 UUID-backed identifier.
  factory generate() => ProfileId(const Uuid().v4());
}
