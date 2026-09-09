import 'package:drift/drift.dart';

import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/features/profile/infrastructure/tables/guest_profiles_table.dart';

part 'guest_profile_dao.g.dart';

/// Typed queries against the [GuestProfiles] table.
@DriftAccessor(tables: [GuestProfiles])
class GuestProfileDao extends DatabaseAccessor<AppDatabase>
    with _$GuestProfileDaoMixin {
  /// Creates the DAO bound to the shared [AppDatabase].
  new(super.attachedDatabase);

  /// Emits the single Guest Profile row, or `null` if none exists yet,
  /// and every subsequent change to it.
  Stream<GuestProfileRow?> watchActiveProfile() {
    return (select(guestProfiles)..limit(1)).watchSingleOrNull();
  }

  /// Returns the single Guest Profile row, or `null` if none exists yet.
  Future<GuestProfileRow?> getActiveProfile() {
    return (select(guestProfiles)..limit(1)).getSingleOrNull();
  }

  /// Inserts the first (and only) Guest Profile row.
  Future<void> insertProfile(GuestProfilesCompanion row) {
    return into(guestProfiles).insert(row);
  }

  /// Renames the row identified by [id] to [username].
  Future<void> updateUsername({required String id, required String username}) {
    return (update(guestProfiles)..where((row) => row.id.equals(id))).write(
      GuestProfilesCompanion(username: Value(username)),
    );
  }

  /// Overwrites the row identified by [id]'s self-expression fields —
  /// always all six together, since the editor is a single form; a
  /// `null` explicitly clears that field. [favoriteLanguages] is already
  /// comma-joined by the caller (see `ProfileMapper`'s CSV helpers).
  Future<void> updateCustomization({
    required String id,
    required String? favoriteLanguages,
    required String? keyboardLayout,
    required String? keyboardBrand,
    required String? keyboardModel,
    required String? favoriteQuote,
    required String? favoriteProgrammer,
  }) {
    return (update(guestProfiles)..where((row) => row.id.equals(id))).write(
      GuestProfilesCompanion(
        favoriteLanguages: Value(favoriteLanguages),
        keyboardLayout: Value(keyboardLayout),
        keyboardBrand: Value(keyboardBrand),
        keyboardModel: Value(keyboardModel),
        favoriteQuote: Value(favoriteQuote),
        favoriteProgrammer: Value(favoriteProgrammer),
      ),
    );
  }
}
