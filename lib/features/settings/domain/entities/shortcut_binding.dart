import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortcut_binding.freezed.dart';

/// A user-customizable key combination for one `AppShortcutAction` —
/// deliberately Flutter-free (no `LogicalKeyboardKey` here) so the
/// domain layer stays pure Dart, same rule as every other entity in this
/// repo. [keyId] is `LogicalKeyboardKey.keyId`, reconstructible in the
/// presentation layer via `LogicalKeyboardKey(keyId)`.
@freezed
abstract class ShortcutBinding with _$ShortcutBinding {
  /// Creates an immutable key-combination snapshot.
  const factory({
    required int keyId,
    required bool control,
    required bool alt,
    required bool shift,
  }) = _ShortcutBinding;
}
