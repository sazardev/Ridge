import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/core/widgets/escape_to_pop.dart';
import 'package:ridge/core/widgets/keyboard_scroll_shortcuts.dart';
import 'package:ridge/core/widgets/staggered_entrance.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_customization.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_key_spec.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_layout.dart';
import 'package:ridge/features/profile/domain/entities/keyboard_shape_family.dart';
import 'package:ridge/features/profile/presentation/providers/profile_providers.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard/keyboard_visual.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_customize_key_editing.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_customize_preview.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_editor_sections.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_per_key_section.dart';
import 'package:ridge/features/profile/presentation/widgets/keyboard_editor/keyboard_section_nav.dart';

/// The dedicated keyboard editor (`/profile/keyboard/customize`): a big,
/// live, interactive 3D preview pinned on top — tapping a key opens its
/// per-key editor — over a scrollable form with every piece of keyboard
/// metadata the app collects: brand/model/layout, form factor, keycap
/// shape and colors, RGB, switches/materials, story notes, extra keys and
/// functional remaps. Saving writes the whole keyboard setup through
/// `updateKeyboardSetup`, disjoint from the profile-flair form.
class KeyboardCustomizeScreen extends ConsumerStatefulWidget {
  /// Creates the editor pre-filled with [profile]'s current keyboard setup.
  const new({required this.profile, super.key});

  /// The profile whose keyboard is being edited.
  final GuestProfile profile;

  @override
  ConsumerState<KeyboardCustomizeScreen> createState() =>
      _KeyboardCustomizeScreenState();
}

