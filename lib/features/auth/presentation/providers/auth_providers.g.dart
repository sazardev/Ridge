// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the callable-function client bound to the Firebase project
/// the app is configured against (never on Linux, where there is no
/// Firebase at all).

@ProviderFor(callableFunctionsClient)
final callableFunctionsClientProvider = CallableFunctionsClientProvider._();

/// Provides the callable-function client bound to the Firebase project
/// the app is configured against (never on Linux, where there is no
/// Firebase at all).

final class CallableFunctionsClientProvider
    extends
        $FunctionalProvider<
          CallableFunctionsClient,
          CallableFunctionsClient,
          CallableFunctionsClient
        >
    with $Provider<CallableFunctionsClient> {
  /// Provides the callable-function client bound to the Firebase project
  /// the app is configured against (never on Linux, where there is no
  /// Firebase at all).
  CallableFunctionsClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callableFunctionsClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callableFunctionsClientHash();

  @$internal
  @override
  $ProviderElement<CallableFunctionsClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CallableFunctionsClient create(Ref ref) {
    return callableFunctionsClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CallableFunctionsClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CallableFunctionsClient>(value),
    );
  }
}

String _$callableFunctionsClientHash() =>
    r'f76402a67f5e5377018880f89c36857c16d187b7';

/// Provides the [AccountRepository] for this platform: the Firebase
/// adapter on Android/Web/Windows, a no-op on Linux (STACK.md §5.2).

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

/// Provides the [AccountRepository] for this platform: the Firebase
/// adapter on Android/Web/Windows, a no-op on Linux (STACK.md §5.2).

final class AccountRepositoryProvider
    extends
        $FunctionalProvider<
          AccountRepository,
          AccountRepository,
          AccountRepository
        >
    with $Provider<AccountRepository> {
  /// Provides the [AccountRepository] for this platform: the Firebase
  /// adapter on Android/Web/Windows, a no-op on Linux (STACK.md §5.2).
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountRepository>(value),
    );
  }
}

String _$accountRepositoryHash() => r'8352eb64a785b712a5bd289a28fb8eb33f849544';

/// Provides the [WatchCurrentAccountUseCase] for observing the session.

@ProviderFor(watchCurrentAccountUseCase)
final watchCurrentAccountUseCaseProvider =
    WatchCurrentAccountUseCaseProvider._();

/// Provides the [WatchCurrentAccountUseCase] for observing the session.

final class WatchCurrentAccountUseCaseProvider
    extends
        $FunctionalProvider<
          WatchCurrentAccountUseCase,
          WatchCurrentAccountUseCase,
          WatchCurrentAccountUseCase
        >
    with $Provider<WatchCurrentAccountUseCase> {
  /// Provides the [WatchCurrentAccountUseCase] for observing the session.
  WatchCurrentAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCurrentAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCurrentAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchCurrentAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchCurrentAccountUseCase create(Ref ref) {
    return watchCurrentAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchCurrentAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchCurrentAccountUseCase>(value),
    );
  }
}

String _$watchCurrentAccountUseCaseHash() =>
    r'd0fed162fa47051dfda01888f2d97e70b4dad6f8';

/// The currently signed-in Registered Account, or `null` while signed
/// out — the SDK restores the session across app restarts, so this is
/// what keeps a registered user signed in. Eagerly watched from
/// `app.dart` so the session is live for the app's whole lifetime.

@ProviderFor(currentAccount)
final currentAccountProvider = CurrentAccountProvider._();

/// The currently signed-in Registered Account, or `null` while signed
/// out — the SDK restores the session across app restarts, so this is
/// what keeps a registered user signed in. Eagerly watched from
/// `app.dart` so the session is live for the app's whole lifetime.

final class CurrentAccountProvider
    extends
        $FunctionalProvider<
          AsyncValue<RegisteredAccount?>,
          RegisteredAccount?,
          Stream<RegisteredAccount?>
        >
    with
        $FutureModifier<RegisteredAccount?>,
        $StreamProvider<RegisteredAccount?> {
  /// The currently signed-in Registered Account, or `null` while signed
  /// out — the SDK restores the session across app restarts, so this is
  /// what keeps a registered user signed in. Eagerly watched from
  /// `app.dart` so the session is live for the app's whole lifetime.
  CurrentAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAccountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAccountHash();

  @$internal
  @override
  $StreamProviderElement<RegisteredAccount?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RegisteredAccount?> create(Ref ref) {
    return currentAccount(ref);
  }
}

