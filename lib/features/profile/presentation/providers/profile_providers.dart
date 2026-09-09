import 'package:just_in_time/core/error/app_failure.dart';
import 'package:just_in_time/core/persistence/drift/app_database.dart';
import 'package:just_in_time/core/persistence/drift/database_provider.dart';
import 'package:just_in_time/core/utils/result.dart';
import 'package:just_in_time/features/profile/application/usecases/create_guest_profile_usecase.dart';
import 'package:just_in_time/features/profile/application/usecases/rename_profile_usecase.dart';
import 'package:just_in_time/features/profile/application/usecases/update_profile_customization_usecase.dart';
import 'package:just_in_time/features/profile/application/usecases/watch_active_profile_usecase.dart';
import 'package:just_in_time/features/profile/domain/entities/favorite_language.dart';
import 'package:just_in_time/features/profile/domain/entities/guest_profile.dart';
import 'package:just_in_time/features/profile/domain/entities/keyboard_layout.dart';
import 'package:just_in_time/features/profile/domain/repositories/profile_repository.dart';
import 'package:just_in_time/features/profile/infrastructure/guest_profile_dao.dart';
import 'package:just_in_time/features/profile/infrastructure/profile_repository_impl.dart';
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

  /// Updates the Guest Profile's self-expression fields — always all six
  /// together, since the editor is a single form.
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    String? favoriteQuote,
    String? favoriteProgrammer,
  }) {
    return ref.read(updateProfileCustomizationUseCaseProvider)(
      favoriteLanguages: favoriteLanguages,
      keyboardLayout: keyboardLayout,
      keyboardBrand: keyboardBrand,
      keyboardModel: keyboardModel,
      favoriteQuote: favoriteQuote,
      favoriteProgrammer: favoriteProgrammer,
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
