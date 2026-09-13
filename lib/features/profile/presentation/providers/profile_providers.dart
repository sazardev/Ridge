import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/persistence/drift/app_database.dart';
import 'package:ridge/core/persistence/drift/database_provider.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/application/usecases/create_guest_profile_usecase.dart';
import 'package:ridge/features/profile/application/usecases/ensure_device_info_usecase.dart';
import 'package:ridge/features/profile/application/usecases/rename_profile_usecase.dart';
import 'package:ridge/features/profile/application/usecases/update_keyboard_setup_usecase.dart';
import 'package:ridge/features/profile/application/usecases/update_profile_customization_usecase.dart';
import 'package:ridge/features/profile/application/usecases/watch_active_profile_usecase.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';
import 'package:ridge/features/profile/infrastructure/device_info_source_impl.dart';
import 'package:ridge/features/profile/infrastructure/guest_profile_dao.dart';
import 'package:ridge/features/profile/infrastructure/profile_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

/// Provides the [GuestProfileDao] bound to the shared [AppDatabase].
@Riverpod(keepAlive: true)
GuestProfileDao guestProfileDao(Ref ref) {
  return ref.watch(appDatabaseProvider).guestProfileDao;
}

/// Provides the [ProfileRepository] implementation used across the app.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(guestProfileDaoProvider));
}

/// Provides the [CreateGuestProfileUseCase] for first-run profile creation.
@riverpod
CreateGuestProfileUseCase createGuestProfileUseCase(Ref ref) {
  return CreateGuestProfileUseCase(ref.watch(profileRepositoryProvider));
}

/// Provides the [WatchActiveProfileUseCase] for observing the Guest Profile.
@riverpod
WatchActiveProfileUseCase watchActiveProfileUseCase(Ref ref) {
  return WatchActiveProfileUseCase(ref.watch(profileRepositoryProvider));
}

/// Provides the [RenameProfileUseCase] for renaming the Guest Profile.
@riverpod
RenameProfileUseCase renameProfileUseCase(Ref ref) {
  return RenameProfileUseCase(ref.watch(profileRepositoryProvider));
}

/// Provides the [UpdateProfileCustomizationUseCase] for editing the Guest
/// Profile's self-expression fields.
@riverpod
UpdateProfileCustomizationUseCase updateProfileCustomizationUseCase(Ref ref) {
  return UpdateProfileCustomizationUseCase(
    ref.watch(profileRepositoryProvider),
  );
}

/// Provides the [UpdateKeyboardSetupUseCase] for editing the Guest
/// Profile's keyboard (brand, model, character layout and advanced
/// customization) from the dedicated keyboard editor.
@riverpod
UpdateKeyboardSetupUseCase updateKeyboardSetupUseCase(Ref ref) {
  return UpdateKeyboardSetupUseCase(ref.watch(profileRepositoryProvider));
}

/// Provides the [DeviceInfoSource] adapter.
@Riverpod(keepAlive: true)
DeviceInfoSource deviceInfoSource(Ref ref) => const DeviceInfoSourceImpl();

/// Provides the [EnsureDeviceInfoUseCase] for auto-detecting device info.
@riverpod
EnsureDeviceInfoUseCase ensureDeviceInfoUseCase(Ref ref) {
  return EnsureDeviceInfoUseCase(
    ref.watch(profileRepositoryProvider),
    ref.watch(deviceInfoSourceProvider),
  );
}

/// Detects and persists device info onto the active Guest Profile,
/// watched unconditionally from `app.dart` (same fire-and-forget-on-start
/// shape as `content_providers.dart`'s `catalogSeed`). A no-op while no
/// profile exists yet, and idempotent once one does — see
/// [EnsureDeviceInfoUseCase] — so re-running on every subsequent profile
/// update (rename, customization) is harmless.
@Riverpod(keepAlive: true)
Future<void> deviceInfoSync(Ref ref) async {
  final profile = ref.watch(activeProfileControllerProvider).value;
  await ref.watch(ensureDeviceInfoUseCaseProvider)(profile);
}

/// Exposes the current [GuestProfile] (or `null` before one exists) and
/// the mutations the UI can request.
@Riverpod(keepAlive: true)
class ActiveProfileController extends _$ActiveProfileController {
  @override
  Stream<GuestProfile?> build() {
    return ref.watch(watchActiveProfileUseCaseProvider)();
  }

  /// Creates the Guest Profile with [username].
  Future<Result<GuestProfile, AppFailure>> create(String username) {
    return ref.read(createGuestProfileUseCaseProvider)(username);
  }

  /// Renames the Guest Profile to [newUsername].
  Future<Result<void, AppFailure>> rename(String newUsername) {
    return ref.read(renameProfileUseCaseProvider)(newUsername);
  }

  /// Updates the Guest Profile's profile-flair fields — always all of
  /// them together, since the editor is a single form.
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) {
    return ref.read(updateProfileCustomizationUseCaseProvider)(
      favoriteLanguages: favoriteLanguages,
      favoriteQuote: favoriteQuote,
      favoriteProgrammer: favoriteProgrammer,
      githubUsername: githubUsername,
      websiteUrl: websiteUrl,
    );
  }

  /// Updates the Guest Profile's keyboard setup — always all of it
  /// together, since the dedicated editor is a single form.
  Future<Result<void, AppFailure>> updateKeyboardSetup({
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    KeyboardCustomization? keyboardCustomization,
  }) {
    return ref.read(updateKeyboardSetupUseCaseProvider)(
      keyboardLayout: keyboardLayout,
      keyboardBrand: keyboardBrand,
      keyboardModel: keyboardModel,
      keyboardCustomization: keyboardCustomization,
    );
  }
}

/// Whether a Guest Profile is known to exist, for the router's redirect.
///
/// `true` while [ActiveProfileController] hasn't emitted its first value
/// yet — so a cold start never flashes the create-profile screen before
/// drift finishes its first query. The moment the real answer arrives,
/// this value changes and `_RouterRefreshNotifier` re-evaluates the
/// redirect (mirrors how `settingsControllerProvider`'s nullable `.value`
/// is read defensively in `app_router.dart`).
@Riverpod(keepAlive: true)
bool hasGuestProfile(Ref ref) {
  final profileState = ref.watch(activeProfileControllerProvider);
  if (!profileState.hasValue) return true;
  return profileState.value != null;
}

/// The active profile's functional keyboard remaps, indexed by
/// `PhysicalKeyId.name` — read by `practice`'s capture engine on every
/// keydown (a deliberately narrow cross-feature read: the keyboard being
/// remapped is the profile's own). Empty while no profile or no remap
/// exists; kept alive and recomputed from the profile stream, so a saved
/// remap takes effect live, without restarting the session.
@Riverpod(keepAlive: true)
Map<String, KeyboardKeyRemap> keyboardRemapsByName(Ref ref) {
  final remaps = ref
      .watch(activeProfileControllerProvider)
      .value
      ?.keyboardCustomization
      ?.remaps;
  if (remaps == null || remaps.isEmpty) return const {};
  return {for (final remap in remaps) remap.physicalKey: remap};
}
