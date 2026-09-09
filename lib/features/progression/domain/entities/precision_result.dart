import 'package:freezed_annotation/freezed_annotation.dart';

part 'precision_result.freezed.dart';

/// The two metrics `MasteryEvaluator` needs from one past Precision-mode
/// session — never the whole `TypingSession`.
@freezed
abstract class PrecisionResult with _$PrecisionResult {
  /// Creates an immutable precision-result read view.
  const factory({required double accuracyPct, required double netSpeedCpm}) =
      _PrecisionResult;
}
