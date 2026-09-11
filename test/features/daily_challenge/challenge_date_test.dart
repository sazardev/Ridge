// Unit tests for `ChallengeDate` — UTC-only normalization, the
// `yyyy-MM-dd` storage key, and ordering. No clock/drift needed.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/daily_challenge/domain/value_objects/challenge_date.dart';

void main() {
  test('fromUtc strips time-of-day and normalizes non-UTC instants', () {
    final date = ChallengeDate.fromUtc(DateTime.utc(2026, 3, 7, 23, 59, 59));
    expect(date, ChallengeDate(DateTime.utc(2026, 3, 7)));
  });

  test('fromUtc converts a local instant to its UTC calendar day', () {
    // A local instant is first converted to UTC, then stripped down to
    // its date-only form — fromUtc must never treat the wall-clock
    // year/month/day as if it were already UTC.
    final local = DateTime(2026, 3, 8, 10);
    final expectedUtc = local.toUtc();
    final date = ChallengeDate.fromUtc(local);
    expect(
      date,
      ChallengeDate(
        DateTime.utc(expectedUtc.year, expectedUtc.month, expectedUtc.day),
      ),
    );
  });

  test('isoKey is zero-padded yyyy-MM-dd', () {
    final date = ChallengeDate(DateTime.utc(2026, 1, 5));
    expect(date.isoKey, '2026-01-05');
  });

  test('parse reconstructs the exact same date fromUtc would produce', () {
    final date = ChallengeDate.fromUtc(DateTime.utc(2026, 12, 31));
    expect(ChallengeDate.parse(date.isoKey), date);
  });

  test('yesterday steps back exactly one UTC day, crossing month/year '
      'boundaries', () {
    expect(
      ChallengeDate(DateTime.utc(2026, 3)).yesterday,
      ChallengeDate(DateTime.utc(2026, 2, 28)),
    );
    expect(
      ChallengeDate(DateTime.utc(2026)).yesterday,
      ChallengeDate(DateTime.utc(2025, 12, 31)),
    );
  });

  test('compareTo orders chronologically', () {
    final earlier = ChallengeDate(DateTime.utc(2026));
    final later = ChallengeDate(DateTime.utc(2026, 1, 2));
    expect(earlier.compareTo(later), lessThan(0));
    expect(later.compareTo(earlier), greaterThan(0));
    expect(earlier.compareTo(earlier), 0);
  });

  test('equality is value-based (freezed)', () {
    expect(
      ChallengeDate(DateTime.utc(2026, 5, 4)),
      ChallengeDate(DateTime.utc(2026, 5, 4)),
    );
  });
}
