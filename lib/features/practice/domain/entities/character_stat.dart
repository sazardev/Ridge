import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_stat.freezed.dart';

/// Per-character derived metrics for one session (SPEC.md §4.2's "perfil
/// por carácter") — keyed by the character in `SessionMetrics.characterStats`.
@freezed
abstract class CharacterStat with _$CharacterStat {
  /// Creates an immutable per-character stat snapshot.
  const factory({
    required String character,
    required int attempts,
    required int errors,
    required double avgFlightMs,
  }) = _CharacterStat;
}
