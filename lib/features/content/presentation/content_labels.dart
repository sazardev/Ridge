import 'package:flutter/widgets.dart' show BuildContext, Localizations;

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/features/content/domain/entities/content_category.dart';
import 'package:just_in_time/features/content/domain/entities/difficulty.dart';
import 'package:just_in_time/features/content/domain/entities/programming_language.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';

/// Localized display label for a [ProgrammingLanguage], shared by every
/// widget that renders one (the language selector, snippet metadata) so
/// the mapping lives in exactly one place — the same reason a future
/// second language is just a new `switch` arm here, not a redesign.
extension ProgrammingLanguageLabel on ProgrammingLanguage {
  /// Returns this language's localized display name.
  String label(AppLocalizations l10n) => switch (this) {
    ProgrammingLanguage.go => l10n.languageGo,
    ProgrammingLanguage.bash => l10n.languageBash,
    ProgrammingLanguage.sql => l10n.languageSql,
  };
}

/// Localized display label for a [Difficulty], shared by every widget
/// that renders one so the mapping lives in exactly one place.
extension DifficultyLabel on Difficulty {
  /// Returns this difficulty's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    Difficulty.beginner => l10n.difficultyBeginner,
    Difficulty.intermediate => l10n.difficultyIntermediate,
    Difficulty.advanced => l10n.difficultyAdvanced,
    Difficulty.expert => l10n.difficultyExpert,
  };
}

/// Localized display label for a [ContentCategory], shared by every
/// widget that renders one so the mapping lives in exactly one place.
extension ContentCategoryLabel on ContentCategory {
  /// Returns this category's localized display label.
  String label(AppLocalizations l10n) => switch (this) {
    ContentCategory.variablesAndTypes => l10n.categoryVariablesAndTypes,
    ContentCategory.conditionals => l10n.categoryConditionals,
    ContentCategory.loops => l10n.categoryLoops,
    ContentCategory.functions => l10n.categoryFunctions,
    ContentCategory.structs => l10n.categoryStructs,
    ContentCategory.interfaces => l10n.categoryInterfaces,
    ContentCategory.slicesAndMaps => l10n.categorySlicesAndMaps,
    ContentCategory.errorHandling => l10n.categoryErrorHandling,
    ContentCategory.pointers => l10n.categoryPointers,
    ContentCategory.concurrency => l10n.categoryConcurrency,
    ContentCategory.generics => l10n.categoryGenerics,
    ContentCategory.idiomaticFormatting => l10n.categoryIdiomaticFormatting,
    ContentCategory.shellCommands => l10n.categoryShellCommands,
    ContentCategory.pipesAndRedirection => l10n.categoryPipesAndRedirection,
    ContentCategory.textProcessing => l10n.categoryTextProcessing,
    ContentCategory.systemAdministration => l10n.categorySystemAdministration,
    ContentCategory.sqlBasics => l10n.categorySqlBasics,
    ContentCategory.sqlSchema => l10n.categorySqlSchema,
    ContentCategory.sqlQueries => l10n.categorySqlQueries,
    ContentCategory.sqlFiltering => l10n.categorySqlFiltering,
    ContentCategory.sqlAggregation => l10n.categorySqlAggregation,
    ContentCategory.sqlJoins => l10n.categorySqlJoins,
    ContentCategory.sqlModifications => l10n.categorySqlModifications,
    ContentCategory.sqlAdvancedQueries => l10n.categorySqlAdvancedQueries,
    ContentCategory.domainModeling => l10n.categoryDomainModeling,
    ContentCategory.hexagonalPorts => l10n.categoryHexagonalPorts,
    ContentCategory.applicationUseCases => l10n.categoryApplicationUseCases,
    ContentCategory.persistenceAdapters => l10n.categoryPersistenceAdapters,
    ContentCategory.restAdapters => l10n.categoryRestAdapters,
    ContentCategory.testingWithFakes => l10n.categoryTestingWithFakes,
  };
}

/// Locale-resolved access to a [Snippet]'s bilingual title and "what did
/// you just type?" explanation (unlike the enum labels above, these are
/// free-form per-snippet prose, so they live directly on the entity/
/// content JSON rather than in the ARB catalog — an ARB key per snippet
/// wouldn't scale. `sourceAttribution` is the one snippet field that
/// deliberately stays off this pattern: it's internal metadata never
/// shown in any screen, so it isn't worth translating.)
extension SnippetTitleLabel on Snippet {
  /// Returns [Snippet.titleEs] under a Spanish app locale, else
  /// [Snippet.titleEn].
  String titleFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? titleEs : titleEn;
}

/// Locale-resolved access to a [Snippet]'s bilingual "what did you just
/// type?" explanation.
extension SnippetExplanationLabel on Snippet {
  /// Returns [Snippet.explanationEs] under a Spanish app locale, else
  /// [Snippet.explanationEn].
  String explanationFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es'
      ? explanationEs
      : explanationEn;
}

/// Locale-resolved access to a [Snippet]'s ultra-short tl;dr — shown
/// above [SnippetExplanationLabel.explanationFor]'s fuller text, never
/// as a replacement for it.
extension SnippetTldrLabel on Snippet {
  /// Returns [Snippet.tldrEs] under a Spanish app locale, else
  /// [Snippet.tldrEn].
  String tldrFor(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? tldrEs : tldrEn;
}
