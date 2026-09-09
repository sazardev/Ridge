import 'package:freezed_annotation/freezed_annotation.dart';

part 'xp_summary.freezed.dart';

/// XP/level standing for one profile (SPEC.md §6.1-§6.2) — a long-term,
/// uncapped measure of dedication, independent of the competitive skill
/// rating SPEC.md §6.5 describes, which requires online
/// matchmaking/duels and is out of scope for this offline-first pass
/// entirely (see the project plan's "out of scope" list).
@freezed
abstract class XpSummary with _$XpSummary {
  /// Creates an immutable XP/level snapshot.
  const factory({
    required int totalXp,
    required int level,
    // The two ends of the current level's XP bracket — both already
    // resolved by `LevelCalculator` at snapshot-compute time, so this
    // entity never needs to depend on that service to render a progress
    // bar.
    required int xpAtCurrentLevel,
    required int xpForNextLevel,
  }) = _XpSummary;

  // See `Snippet._()`'s comment: a private named non-factory constructor
  // has no elided `new` spelling.
  // ignore: unnecessary_type_name_in_constructor
  const XpSummary._();

  /// How far through the current level's XP bracket [totalXp] is, from
  /// `0.0` (just leveled up) to `1.0` (about to level up again).
  double get progressToNextLevel {
    final bracket = xpForNextLevel - xpAtCurrentLevel;
    if (bracket <= 0) return 1;
    return ((totalXp - xpAtCurrentLevel) / bracket).clamp(0, 1).toDouble();
  }
}
