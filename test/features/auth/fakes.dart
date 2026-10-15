// Hand-written fake ports shared by the `auth` usecase tests, same
// pattern as the other usecase test files — kept in one place because
// five use cases exercise the same [AccountRepository] /
// [ProfileRepository] pair (this file doesn't end in `_test.dart`, so
// the runner never picks it up as a suite).
import 'dart:async';

import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/domain/value_objects/account_username.dart';
import 'package:ridge/features/data_management/domain/repositories/data_reset_repository.dart';
import 'package:ridge/features/learning_paths/domain/value_objects/lesson_id.dart';
import 'package:ridge/features/profile/domain/entities/favorite_language.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/device_info_source.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';
import 'package:ridge/features/profile/domain/value_objects/profile_id.dart';

/// Configurable [AccountRepository] fake: every method answers with
/// whatever the test set up (defaulting to a success) and records its
/// inputs.
class FakeAccountRepository implements AccountRepository {
  /// Creates the fake; [isSupported] mirrors the platform capability.
  new({this.isSupported = true});

  @override
  final bool isSupported;

  /// Result for [register]; defaults to registering
  /// `(user: 'omar', recoveryCode: 'AAAAA-BBBBB-CCCCC-DDDDD')`.
  Result<AccountRegistration, AppFailure>? registerResult;

  /// Result for [signIn]; defaults to the `omar` account.
  Result<RegisteredAccount, AppFailure>? signInResult;

  /// Result for [signOut]; defaults to success.
  Result<void, AppFailure>? signOutResult;

  /// Result for [deleteAccount]; defaults to success.
  Result<void, AppFailure>? deleteAccountResult;

  /// Result for [recover]; defaults to a fresh code.
  Result<String, AppFailure>? recoverResult;

  int registerCalls = 0;
  int signInCalls = 0;
  int signOutCalls = 0;
  int deleteCalls = 0;
  int recoverCalls = 0;
  AccountUsername? lastUsername;
  String? lastPassword;
  String? lastRecoveryCode;
  String? lastNewPassword;

  final _accounts = StreamController<RegisteredAccount?>.broadcast();

  @override
  Stream<RegisteredAccount?> watchCurrentAccount() => _accounts.stream;

  @override
  Future<Result<AccountRegistration, AppFailure>> register({
    required AccountUsername username,
    required String password,
  }) async {
    registerCalls++;
    lastUsername = username;
    lastPassword = password;
    return registerResult ??
        Result.ok((
          account: RegisteredAccount(
            uid: 'uid-1',
            username: username.value,
            createdAt: DateTime(2026),
          ),
          recoveryCode: 'AAAAA-BBBBB-CCCCC-DDDDD',
        ));
  }

  @override
  Future<Result<RegisteredAccount, AppFailure>> signIn({
    required AccountUsername username,
    required String password,
  }) async {
    signInCalls++;
    lastUsername = username;
    lastPassword = password;
    return signInResult ??
        Result.ok(
          RegisteredAccount(
            uid: 'uid-1',
            username: username.value,
            createdAt: DateTime(2026),
          ),
        );
  }

  @override
  Future<Result<void, AppFailure>> signOut() async {
    signOutCalls++;
    return signOutResult ?? const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> deleteAccount() async {
    deleteCalls++;
    return deleteAccountResult ?? const Result.ok(null);
  }

  @override
  Future<Result<String, AppFailure>> recover({
    required AccountUsername username,
    required String recoveryCode,
    required String newPassword,
  }) async {
    recoverCalls++;
    lastUsername = username;
    lastRecoveryCode = recoveryCode;
    lastNewPassword = newPassword;
    return recoverResult ?? const Result.ok('EEEEE-FFFFF-GGGGG-HHHHH');
  }
}

/// Configurable [ProfileRepository] fake — an in-memory single profile
/// with every account-related write recorded.
class FakeProfileRepository implements ProfileRepository {
  /// Creates the fake, optionally with an existing [profile].
  new({this.profile});

  /// The on-device profile, if any.
  GuestProfile? profile;

  /// When set, [renameProfile] fails with it (the real adapter rejects
  /// renames on a linked profile).
  AppFailure? renameFailure;

  /// When set, [createGuestProfile] fails with it.
  AppFailure? createFailure;

  /// When set, [linkAccount] fails with it.
  AppFailure? linkFailure;

  String? linkedAccountUid;
  bool unlinked = false;
  String? renamedTo;
  int createCalls = 0;

  @override
  Stream<GuestProfile?> watchActiveProfile() => Stream.value(profile);

  @override
  Future<Result<GuestProfile, AppFailure>> createGuestProfile(
    String username,
  ) async {
    createCalls++;
    final failure = createFailure;
    if (failure != null) return Result.err(failure);
    final created = GuestProfile(
      id: ProfileId.generate(),
      username: username,
      createdAt: DateTime(2026),
    );
    profile = created;
    return Result.ok(created);
  }

  @override
  Future<Result<void, AppFailure>> renameProfile(String newUsername) async {
    final failure = renameFailure;
    if (failure != null) return Result.err(failure);
    renamedTo = newUsername;
    final current = profile;
    if (current != null) {
      profile = current.copyWith(username: newUsername);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> linkAccount({
    required String accountUid,
  }) async {
    final failure = linkFailure;
    if (failure != null) return Result.err(failure);
    linkedAccountUid = accountUid;
    final current = profile;
    if (current != null) {
      profile = current.copyWith(accountUid: accountUid);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> unlinkAccount() async {
    unlinked = true;
    final current = profile;
    if (current != null) {
      profile = current.copyWith(accountUid: null);
    }
    return const Result.ok(null);
  }

  @override
  Future<Result<void, AppFailure>> updateCustomization({
    List<FavoriteLanguage> favoriteLanguages = const [],
    String? favoriteQuote,
    String? favoriteProgrammer,
    String? githubUsername,
    String? websiteUrl,
  }) async => const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> updateKeyboardSetup({
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    KeyboardCustomization? keyboardCustomization,
  }) async => const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> updateDeviceInfo(
    DetectedDeviceInfo info,
  ) async => const Result.err(ValidationFailure('unused in this test'));
}

/// Configurable [DataResetRepository] fake recording the wipe.
class FakeDataResetRepository implements DataResetRepository {
  /// When set, [wipeAllData] fails with it.
  AppFailure? wipeFailure;

  int wipeCalls = 0;

  @override
  Future<Result<void, AppFailure>> wipeAllData() async {
    wipeCalls++;
    final failure = wipeFailure;
    return failure == null ? const Result.ok(null) : Result.err(failure);
  }

  @override
  Future<Result<void, AppFailure>> resetLesson({
    required ProfileId profileId,
    required LessonId lessonId,
  }) async => const Result.err(ValidationFailure('unused in this test'));

  @override
  Future<Result<void, AppFailure>> resetAllLessons(ProfileId profileId) async =>
      const Result.err(ValidationFailure('unused in this test'));
}

/// A minimal valid profile for tests that need one to already exist.
GuestProfile testGuestProfile() => GuestProfile(
  id: ProfileId.generate(),
  username: 'Omar',
  createdAt: DateTime(2026),
);

/// A minimal registered account for tests.
RegisteredAccount testAccount({
  String username = 'omar',
  String uid = 'uid-1',
}) =>
    RegisteredAccount(uid: uid, username: username, createdAt: DateTime(2026));
