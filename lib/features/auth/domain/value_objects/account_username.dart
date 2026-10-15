import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';

part 'account_username.freezed.dart';

/// Type-safe Registered Account username (SPEC.md §7.2) — the
/// platform-wide unique handle that doubles as the sign-in identifier.
/// Distinct from the Guest Profile's free-form display name: this one is
/// normalized (lowercase, trimmed), restricted to an email-safe character
/// set and length, and is what both Firebase Auth (via the internal
/// synthetic email derived from it) and the uniqueness index key off.
@freezed
abstract class AccountUsername with _$AccountUsername {
  /// Wraps the already-normalized [value].
  const factory(String value) = _AccountUsername;

  /// The shortest accepted username.
  static const minLength = 3;

  /// The longest accepted username — deliberately the same limit as the
  /// Guest Profile's display name, so converting one into an account
  /// never forces the user to shorten it.
  static const maxLength = 24;

  /// Lowercase, alphanumeric at both ends; dots, dashes and underscores
  /// allowed in between (the exact set an email local part tolerates).
  static final _pattern = RegExp(r'^[a-z0-9](?:[a-z0-9_.-]*[a-z0-9])?$');

  /// Normalizes [raw] (trim + lowercase) and validates it, returning the
  /// typed username or a [ValidationFailure] describing the first rule
  /// it broke.
  static Result<AccountUsername, AppFailure> parse(String raw) {
    final normalized = normalize(raw);
    if (normalized.length < minLength || normalized.length > maxLength) {
      return const Result.err(
        ValidationFailure(
          'Username must be between $minLength and $maxLength characters',
        ),
      );
    }
    if (!_pattern.hasMatch(normalized)) {
      return const Result.err(
        ValidationFailure(
          'Username may only contain letters, digits, dots, dashes and '
          'underscores, and must start and end with a letter or digit',
        ),
      );
    }
    return Result.ok(AccountUsername(normalized));
  }

  /// The canonical form of [raw]: trimmed and lowercased. Also the exact
  /// derivation the internal synthetic email is built from — kept here,
  /// trivially pure, so the client and the server-side functions can
  /// never drift apart on what "the same username" means.
  static String normalize(String raw) => raw.trim().toLowerCase();

  /// Best-effort conversion of a display name into a candidate username,
  /// for prefilling the registration form after a Guest → Registered
  /// conversion (SPEC.md §7.2): spaces and anything outside the allowed
  /// set become dashes, the result is clamped to [maxLength] and never
  /// ends on a separator. Returns `null` when nothing usable is left —
  /// the caller then just leaves the field empty.
  static String? suggestFromDisplayName(String displayName) {
    final dashed = normalize(displayName)
        .replaceAll(RegExp('[^a-z0-9_.-]'), '-');
    final clamped = dashed.length > maxLength
        ? dashed.substring(0, maxLength)
        : dashed;
    final trimmed = clamped.replaceAll(RegExp(r'^[^a-z0-9]+|[^a-z0-9]+$'), '');
    return trimmed.isEmpty ? null : trimmed;
  }
}
