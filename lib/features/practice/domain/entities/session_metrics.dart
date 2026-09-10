import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/entities/character_stat.dart';
import 'package:ridge/features/practice/domain/entities/finger.dart';
import 'package:ridge/features/practice/domain/entities/finger_stat.dart';
import 'package:ridge/features/practice/domain/entities/ngram_stat.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

part 'session_metrics.freezed.dart';

/// Usage/error tally for one physical key, aggregated within a session —
/// the raw material for the cross-session keyboard heatmap (SPEC.md
/// §4.2's "mapa de calor del teclado"); aggregation across sessions is a
/// `progression`-phase concern.
typedef KeyHeatmapEntry = ({int usageCount, int errorCount});

/// The full set of derived metrics for one finished practice session
/// (SPEC.md §4.2), computed once by `MetricsCalculator` from that
/// session's raw `Keystroke` log.
@freezed
abstract class SessionMetrics with _$SessionMetrics {
  /// Creates an immutable metrics snapshot.
  const factory({
    required double rawSpeedCpm,
    required double netSpeedCpm,
    required double accuracyPct,
    required double consistencyScore,
    required int maxStreak,
    required double fatigueFirstThirdCpm,
    required double fatigueMiddleThirdCpm,
    required double fatigueLastThirdCpm,
    required double handBalanceRatio,
    required Map<String, CharacterStat> characterStats,
    required Map<Finger, FingerStat> fingerStats,
    required List<NgramStat> ngramStats,
    required Map<PhysicalKeyId, KeyHeatmapEntry> keyHeatmap,
  }) = _SessionMetrics;
}
