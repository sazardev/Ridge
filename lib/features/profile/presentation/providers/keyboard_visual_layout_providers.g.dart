// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyboard_visual_layout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [KeyboardVisualLayoutSource] implementation used across
/// the app.

@ProviderFor(keyboardVisualLayoutSource)
final keyboardVisualLayoutSourceProvider =
    KeyboardVisualLayoutSourceProvider._();

/// Provides the [KeyboardVisualLayoutSource] implementation used across
/// the app.

final class KeyboardVisualLayoutSourceProvider
    extends
        $FunctionalProvider<
          KeyboardVisualLayoutSource,
          KeyboardVisualLayoutSource,
          KeyboardVisualLayoutSource
        >
    with $Provider<KeyboardVisualLayoutSource> {
  /// Provides the [KeyboardVisualLayoutSource] implementation used across
  /// the app.
  KeyboardVisualLayoutSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardVisualLayoutSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardVisualLayoutSourceHash();

  @$internal
  @override
  $ProviderElement<KeyboardVisualLayoutSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeyboardVisualLayoutSource create(Ref ref) {
    return keyboardVisualLayoutSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeyboardVisualLayoutSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeyboardVisualLayoutSource>(value),
    );
  }
}

String _$keyboardVisualLayoutSourceHash() =>
    r'45eb8357bda126e2199204292e052927604c70ff';

/// Loads every curated keyboard layout once and keeps it — the data bank
/// is bundled, read-only content, never re-fetched or invalidated within
/// an app session (same reasoning as `learningPathRepositoryProvider`).

@ProviderFor(keyboardVisualLayouts)
final keyboardVisualLayoutsProvider = KeyboardVisualLayoutsProvider._();

/// Loads every curated keyboard layout once and keeps it — the data bank
/// is bundled, read-only content, never re-fetched or invalidated within
/// an app session (same reasoning as `learningPathRepositoryProvider`).

final class KeyboardVisualLayoutsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, KeyboardVisualLayout>>,
          Map<String, KeyboardVisualLayout>,
          FutureOr<Map<String, KeyboardVisualLayout>>
        >
    with
        $FutureModifier<Map<String, KeyboardVisualLayout>>,
        $FutureProvider<Map<String, KeyboardVisualLayout>> {
  /// Loads every curated keyboard layout once and keeps it — the data bank
  /// is bundled, read-only content, never re-fetched or invalidated within
  /// an app session (same reasoning as `learningPathRepositoryProvider`).
  KeyboardVisualLayoutsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardVisualLayoutsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardVisualLayoutsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, KeyboardVisualLayout>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, KeyboardVisualLayout>> create(Ref ref) {
    return keyboardVisualLayouts(ref);
  }
}

String _$keyboardVisualLayoutsHash() =>
    r'32d2607a55122f33584ec2ebaf5f155376bee993';
