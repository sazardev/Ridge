import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_date.freezed.dart';

/// The UTC calendar day a shared Daily Challenge snippet belongs to
/// (SPEC.md §5.4) — normalized to date-only, UTC, so "today" means the
/// same instant worldwide rather than depending on each device's local
/// timezone. This is what makes "everyone gets the same snippet" hold
/// without a server: every device that normalizes the same wall-clock
/// moment through [ChallengeDate.fromUtc] arrives at the same
/// [ChallengeDate].
@freezed
abstract class ChallengeDate
    with _$ChallengeDate
    implements Comparable<ChallengeDate> {
  /// Wraps an already UTC, time-of-day-stripped [value]. Prefer
  /// [ChallengeDate.fromUtc] when normalizing an arbitrary instant, or
  /// [ChallengeDate.parse] when reconstructing from a stored [isoKey].
  const factory(DateTime value) = _ChallengeDate;

  // See `Snippet`'s class doc for why this project's "elide the type name
  // in a constructor" convention has no valid spelling for a private
  // named non-factory constructor.
  // ignore: unnecessary_type_name_in_constructor
  const ChallengeDate._();

  /// Normalizes [instant] (interpreted in UTC) to its date-only
  /// [ChallengeDate], stripping time-of-day.
  factory fromUtc(DateTime instant) {
    final utc = instant.toUtc();
    return ChallengeDate(DateTime.utc(utc.year, utc.month, utc.day));
  }

  /// Reconstructs a [ChallengeDate] from its [isoKey] storage form.
  factory parse(String isoKey) {
    final parts = isoKey.split('-');
    return ChallengeDate(
      DateTime.utc(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
    );
  }

  /// Zero-padded `yyyy-MM-dd` form — this feature's stable storage key
  /// and the input to the daily-snippet selector's hash, independent of
  /// `DateTime.toString()`'s formatting (not part of Dart's API
  /// contract).
  String get isoKey =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';

  /// This date, one UTC day earlier.
  ChallengeDate get yesterday =>
      ChallengeDate(value.subtract(const Duration(days: 1)));

  @override
  int compareTo(ChallengeDate other) => value.compareTo(other.value);
}
