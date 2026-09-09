import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/progression/domain/entities/trend.dart';

part 'weak_character.freezed.dart';

/// One entry in the "weakest characters" ranked list (SPEC.md §4.2/§4.3's
/// "perfil por carácter" turned into a diagnostic top-N).
@freezed
abstract class WeakCharacter with _$WeakCharacter {
  /// Creates an immutable ranked-entry snapshot.
  const factory({
    required String character,
    required double score,
    required Trend trend,
  }) = _WeakCharacter;
}
