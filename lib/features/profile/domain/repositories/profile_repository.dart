import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';

/// Driven port: the application core depends on this abstraction only.
/// Infrastructure provides the adapter (currently a local drift table).
///
/// The whole persistence model assumes exactly one on-device Guest
/// Profile per install (SPEC.md §7.1) — the "active" profile is simply
/// the one row that exists, if any.
abstract interface class ProfileRepository {
  /// Emits the on-device Guest Profile, or `null` if none has been
  /// created yet, and every update after it.
  Stream<GuestProfile?> watchActiveProfile();

  /// Creates the (single) on-device Guest Profile with [username].
  ///
  /// Callers are expected to have already validated [username] (non-empty,
  /// trimmed, within the allowed length) — this port stays dumb on
  /// purpose, validation lives in `application/usecases`.
  Future<Result<GuestProfile, AppFailure>> createGuestProfile(String username);

  /// Renames the existing Guest Profile to [newUsername].
  ///
  /// Same expectation as [createGuestProfile]: [newUsername] is assumed
  /// already validated by the caller.
  Future<Result<void, AppFailure>> renameProfile(String newUsername);

  /// Overwrites the existing Guest Profile's self-expression fields —
  /// always all of them together (a `null`/empty-list explicitly clears
  /// that field).
  ///
  /// Same expectation as [createGuestProfile]: every free-text argument is
  /// assumed already trimmed/validated by the caller.
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  });

  /// Overwrites the existing Guest Profile's auto-detected device info
  /// (platform, OS version, device model) — separate from
  /// [updateCustomization] since these are detected, never user-edited.
  Future<Result<void, AppFailure>> updateDeviceInfo(DetectedDeviceInfo info);
}