String _$currentAccountHash() => r'8b6ae078a0b756c608472ec45860dab8a3105626';

/// Provides the [RegisterAccountUseCase].

@ProviderFor(registerAccountUseCase)
final registerAccountUseCaseProvider = RegisterAccountUseCaseProvider._();

/// Provides the [RegisterAccountUseCase].

final class RegisterAccountUseCaseProvider
    extends
        $FunctionalProvider<
          RegisterAccountUseCase,
          RegisterAccountUseCase,
          RegisterAccountUseCase
        >
    with $Provider<RegisterAccountUseCase> {
  /// Provides the [RegisterAccountUseCase].
  RegisterAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegisterAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegisterAccountUseCase create(Ref ref) {
    return registerAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterAccountUseCase>(value),
    );
  }
}

String _$registerAccountUseCaseHash() =>
    r'197267ab2d0b0f0d24e0af7af231c75d39697a60';

/// Provides the [SignInAccountUseCase].

@ProviderFor(signInAccountUseCase)
final signInAccountUseCaseProvider = SignInAccountUseCaseProvider._();

/// Provides the [SignInAccountUseCase].

final class SignInAccountUseCaseProvider
    extends
        $FunctionalProvider<
          SignInAccountUseCase,
          SignInAccountUseCase,
          SignInAccountUseCase
        >
    with $Provider<SignInAccountUseCase> {
  /// Provides the [SignInAccountUseCase].
  SignInAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInAccountUseCase create(Ref ref) {
    return signInAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInAccountUseCase>(value),
    );
  }
}

String _$signInAccountUseCaseHash() =>
    r'd05c7f5da28fc577fe4d2b878e408c138f2502c0';

/// Provides the [SignOutAccountUseCase].

@ProviderFor(signOutAccountUseCase)
final signOutAccountUseCaseProvider = SignOutAccountUseCaseProvider._();

/// Provides the [SignOutAccountUseCase].

final class SignOutAccountUseCaseProvider
    extends
        $FunctionalProvider<
          SignOutAccountUseCase,
          SignOutAccountUseCase,
          SignOutAccountUseCase
        >
    with $Provider<SignOutAccountUseCase> {
  /// Provides the [SignOutAccountUseCase].
  SignOutAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignOutAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignOutAccountUseCase create(Ref ref) {
    return signOutAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutAccountUseCase>(value),
    );
  }
}

String _$signOutAccountUseCaseHash() =>
    r'965077fcd2b0024c728f2446ed0c13c7e7755b02';

/// Provides the [DeleteAccountUseCase] — remote deletion plus the same
/// full local wipe as Settings > "delete all data".

@ProviderFor(deleteAccountUseCase)
final deleteAccountUseCaseProvider = DeleteAccountUseCaseProvider._();

/// Provides the [DeleteAccountUseCase] — remote deletion plus the same
/// full local wipe as Settings > "delete all data".

final class DeleteAccountUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteAccountUseCase,
          DeleteAccountUseCase,
          DeleteAccountUseCase
        >
    with $Provider<DeleteAccountUseCase> {
  /// Provides the [DeleteAccountUseCase] — remote deletion plus the same
  /// full local wipe as Settings > "delete all data".
  DeleteAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteAccountUseCase create(Ref ref) {
    return deleteAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteAccountUseCase>(value),
    );
  }
}

String _$deleteAccountUseCaseHash() =>
    r'afa077c8deae0406cd7e2558802c548c6c1b0994';

/// Provides the [RecoverAccountUseCase].

@ProviderFor(recoverAccountUseCase)
final recoverAccountUseCaseProvider = RecoverAccountUseCaseProvider._();

/// Provides the [RecoverAccountUseCase].

final class RecoverAccountUseCaseProvider
    extends
        $FunctionalProvider<
          RecoverAccountUseCase,
          RecoverAccountUseCase,
          RecoverAccountUseCase
        >
    with $Provider<RecoverAccountUseCase> {
  /// Provides the [RecoverAccountUseCase].
  RecoverAccountUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recoverAccountUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recoverAccountUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecoverAccountUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecoverAccountUseCase create(Ref ref) {
    return recoverAccountUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecoverAccountUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecoverAccountUseCase>(value),
    );
  }
}

String _$recoverAccountUseCaseHash() =>
    r'15e6e4636afa6d8c991853ac49d612495fc3ab0c';
