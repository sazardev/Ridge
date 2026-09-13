import 'package:ridge/core/error/app_failure.dart';
import 'package:ridge/core/utils/result.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/repositories/profile_repository.dart';

/// Trims and validates the Guest Profile's whole keyboard setup —
/// character layout, free-text brand/model and the advanced
/// [KeyboardCustomization] blob — then persists it through the
/// repository port in one write.
///
/// Kept separate from `UpdateProfileCustomizationUseCase` so the profile
/// form and the dedicated keyboard editor own disjoint columns and can
/// never overwrite each other's work. Bounds are generous but real: the
/// editor's controls make every one of them unreachable, so a failure
/// here means a hand-crafted/corrupted payload, never a normal edit.
class UpdateKeyboardSetupUseCase {
  /// Creates the use case over the given [ProfileRepository] port.
  const new(this._repository);

  final ProfileRepository _repository;

  /// The longest a free-text keyboard brand/model this app accepts.
  static const maxShortTextLength = 60;

  /// The longest keyboard notes text this app accepts.
  static const maxNotesLength = 500;

  /// The earliest plausible purchase year.
  static const minPurchaseYear = 1950;

  /// Caps on the user-authored collections — far above what any real
  /// board needs, low enough that a corrupt blob can't blow up storage
  /// or rendering.
  /// The most per-key legend overrides this app stores.
  static const maxKeyOverrides = 256;

  /// The most user-added extra keys this app stores.
  static const maxExtraKeys = 32;

  /// The most functional remaps this app stores.
  static const maxRemaps = 128;

  /// The most per-key backlight colors this app stores.
  static const maxKeyLights = 256;

  /// The longest legend printed on one cap.
  static const maxLegendLength = 24;

  /// The longest output of a functional remap, in UTF-16 code units —
  /// one printable character, maybe with a combining mark.
  static const maxRemapCharLength = 2;

  /// The largest a user-added extra key may be, in key-units.
  static const maxExtraKeySize = 4.0;

  /// Validates and persists the given keyboard setup. Blank free text is
  /// normalized to `null` (clearing that field) rather than stored as an
  /// empty string; within [keyboardCustomization], blank legends are
  /// dropped and fully-empty entries are pruned so the blob only ever
  /// stores real customization.
  Future<Result<void, AppFailure>> call({
    KeyboardLayout? keyboardLayout,
    String? keyboardBrand,
    String? keyboardModel,
    KeyboardCustomization? keyboardCustomization,
  }) {
    final cleanBrand = _clean(keyboardBrand);
    if (cleanBrand != null && cleanBrand.length > maxShortTextLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Keyboard brand must be $maxShortTextLength characters or fewer',
          ),
        ),
      );
    }
    final cleanModel = _clean(keyboardModel);
    if (cleanModel != null && cleanModel.length > maxShortTextLength) {
      return Future.value(
        const Result.err(
          ValidationFailure(
            'Keyboard model must be $maxShortTextLength characters or fewer',
          ),
        ),
      );
    }

    KeyboardCustomization? cleanCustomization;
    if (keyboardCustomization != null) {
      final failure = _validateCustomization(keyboardCustomization);
      if (failure != null) return Future.value(Result.err(failure));
      cleanCustomization = _normalizeCustomization(keyboardCustomization);
    }

    return _repository.updateKeyboardSetup(
      keyboardLayout: keyboardLayout,
      keyboardBrand: cleanBrand,
      keyboardModel: cleanModel,
      keyboardCustomization: cleanCustomization,
    );
  }

  String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  AppFailure? _validateCustomization(KeyboardCustomization c) {
    final notes = _clean(c.notes);
    if (notes != null && notes.length > maxNotesLength) {
      return const ValidationFailure(
        'Keyboard notes must be $maxNotesLength characters or fewer',
      );
    }
    final year = c.purchaseYear;
    if (year != null) {
      final maxYear = DateTime.now().year + 1;
      if (year < minPurchaseYear || year > maxYear) {
        return ValidationFailure(
          'Purchase year must be between $minPurchaseYear and $maxYear',
        );
      }
    }
    if (c.keyOverrides.length > maxKeyOverrides) {
      return const ValidationFailure('Too many per-key legend overrides');
    }
    if (c.extraKeys.length > maxExtraKeys) {
      return const ValidationFailure('Too many extra keys');
    }
    if (c.remaps.length > maxRemaps) {
      return const ValidationFailure('Too many functional key remaps');
    }
    if (c.keyLights.length > maxKeyLights) {
      return const ValidationFailure('Too many per-key lights');
    }
    for (final override in c.keyOverrides) {
      if (!_legendFits(override.label) || !_legendFits(override.label2)) {
        return const ValidationFailure(
          'A key legend must be $maxLegendLength characters or fewer',
        );
      }
    }
    for (final extra in c.extraKeys) {
      if (!_legendFits(extra.label) || !_legendFits(extra.label2)) {
        return const ValidationFailure(
          'A key legend must be $maxLegendLength characters or fewer',
        );
      }
      if (extra.width < 1 ||
          extra.width > maxExtraKeySize ||
          extra.height < 1 ||
          extra.height > maxExtraKeySize) {
        return const ValidationFailure(
          'An extra key must be between 1u and ${maxExtraKeySize}u',
        );
      }
    }
    for (final remap in c.remaps) {
      if (remap.physicalKey.trim().isEmpty ||
          !_remapCharFits(remap.character) ||
          !_remapCharFits(remap.shiftedCharacter)) {
        return const ValidationFailure('A key remap is not valid');
      }
    }
    return null;
  }

  KeyboardCustomization _normalizeCustomization(KeyboardCustomization c) {
    return c.copyWith(
      notes: _clean(c.notes),
      keyOverrides: [
        for (final override in c.keyOverrides)
          if (_clean(override.label) != null || _clean(override.label2) != null)
            override.copyWith(
              label: _clean(override.label),
              label2: _clean(override.label2),
            ),
      ],
      extraKeys: [
        for (final extra in c.extraKeys)
          extra.copyWith(
            label: _clean(extra.label),
            label2: _clean(extra.label2),
          ),
      ],
      remaps: [
        for (final remap in c.remaps)
          remap.copyWith(
            physicalKey: remap.physicalKey.trim(),
            shiftedCharacter: _clean(remap.shiftedCharacter),
          ),
      ],
      keyLights: [
        for (final light in c.keyLights)
          if (light.keyId.trim().isNotEmpty)
            light.copyWith(keyId: light.keyId.trim()),
      ],
    );
  }

  bool _legendFits(String? legend) =>
      legend == null || legend.length <= maxLegendLength;

  bool _remapCharFits(String? char) =>
      char == null || (char.isNotEmpty && char.length <= maxRemapCharLength);
}
