import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

part 'guest_profile.freezed.dart';

/// The local, offline-only identity described by SPEC.md §7.1 — a
/// username with no password, living entirely on the device it was
/// created on. Pure domain entity: no JSON, no Flutter, no drift.
///
/// The trailing self-expression fields (`favoriteLanguages` through
/// `favoriteProgrammer`) are optional flair set via the full-screen
/// profile editor, never required to create a profile — none of them
/// feed practice/progression logic anywhere.
///
/// `platform`/`operatingSystemVersion`/`deviceModel` are a different
/// kind of optional field: auto-detected once (never user-editable, see
/// `EnsureDeviceInfoUseCase`), `null` until detection has run or when the
/// current platform doesn't expose that attribute.
@freezed
abstract class GuestProfile with _$GuestProfile {
  /// Creates an immutable Guest Profile snapshot.
  const factory({
    required ProfileId id,
    required String username,
    required DateTime createdAt,
    @Default(<FavoriteLanguage>[]) List<FavoriteLanguage> favoriteLanguages,
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? platform,
    String? operatingSystemVersion,
    String? deviceModel,
  }) = _GuestProfile;
}
