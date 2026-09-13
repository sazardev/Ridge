import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization_options.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';
import 'package:ridge/features/profile/presentation/profile_suggestions.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_editor_fields.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_effect_grid.dart';
import 'package:ridge/features/profile/presentation/widgets/suggestion_field.dart';

/// Brand/model + character-layout section of the keyboard editor.
class KeyboardBrandModelSection extends StatelessWidget {
  /// Creates the section over the given current values.
  const new({
    required this.brand,
    required this.model,
    required this.layout,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.onLayoutChanged,
    super.key,
  });

  /// Current free-text brand.
  final String brand;

  /// Current free-text model.
  final String model;

  /// Current character layout.
  final KeyboardLayout? layout;

  /// Brand change callback.
  final ValueChanged<String> onBrandChanged;

  /// Model change callback.
  final ValueChanged<String> onModelChanged;

  /// Layout change callback.
  final ValueChanged<KeyboardLayout?> onLayoutChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeBrandSectionTitle,
      icon: LucideIcons.keyboard,
      children: [
        SuggestionField(
          label: l10n.profileKeyboardBrandLabel,
          icon: LucideIcons.keyboard300,
          initialValue: brand,
          suggestions: kKeyboardBrandSuggestions,
          onChanged: onBrandChanged,
        ),
        const SizedBox(height: 16),
        SuggestionField(
          label: l10n.profileKeyboardModelLabel,
          icon: LucideIcons.memoryStick300,
          initialValue: model,
          suggestions: kKeyboardModelSuggestions,
          preferredPrefix: brand,
          onChanged: onModelChanged,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profileKeyboardLayoutLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        KeyboardChoiceChips<KeyboardLayout>(
          values: KeyboardLayout.values,
          selected: layout,
          labelOf: (value) => value.label(l10n),
          onSelected: onLayoutChanged,
        ),
      ],
    );
  }
}

/// Form-factor override section — picks the generic silhouette the board
/// is drawn with when the model has no curated layout (or the user wants a
/// different one).
class KeyboardShapeSection extends StatelessWidget {
  /// Creates the section.
  const new({
    required this.shapeFamily,
    required this.onShapeFamilyChanged,
    super.key,
  });

  /// Current family override, or `null` for "whatever the model resolves
  /// to".
  final KeyboardShapeFamily? shapeFamily;

  /// Family change callback.
  final ValueChanged<KeyboardShapeFamily?> onShapeFamilyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeShapeSectionTitle,
      icon: LucideIcons.layoutGrid,
      children: [
        KeyboardChoiceChips<KeyboardShapeFamily>(
          values: KeyboardShapeFamily.values,
          selected: shapeFamily,
          labelOf: (value) => value.label(l10n),
          onSelected: onShapeFamilyChanged,
        ),
        const SizedBox(height: 8),
        Text(
          shapeFamily == null
              ? l10n.keyboardCustomizeFormFactorAuto
              : l10n.keyboardCustomizeFormFactorOverrideHint,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Keycap silhouette + custom keycap/case colors.
class KeyboardKeycapsSection extends StatelessWidget {
  /// Creates the section.
  const new({
    required this.shape,
    required this.transparency,
    required this.keycapColor,
    required this.caseColor,
    required this.onShapeChanged,
    required this.onTransparencyChanged,
    required this.onKeycapColorChanged,
    required this.onCaseColorChanged,
    super.key,
  });

  /// Current keycap shape.
  final KeycapShape shape;

  /// Current keycap light transmission.
  final KeycapTransparency transparency;

  /// Current custom keycap color (ARGB), or `null`.
  final int? keycapColor;

  /// Current custom case color (ARGB), or `null`.
  final int? caseColor;

  /// Shape change callback.
  final ValueChanged<KeycapShape> onShapeChanged;

  /// Transparency change callback.
  final ValueChanged<KeycapTransparency> onTransparencyChanged;

  /// Keycap color change callback.
  final ValueChanged<int?> onKeycapColorChanged;

  /// Case color change callback.
  final ValueChanged<int?> onCaseColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeKeycapsSectionTitle,
      icon: LucideIcons.shapes,
      children: [
        Text(
          l10n.keyboardCustomizeKeycapShapeLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        KeyboardChoiceChips<KeycapShape>(
          values: KeycapShape.values,
          selected: shape,
          labelOf: (value) => value.label(l10n),
          onSelected: (value) {
            if (value != null) onShapeChanged(value);
          },
          allowDeselect: false,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.keyboardCustomizeKeycapTransparencyLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        KeyboardChoiceChips<KeycapTransparency>(
          values: KeycapTransparency.values,
          selected: transparency,
          labelOf: (value) => value.label(l10n),
          iconOf: iconForKeycapTransparency,
          onSelected: (value) {
            if (value != null) onTransparencyChanged(value);
          },
          allowDeselect: false,
        ),
        const SizedBox(height: 16),
        KeyboardColorField(
          label: l10n.keyboardCustomizeKeycapColorLabel,
          value: keycapColor,
          onChanged: onKeycapColorChanged,
        ),
        const SizedBox(height: 16),
        KeyboardColorField(
          label: l10n.keyboardCustomizeCaseColorLabel,
          value: caseColor,
          onChanged: onCaseColorChanged,
        ),
      ],
    );
  }
}

/// RGB backlight section — on/off, color and effect.
class KeyboardLightingSection extends StatelessWidget {
  /// Creates the section.
  const new({
    required this.enabled,
    required this.effect,
    required this.color,
    required this.onEnabledChanged,
    required this.onEffectChanged,
    required this.onColorChanged,
    super.key,
  });

  /// Whether RGB is on.
  final bool enabled;

  /// The current effect.
  final RgbEffect effect;

  /// The current light color (ARGB), or `null` for the theme primary.
  final int? color;

  /// Toggle callback.
  final ValueChanged<bool> onEnabledChanged;

  /// Effect change callback.
  final ValueChanged<RgbEffect> onEffectChanged;

  /// Color change callback.
  final ValueChanged<int?> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeLightingSectionTitle,
      icon: LucideIcons.lightbulb,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.keyboardCustomizeRgbToggleLabel),
          value: enabled,
          onChanged: onEnabledChanged,
        ),
        if (enabled) ...[
          const SizedBox(height: 8),
          KeyboardColorField(
            label: l10n.keyboardCustomizeRgbColorLabel,
            value: color,
            onChanged: onColorChanged,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.keyboardCustomizeRgbEffectLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          KeyboardEffectGrid(selected: effect, onSelected: onEffectChanged),
        ],
      ],
    );
  }
}

