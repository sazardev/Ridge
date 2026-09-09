import 'package:drift/drift.dart' show Value;
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/domain/entities/keyboard_layout.dart';
import 'package:just_in_time/features/profile/domain/value_objects/profile_id.dart';
import 'package:just_in_time/features/profile/infrastructure/profile_dto.dart';

/// Converts a [ProfileDto] into its domain [GuestProfile] representation.
extension ProfileDtoMapper on ProfileDto {
  /// Maps this DTO to the domain entity, dropping an unrecognized
  /// favorite-language/keyboard-layout name back to `null` rather than
  /// guessing.
  GuestProfile toDomain() {
    return GuestProfile(
      id: ProfileId(id),
      username: username,
      createdAt: DateTime.parse(createdAt),
      favoriteLanguages: [
        for (final name in favoriteLanguages ?? const <String>[])
          ...FavoriteLanguage.values.where((l) => l.name == name),
      ],
      keyboardLayout: keyboardLayout == null
          ? null
          : KeyboardLayout.values.firstWhereOrNull(
              (k) => k.name == keyboardLayout,
            ),
      keyboardBrand: keyboardBrand,
      keyboardModel: keyboardModel,
      favoriteQuote: favoriteQuote,
      favoriteProgrammer: favoriteProgrammer,
    );
  }

  /// Maps this DTO to a drift row-insert companion.
  GuestProfilesCompanion toCompanion() {
    return GuestProfilesCompanion.insert(
      id: id,
      username: username,
      createdAt: DateTime.parse(createdAt),
      favoriteLanguages: Value(_joinCsv(favoriteLanguages)),
      keyboardLayout: Value(keyboardLayout),
      keyboardBrand: Value(keyboardBrand),
      keyboardModel: Value(keyboardModel),
      favoriteQuote: Value(favoriteQuote),
      favoriteProgrammer: Value(favoriteProgrammer),
    );
  }
}

/// Converts a [GuestProfile] domain entity into its storage [ProfileDto].
extension GuestProfileMapper on GuestProfile {
  /// Maps this entity to its wire/storage shape.
  ProfileDto toDto() {
    return ProfileDto(
      id: id.value,
      username: username,
      createdAt: createdAt.toIso8601String(),
      favoriteLanguages: [for (final l in favoriteLanguages) l.name],
      keyboardLayout: keyboardLayout?.name,
      keyboardBrand: keyboardBrand,
      keyboardModel: keyboardModel,
      favoriteQuote: favoriteQuote,
      favoriteProgrammer: favoriteProgrammer,
    );
  }
}

/// Converts a drift [GuestProfileRow] into its storage [ProfileDto]. The
/// row stores [favoriteLanguages] as one comma-joined `TEXT` column (see
/// `guest_profiles_table.dart`); this is the one place that splits it back
/// into a list.
extension GuestProfileRowMapper on GuestProfileRow {
  /// Maps this row to the storage DTO.
  ProfileDto toDto() {
    return ProfileDto(
      id: id,
      username: username,
      createdAt: createdAt.toIso8601String(),
      favoriteLanguages: _splitCsv(favoriteLanguages),
      keyboardLayout: keyboardLayout,
      keyboardBrand: keyboardBrand,
      keyboardModel: keyboardModel,
      favoriteQuote: favoriteQuote,
      favoriteProgrammer: favoriteProgrammer,
    );
  }
}

List<String>? _splitCsv(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return raw.split(',').where((s) => s.isNotEmpty).toList();
}

String? _joinCsv(List<String>? values) {
  if (values == null || values.isEmpty) return null;
  return values.join(',');
}

extension _FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
