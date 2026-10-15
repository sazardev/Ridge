// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-lifetime [DailyReminderScheduler] implementation.

@ProviderFor(dailyReminderScheduler)
final dailyReminderSchedulerProvider = DailyReminderSchedulerProvider._();

/// Provides the app-lifetime [DailyReminderScheduler] implementation.

final class DailyReminderSchedulerProvider
    extends
        $FunctionalProvider<
          DailyReminderScheduler,
          DailyReminderScheduler,
          DailyReminderScheduler
        >
    with $Provider<DailyReminderScheduler> {
  /// Provides the app-lifetime [DailyReminderScheduler] implementation.
  DailyReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<DailyReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyReminderScheduler create(Ref ref) {
    return dailyReminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyReminderScheduler>(value),
    );
  }
}

String _$dailyReminderSchedulerHash() =>
    r'2598a1a9de51ae8e1aee72244a0226422eb02415';
