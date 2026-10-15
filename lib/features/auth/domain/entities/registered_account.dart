import 'package:freezed_annotation/freezed_annotation.dart';

part 'registered_account.freezed.dart';

/// A Registered Account (SPEC.md §7.2): the cloud-backed identity a Guest
/// Profile can be converted into. `uid` is the Firebase Auth user id the
/// local profile links to; `username` is the platform-wide handle it
/// registered under. No email, no personal data — by design.
///
/// `createdAt` is `null` when it couldn't be read back (e.g. an offline
/// session restore fell back to the synthetic email for the username) —
/// the local profile's own `createdAt` is the one shown in the UI.
@freezed
abstract class RegisteredAccount with _$RegisteredAccount {
  /// Creates an immutable Registered Account snapshot.
  const factory({
    required String uid,
    required String username,
    DateTime? createdAt,
  }) = _RegisteredAccount;
}
