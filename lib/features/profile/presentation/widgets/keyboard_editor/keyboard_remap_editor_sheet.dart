import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id.dart';
import 'package:ridge/features/practice/domain/value_objects/physical_key_id_label.dart';

/// The physical keys a functional remap can actually affect: the capture
/// engine handles Backspace/Delete/arrows/Shift/Tab/Enter as control
/// actions before ever resolving a character, so remapping those would
/// silently do nothing and is deliberately not offered.
const kRemappablePhysicalKeys = <PhysicalKeyId>[
  PhysicalKeyId.keyA,
  PhysicalKeyId.keyB,
  PhysicalKeyId.keyC,
  PhysicalKeyId.keyD,
  PhysicalKeyId.keyE,
  PhysicalKeyId.keyF,
  PhysicalKeyId.keyG,
  PhysicalKeyId.keyH,
  PhysicalKeyId.keyI,
  PhysicalKeyId.keyJ,
  PhysicalKeyId.keyK,
  PhysicalKeyId.keyL,
  PhysicalKeyId.keyM,
  PhysicalKeyId.keyN,
  PhysicalKeyId.keyO,
  PhysicalKeyId.keyP,
  PhysicalKeyId.keyQ,
  PhysicalKeyId.keyR,
  PhysicalKeyId.keyS,
  PhysicalKeyId.keyT,
  PhysicalKeyId.keyU,
  PhysicalKeyId.keyV,
  PhysicalKeyId.keyW,
  PhysicalKeyId.keyX,
  PhysicalKeyId.keyY,
  PhysicalKeyId.keyZ,
  PhysicalKeyId.digit0,
  PhysicalKeyId.digit1,
  PhysicalKeyId.digit2,
  PhysicalKeyId.digit3,
  PhysicalKeyId.digit4,
  PhysicalKeyId.digit5,
  PhysicalKeyId.digit6,
  PhysicalKeyId.digit7,
  PhysicalKeyId.digit8,
  PhysicalKeyId.digit9,
  PhysicalKeyId.minus,
  PhysicalKeyId.equal,
  PhysicalKeyId.bracketLeft,
  PhysicalKeyId.bracketRight,
  PhysicalKeyId.backslash,
  PhysicalKeyId.semicolon,
  PhysicalKeyId.quote,
  PhysicalKeyId.backquote,
  PhysicalKeyId.comma,
  PhysicalKeyId.period,
  PhysicalKeyId.slash,
  PhysicalKeyId.intlBackslash,
  PhysicalKeyId.space,
];

/// The user's verdict from the remap sheet: the new binding, or [removed]
/// when the remap should be deleted.
@immutable
class KeyboardRemapEdit {
  /// Creates the edit result.
  const new({
    required this.physicalKey,
    required this.character,
    this.shiftedCharacter,
    this.removed = false,
  });

  /// The physical key being rebound.
  final PhysicalKeyId physicalKey;

  /// The character it now types (unshifted / base).
  final String character;

  /// The character it types with Shift held, when set.
  final String? shiftedCharacter;

  /// Whether the caller should delete the remap.
  final bool removed;
}

/// Opens the modal editor for one functional remap. Returns `null` when
/// dismissed without applying.
Future<KeyboardRemapEdit?> showKeyboardRemapEditorSheet(
  BuildContext context, {
  PhysicalKeyId? initialPhysicalKey,
  String? initialCharacter,
  String? initialShiftedCharacter,
  bool isExisting = false,
}) {
  return showModalBottomSheet<KeyboardRemapEdit>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _KeyboardRemapEditorSheet(
      initialPhysicalKey: initialPhysicalKey,
      initialCharacter: initialCharacter,
      initialShiftedCharacter: initialShiftedCharacter,
      isExisting: isExisting,
    ),
  );
}

class _KeyboardRemapEditorSheet extends StatefulWidget {
  const new({
    required this.initialPhysicalKey,
    required this.initialCharacter,
    required this.initialShiftedCharacter,
    required this.isExisting,
  });

  final PhysicalKeyId? initialPhysicalKey;
  final String? initialCharacter;
  final String? initialShiftedCharacter;
  final bool isExisting;

  @override
  State<_KeyboardRemapEditorSheet> createState() =>
      _KeyboardRemapEditorSheetState();
}

class _KeyboardRemapEditorSheetState extends State<_KeyboardRemapEditorSheet> {
  late PhysicalKeyId? _physicalKey = widget.initialPhysicalKey;
  late final TextEditingController _characterController = TextEditingController(
    text: widget.initialCharacter ?? '',
  );
  late final TextEditingController _shiftedController = TextEditingController(
    text: widget.initialShiftedCharacter ?? '',
  );

  @override
  void dispose() {
    _characterController.dispose();
    _shiftedController.dispose();
    super.dispose();
  }

  String? _clean(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _apply() {
    final physicalKey = _physicalKey;
    final character = _clean(_characterController.text);
    if (physicalKey == null || character == null) return;
    Navigator.of(context).pop(
      KeyboardRemapEdit(
        physicalKey: physicalKey,
        character: character,
        shiftedCharacter: _clean(_shiftedController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final physicalKey = _physicalKey;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.keyboardCustomizeRemapLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.keyboardCustomizeRemapExplainer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.keyboardCustomizeRemapPhysicalKeyLabel,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PhysicalKeyId>(
                  isExpanded: true,
                  value: physicalKey,
                  items: [
                    for (final key in kRemappablePhysicalKeys)
                      DropdownMenuItem(
                        value: key,
                        child: Text(key.displayLabel(l10n)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _physicalKey = value),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _characterController,
              autofocus: true,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: l10n.keyboardCustomizeRemapCharacterLabel,
              ),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: _shiftedController,
              maxLength: 2,
              decoration: InputDecoration(
                labelText: l10n.keyboardCustomizeRemapShiftedLabel,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (widget.isExisting)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(
                      KeyboardRemapEdit(
                        physicalKey: physicalKey ?? PhysicalKeyId.space,
                        character: '',
                        removed: true,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l10n.keyboardCustomizeRemoveAction),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.keyboardCustomizeCancelAction),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed:
                      physicalKey != null &&
                          _clean(_characterController.text) != null
                      ? _apply
                      : null,
                  child: Text(l10n.keyboardCustomizeApplyAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
