// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reminder_guard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the daily practice reminder in sync with reality: fires once the
/// app's settings and session history first load, and again whenever the
/// reminder-relevant settings or the session list change (any finished
/// session included) — so the scheduled ping always targets the next
/// sensible occurrence and never nags about a day already practiced.
///
/// Watched unconditionally in `RidgeApp.build`, the same fire-on-start
/// shape as `catalogSeedProvider`/`deepLinkListenerProvider`. Deliberately
/// lives in `practice` rather than `settings`: it needs the session
/// history, and `practice -> settings` is an established direction while
/// the reverse would be a new cycle.

@ProviderFor(dailyReminderGuard)
final dailyReminderGuardProvider = DailyReminderGuardProvider._();

/// Keeps the daily practice reminder in sync with reality: fires once the
/// app's settings and session history first load, and again whenever the
/// reminder-relevant settings or the session list change (any finished
/// session included) — so the scheduled ping always targets the next
/// sensible occurrence and never nags about a day already practiced.
///
/// Watched unconditionally in `RidgeApp.build`, the same fire-on-start
/// shape as `catalogSeedProvider`/`deepLinkListenerProvider`. Deliberately
/// lives in `practice` rather than `settings`: it needs the session
/// history, and `practice -> settings` is an established direction while
/// the reverse would be a new cycle.

final class DailyReminderGuardProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the daily practice reminder in sync with reality: fires once the
  /// app's settings and session history first load, and again whenever the
  /// reminder-relevant settings or the session list change (any finished
  /// session included) — so the scheduled ping always targets the next
  /// sensible occurrence and never nags about a day already practiced.
  ///
  /// Watched unconditionally in `RidgeApp.build`, the same fire-on-start
  /// shape as `catalogSeedProvider`/`deepLinkListenerProvider`. Deliberately
  /// lives in `practice` rather than `settings`: it needs the session
  /// history, and `practice -> settings` is an established direction while
  /// the reverse would be a new cycle.
  DailyReminderGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderGuardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderGuardHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return dailyReminderGuard(ref);
  }
}

String _$dailyReminderGuardHash() =>
    r'65b4829209a3ad1d456cd29a38bce064658d918d';
