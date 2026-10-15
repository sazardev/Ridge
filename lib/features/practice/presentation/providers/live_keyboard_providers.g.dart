// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_keyboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Physical keys currently held down during a practice session, by
/// `PhysicalKeyId.name` — the bridge between `KeystrokeCaptureField`
/// (which sees every real keydown/keyup) and the live 3D keyboard strip.
///
/// A raw `ValueNotifier` on purpose: it changes on every keystroke, and
/// only the strip's own `ValueListenableBuilder` should rebuild that
/// often — a Riverpod state here would rebuild the capture field per
/// key. Kept alive (and explicitly cleared when the field disposes) so a
/// key still held at the end of a session can never stay lit into the
/// next one.

@ProviderFor(pressedSessionKeys)
final pressedSessionKeysProvider = PressedSessionKeysProvider._();

/// Physical keys currently held down during a practice session, by
/// `PhysicalKeyId.name` — the bridge between `KeystrokeCaptureField`
/// (which sees every real keydown/keyup) and the live 3D keyboard strip.
///
/// A raw `ValueNotifier` on purpose: it changes on every keystroke, and
/// only the strip's own `ValueListenableBuilder` should rebuild that
/// often — a Riverpod state here would rebuild the capture field per
/// key. Kept alive (and explicitly cleared when the field disposes) so a
/// key still held at the end of a session can never stay lit into the
/// next one.

final class PressedSessionKeysProvider
    extends
        $FunctionalProvider<
          ValueNotifier<Set<String>>,
          ValueNotifier<Set<String>>,
          ValueNotifier<Set<String>>
        >
    with $Provider<ValueNotifier<Set<String>>> {
  /// Physical keys currently held down during a practice session, by
  /// `PhysicalKeyId.name` — the bridge between `KeystrokeCaptureField`
  /// (which sees every real keydown/keyup) and the live 3D keyboard strip.
  ///
  /// A raw `ValueNotifier` on purpose: it changes on every keystroke, and
  /// only the strip's own `ValueListenableBuilder` should rebuild that
  /// often — a Riverpod state here would rebuild the capture field per
  /// key. Kept alive (and explicitly cleared when the field disposes) so a
  /// key still held at the end of a session can never stay lit into the
  /// next one.
  PressedSessionKeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pressedSessionKeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pressedSessionKeysHash();

  @$internal
  @override
  $ProviderElement<ValueNotifier<Set<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ValueNotifier<Set<String>> create(Ref ref) {
    return pressedSessionKeys(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ValueNotifier<Set<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ValueNotifier<Set<String>>>(value),
    );
  }
}

String _$pressedSessionKeysHash() =>
    r'ea6a8cce7f6ed424f79d533a5695d820195525fa';

/// Whether the active profile has a keyboard the live strip can actually
/// draw — a non-empty model that resolves to a curated layout or a known
/// family silhouette. Gates both the session AppBar's toggle and the
/// strip itself, so the control never dangles over nothing.

@ProviderFor(hasSessionKeyboardVisual)
final hasSessionKeyboardVisualProvider = HasSessionKeyboardVisualProvider._();

/// Whether the active profile has a keyboard the live strip can actually
/// draw — a non-empty model that resolves to a curated layout or a known
/// family silhouette. Gates both the session AppBar's toggle and the
/// strip itself, so the control never dangles over nothing.

final class HasSessionKeyboardVisualProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the active profile has a keyboard the live strip can actually
  /// draw — a non-empty model that resolves to a curated layout or a known
  /// family silhouette. Gates both the session AppBar's toggle and the
  /// strip itself, so the control never dangles over nothing.
  HasSessionKeyboardVisualProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasSessionKeyboardVisualProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasSessionKeyboardVisualHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasSessionKeyboardVisual(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasSessionKeyboardVisualHash() =>
    r'ff4927abce1568ee870022c4b803538229353ff0';
