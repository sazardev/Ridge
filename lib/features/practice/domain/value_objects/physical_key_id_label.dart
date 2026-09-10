import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/practice/domain/value_objects/physical_key_id.dart';

/// Localized display label for a [PhysicalKeyId], shared by every widget
/// that renders one raw physical key (SPEC.md §4.1's key-transition
/// diagnostic) so the mapping lives in exactly one place — mirrors
/// `content`'s `ContentCategoryLabel`/`progression`'s `TrendPresentation`.
/// Printable keys (letters, digits, symbols) show the character a US-QWERTY
/// layout prints unshifted; non-printable keys use a localized name.
extension PhysicalKeyIdLabel on PhysicalKeyId {
  /// Returns this key's localized display label.
  String displayLabel(AppLocalizations l10n) => switch (this) {
    PhysicalKeyId.keyA => 'A',
    PhysicalKeyId.keyB => 'B',
    PhysicalKeyId.keyC => 'C',
    PhysicalKeyId.keyD => 'D',
    PhysicalKeyId.keyE => 'E',
    PhysicalKeyId.keyF => 'F',
    PhysicalKeyId.keyG => 'G',
    PhysicalKeyId.keyH => 'H',
    PhysicalKeyId.keyI => 'I',
    PhysicalKeyId.keyJ => 'J',
    PhysicalKeyId.keyK => 'K',
    PhysicalKeyId.keyL => 'L',
    PhysicalKeyId.keyM => 'M',
    PhysicalKeyId.keyN => 'N',
    PhysicalKeyId.keyO => 'O',
    PhysicalKeyId.keyP => 'P',
    PhysicalKeyId.keyQ => 'Q',
    PhysicalKeyId.keyR => 'R',
    PhysicalKeyId.keyS => 'S',
    PhysicalKeyId.keyT => 'T',
    PhysicalKeyId.keyU => 'U',
    PhysicalKeyId.keyV => 'V',
    PhysicalKeyId.keyW => 'W',
    PhysicalKeyId.keyX => 'X',
    PhysicalKeyId.keyY => 'Y',
    PhysicalKeyId.keyZ => 'Z',
    PhysicalKeyId.digit0 => '0',
    PhysicalKeyId.digit1 => '1',
    PhysicalKeyId.digit2 => '2',
    PhysicalKeyId.digit3 => '3',
    PhysicalKeyId.digit4 => '4',
    PhysicalKeyId.digit5 => '5',
    PhysicalKeyId.digit6 => '6',
    PhysicalKeyId.digit7 => '7',
    PhysicalKeyId.digit8 => '8',
    PhysicalKeyId.digit9 => '9',
    PhysicalKeyId.minus => '-',
    PhysicalKeyId.equal => '=',
    PhysicalKeyId.bracketLeft => '[',
    PhysicalKeyId.bracketRight => ']',
    PhysicalKeyId.backslash => r'\',
    PhysicalKeyId.semicolon => ';',
    PhysicalKeyId.quote => "'",
    PhysicalKeyId.backquote => '`',
    PhysicalKeyId.comma => ',',
    PhysicalKeyId.period => '.',
    PhysicalKeyId.slash => '/',
    PhysicalKeyId.space => l10n.progressKeySpace,
    PhysicalKeyId.backspace => l10n.progressKeyBackspace,
    PhysicalKeyId.delete => l10n.progressKeyDelete,
    PhysicalKeyId.arrowLeft => l10n.progressKeyArrowLeft,
    PhysicalKeyId.arrowRight => l10n.progressKeyArrowRight,
    PhysicalKeyId.shiftLeft => l10n.progressKeyShiftLeft,
    PhysicalKeyId.shiftRight => l10n.progressKeyShiftRight,
    PhysicalKeyId.tab => l10n.progressKeyTab,
    PhysicalKeyId.enter => l10n.progressKeyEnter,
  };
}
