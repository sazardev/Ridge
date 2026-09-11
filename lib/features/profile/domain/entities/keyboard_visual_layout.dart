import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';

part 'keyboard_visual_layout.freezed.dart';

/// A curated, faithful 2D physical layout for one specific
/// `keyboardModel` string (see `profile_suggestions.dart`'s
/// `kKeyboardModelSuggestions`) — the "data bank" entry backing the
/// profile's keyboard visual for models with real, verifiable public
/// layout data (see `assets/content/keyboard_layouts/`). Most models
/// have no curated entry and fall back to a generic
/// `KeyboardShapeFamily` silhouette instead (`keyboard_shape_lookup.dart`)
/// — see `keyboard_visual_layout_local_data_source.dart`'s doc comment
/// for why most OEM/gaming boards can never have one of these.
@freezed
abstract class KeyboardVisualLayout with _$KeyboardVisualLayout {
  /// Creates a curated layout snapshot for [model].
  const factory({required String model, required List<KeyboardKeySpec> keys}) =
      _KeyboardVisualLayout;
}
