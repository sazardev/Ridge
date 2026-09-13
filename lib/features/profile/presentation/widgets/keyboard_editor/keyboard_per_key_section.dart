import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id_label.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_editor_fields.dart';

/// Resolves a persisted `PhysicalKeyId.name` back to its enum value, or
/// `null` when the name isn't one this app version models — a remap whose
/// key was removed in a future version stays stored but renders by name.
PhysicalKeyId? physicalKeyIdByName(String name) {
  for (final key in PhysicalKeyId.values) {
    if (key.name == name) return key;
  }
  return null;
}

/// The keyboard editor's per-key section: chips for every customized
/// legend, the list of user-added extra keys, and the functional remaps —
/// all edited through the modal sheets the parent screen owns, so this
/// widget is pure presentation over [customization] plus callbacks.
class KeyboardPerKeySection extends StatelessWidget {
  /// Creates the section over [customization] and its callbacks.
  const new({
    required this.customization,
    required this.onRemoveOverride,
    required this.onAddExtraKey,
    required this.onEditExtra,
    required this.onRemoveExtra,
    required this.onAddRemap,
    required this.onEditRemap,
    required this.onRemoveRemap,
    super.key,
  });

  /// The live customization being edited.
  final KeyboardCustomization customization;

  /// Removes the legend override for the given physical key id.
  final ValueChanged<String> onRemoveOverride;

  /// Opens the sheet for a brand-new extra key.
  final VoidCallback onAddExtraKey;

  /// Opens the sheet for the extra key at the given index.
  final ValueChanged<int> onEditExtra;

  /// Removes the extra key with the given id.
  final ValueChanged<String> onRemoveExtra;

  /// Opens the sheet for a brand-new remap.
  final VoidCallback onAddRemap;

  /// Opens the sheet for the remap at the given index.
  final ValueChanged<int> onEditRemap;

  /// Removes the remap for the given physical-key name.
  final ValueChanged<String> onRemoveRemap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final overrides = customization.keyOverrides;
    final extras = customization.extraKeys;
    final remaps = customization.remaps;

    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeKeysSectionTitle,
      icon: LucideIcons.slidersHorizontal,
      children: [
        if (overrides.isNotEmpty) ...[
          Text(
            l10n.keyboardSpecsCustomLegendsLabel,
            style: textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final override in overrides)
                InputChip(
                  label: Text(
                    override.label ?? override.label2 ?? override.keyId,
                  ),
                  onDeleted: () => onRemoveOverride(override.keyId),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.keyboardCustomizeExtraKeysLabel,
                style: textTheme.titleSmall,
              ),
            ),
            TextButton.icon(
              onPressed: onAddExtraKey,
              icon: const Icon(LucideIcons.plus300, size: 18),
              label: Text(l10n.keyboardCustomizeExtraKeysAddAction),
            ),
          ],
        ),
        if (extras.isEmpty)
          Text(
            l10n.keyboardCustomizeKeysHint,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (var index = 0; index < extras.length; index++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(LucideIcons.squareDashed300),
              title: Text(extras[index].label ?? extras[index].label2 ?? '—'),
              subtitle: Text(
                '${extras[index].width.toStringAsFixed(2)}u × '
                '${extras[index].height.toStringAsFixed(2)}u',
              ),
              trailing: IconButton(
                icon: const Icon(LucideIcons.trash2300),
                tooltip: l10n.keyboardCustomizeRemoveAction,
                onPressed: () => onRemoveExtra(extras[index].id),
              ),
              onTap: () => onEditExtra(index),
            ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.keyboardCustomizeRemapLabel,
                style: textTheme.titleSmall,
              ),
            ),
            TextButton.icon(
              onPressed: onAddRemap,
              icon: const Icon(LucideIcons.plus300, size: 18),
              label: Text(l10n.keyboardCustomizeRemapAddAction),
            ),
          ],
        ),
        Text(
          l10n.keyboardCustomizeRemapExplainer,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        for (var index = 0; index < remaps.length; index++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(LucideIcons.arrowLeftRight300),
            title: Text(_remapTitle(l10n, remaps[index])),
            trailing: IconButton(
              icon: const Icon(LucideIcons.trash2300),
              tooltip: l10n.keyboardCustomizeRemoveAction,
              onPressed: () => onRemoveRemap(remaps[index].physicalKey),
            ),
            onTap: () => onEditRemap(index),
          ),
      ],
    );
  }

  /// "A → q / Q" — the physical key's localized label, the character it
  /// now types, and the shifted character when one is set.
  String _remapTitle(AppLocalizations l10n, KeyboardKeyRemap remap) {
    final physical =
        physicalKeyIdByName(remap.physicalKey)?.displayLabel(l10n) ??
        remap.physicalKey;
    final shifted = remap.shiftedCharacter;
    return '$physical → ${remap.character}'
        '${shifted == null ? '' : ' / $shifted'}';
  }
}
