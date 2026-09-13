import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_key_editor_sheet.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_per_key_section.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_remap_editor_sheet.dart';

/// The keyboard editor's per-key editing behavior — opening the key, extra
/// key and remap sheets and folding their results into the live
/// customization — split off the screen class so it stays layout and
/// navigation. Every write goes through [setState], since all of this is
/// unsaved editor state.
mixin KeyboardCustomizeKeyEditing<T extends StatefulWidget> on State<T> {
  /// The live, unsaved customization.
  KeyboardCustomization get customization;

  /// Replaces the live customization (called inside [State.setState]).
  set customization(KeyboardCustomization value);

  /// The editor's resolved *base* keys (used for position ids).
  List<KeyboardKeySpec> get baseKeys;

  int _extraKeySeed = 0;

  /// Routes a tapped preview key to the base-key or extra-key editor.
  Future<void> editKey(int index, KeyboardKeySpec key) {
    if (index < baseKeys.length) return editBaseKey(baseKeys[index]);
    return editExtra(index - baseKeys.length);
  }

  /// Opens the sheet for an existing (base-layout) cap and applies the
  /// resulting legend/light override.
  Future<void> editBaseKey(KeyboardKeySpec baseKey) async {
    final l10n = AppLocalizations.of(context);
    final keyId = keyboardKeyIdFor(baseKey);
    final existing = _overrideFor(keyId);
    final result = await showKeyboardKeyEditorSheet(
      context,
      title: l10n.keyboardCustomizeKeySheetTitle,
      initialLabel: existing?.label ?? baseKey.label,
      initialLabel2: existing?.label2 ?? baseKey.label2,
      initialLightColor: _lightColorFor(keyId),
      rgbEnabled: customization.rgbEnabled,
      isOverridden: existing != null,
    );
    if (result == null || !mounted) return;
    setState(() {
      final overrides = [
        for (final override in customization.keyOverrides)
          if (override.keyId != keyId) override,
      ];
      if (!result.removed && (result.label != null || result.label2 != null)) {
        overrides.add(
          KeyboardKeyLegendOverride(
            keyId: keyId,
            label: result.label,
            label2: result.label2,
          ),
        );
      }
      customization = customization.copyWith(
        keyOverrides: overrides,
        keyLights: _withKeyLight(keyId, result.lightColor),
      );
    });
  }

  /// Opens the sheet for an existing extra key, applying legends, size and
  /// light (or removing it).
  Future<void> editExtra(int index) async {
    final l10n = AppLocalizations.of(context);
    final extra = customization.extraKeys[index];
    final result = await showKeyboardKeyEditorSheet(
      context,
      title: l10n.keyboardCustomizeKeySheetTitle,
      initialLabel: extra.label,
      initialLabel2: extra.label2,
      initialWidth: extra.width,
      initialHeight: extra.height,
      initialLightColor: _lightColorFor(extra.id),
      rgbEnabled: customization.rgbEnabled,
      isExtra: true,
    );
    if (result == null || !mounted) return;
    setState(() {
      final extras = [...customization.extraKeys];
      if (result.removed) {
        extras.removeAt(index);
      } else {
        extras[index] = extra.copyWith(
          label: result.label,
          label2: result.label2,
          width: result.width,
          height: result.height,
        );
      }
      customization = customization.copyWith(
        extraKeys: extras,
        keyLights: _withKeyLight(
          extra.id,
          result.removed ? null : result.lightColor,
        ),
      );
    });
  }

  /// Adds a brand-new extra key and opens its sheet right away; cancelling
  /// the sheet drops the key again, so a mis-tap never leaves a blank cap
  /// on the board.
  Future<void> addExtraKey() async {
    final l10n = AppLocalizations.of(context);
    final id = _newExtraKeyId();
    setState(() {
      customization = customization.copyWith(
        extraKeys: [
          ...customization.extraKeys,
          KeyboardExtraKey(id: id),
        ],
      );
    });
    final result = await showKeyboardKeyEditorSheet(
      context,
      title: l10n.keyboardCustomizeKeySheetTitle,
      rgbEnabled: customization.rgbEnabled,
      isExtra: true,
    );
    if (!mounted) return;
    setState(() {
      final kept = result != null && !result.removed;
      final extras = [
        for (final extra in customization.extraKeys)
          if (extra.id != id)
            extra
          else if (kept)
            extra.copyWith(
              label: result.label,
              label2: result.label2,
              width: result.width,
              height: result.height,
            ),
      ];
      customization = customization.copyWith(
        extraKeys: extras,
        keyLights: _withKeyLight(id, kept ? result.lightColor : null),
      );
    });
  }

  /// Opens the remap sheet for a new ([index] `null`) or existing remap.
  Future<void> editRemap(int? index) async {
    final existing = index == null ? null : customization.remaps[index];
    final result = await showKeyboardRemapEditorSheet(
      context,
      initialPhysicalKey: existing == null
          ? null
          : physicalKeyIdByName(existing.physicalKey),
      initialCharacter: existing?.character,
      initialShiftedCharacter: existing?.shiftedCharacter,
      isExisting: existing != null,
    );
    if (result == null || !mounted) return;
    setState(() {
      final remaps = [
        for (final remap in customization.remaps)
          if (remap.physicalKey != result.physicalKey.name) remap,
      ];
      if (!result.removed) {
        remaps.add(
          KeyboardKeyRemap(
            physicalKey: result.physicalKey.name,
            character: result.character,
            shiftedCharacter: result.shiftedCharacter,
          ),
        );
      }
      customization = customization.copyWith(remaps: remaps);
    });
  }

  KeyboardKeyLegendOverride? _overrideFor(String keyId) {
    for (final override in customization.keyOverrides) {
      if (override.keyId == keyId) return override;
    }
    return null;
  }

  int? _lightColorFor(String keyId) {
    for (final light in customization.keyLights) {
      if (light.keyId == keyId) return light.color;
    }
    return null;
  }

  /// The customization's key-light list with [keyId] set to [color], or
  /// removed when [color] is `null`.
  List<KeyboardKeyLight> _withKeyLight(String keyId, int? color) => [
    for (final light in customization.keyLights)
      if (light.keyId != keyId) light,
    if (color != null) KeyboardKeyLight(keyId: keyId, color: color),
  ];

  String _newExtraKeyId() =>
      '${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '-${_extraKeySeed++}';
}
