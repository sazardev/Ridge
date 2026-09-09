import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/domain/entities/keyboard_layout.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';

part 'guest_profile.freezed.dart';

/// The local, offline-only identity described by SPEC.md §7.1 — a
/// username with no password, living entirely on the device it was
/// created on. Pure domain entity: no JSON, no Flutter, no drift.
///
/// The trailing fields are optional self-expression flair (set via the
/// full-screen profile editor, never required to create a profile) —
/// none of them feed practice/progression logic anywhere.
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
  }) = _GuestProfile;
}