/// Switches/materials/physical-layout/connection metadata section.
class KeyboardHardwareSection extends StatelessWidget {
  /// Creates the section.
  const new({
    required this.switchType,
    required this.keycapMaterial,
    required this.caseMaterial,
    required this.physicalLayout,
    required this.connection,
    required this.hotSwappable,
    required this.onSwitchTypeChanged,
    required this.onKeycapMaterialChanged,
    required this.onCaseMaterialChanged,
    required this.onPhysicalLayoutChanged,
    required this.onConnectionChanged,
    required this.onHotSwappableChanged,
    super.key,
  });

  /// Current switch type, or `null`.
  final SwitchType? switchType;

  /// Current keycap material, or `null`.
  final KeycapMaterial? keycapMaterial;

  /// Current case material, or `null`.
  final CaseMaterial? caseMaterial;

  /// Current physical layout, or `null`.
  final KeyboardPhysicalLayout? physicalLayout;

  /// Current connection type, or `null`.
  final KeyboardConnectionType? connection;

  /// Current hot-swap state, or `null` when unknown.
  final bool? hotSwappable;

  /// Switch type change callback.
  final ValueChanged<SwitchType?> onSwitchTypeChanged;

  /// Keycap material change callback.
  final ValueChanged<KeycapMaterial?> onKeycapMaterialChanged;

  /// Case material change callback.
  final ValueChanged<CaseMaterial?> onCaseMaterialChanged;

  /// Physical layout change callback.
  final ValueChanged<KeyboardPhysicalLayout?> onPhysicalLayoutChanged;

  /// Connection change callback.
  final ValueChanged<KeyboardConnectionType?> onConnectionChanged;

  /// Hot-swap change callback.
  final ValueChanged<bool> onHotSwappableChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeHardwareSectionTitle,
      icon: LucideIcons.cpu,
      children: [
        KeyboardOptionDropdown<SwitchType>(
          label: l10n.keyboardCustomizeSwitchTypeLabel,
          values: SwitchType.values,
          value: switchType,
          labelOf: (value) => value.label(l10n),
          onChanged: onSwitchTypeChanged,
        ),
        const SizedBox(height: 16),
        KeyboardOptionDropdown<KeycapMaterial>(
          label: l10n.keyboardCustomizeKeycapMaterialLabel,
          values: KeycapMaterial.values,
          value: keycapMaterial,
          labelOf: (value) => value.label(l10n),
          onChanged: onKeycapMaterialChanged,
        ),
        const SizedBox(height: 16),
        KeyboardOptionDropdown<CaseMaterial>(
          label: l10n.keyboardCustomizeCaseMaterialLabel,
          values: CaseMaterial.values,
          value: caseMaterial,
          labelOf: (value) => value.label(l10n),
          onChanged: onCaseMaterialChanged,
        ),
        const SizedBox(height: 16),
        KeyboardOptionDropdown<KeyboardPhysicalLayout>(
          label: l10n.keyboardCustomizePhysicalLayoutLabel,
          values: KeyboardPhysicalLayout.values,
          value: physicalLayout,
          labelOf: (value) => value.label(l10n),
          onChanged: onPhysicalLayoutChanged,
        ),
        const SizedBox(height: 16),
        KeyboardOptionDropdown<KeyboardConnectionType>(
          label: l10n.keyboardCustomizeConnectionLabel,
          values: KeyboardConnectionType.values,
          value: connection,
          labelOf: (value) => value.label(l10n),
          onChanged: onConnectionChanged,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.keyboardCustomizeHotSwappableLabel),
          value: hotSwappable ?? false,
          onChanged: onHotSwappableChanged,
        ),
      ],
    );
  }
}

/// The "story" section — purchase year and free-form notes.
class KeyboardStorySection extends StatelessWidget {
  /// Creates the section over its current values.
  const new({
    required this.purchaseYear,
    required this.notesController,
    required this.onPurchaseYearChanged,
    super.key,
  });

  /// Current purchase year, or `null`.
  final int? purchaseYear;

  /// Controller for the notes field (owned by the screen so Save can read
  /// it).
  final TextEditingController notesController;

  /// Purchase year change callback.
  final ValueChanged<int?> onPurchaseYearChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentYear = DateTime.now().year + 1;
    return KeyboardEditorSection(
      title: l10n.keyboardCustomizeStorySectionTitle,
      icon: LucideIcons.bookOpen,
      children: [
        KeyboardOptionDropdown<int>(
          label: l10n.keyboardCustomizePurchaseYearLabel,
          values: [for (var year = currentYear; year >= 1950; year--) year],
          value: purchaseYear,
          labelOf: (value) => '$value',
          onChanged: onPurchaseYearChanged,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: notesController,
          maxLines: 3,
          maxLength: 500,
          decoration: InputDecoration(
            labelText: l10n.keyboardCustomizeNotesLabel,
            hintText: l10n.keyboardCustomizeNotesHint,
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
