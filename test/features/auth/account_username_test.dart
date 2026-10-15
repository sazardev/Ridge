// Unit tests for `AccountUsername` — the normalization/validation rules
// every Registered Account username passes through, plus the display-name
// suggestion used to prefill the registration form after a guest
// conversion. Pure value-object logic, no fakes needed.
import 'package:flutter_test/flutter_test.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';

void main() {
  group('AccountUsername.parse', () {
    test('normalizes case and surrounding whitespace', () {
      final result = AccountUsername.parse('  Omar.Ridge  ');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.value, 'omar.ridge');
    });

    test('accepts the minimum and maximum lengths', () {
      expect(AccountUsername.parse('abc').isOk, isTrue);
      expect(AccountUsername.parse('a' * 24).isOk, isTrue);
    });

    test('rejects too-short and too-long usernames', () {
      expect(AccountUsername.parse('ab').isErr, isTrue);
      expect(AccountUsername.parse('a' * 25).isErr, isTrue);
    });

    test('rejects characters outside the email-safe set', () {
      for (final invalid in ['has space', 'emoji🙂', 'slash/', 'plus+', 'ñ']) {
        expect(AccountUsername.parse(invalid).isErr, isTrue, reason: invalid);
      }
    });

    test('rejects separators at either end', () {
      for (final invalid in ['.omar', '-omar', '_omar', 'omar.', 'omar-']) {
        expect(AccountUsername.parse(invalid).isErr, isTrue, reason: invalid);
      }
    });

    test('accepts separators in the middle', () {
      expect(AccountUsername.parse('omar_ridge-dev.01').isOk, isTrue);
    });
  });

  group('AccountUsername.suggestFromDisplayName', () {
    test('dashes anything outside the allowed set', () {
      expect(
        AccountUsername.suggestFromDisplayName('Omar Flores'),
        'omar-flores',
      );
    });

    test('trims leading and trailing separators', () {
      expect(AccountUsername.suggestFromDisplayName('  OMAR!  '), 'omar');
      expect(AccountUsername.suggestFromDisplayName('.omar.'), 'omar');
    });

    test('clamps to the maximum length without ending on a separator', () {
      final suggestion = AccountUsername.suggestFromDisplayName(
        'aaaaaaaaaaaaaaaaaaaaaaa bbbbb',
      );

      expect(suggestion!.length, lessThanOrEqualTo(AccountUsername.maxLength));
      expect(AccountUsername.parse(suggestion).isOk, isTrue);
    });

    test('returns null when nothing usable is left', () {
      expect(AccountUsername.suggestFromDisplayName('¡¡¡'), isNull);
      expect(AccountUsername.suggestFromDisplayName(''), isNull);
    });
  });
}
