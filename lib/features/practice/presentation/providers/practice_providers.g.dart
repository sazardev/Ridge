// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [PracticeDao] bound to the shared [AppDatabase].

@ProviderFor(practiceDao)
final practiceDaoProvider = PracticeDaoProvider._();

/// Provides the [PracticeDao] bound to the shared [AppDatabase].

final class PracticeDaoProvider
    extends $FunctionalProvider<PracticeDao, PracticeDao, PracticeDao>
    with $Provider<PracticeDao> {
  /// Provides the [PracticeDao] bound to the shared [AppDatabase].
  PracticeDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'practiceDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$practiceDaoHash();

  @$internal
  @override
  $ProviderElement<PracticeDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PracticeDao create(Ref ref) {
    return practiceDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PracticeDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PracticeDao>(value),
    );
  }
}

String _$practiceDaoHash() => r'39d363b92931d05a90843e5b486df4a9342502d5';

/// Provides the [SessionRepository] implementation used across the app.

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

/// Provides the [SessionRepository] implementation used across the app.

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  /// Provides the [SessionRepository] implementation used across the app.
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'5d852fcbe9af081e93b02399bdef4cbf0a604a6a';

/// Provides the [StartPracticeSessionUseCase] for validating a session
/// before it starts.

@ProviderFor(startPracticeSessionUseCase)
final startPracticeSessionUseCaseProvider =
    StartPracticeSessionUseCaseProvider._();

/// Provides the [StartPracticeSessionUseCase] for validating a session
/// before it starts.

final class StartPracticeSessionUseCaseProvider
    extends
        $FunctionalProvider<
          StartPracticeSessionUseCase,
          StartPracticeSessionUseCase,
          StartPracticeSessionUseCase
        >
    with $Provider<StartPracticeSessionUseCase> {
  /// Provides the [StartPracticeSessionUseCase] for validating a session
  /// before it starts.
  StartPracticeSessionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startPracticeSessionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startPracticeSessionUseCaseHash();

  @$internal
  @override
  $ProviderElement<StartPracticeSessionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StartPracticeSessionUseCase create(Ref ref) {
    return startPracticeSessionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartPracticeSessionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartPracticeSessionUseCase>(value),
    );
  }
}

String _$startPracticeSessionUseCaseHash() =>
    r'1512c4cb520249a4e117f9f84ba96f4117bf051e';

/// Provides the [FinishPracticeSessionUseCase] for computing metrics and
/// persisting a finished session.

@ProviderFor(finishPracticeSessionUseCase)
final finishPracticeSessionUseCaseProvider =
    FinishPracticeSessionUseCaseProvider._();

/// Provides the [FinishPracticeSessionUseCase] for computing metrics and
/// persisting a finished session.

final class FinishPracticeSessionUseCaseProvider
    extends
        $FunctionalProvider<
          FinishPracticeSessionUseCase,
          FinishPracticeSessionUseCase,
          FinishPracticeSessionUseCase
        >
    with $Provider<FinishPracticeSessionUseCase> {
  /// Provides the [FinishPracticeSessionUseCase] for computing metrics and
  /// persisting a finished session.
  FinishPracticeSessionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finishPracticeSessionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finishPracticeSessionUseCaseHash();

  @$internal
  @override
  $ProviderElement<FinishPracticeSessionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinishPracticeSessionUseCase create(Ref ref) {
    return finishPracticeSessionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinishPracticeSessionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinishPracticeSessionUseCase>(value),
    );
  }
}

String _$finishPracticeSessionUseCaseHash() =>
    r'd6c85f46d666fdc6b2e43bf5ca487745f8f2718f';

/// Provides the [GetNextSprintSnippetUseCase] Sprint mode uses to advance
/// through its same-difficulty snippet queue (SPEC.md §5.2).

@ProviderFor(getNextSprintSnippetUseCase)
final getNextSprintSnippetUseCaseProvider =
    GetNextSprintSnippetUseCaseProvider._();

/// Provides the [GetNextSprintSnippetUseCase] Sprint mode uses to advance
/// through its same-difficulty snippet queue (SPEC.md §5.2).

final class GetNextSprintSnippetUseCaseProvider
    extends
        $FunctionalProvider<
          GetNextSprintSnippetUseCase,
          GetNextSprintSnippetUseCase,
          GetNextSprintSnippetUseCase
        >
    with $Provider<GetNextSprintSnippetUseCase> {
  /// Provides the [GetNextSprintSnippetUseCase] Sprint mode uses to advance
  /// through its same-difficulty snippet queue (SPEC.md §5.2).
  GetNextSprintSnippetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNextSprintSnippetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNextSprintSnippetUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetNextSprintSnippetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetNextSprintSnippetUseCase create(Ref ref) {
    return getNextSprintSnippetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetNextSprintSnippetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetNextSprintSnippetUseCase>(value),
    );
  }
}

String _$getNextSprintSnippetUseCaseHash() =>
    r'ab76002fdc5fa25727cc0d4ee22d1adb9c324c35';

/// Provides the app-lifetime [KeystrokeSoundPlayer] for the current
/// settings-chosen sound pack — kept alive (rather than one per session)
/// so its audio pools stay pre-loaded across every practice session
/// instead of reloading on each one. Rebuilds (disposing the old pools,
/// loading the new pack's) whenever the sound pack setting changes.

@ProviderFor(keystrokeSoundPlayer)
final keystrokeSoundPlayerProvider = KeystrokeSoundPlayerProvider._();

/// Provides the app-lifetime [KeystrokeSoundPlayer] for the current
/// settings-chosen sound pack — kept alive (rather than one per session)
/// so its audio pools stay pre-loaded across every practice session
/// instead of reloading on each one. Rebuilds (disposing the old pools,
/// loading the new pack's) whenever the sound pack setting changes.

final class KeystrokeSoundPlayerProvider
    extends
        $FunctionalProvider<
          KeystrokeSoundPlayer,
          KeystrokeSoundPlayer,
          KeystrokeSoundPlayer
        >
    with $Provider<KeystrokeSoundPlayer> {
  /// Provides the app-lifetime [KeystrokeSoundPlayer] for the current
  /// settings-chosen sound pack — kept alive (rather than one per session)
  /// so its audio pools stay pre-loaded across every practice session
  /// instead of reloading on each one. Rebuilds (disposing the old pools,
  /// loading the new pack's) whenever the sound pack setting changes.
  KeystrokeSoundPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keystrokeSoundPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keystrokeSoundPlayerHash();

  @$internal
  @override
  $ProviderElement<KeystrokeSoundPlayer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeystrokeSoundPlayer create(Ref ref) {
    return keystrokeSoundPlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeystrokeSoundPlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeystrokeSoundPlayer>(value),
    );
  }
}

String _$keystrokeSoundPlayerHash() =>
    r'2fdc6b3dfdf1487fcb8a5588fbe525f704ff7289';
