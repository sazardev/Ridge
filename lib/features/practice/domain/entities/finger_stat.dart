import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/entities/finger.dart';

part 'finger_stat.freezed.dart';

/// Per-finger derived metrics for one session (SPEC.md §4.2's "perfil por
/// dedo") — keyed by [Finger] in `SessionMetrics.fingerStats`. `Hand`
/// rollups are read off `finger.hand`, never stored redundantly here.
@freezed
abstract class FingerStat with _$FingerStat {
  /// Creates an immutable per-finger stat snapshot.
  const factory({
    required Finger finger,
    required int attempts,
    required int errors,
    required double avgFlightMs,
  }) = _FingerStat;
}
