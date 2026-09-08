import 'package:flutter/material.dart';

import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';

class NumericKeypad extends StatelessWidget {
  const new({required this.onDigit, required this.onBackspace, super.key});

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const _layout = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _layout)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final key in row)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _KeypadButton(
                      label: key,
                      onTap: switch (key) {
                        '' => null,
                        '⌫' => onBackspace,
                        final digit => () => onDigit(digit),
                      },
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _KeypadButton extends StatefulWidget {
  const new({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = widget.onTap != null;

    return AnimatedScale(
      scale: _pressed ? 0.9 : 1.0,
      duration: AppMotion.effectsFast,
      curve: AppMotion.spatial,
      child: Material(
        color: enabled ? colorScheme.surfaceContainerHigh : Colors.transparent,
        shape: AppShapes.full,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          child: SizedBox(
            width: 68,
            height: 68,
            child: Center(
              child: widget.label == '⌫'
                  ? Icon(
                      Icons.backspace_outlined,
                      color: colorScheme.onSurfaceVariant,
                    )
                  : Text(
                      widget.label,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: colorScheme.onSurface),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
