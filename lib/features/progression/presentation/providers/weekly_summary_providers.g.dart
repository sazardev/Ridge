// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Progress screen's rolling weekly report card's data — `null`
/// while there's no active profile or no session history at all yet (a
/// brand-new profile has no week to report on; the Progress screen's own
/// empty state already covers that case).
///
/// Deliberately its own file: it reads `practice`'s sessions stream,
/// while `practice` reads `progression_providers.dart` — keeping this
/// provider out of that file avoids a library-level import cycle.

@ProviderFor(weeklySummary)
final weeklySummaryProvider = WeeklySummaryProvider._();

/// The Progress screen's rolling weekly report card's data — `null`
/// while there's no active profile or no session history at all yet (a
/// brand-new profile has no week to report on; the Progress screen's own
/// empty state already covers that case).
///
/// Deliberately its own file: it reads `practice`'s sessions stream,
/// while `practice` reads `progression_providers.dart` — keeping this
/// provider out of that file avoids a library-level import cycle.

final class WeeklySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeeklySummary?>,
          WeeklySummary?,
          FutureOr<WeeklySummary?>
        >
    with $FutureModifier<WeeklySummary?>, $FutureProvider<WeeklySummary?> {
  /// The Progress screen's rolling weekly report card's data — `null`
  /// while there's no active profile or no session history at all yet (a
  /// brand-new profile has no week to report on; the Progress screen's own
  /// empty state already covers that case).
  ///
  /// Deliberately its own file: it reads `practice`'s sessions stream,
  /// while `practice` reads `progression_providers.dart` — keeping this
  /// provider out of that file avoids a library-level import cycle.
  WeeklySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklySummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklySummaryHash();

  @$internal
  @override
  $FutureProviderElement<WeeklySummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WeeklySummary?> create(Ref ref) {
    return weeklySummary(ref);
  }
}

String _$weeklySummaryHash() => r'6a4e7e8a95f98369998fc8a05cfd9510c7cd0127';
