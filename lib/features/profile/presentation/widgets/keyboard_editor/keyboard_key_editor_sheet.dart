import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_editor_fields.dart';

/// The user's verdict from the key editor sheet: new legends, an optional
/// per-key backlight color and, for extra keys, a new size — or [removed]
/// when the override/key should be deleted.
@immutable
class KeyboardKeyEdit {
  /// Creates the edit result.
  const new({
    this.label,
    this.label2,
    this.width = 1,
    this.height = 1,
    this.lightColor,
    this.removed = false,
  });

  /// The new primary legend, or `null` for "keep the default".
  final String? label;

  /// The new shifted legend, or `null` for "keep the default".
  final String? label2;

  /// The extra key's new width, in key-units.
  final double width;

  /// The extra key's new height, in key-units.
  final double height;

  /// The key's own backlight color (ARGB), or `null` for "use the
  /// board-wide light" — only meaningful while RGB is enabled.
  final int? lightColor;

  /// Whether the caller should delete the override (base keys) or the
  /// extra key itself.
  final bool removed;
}

/// Opens the modal editor for one keycap. Base keys get legend fields plus
/// a "reset" action (drops the per-key override); extra keys additionally
/// get width/height sliders and a remove action. When [rgbEnabled], the
/// sheet also offers a per-key backlight color. Returns `null` when the
/// sheet is dismissed without applying.
Future<KeyboardKeyEdit?> showKeyboardKeyEditorSheet(
  BuildContext context, {
  required String title,
  String? initialLabel,
  String? initialLabel2,
  double initialWidth = 1,
  double initialHeight = 1,
  int? initialLightColor,
  bool rgbEnabled = false,
  bool isExtra = false,
  bool isOverridden = false,
}) {
  return showModalBottomSheet<KeyboardKeyEdit>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _KeyboardKeyEditorSheet(
      title: title,
      initialLabel: initialLabel,
      initialLabel2: initialLabel2,
      initialWidth: initialWidth,
      initialHeight: initialHeight,
      initialLightColor: initialLightColor,
      rgbEnabled: rgbEnabled,
      isExtra: isExtra,
      isOverridden: isOverridden,
    ),
  );
}

class _KeyboardKeyEditorSheet extends StatefulWidget {
  const new({
    required this.title,
    required this.initialLabel,
    required this.initialLabel2,
    required this.initialWidth,
    required this.initialHeight,
    required this.initialLightColor,
    required this.rgbEnabled,
    required this.isExtra,
    required this.isOverridden,
  });

  final String title;
  final String? initialLabel;
  final String? initialLabel2;
  final double initialWidth;
  final double initialHeight;
  final int? initialLightColor;
  final bool rgbEnabled;
  final bool isExtra;
  final bool isOverridden;

  @override
  State<_KeyboardKeyEditorSheet> createState() =>
      _KeyboardKeyEditorSheetState();
}

class _KeyboardKeyEditorSheetState extends State<_KeyboardKeyEditorSheet> {
  late final TextEditingController _labelController = TextEditingController(
    text: widget.initialLabel ?? '',
  );
  late final TextEditingController _label2Controller = TextEditingController(
    text: widget.initialLabel2 ?? '',
  );
  late double _width = widget.initialWidth;
  late double _height = widget.initialHeight;
  late int? _lightColor = widget.initialLightColor;

  @override
  void dispose() {
    _labelController.dispose();
    _label2Controller.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.of(context).pop(
      KeyboardKeyEdit(
        label: _clean(_labelController.text),
        label2: _clean(_label2Controller.text),
        width: _width,
        height: _height,
        lightColor: _lightColor,
      ),
    );
  }

  void _remove() {
    Navigator.of(context).pop(const KeyboardKeyEdit(removed: true));
  }

  String? _clean(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

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
            Text(widget.title, style: textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _labelController,
              autofocus: !widget.isExtra,
              maxLength: 24,
              decoration: InputDecoration(
                labelText: l10n.keyboardCustomizeKeyLegendLabel,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _label2Controller,
              maxLength: 24,
              decoration: InputDecoration(
                labelText: l10n.keyboardCustomizeKeyLegendShiftLabel,
              ),
            ),
            if (widget.rgbEnabled) ...[
              const SizedBox(height: 8),
              KeyboardColorField(
                label: l10n.keyboardCustomizePerKeyLightLabel,
                value: _lightColor,
                onChanged: (value) => setState(() => _lightColor = value),
              ),
            ],
            if (widget.isExtra) ...[
              const SizedBox(height: 8),
              _SizeSlider(
                label: l10n.keyboardCustomizeExtraKeyWidthLabel,
                value: _width,
                onChanged: (value) => setState(() => _width = value),
              ),
              _SizeSlider(
                label: l10n.keyboardCustomizeExtraKeyHeightLabel,
                value: _height,
                onChanged: (value) => setState(() => _height = value),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.isOverridden || widget.isExtra)
                  TextButton.icon(
                    onPressed: _remove,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(
                      widget.isExtra
                          ? l10n.keyboardCustomizeRemoveAction
                          : l10n.keyboardCustomizeResetKeyAction,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.keyboardCustomizeCancelAction),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _apply,
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

class _SizeSlider extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: 1,
            max: 4,
            divisions: 12,
            label: '${value.toStringAsFixed(2)}u',
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 48,
          child: Text(
            '${value.toStringAsFixed(2)}u',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
