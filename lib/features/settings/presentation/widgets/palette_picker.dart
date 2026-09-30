import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/theme/app_motion.dart';
import 'package:ridge/core/theme/app_palette_catalog.dart';
import 'package:ridge/core/theme/app_shapes.dart';
import 'package:ridge/core/widgets/bouncy_tap.dart';
import 'package:ridge/features/settings/domain/entities/app_palette.dart';

/// A flowing, responsive gallery of live-rendered palette previews for
/// picking the app's global [AppPaletteId] — one continuous [Wrap] with no
/// artificial solid-vs-themed split, since each tile already renders its
/// own real background and accent colors and speaks for itself.
class PalettePicker extends StatelessWidget {
  /// Creates the picker.
  const new({
    required this.selected,
    required this.expressive,
    required this.onSelected,
    super.key,
  });

  /// The currently active palette.
  final AppPaletteId selected;

  /// Whether the expressive M3 color variant is on, so previews match what
  /// picking a palette would actually produce.
  final bool expressive;

  /// Called with the newly tapped palette's id.
  final ValueChanged<AppPaletteId> onSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final definition in AppPaletteCatalog.all)
            _PaletteTile(
              definition: definition,
              brightness: brightness,
              expressive: expressive,
              selected: definition.id == selected,
              onTap: () => onSelected(definition.id),
            ),
        ],
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const new({
    required this.definition,
    required this.brightness,
    required this.expressive,
    required this.selected,
    required this.onTap,
  });

  final AppPaletteDefinition definition;
  final Brightness brightness;
  final bool expressive;
  final bool selected;
  final VoidCallback onTap;

  static const _width = 104.0;
  static const _height = 78.0;

  String _label(AppLocalizations l10n) => switch (definition.id) {
    AppPaletteId.ember => l10n.paletteEmber,
    AppPaletteId.ocean => l10n.paletteOcean,
    AppPaletteId.forest => l10n.paletteForest,
    AppPaletteId.grape => l10n.paletteGrape,
    AppPaletteId.rose => l10n.paletteRose,
    AppPaletteId.sunflower => l10n.paletteSunflower,
    AppPaletteId.teal => l10n.paletteTeal,
    AppPaletteId.crimson => l10n.paletteCrimson,
    AppPaletteId.mono => l10n.paletteMono,
    AppPaletteId.nord => l10n.paletteNord,
    AppPaletteId.gruvbox => l10n.paletteGruvbox,
    AppPaletteId.dracula => l10n.paletteDracula,
    AppPaletteId.solarized => l10n.paletteSolarized,
    AppPaletteId.catppuccin => l10n.paletteCatppuccin,
    AppPaletteId.tokyoNight => l10n.paletteTokyoNight,
    AppPaletteId.terminal => l10n.paletteTerminal,
    AppPaletteId.matrix => l10n.paletteMatrix,
    AppPaletteId.fallout => l10n.paletteFallout,
    AppPaletteId.blackWhite => l10n.paletteBlackWhite,
    AppPaletteId.monokai => l10n.paletteMonokai,
    AppPaletteId.oneDark => l10n.paletteOneDark,
    AppPaletteId.cyberpunk => l10n.paletteCyberpunk,
    AppPaletteId.synthwave => l10n.paletteSynthwave,
    AppPaletteId.github => l10n.paletteGithub,
    AppPaletteId.vscode => l10n.paletteVscode,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activePrimary = Theme.of(context).colorScheme.primary;
    final preview = definition.buildScheme(
      brightness: brightness,
      expressive: expressive,
    );
    final label = _label(l10n);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: BouncyTap(
        enabled: true,
        child: AnimatedScale(
          scale: selected ? 1.06 : 1,
          duration: AppMotion.spatialDefault,
          curve: AppMotion.bouncy,
          child: Material(
            color: preview.surface,
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.circular(AppShapes.of(context).medium),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                width: _width,
                height: _height,
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _Dot(preview.primary),
                            const SizedBox(width: 4),
                            _Dot(preview.secondary),
                            const SizedBox(width: 4),
                            _Dot(preview.tertiary),
                          ],
                        ),
                        AnimatedScale(
                          duration: AppMotion.spatialDefault,
                          curve: AppMotion.bouncy,
                          scale: selected ? 1 : 0,
                          child: Icon(
                            LucideIcons.circleCheck300,
                            size: 16,
                            color: activePrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: preview.onSurface,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const new(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
