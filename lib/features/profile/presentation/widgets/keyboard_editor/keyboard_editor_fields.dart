import 'package:flutter/material.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_shapes.dart';

/// Curated swatch colors for the keyboard editor's keycap/case/light
/// pickers — classic mechanical-keyboard colorways (white, beige, gray,
/// black, then the loud accent colors), stored as ARGB for the domain.
const kKeyboardColorPresets = <Color>[
  Color(0xFFF5F5F5),
  Color(0xFFE6DFD3),
  Color(0xFF9E9E9E),
  Color(0xFF424242),
  Color(0xFF1B1B1B),
  Color(0xFFB71C1C),
  Color(0xFFE65100),
  Color(0xFFF9A825),
  Color(0xFF2E7D32),
  Color(0xFF00838F),
  Color(0xFF1565C0),
  Color(0xFF4527A0),
  Color(0xFFAD1457),
];

/// A titled card grouping controls in the keyboard editor — the editor's
/// visual unit, so the form reads as a keyboard configurator rather than a
/// wall of fields.
class KeyboardEditorSection extends StatelessWidget {
  /// Creates a section with [title], a leading [icon] and its [children].
  const new({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
  });

  /// The section's localized heading.
  final String title;

  /// A representative icon shown beside the heading.
  final IconData icon;

  /// The section's controls.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: AppShapes.of(context).largeShape,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: textTheme.titleMedium)),
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// A single-select row of choice chips over [values]; [selected] may be
/// `null` ("not set") and tapping the selected chip deselects it when
/// [allowDeselect] is true.
class KeyboardChoiceChips<T> extends StatelessWidget {
  /// Creates the chip row.
  const new({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.iconOf,
    this.allowDeselect = true,
    super.key,
  });

  /// Every selectable value.
  final List<T> values;

  /// The currently selected value, if any.
  final T? selected;

  /// Localized label for a value.
  final String Function(T) labelOf;

  /// Optional leading icon for a value's chip.
  final IconData Function(T)? iconOf;

  /// Called with the new selection (`null` when deselected).
  final ValueChanged<T?> onSelected;

  /// Whether tapping the selected chip clears the selection.
  final bool allowDeselect;

  @override
  Widget build(BuildContext context) {
    final iconOf = this.iconOf;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          ChoiceChip(
            avatar: iconOf == null ? null : Icon(iconOf(value), size: 16),
            label: Text(labelOf(value)),
            selected: selected == value,
            onSelected: (isSelected) {
              if (!isSelected && !allowDeselect) return;
              onSelected(isSelected ? value : null);
            },
          ),
      ],
    );
  }
}

/// A labeled dropdown over [values] with an explicit "not set" entry —
/// the nullable state is part of the data, so every field can be cleared
/// back to "unknown" without a hidden gesture.
class KeyboardOptionDropdown<T> extends StatelessWidget {
  /// Creates the dropdown.
  const new({
    required this.label,
    required this.values,
    required this.value,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  /// The field label.
  final String label;

  /// Every selectable value.
  final List<T> values;

  /// The current value, or `null` for "not set".
  final T? value;

  /// Localized label for a value.
  final String Function(T) labelOf;

  /// Called with the new value.
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T?>(
          isExpanded: true,
          value: value,
          hint: Text(
            l10n.keyboardCustomizeNotSetLabel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          items: [
            for (final option in values)
              DropdownMenuItem(value: option, child: Text(labelOf(option))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// A labeled row of color swatches ([kKeyboardColorPresets]) plus a
/// custom-color picker and a "default" (unset) chip.
class KeyboardColorField extends StatelessWidget {
  /// Creates the color field.
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The field label.
  final String label;

  /// The current ARGB value, or `null` for "use the theme default".
  final int? value;

  /// Called with the new ARGB value (`null` clears it).
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DefaultSwatch(
              selected: value == null,
              onTap: () => onChanged(null),
            ),
            for (final preset in kKeyboardColorPresets)
              _ColorSwatch(
                color: preset,
                selected: value == preset.toARGB32(),
                onTap: () => onChanged(preset.toARGB32()),
              ),
            _CustomSwatch(
              color: value == null ? null : Color(value!),
              selected:
                  value != null &&
                  !kKeyboardColorPresets.any(
                    (preset) => preset.toARGB32() == value,
                  ),
              onTap: () async {
                final picked = await showKeyboardColorPickerDialog(
                  context,
                  initial: value == null ? colorScheme.primary : Color(value!),
                );
                if (picked != null) onChanged(picked);
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          l10n.keyboardCustomizeCustomColorLabel,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const new({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
        child: selected
            ? Icon(
                Icons.check,
                size: 18,
                color: color.computeLuminance() > 0.5
                    ? Colors.black87
                    : Colors.white,
              )
            : null,
      ),
    );
  }
}

class _DefaultSwatch extends StatelessWidget {
  const new({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: AppLocalizations.of(context).keyboardCustomizeColorDefaultLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
          child: Icon(
            Icons.format_color_reset,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _CustomSwatch extends StatelessWidget {
  const new({required this.color, required this.selected, required this.onTap});

  final Color? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color ?? colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
        child: Icon(
          Icons.colorize,
          size: 18,
          color:
              (color ?? colorScheme.surfaceContainerHighest)
                      .computeLuminance() >
                  0.5
              ? Colors.black87
              : Colors.white,
        ),
      ),
    );
  }
}

/// The custom-color dialog: three HSV sliders over a live preview. Returns
/// the picked ARGB value, or `null` when cancelled.
Future<int?> showKeyboardColorPickerDialog(
  BuildContext context, {
  required Color initial,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => _KeyboardColorPickerDialog(initial: initial),
  );
}

class _KeyboardColorPickerDialog extends StatefulWidget {
  const new({required this.initial});

  final Color initial;

  @override
  State<_KeyboardColorPickerDialog> createState() =>
      _KeyboardColorPickerDialogState();
}

class _KeyboardColorPickerDialogState
    extends State<_KeyboardColorPickerDialog> {
  late HSVColor _hsv = HSVColor.fromColor(widget.initial);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _hsv.toColor();

    return AlertDialog(
      title: Text(l10n.keyboardCustomizeCustomColorLabel),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            _ChannelSlider(
              label: 'H',
              value: _hsv.hue,
              max: 360,
              activeColor: color,
              onChanged: (value) => setState(() => _hsv = _hsv.withHue(value)),
            ),
            _ChannelSlider(
              label: 'S',
              value: _hsv.saturation,
              max: 1,
              activeColor: color,
              onChanged: (value) =>
                  setState(() => _hsv = _hsv.withSaturation(value)),
            ),
            _ChannelSlider(
              label: 'V',
              value: _hsv.value,
              max: 1,
              activeColor: color,
              onChanged: (value) =>
                  setState(() => _hsv = _hsv.withValue(value)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.keyboardCustomizeCancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(color.toARGB32()),
          child: Text(l10n.keyboardCustomizeApplyAction),
        ),
      ],
    );
  }
}

class _ChannelSlider extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.max,
    required this.activeColor,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double max;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(0, max),
            max: max,
            activeColor: activeColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
