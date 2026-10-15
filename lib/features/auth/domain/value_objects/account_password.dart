import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';

part 'account_password.freezed.dart';

/// Type-safe Registered Account password (SPEC.md §7.2). The app never
/// stores, hashes or transmits it itself — it goes straight to Firebase
/// Auth over TLS — so this value object only enforces the product's
/// length rules before any network call is made.
@freezed
abstract class AccountPassword with _$AccountPassword {
  /// Wraps the raw [value].
  const factory(String value) = _AccountPassword;

  /// The shortest accepted password.
  static const minLength = 8;

  /// The longest accepted password (Firebase itself allows far more;
  /// this is a product cap, not a platform one).
  static const maxLength = 100;

  /// Validates [raw] as a password, returning the typed value or a
  /// [ValidationFailure]. Deliberately no character-class rules: length
  /// is what actually helps, and this is a local-first typing game, not
  /// a bank.
  static Result<AccountPassword, AppFailure> parse(String raw) {
    if (raw.length < minLength || raw.length > maxLength) {
      return const Result.err(
        ValidationFailure(
          'Password must be between $minLength and $maxLength characters',
        ),
      );
    }
    return Result.ok(AccountPassword(raw));
  }
}
