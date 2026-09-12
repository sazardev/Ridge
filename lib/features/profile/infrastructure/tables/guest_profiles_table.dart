import 'package:drift/drift.dart';

/// Drift table for the on-device Guest Profile (SPEC.md §7.1). Modeled as
/// a normal table keyed by [id] even though exactly one row is expected
/// in practice — single-row-ness is enforced by application logic (see
/// `ProfileRepositoryImpl`), not a DB constraint.
@DataClassName('GuestProfileRow')
class GuestProfiles extends Table {
  /// The `ProfileId` value, stored as plain text.
  TextColumn get id => text()();

  /// The user-chosen display name.
  TextColumn get username => text()();

  /// When this profile was created, on this device.
  DateTimeColumn get createdAt => dateTime()();

  /// The user's self-reported favorite programming languages, as a
  /// comma-joined list of `FavoriteLanguage.name`s (see
  /// `ProfileMapper`'s CSV helpers), or `null`/empty if none are set.
  TextColumn get favoriteLanguages => text().nullable()();

  /// The user's self-reported keyboard layout (`KeyboardLayout.name`), or
  /// `null` if never set.
  TextColumn get keyboardLayout => text().nullable()();

  /// The user's self-reported keyboard brand, free text, or `null` if
  /// never set.
  TextColumn get keyboardBrand => text().nullable()();

  /// The user's self-reported keyboard model, free text, or `null` if
  /// never set.
  TextColumn get keyboardModel => text().nullable()();

  /// The user's favorite quote/phrase, free text, or `null` if never set.
  TextColumn get favoriteQuote => text().nullable()();

  /// The user's favorite programmer/tech influence, free text, or `null`
  /// if never set.
  TextColumn get favoriteProgrammer => text().nullable()();

  /// The user's GitHub handle, without the leading `@` or any URL prefix
  /// (normalized before storage by
  /// `UpdateProfileCustomizationUseCase`), or `null` if never set.
  TextColumn get githubUsername => text().nullable()();

  /// The user's personal website URL, always with an `http(s)://` scheme
  /// (normalized before storage by
  /// `UpdateProfileCustomizationUseCase`), or `null` if never set.
  TextColumn get websiteUrl => text().nullable()();

  /// Auto-detected platform name (e.g. `"Android"`, `"Linux"`), or `null`
  /// if never detected. Never user-edited — see `EnsureDeviceInfoUseCase`.
  TextColumn get platform => text().nullable()();

  /// Auto-detected OS version string (e.g. `"Android 14"`,
  /// `"Ubuntu 24.04.1 LTS"`), or `null` if never detected or unavailable.
  TextColumn get operatingSystemVersion => text().nullable()();

  /// Auto-detected hardware model (e.g. `"Google Pixel 8"`), or `null`
  /// when never detected or the platform doesn't expose one (Linux,
  /// Windows, Web).
  TextColumn get deviceModel => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
