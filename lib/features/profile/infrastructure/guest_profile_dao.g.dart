// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_profile_dao.dart';

// ignore_for_file: type=lint
mixin _$GuestProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $GuestProfilesTable get guestProfiles => attachedDatabase.guestProfiles;
  GuestProfileDaoManager get managers => GuestProfileDaoManager(this);
}

class GuestProfileDaoManager {
  final _$GuestProfileDaoMixin _db;
  GuestProfileDaoManager(this._db);
  $$GuestProfilesTableTableManager get guestProfiles =>
      $$GuestProfilesTableTableManager(_db.attachedDatabase, _db.guestProfiles);
}
