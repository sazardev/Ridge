import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';

part 'key_transition_sample.freezed.dart';

/// One raw physical key-to-key transition observation feeding weakness
/// ranking — two adjacent forward keystrokes within the same session
/// (`k2.seq = k1.seq + 1`), keyed by the *physical* keys involved rather
/// than the characters they produced (SPEC.md §4.1's "transiciones entre
/// teclas ('conexiones')": the cost of moving from one physical key to
/// another regardless of which letter/symbol each one types).
@freezed
abstract class KeyTransitionSample with _$KeyTransitionSample {
  /// Creates an immutable key-transition-sample read view.
  const factory({
    required PhysicalKeyId fromKey,
    required PhysicalKeyId toKey,
    required bool isError,
    required double flightMs,
    required DateTime occurredAtUtc,
  }) = _KeyTransitionSample;
}
