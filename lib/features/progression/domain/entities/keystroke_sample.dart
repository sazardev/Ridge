import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/entities/finger.dart';

part 'keystroke_sample.freezed.dart';

/// One raw forward keystroke observation feeding weakness ranking —
/// exactly the fields `WeaknessRankingCalculator` needs (a character key,
/// a finger key, whether it was an error, how long it took, and how long
/// ago it happened), pulled from `keystroke_events` across many sessions
/// within the recency window.
@freezed
abstract class KeystrokeSample with _$KeystrokeSample {
  /// Creates an immutable keystroke-sample read view.
  const factory({
    required String character,
    required Finger finger,
    required bool isError,
    required double flightMs,
    required DateTime occurredAtUtc,
  }) = _KeystrokeSample;
}
