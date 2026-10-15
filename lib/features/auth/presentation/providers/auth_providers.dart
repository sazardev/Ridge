import 'package:firebase_core/firebase_core.dart';

import 'package:ridge/core/firebase/firebase_bootstrap.dart';
import 'package:ridge/features/auth/application/usecases/delete_account_usecase.dart';
import 'package:ridge/features/auth/application/usecases/recover_account_usecase.dart';
import 'package:ridge/features/auth/application/usecases/register_account_usecase.dart';
import 'package:ridge/features/auth/application/usecases/sign_in_account_usecase.dart';
import 'package:ridge/features/auth/application/usecases/sign_out_account_usecase.dart';
import 'package:ridge/features/auth/application/usecases/watch_current_account_usecase.dart';
import 'package:ridge/features/auth/domain/entities/registered_account.dart';
import 'package:ridge/features/auth/domain/repositories/account_repository.dart';
import 'package:ridge/features/auth/infrastructure/callable_functions_client.dart';
import 'package:ridge/features/auth/infrastructure/firebase_account_repository.dart';
import 'package:ridge/features/auth/infrastructure/unsupported_account_repository.dart';
import 'package:ridge/features/data_management/presentation/providers/data_management_providers.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// The Cloud Functions region `register`/`recoverAccount`/`deleteAccount`
/// are deployed to — must match `functions/src/index.ts` and the
/// `firebase.json` deployment.
const accountFunctionsRegion = 'southamerica-east1';

/// Provides the callable-function client bound to the Firebase project
/// the app is configured against (never on Linux, where there is no
/// Firebase at all).
@Riverpod(keepAlive: true)
CallableFunctionsClient callableFunctionsClient(Ref ref) {
  return CallableFunctionsClient(
    projectId: Firebase.app().options.projectId,
    region: accountFunctionsRegion,
  );
}

/// Provides the [AccountRepository] for this platform: the Firebase
/// adapter on Android/Web/Windows, a no-op on Linux (STACK.md §5.2).
@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) {
  if (!isFirebaseSupportedPlatform) {
    return const UnsupportedAccountRepository();
  }
  return FirebaseAccountRepository(ref.watch(callableFunctionsClientProvider));
}

/// Provides the [WatchCurrentAccountUseCase] for observing the session.
@riverpod
WatchCurrentAccountUseCase watchCurrentAccountUseCase(Ref ref) {
  return WatchCurrentAccountUseCase(ref.watch(accountRepositoryProvider));
}

/// The currently signed-in Registered Account, or `null` while signed
/// out — the SDK restores the session across app restarts, so this is
/// what keeps a registered user signed in. Eagerly watched from
/// `app.dart` so the session is live for the app's whole lifetime.
@Riverpod(keepAlive: true)
Stream<RegisteredAccount?> currentAccount(Ref ref) {
  return ref.watch(watchCurrentAccountUseCaseProvider)();
}

/// Provides the [RegisterAccountUseCase].
@riverpod
RegisterAccountUseCase registerAccountUseCase(Ref ref) {
  return RegisterAccountUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(profileRepositoryProvider),
  );
}

/// Provides the [SignInAccountUseCase].
@riverpod
SignInAccountUseCase signInAccountUseCase(Ref ref) {
  return SignInAccountUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(profileRepositoryProvider),
  );
}

/// Provides the [SignOutAccountUseCase].
@riverpod
SignOutAccountUseCase signOutAccountUseCase(Ref ref) {
  return SignOutAccountUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(profileRepositoryProvider),
  );
}

/// Provides the [DeleteAccountUseCase] — remote deletion plus the same
/// full local wipe as Settings > "delete all data".
@riverpod
DeleteAccountUseCase deleteAccountUseCase(Ref ref) {
  return DeleteAccountUseCase(
    ref.watch(accountRepositoryProvider),
    ref.watch(dataResetRepositoryProvider),
  );
}

/// Provides the [RecoverAccountUseCase].
@riverpod
RecoverAccountUseCase recoverAccountUseCase(Ref ref) {
  return RecoverAccountUseCase(ref.watch(accountRepositoryProvider));
}
