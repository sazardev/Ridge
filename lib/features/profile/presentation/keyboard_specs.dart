import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/profile/domain/entities/guest_profile.dart';
import 'package:ridge/features/profile/presentation/keyboard_shape_lookup.dart';
import 'package:ridge/features/profile/presentation/profile_labels.dart';

/// Every set piece of keyboard metadata as localized label/value rows, in
/// display order — the shared source for the profile keyboard card's
/// summary line and the viewer's full spec sheet, so the two can never
/// disagree about what is shown. Fields the user never set are skipped,
/// never rendered as an empty row.
List<(String, String)> keyboardSpecRows(
  GuestProfile profile,
  AppLocalizations l10n,
) {
  final customization = profile.keyboardCustomization;
  final model = profile.keyboardModel;
  final family = customization?.shapeFamily ?? keyboardShapeFamilyFor(model);
  final rgbEnabled = customization?.rgbEnabled ?? false;

  return [
    if (profile.keyboardBrand?.isNotEmpty ?? false)
      (l10n.profileKeyboardBrandLabel, profile.keyboardBrand!),
    if (model?.isNotEmpty ?? false) (l10n.profileKeyboardModelLabel, model!),
    if (profile.keyboardLayout != null)
      (l10n.profileKeyboardLayoutLabel, profile.keyboardLayout!.label(l10n)),
    if (family != null)
      (l10n.keyboardCustomizeFormFactorLabel, family.label(l10n)),
    if (customization?.physicalLayout != null)
      (
        l10n.keyboardCustomizePhysicalLayoutLabel,
        customization!.physicalLayout!.label(l10n),
      ),
    if (customization?.switchType != null)
      (
        l10n.keyboardCustomizeSwitchTypeLabel,
        customization!.switchType!.label(l10n),
      ),
    if (customization?.keycapMaterial != null)
      (
        l10n.keyboardCustomizeKeycapMaterialLabel,
        customization!.keycapMaterial!.label(l10n),
      ),
    if (customization?.caseMaterial != null)
      (
        l10n.keyboardCustomizeCaseMaterialLabel,
        customization!.caseMaterial!.label(l10n),
      ),
    if (customization?.connection != null)
      (
        l10n.keyboardCustomizeConnectionLabel,
        customization!.connection!.label(l10n),
      ),
    if (customization?.hotSwappable case final hotSwap?)
      (
        l10n.keyboardCustomizeHotSwappableLabel,
        hotSwap ? l10n.keyboardSpecsYes : l10n.keyboardSpecsNo,
      ),
    if (rgbEnabled) ...[
      (
        l10n.keyboardCustomizeRgbEffectLabel,
        customization!.rgbEffect.label(l10n),
      ),
      (
        l10n.keyboardCustomizeKeycapTransparencyLabel,
        customization.keycapTransparency.label(l10n),
      ),
    ],
    if (customization?.purchaseYear case final year?)
      (l10n.keyboardSpecsPurchaseYearLabel, '$year'),
    if ((customization?.keyOverrides.length ?? 0) > 0)
      (
        l10n.keyboardSpecsCustomLegendsLabel,
        '${customization!.keyOverrides.length}',
      ),
    if ((customization?.extraKeys.length ?? 0) > 0)
      (l10n.keyboardSpecsExtraKeysLabel, '${customization!.extraKeys.length}'),
    if ((customization?.remaps.length ?? 0) > 0)
      (l10n.keyboardSpecsRemapsLabel, '${customization!.remaps.length}'),
    if ((customization?.keyLights.length ?? 0) > 0)
      (l10n.keyboardSpecsKeyLightsLabel, '${customization!.keyLights.length}'),
    if (customization?.notes case final notes?)
      (l10n.keyboardCustomizeNotesLabel, notes),
  ];
}

/// The values of the first [max] spec rows, joined for a compact summary
/// line (the profile keyboard card).
List<String> keyboardSpecSummary(
  GuestProfile profile,
  AppLocalizations l10n, {
  int max = 4,
}) =>
    [for (final (_, value) in keyboardSpecRows(profile, l10n)) value]
        .take(max)
        .toList();
