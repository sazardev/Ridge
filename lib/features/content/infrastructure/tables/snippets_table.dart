import 'package:drift/drift.dart';

/// Drift table for the curated snippet catalog (SPEC.md §3), seeded from
/// the bundled JSON asset and then queried directly — the seed step is
/// what keeps this table in sync, not a per-call JSON re-parse.
@DataClassName('SnippetRow')
class Snippets extends Table {
  /// The stable, human-assigned `SnippetId` value.
  TextColumn get id => text()();

  /// Monotonically increasing revision of this entry's content.
  IntColumn get revision => integer()();

  /// `ProgrammingLanguage` enum name, stored as plain text.
  TextColumn get language => text()();

  /// `Difficulty` enum name, stored as plain text.
  TextColumn get difficulty => text()();

  /// `ContentCategory` enum name, stored as plain text.
  TextColumn get category => text()();

  /// Comma-separated `SymbolFocus` enum names, or `null` if this entry
  /// doesn't target any particular symbol.
  TextColumn get symbolFocus => text().nullable()();

  /// `SnippetLength` enum name, stored as plain text.
  TextColumn get length => text()();

  /// Human-readable title shown in the catalog browser (English).
  TextColumn get titleEn => text().withDefault(const Constant(''))();

  /// Spanish counterpart of [titleEn].
  TextColumn get titleEs => text().withDefault(const Constant(''))();

  /// The real Go source code to type.
  TextColumn get code => text()();

  /// Where this code came from (e.g. `stdlib: fmt`, `hand-authored`).
  TextColumn get sourceAttribution => text()();

  /// An ultra-short (a few words) English summary of the concept this
  /// snippet demonstrates — shown first, above [explanationEn], as a
  /// skimmable "tl;dr" before the fuller explanation.
  TextColumn get tldrEn => text().withDefault(const Constant(''))();

  /// Spanish counterpart of [tldrEn].
  TextColumn get tldrEs => text().withDefault(const Constant(''))();

  /// A short, plain-language explanation (English) of what this code
  /// does and which Go syntax/idiom it demonstrates — optional post-
  /// session learning support, never shown during capture itself.
  TextColumn get explanationEn => text().withDefault(const Constant(''))();

  /// Spanish counterpart of [explanationEn].
  TextColumn get explanationEs => text().withDefault(const Constant(''))();

  /// `code.length`, denormalized onto this row so future queries (e.g.
  /// sorting/filtering by length) never need to load the full `code`
  /// column just to compute a sort key.
  IntColumn get charCount => integer()();

  /// Whether this entry is part of the current catalog. A superseded
  /// revision is kept but marked inactive so historical sessions that
  /// reference it stay interpretable.
  BoolColumn get isActive => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
