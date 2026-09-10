import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/progression/domain/entities/trend.dart';

part 'weak_key_transition.freezed.dart';

/// One entry in the "weakest key transitions" ranked list (SPEC.md
/// §4.1's physical "conexiones" turned into a diagnostic top-N) —
/// cross-session, and distinct from `WeakNgram`: this ranks the physical
/// key pair itself, independent of which character each key produced.
@freezed
abstract class WeakKeyTransition with _$WeakKeyTransition {
  /// Creates an immutable ranked-entry snapshot.
  const factory({
    required PhysicalKeyId fromKey,
    required PhysicalKeyId toKey,
    required double score,
    required Trend trend,
  }) = _WeakKeyTransition;
}
