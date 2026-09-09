import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/practice/domain/entities/finger.dart';
import 'package:just_in_time/features/progression/domain/entities/trend.dart';

part 'weak_finger.freezed.dart';

/// One entry in the "weakest fingers" ranked list (SPEC.md §4.2/§4.3's
/// "perfil por dedo" turned into a diagnostic top-N).
@freezed
abstract class WeakFinger with _$WeakFinger {
  /// Creates an immutable ranked-entry snapshot.
  const factory({
    required Finger finger,
    required double score,
    required Trend trend,
  }) = _WeakFinger;
}
