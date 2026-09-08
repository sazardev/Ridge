// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Shared local key-value store used by feature-level infrastructure
/// adapters (never by domain/application code, and never by widgets
/// directly). `SharedPreferencesAsync` talks straight to the platform
/// channel on every call — no stale in-memory cache to reason about.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Shared local key-value store used by feature-level infrastructure
/// adapters (never by domain/application code, and never by widgets
/// directly). `SharedPreferencesAsync` talks straight to the platform
/// channel on every call — no stale in-memory cache to reason about.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferencesAsync,
          SharedPreferencesAsync,
          SharedPreferencesAsync
        >
    with $Provider<SharedPreferencesAsync> {
  /// Shared local key-value store used by feature-level infrastructure
  /// adapters (never by domain/application code, and never by widgets
  /// directly). `SharedPreferencesAsync` talks straight to the platform
  /// channel on every call — no stale in-memory cache to reason about.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesAsync> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesAsync create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesAsync value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesAsync>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'27f75883fdfa5699515101e124521cad2de328e6';
