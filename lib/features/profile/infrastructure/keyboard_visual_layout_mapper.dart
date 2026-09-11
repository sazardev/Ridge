import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_visual_layout.dart';
import 'package:ridge/features/profile/infrastructure/keyboard_visual_layout_dto.dart';

/// Resolves a wire-format key (many fields optional, KLE-default
/// semantics) into a fully-concrete [KeyboardKeySpec].
extension KeyboardKeySpecDtoMapper on KeyboardKeySpecDto {
  /// Applies the KLE defaults documented on [KeyboardKeySpecDto] and
  /// returns the resolved domain value.
  KeyboardKeySpec toDomain() => KeyboardKeySpec(
    x: x,
    y: y,
    w: w,
    h: h,
    x2: x2 ?? 0,
    y2: y2 ?? 0,
    w2: w2 ?? w,
    h2: h2 ?? h,
    rotationAngle: rotationAngle,
    rotationX: rotationX ?? x,
    rotationY: rotationY ?? y,
  );
}

/// Resolves a wire-format curated layout into its domain entity.
extension KeyboardVisualLayoutDtoMapper on KeyboardVisualLayoutDto {
  /// Maps every key via [KeyboardKeySpecDtoMapper.toDomain].
  KeyboardVisualLayout toDomain() => KeyboardVisualLayout(
    model: model,
    keys: [for (final key in keys) key.toDomain()],
  );
}
