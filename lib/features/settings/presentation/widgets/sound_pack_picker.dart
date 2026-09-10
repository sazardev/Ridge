import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/settings/domain/entities/app_sound_pack.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A selectable list of [AppSoundPack]s for the keystroke sound effects
/// (see `KeystrokeSoundPlayer`), each row with a one-shot preview button
/// so the user can hear a pack's click before committing to it.
class SoundPackPicker extends StatefulWidget {
  /// Creates the picker.
  const new({required this.selected, required this.onSelected, super.key});

  /// The currently active sound pack.
  final AppSoundPack selected;

  /// Called with the newly picked pack's id.
  final ValueChanged<AppSoundPack> onSelected;

  @override
  State<SoundPackPicker> createState() => _SoundPackPickerState();
}

class _SoundPackPickerState extends State<SoundPackPicker> {
  final AudioPlayer _previewPlayer = AudioPlayer();

  @override
  void dispose() {
    unawaited(_previewPlayer.dispose());
    super.dispose();
  }

  Future<void> _preview(AppSoundPack pack) async {
    try {
      await _previewPlayer.stop();
      await _previewPlayer.play(
        AssetSource('sounds/${pack.name}/key_click.wav'),
      );
    } on Exception {
      // Best-effort, same reasoning as KeystrokeSoundPlayer's doc — a
      // missing audio backend must never surface as an error here.
    }
  }

  String _label(AppLocalizations l10n, AppSoundPack pack) => switch (pack) {
    AppSoundPack.mechanical => l10n.soundPackMechanical,
    AppSoundPack.soft => l10n.soundPackSoft,
    AppSoundPack.typewriter => l10n.soundPackTypewriter,
    AppSoundPack.arcade => l10n.soundPackArcade,
    AppSoundPack.pop => l10n.soundPackPop,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RadioGroup<AppSoundPack>(
      groupValue: widget.selected,
      onChanged: (pack) {
        if (pack != null) widget.onSelected(pack);
      },
      child: Column(
        children: [
          for (final pack in AppSoundPack.values) ...[
            if (pack != AppSoundPack.values.first)
              const Divider(height: 1, indent: 16, endIndent: 16),
            RadioListTile<AppSoundPack>(
              value: pack,
              title: Text(_label(l10n, pack)),
              secondary: IconButton(
                icon: const Icon(LucideIcons.circlePlay),
                tooltip: l10n.settingsSoundPreview,
                onPressed: () => _preview(pack),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
