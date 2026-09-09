import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/progression/domain/entities/weak_character.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_finger.dart';
import 'package:just_in_time/features/progression/domain/entities/weak_ngram.dart';

part 'weakness_report.freezed.dart';

/// The "tus puntos débiles" diagnostic (SPEC.md §4.3) — three separately
/// ranked lists, never flattened into one, since a character's error-rate
/// denominator isn't comparable to a finger's or an n-gram's. Each list
/// is already sorted worst-first and capped to a small top-N by
/// `WeaknessRankingCalculator`.
@freezed
abstract class WeaknessReport with _$WeaknessReport {
  /// Creates an immutable weakness-report snapshot.
  const factory({
    required List<WeakCharacter> weakCharacters,
    required List<WeakFinger> weakFingers,
    required List<WeakNgram> weakNgrams,
  }) = _WeaknessReport;

  /// An empty report — no keystroke history in the window yet.
  static const empty = WeaknessReport(
    weakCharacters: [],
    weakFingers: [],
    weakNgrams: [],
  );
}
