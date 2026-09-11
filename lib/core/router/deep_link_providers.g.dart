// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deep_link_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Listens for incoming `ridge://` links, both while the app is already
/// running and the one that launched it cold (`getInitialLink`), and
/// forwards recognized ones to [appRouterProvider]'s `GoRouter` — fired
/// once at startup exactly like `catalogSeedProvider`/
/// `deviceInfoSyncProvider` (`content_providers.dart`/
/// `profile_providers.dart`), watched unconditionally in `RidgeApp.build`.

@ProviderFor(deepLinkListener)
final deepLinkListenerProvider = DeepLinkListenerProvider._();

/// Listens for incoming `ridge://` links, both while the app is already
/// running and the one that launched it cold (`getInitialLink`), and
/// forwards recognized ones to [appRouterProvider]'s `GoRouter` — fired
/// once at startup exactly like `catalogSeedProvider`/
/// `deviceInfoSyncProvider` (`content_providers.dart`/
/// `profile_providers.dart`), watched unconditionally in `RidgeApp.build`.

final class DeepLinkListenerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Listens for incoming `ridge://` links, both while the app is already
  /// running and the one that launched it cold (`getInitialLink`), and
  /// forwards recognized ones to [appRouterProvider]'s `GoRouter` — fired
  /// once at startup exactly like `catalogSeedProvider`/
  /// `deviceInfoSyncProvider` (`content_providers.dart`/
  /// `profile_providers.dart`), watched unconditionally in `RidgeApp.build`.
  DeepLinkListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepLinkListenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepLinkListenerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return deepLinkListener(ref);
  }
}

String _$deepLinkListenerHash() => r'2611536941dc756f1876fd145b9da5b6e40f4815';
