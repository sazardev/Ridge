// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ApplyDailyReminderUseCase] over the platform scheduler.

@ProviderFor(applyDailyReminderUseCase)
final applyDailyReminderUseCaseProvider = ApplyDailyReminderUseCaseProvider._();

/// Provides the [ApplyDailyReminderUseCase] over the platform scheduler.

final class ApplyDailyReminderUseCaseProvider
    extends
        $FunctionalProvider<
          ApplyDailyReminderUseCase,
          ApplyDailyReminderUseCase,
          ApplyDailyReminderUseCase
        >
    with $Provider<ApplyDailyReminderUseCase> {
  /// Provides the [ApplyDailyReminderUseCase] over the platform scheduler.
  ApplyDailyReminderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applyDailyReminderUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applyDailyReminderUseCaseHash();

  @$internal
  @override
  $ProviderElement<ApplyDailyReminderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApplyDailyReminderUseCase create(Ref ref) {
    return applyDailyReminderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplyDailyReminderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplyDailyReminderUseCase>(value),
    );
  }
}

String _$applyDailyReminderUseCaseHash() =>
    r'9b5695e79f2da3cf41c18689e29d124e37dc2fdc';

/// Coordinates the daily practice reminder across its moving parts —
/// the settings snapshot, the platform's [DailyReminderCapability] and
/// the localized notification copy. Kept alive so its `Ref` stays valid
/// across `sync`'s awaits (callers fire it from provider listeners, not
/// from widget builds).

@ProviderFor(dailyReminderService)
final dailyReminderServiceProvider = DailyReminderServiceProvider._();

/// Coordinates the daily practice reminder across its moving parts —
/// the settings snapshot, the platform's [DailyReminderCapability] and
/// the localized notification copy. Kept alive so its `Ref` stays valid
/// across `sync`'s awaits (callers fire it from provider listeners, not
/// from widget builds).

final class DailyReminderServiceProvider
    extends
        $FunctionalProvider<
          DailyReminderService,
          DailyReminderService,
          DailyReminderService
        >
    with $Provider<DailyReminderService> {
  /// Coordinates the daily practice reminder across its moving parts —
  /// the settings snapshot, the platform's [DailyReminderCapability] and
  /// the localized notification copy. Kept alive so its `Ref` stays valid
  /// across `sync`'s awaits (callers fire it from provider listeners, not
  /// from widget builds).
  DailyReminderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderServiceHash();

  @$internal
  @override
  $ProviderElement<DailyReminderService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyReminderService create(Ref ref) {
    return dailyReminderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyReminderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyReminderService>(value),
    );
  }
}

String _$dailyReminderServiceHash() =>
    r'e6aea61492622f7ee8c5a132ef657a8b95a8a57d';
