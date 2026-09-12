import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';
import 'package:ridge/features/profile/infrastructure/guest_profile_dao.dart';
import 'package:ridge/features/profile/infrastructure/profile_mapper.dart';

/// Drift-backed adapter for [ProfileRepository].
///
/// Unlike the `shared_preferences`-backed repositories elsewhere in this
/// app, this adapter does not need a hand-rolled in-memory current-value
/// + broadcast `StreamController` — drift's `.watch()` queries are
/// already reactive (re-run and re-emit on every write to the watched
/// table, and replay the current rows to any new listener), so
/// `watchActiveProfile` simply maps that stream. Writes still follow the
/// established try/catch → `Result.err(StorageFailure(...))` shape.
class ProfileRepositoryImpl implements ProfileRepository {
  /// Creates the adapter over the given [GuestProfileDao].
  new(this._dao);

  final GuestProfileDao _dao;

  @override
  Stream<GuestProfile?> watchActiveProfile() {
    return _dao.watchActiveProfile().map((row) => row?.toDto().toDomain());
  }

  @override
  Future<Result<GuestProfile, AppFailure>> createGuestProfile(
    String username,
  ) async {
    try {
      final existing = await _dao.getActiveProfile();
      if (existing != null) {
        return const Result.err(
          ValidationFailure('A guest profile already exists on this device'),
        );
      }
      final profile = GuestProfile(
        id: ProfileId.generate(),
        username: username,
        createdAt: DateTime.now(),
      );
      await _dao.insertProfile(profile.toDto().toCompanion());
      return Result.ok(profile);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not create guest profile', cause: e),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> renameProfile(String newUsername) async {
    try {
      final current = await _dao.getActiveProfile();
      if (current == null) {
        return const Result.err(NotFoundFailure('No guest profile to rename'));
      }
      await _dao.updateUsername(id: current.id, username: newUsername);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not rename profile', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) async {
    try {
      final current = await _dao.getActiveProfile();
      if (current == null) {
        return const Result.err(NotFoundFailure('No guest profile to update'));
      }
      await _dao.updateCustomization(
        id: current.id,
        favoriteLanguages: favoriteLanguages.isEmpty
            ? null
            : favoriteLanguages.map((l) => l.name).join(','),
        keyboardLayout: keyboardLayout?.name,
        keyboardBrand: keyboardBrand,
        keyboardModel: keyboardModel,
        favoriteQuote: favoriteQuote,
        favoriteProgrammer: favoriteProgrammer,
        githubUsername: githubUsername,
        websiteUrl: websiteUrl,
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(StorageFailure('Could not update profile', cause: e));
    }
  }

  @override
  Future<Result<void, AppFailure>> updateDeviceInfo(
    DetectedDeviceInfo info,
  ) async {
    try {
      final current = await _dao.getActiveProfile();
      if (current == null) {
        return const Result.err(NotFoundFailure('No guest profile to update'));
      }
      await _dao.updateDeviceInfo(
        id: current.id,
        platform: info.platform,
        operatingSystemVersion: info.operatingSystemVersion,
        deviceModel: info.deviceModel,
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.err(
        StorageFailure('Could not update device info', cause: e),
      );
    }
  }
}
