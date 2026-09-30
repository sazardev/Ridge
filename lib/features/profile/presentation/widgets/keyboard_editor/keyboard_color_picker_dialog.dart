import 'package:flutter/material.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';

/// The custom-color dialog: three HSV sliders over a live preview. Returns
/// the picked ARGB value, or `null` when cancelled.
Future<int?> showKeyboardColorPickerDialog(
  BuildContext context, {
  required Color initial,
}) {
  return showDialog<int>(
    animationStyle: AppMotion.dialog,
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