class _KeyboardCustomizeScreenState
    extends ConsumerState<KeyboardCustomizeScreen>
    with KeyboardCustomizeKeyEditing<KeyboardCustomizeScreen> {
  late KeyboardLayout? _layout = widget.profile.keyboardLayout;
  late String _brand = widget.profile.keyboardBrand ?? '';
  late String _model = widget.profile.keyboardModel ?? '';
  late KeyboardCustomization _customization =
      widget.profile.keyboardCustomization ?? KeyboardCustomization.empty;
  late final TextEditingController _notesController = TextEditingController(
    text: widget.profile.keyboardCustomization?.notes ?? '',
  );

  bool _submitting = false;
  String? _errorText;
  final _scrollController = ScrollController();

  @override
  KeyboardCustomization get customization => _customization;

  @override
  set customization(KeyboardCustomization value) => _customization = value;

  @override
  List<KeyboardKeySpec> get baseKeys => _baseKeys;

  /// The base (pre-customization) keys of the last build — the callbacks
  /// that open the per-key sheets run outside build, where `ref.watch`
  /// isn't available, and need the same base list the preview painted.
  /// `null` means the model/family resolved to nothing at all.
  List<KeyboardKeySpec>? _resolvedKeys;
  List<KeyboardKeySpec> _baseKeys = const [];

  /// One key per controls section, so the quick-nav chips can scroll the
  /// list straight to them.
  final GlobalKey _brandModelKey = GlobalKey();
  final GlobalKey _shapeKey = GlobalKey();
  final GlobalKey _keycapsKey = GlobalKey();
  final GlobalKey _lightingKey = GlobalKey();
  final GlobalKey _hardwareKey = GlobalKey();
  final GlobalKey _storyKey = GlobalKey();
  final GlobalKey _perKeyKey = GlobalKey();

  String? get _modelOrNull => _model.isEmpty ? null : _model;

  /// Clears the whole keyboard — brand, model, layout and every
  /// customization — back to "nothing set" (still unsaved until Save).
  void _resetAll() {
    setState(() {
      _layout = null;
      _brand = '';
      _model = '';
      _customization = KeyboardCustomization.empty;
      _notesController.clear();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _update(KeyboardCustomization Function(KeyboardCustomization) update) {
    setState(() => _customization = update(_customization));
  }

  /// Opens the fullscreen inspector over the *live* editor state — the
  /// same profile with the unsaved brand/model/layout/customization, so
  /// the big view shows exactly what the preview does.
  void _openViewer() {
    final notes = _notesController.text.trim();
    final profile = widget.profile.copyWith(
      keyboardBrand: _brand.isEmpty ? null : _brand,
      keyboardModel: _model.isEmpty ? null : _model,
      keyboardLayout: _layout,
      keyboardCustomization: _customization.copyWith(
        notes: notes.isEmpty ? null : notes,
      ),
    );
    unawaited(context.push('/profile/keyboard', extra: profile));
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    final notes = _notesController.text.trim();
    final customization = _customization.copyWith(
      notes: notes.isEmpty ? null : notes,
    );
    final result = await ref
        .read(activeProfileControllerProvider.notifier)
        .updateKeyboardSetup(
          keyboardLayout: _layout,
          keyboardBrand: _brand,
          keyboardModel: _model,
          keyboardCustomization: customization == KeyboardCustomization.empty
              ? null
              : customization,
        );
    if (!mounted) return;
    if (result.isOk) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _submitting = false;
      _errorText = l10n.profileCustomizationInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    _resolvedKeys = resolveKeyboardKeySpecs(ref, _modelOrNull, _customization);
    _baseKeys = _resolvedKeys ?? const [];
    final canRender =
        _resolvedKeys != null &&
        (_resolvedKeys!.isNotEmpty || _customization.extraKeys.isNotEmpty);
    final emptyHint = _customization.shapeFamily == KeyboardShapeFamily.custom
        ? l10n.keyboardCustomizeCustomBoardHint
        : l10n.keyboardCustomizeEmptyPreview;

    return EscapeToPop(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.keyboardCustomizeTitle),
          actions: [
            IconButton(
              onPressed: _resetAll,
              tooltip: l10n.keyboardCustomizeResetAction,
              icon: const Icon(LucideIcons.rotateCcw),
            ),
            IconButton(
              onPressed: _submitting ? null : _submit,
              tooltip: l10n.profileSave,
              icon: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.check300),
            ),
          ],
        ),
        body: KeyboardScrollShortcuts(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: KeyboardCustomizePreview(
                  model: _modelOrNull,
                  customization: _customization,
                  canRender: canRender,
                  emptyHint: emptyHint,
                  onKeyTap: editKey,
                  onExpand: _openViewer,
                ),
              ),
              KeyboardSectionNav(
                entries: [
                  (
                    label: l10n.keyboardCustomizeBrandSectionTitle,
                    icon: LucideIcons.keyboard,
                    sectionKey: _brandModelKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeShapeSectionTitle,
                    icon: LucideIcons.layoutGrid,
                    sectionKey: _shapeKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeKeycapsSectionTitle,
                    icon: LucideIcons.shapes,
                    sectionKey: _keycapsKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeLightingSectionTitle,
                    icon: LucideIcons.lightbulb,
                    sectionKey: _lightingKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeHardwareSectionTitle,
                    icon: LucideIcons.cpu,
                    sectionKey: _hardwareKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeStorySectionTitle,
                    icon: LucideIcons.bookOpen,
                    sectionKey: _storyKey,
                  ),
                  (
                    label: l10n.keyboardCustomizeKeysSectionTitle,
                    icon: LucideIcons.slidersHorizontal,
                    sectionKey: _perKeyKey,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    if (_errorText != null) ...[
                      Text(
                        _errorText!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    KeyboardBrandModelSection(
                      key: _brandModelKey,
                      brand: _brand,
                      model: _model,
                      layout: _layout,
                      onBrandChanged: (value) => setState(() => _brand = value),
                      onModelChanged: (value) => setState(() => _model = value),
                      onLayoutChanged: (value) =>
                          setState(() => _layout = value),
                    ).staggeredIn(context, 0),
                    const SizedBox(height: 16),
                    KeyboardShapeSection(
                      key: _shapeKey,
                      shapeFamily: _customization.shapeFamily,
                      onShapeFamilyChanged: (value) =>
                          _update((c) => c.copyWith(shapeFamily: value)),
                    ).staggeredIn(context, 1),
                    const SizedBox(height: 16),
                    KeyboardKeycapsSection(
                      key: _keycapsKey,
                      shape: _customization.keycapShape,
                      transparency: _customization.keycapTransparency,
                      keycapColor: _customization.keycapColor,
                      caseColor: _customization.caseColor,
                      onShapeChanged: (value) =>
                          _update((c) => c.copyWith(keycapShape: value)),
                      onTransparencyChanged: (value) =>
                          _update((c) => c.copyWith(keycapTransparency: value)),
                      onKeycapColorChanged: (value) =>
                          _update((c) => c.copyWith(keycapColor: value)),
                      onCaseColorChanged: (value) =>
                          _update((c) => c.copyWith(caseColor: value)),
                    ),
                    const SizedBox(height: 16),
                    KeyboardLightingSection(
                      key: _lightingKey,
                      enabled: _customization.rgbEnabled,
                      effect: _customization.rgbEffect,
                      color: _customization.rgbColor,
                      onEnabledChanged: (value) =>
                          _update((c) => c.copyWith(rgbEnabled: value)),
                      onEffectChanged: (value) =>
                          _update((c) => c.copyWith(rgbEffect: value)),
                      onColorChanged: (value) =>
                          _update((c) => c.copyWith(rgbColor: value)),
                    ),
                    const SizedBox(height: 16),
                    KeyboardHardwareSection(
                      key: _hardwareKey,
                      switchType: _customization.switchType,
                      keycapMaterial: _customization.keycapMaterial,
                      caseMaterial: _customization.caseMaterial,
                      physicalLayout: _customization.physicalLayout,
                      connection: _customization.connection,
                      hotSwappable: _customization.hotSwappable,
                      onSwitchTypeChanged: (value) =>
                          _update((c) => c.copyWith(switchType: value)),
                      onKeycapMaterialChanged: (value) =>
                          _update((c) => c.copyWith(keycapMaterial: value)),
                      onCaseMaterialChanged: (value) =>
                          _update((c) => c.copyWith(caseMaterial: value)),
                      onPhysicalLayoutChanged: (value) =>
                          _update((c) => c.copyWith(physicalLayout: value)),
                      onConnectionChanged: (value) =>
                          _update((c) => c.copyWith(connection: value)),
                      onHotSwappableChanged: (value) =>
                          _update((c) => c.copyWith(hotSwappable: value)),
                    ),
                    const SizedBox(height: 16),
                    KeyboardStorySection(
                      key: _storyKey,
                      purchaseYear: _customization.purchaseYear,
                      notesController: _notesController,
                      onPurchaseYearChanged: (value) =>
                          _update((c) => c.copyWith(purchaseYear: value)),
                    ),
                    const SizedBox(height: 16),
                    KeyboardPerKeySection(
                      key: _perKeyKey,
                      customization: _customization,
                      onRemoveOverride: (keyId) => _update(
                        (c) => c.copyWith(
                          keyOverrides: [
                            for (final o in c.keyOverrides)
                              if (o.keyId != keyId) o,
                          ],
                        ),
                      ),
                      onAddExtraKey: addExtraKey,
                      onEditExtra: editExtra,
                      onRemoveExtra: (id) => _update(
                        (c) => c.copyWith(
                          extraKeys: [
                            for (final e in c.extraKeys)
                              if (e.id != id) e,
                          ],
                        ),
                      ),
                      onAddRemap: () => editRemap(null),
                      onEditRemap: editRemap,
                      onRemoveRemap: (physicalKey) => _update(
                        (c) => c.copyWith(
                          remaps: [
                            for (final r in c.remaps)
                              if (r.physicalKey != physicalKey) r,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
