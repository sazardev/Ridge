import 'package:flutter/widgets.dart' show BuildContext, Localizations;

import 'package:ridge/core/i18n/gen/app_localizations.dart';
import 'package:ridge/features/content/domain/entities/content_category.dart';
import 'package:ridge/features/content/domain/entities/difficulty.dart';
import 'package:ridge/features/content/domain/entities/programming_language.dart';
import 'package:ridge/features/content/domain/entities/snippet.dart';

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
    ProgrammingLanguage.rust => l10n.languageRust,
    ProgrammingLanguage.zig => l10n.languageZig,
    ProgrammingLanguage.python => l10n.languagePython,
    ProgrammingLanguage.javascript => l10n.languageJavascript,
    ProgrammingLanguage.typescript => l10n.languageTypescript,
    ProgrammingLanguage.haskell => l10n.languageHaskell,
    ProgrammingLanguage.c => l10n.languageC,
    ProgrammingLanguage.cpp => l10n.languageCpp,
    ProgrammingLanguage.java => l10n.languageJava,
    ProgrammingLanguage.crystal => l10n.languageCrystal,
    ProgrammingLanguage.swift => l10n.languageSwift,
    ProgrammingLanguage.css => l10n.languageCss,
    ProgrammingLanguage.csharp => l10n.languageCsharp,
    ProgrammingLanguage.kotlin => l10n.languageKotlin,
    ProgrammingLanguage.dart => l10n.languageDart,
    ProgrammingLanguage.php => l10n.languagePhp,
    ProgrammingLanguage.git => l10n.languageGit,
    ProgrammingLanguage.linux => l10n.languageLinux,
    ProgrammingLanguage.docker => l10n.languageDocker,
    ProgrammingLanguage.githubActions => l10n.languageGithubActions,
  };
}

/// Localized one-line pitch for a [ProgrammingLanguage] — what it is
/// especially good for, shown under its name in the language catalog (and
/// its picker sheet) so a newcomer can tell the languages apart at a
/// glance. Deliberately one short sentence, never a paragraph.
extension ProgrammingLanguageBlurb on ProgrammingLanguage {
  /// Returns this language's short "why learn it" blurb.
  String blurb(AppLocalizations l10n) => switch (this) {
    ProgrammingLanguage.go => l10n.languageGoBlurb,
    ProgrammingLanguage.bash => l10n.languageBashBlurb,
    ProgrammingLanguage.sql => l10n.languageSqlBlurb,
    ProgrammingLanguage.rust => l10n.languageRustBlurb,
    ProgrammingLanguage.zig => l10n.languageZigBlurb,
    ProgrammingLanguage.python => l10n.languagePythonBlurb,
    ProgrammingLanguage.javascript => l10n.languageJavascriptBlurb,
    ProgrammingLanguage.typescript => l10n.languageTypescriptBlurb,
    ProgrammingLanguage.haskell => l10n.languageHaskellBlurb,
    ProgrammingLanguage.c => l10n.languageCBlurb,
    ProgrammingLanguage.cpp => l10n.languageCppBlurb,
    ProgrammingLanguage.java => l10n.languageJavaBlurb,
    ProgrammingLanguage.crystal => l10n.languageCrystalBlurb,
    ProgrammingLanguage.swift => l10n.languageSwiftBlurb,
    ProgrammingLanguage.css => l10n.languageCssBlurb,
    ProgrammingLanguage.csharp => l10n.languageCsharpBlurb,
    ProgrammingLanguage.kotlin => l10n.languageKotlinBlurb,
    ProgrammingLanguage.dart => l10n.languageDartBlurb,
    ProgrammingLanguage.php => l10n.languagePhpBlurb,
    ProgrammingLanguage.git => l10n.languageGitBlurb,
    ProgrammingLanguage.linux => l10n.languageLinuxBlurb,
    ProgrammingLanguage.docker => l10n.languageDockerBlurb,
    ProgrammingLanguage.githubActions => l10n.languageGithubActionsBlurb,
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
    ContentCategory.comptime => l10n.categoryComptime,
    ContentCategory.modernGo => l10n.categoryModernGo,
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
    ContentCategory.searchAndIndexing => l10n.categorySearchAndIndexing,
    ContentCategory.regularExpressions => l10n.categoryRegularExpressions,
    ContentCategory.fileOperations => l10n.categoryFileOperations,
    ContentCategory.sshClient => l10n.categorySshClient,
    ContentCategory.sshServer => l10n.categorySshServer,
    ContentCategory.shellProfiles => l10n.categoryShellProfiles,
    ContentCategory.searchingAlgorithms => l10n.categorySearchingAlgorithms,
    ContentCategory.sortingAlgorithms => l10n.categorySortingAlgorithms,
    ContentCategory.graphAlgorithms => l10n.categoryGraphAlgorithms,
    ContentCategory.domainModeling => l10n.categoryDomainModeling,
    ContentCategory.hexagonalPorts => l10n.categoryHexagonalPorts,
    ContentCategory.applicationUseCases => l10n.categoryApplicationUseCases,
    ContentCategory.persistenceAdapters => l10n.categoryPersistenceAdapters,
    ContentCategory.restAdapters => l10n.categoryRestAdapters,
    ContentCategory.testingWithFakes => l10n.categoryTestingWithFakes,
    ContentCategory.calculatorCore => l10n.categoryCalculatorCore,
    ContentCategory.wailsProjectSetup => l10n.categoryWailsProjectSetup,
    ContentCategory.wailsBindings => l10n.categoryWailsBindings,
    ContentCategory.wailsFrontend => l10n.categoryWailsFrontend,
    ContentCategory.wailsArchitecture => l10n.categoryWailsArchitecture,
    ContentCategory.wailsStyling => l10n.categoryWailsStyling,
    ContentCategory.wailsPackaging => l10n.categoryWailsPackaging,
    ContentCategory.wailsTesting => l10n.categoryWailsTesting,
    ContentCategory.tuiArchitecture => l10n.categoryTuiArchitecture,
    ContentCategory.tuiStyling => l10n.categoryTuiStyling,
    ContentCategory.tuiComponents => l10n.categoryTuiComponents,
    ContentCategory.tuiAdapter => l10n.categoryTuiAdapter,
    ContentCategory.httpServers => l10n.categoryHttpServers,
    ContentCategory.httpClients => l10n.categoryHttpClients,
    ContentCategory.httpTesting => l10n.categoryHttpTesting,
    ContentCategory.sqlPersistence => l10n.categorySqlPersistence,
    ContentCategory.classesAndObjects => l10n.categoryClassesAndObjects,
    ContentCategory.modules => l10n.categoryModules,
    ContentCategory.arraysAndStrings => l10n.categoryArraysAndStrings,
    ContentCategory.memoryManagement => l10n.categoryMemoryManagement,
    ContentCategory.preprocessor => l10n.categoryPreprocessor,
    ContentCategory.fileIO => l10n.categoryFileIO,
    ContentCategory.templates => l10n.categoryTemplates,
    ContentCategory.stlContainers => l10n.categoryStlContainers,
    ContentCategory.blocksAndProcs => l10n.categoryBlocksAndProcs,
    ContentCategory.collections => l10n.categoryCollections,
    ContentCategory.nilSafety => l10n.categoryNilSafety,
    ContentCategory.cssSelectors => l10n.categoryCssSelectors,
    ContentCategory.cssBoxModel => l10n.categoryCssBoxModel,
    ContentCategory.cssColorsAndTypography =>
      l10n.categoryCssColorsAndTypography,
    ContentCategory.cssLayout => l10n.categoryCssLayout,
    ContentCategory.cssPositioning => l10n.categoryCssPositioning,
    ContentCategory.cssCustomProperties => l10n.categoryCssCustomProperties,
    ContentCategory.cssResponsive => l10n.categoryCssResponsive,
    ContentCategory.cssTransitionsAndAnimations =>
      l10n.categoryCssTransitionsAndAnimations,
    ContentCategory.patternMatching => l10n.categoryPatternMatching,
    ContentCategory.delegatesAndEvents => l10n.categoryDelegatesAndEvents,
    ContentCategory.linq => l10n.categoryLinq,
    ContentCategory.asyncProgramming => l10n.categoryAsyncProgramming,
    ContentCategory.optionals => l10n.categoryOptionals,
    ContentCategory.closures => l10n.categoryClosures,
    ContentCategory.enumsAndPatternMatching =>
      l10n.categoryEnumsAndPatternMatching,
    ContentCategory.codable => l10n.categoryCodable,
    ContentCategory.propertyWrappers => l10n.categoryPropertyWrappers,
    ContentCategory.nullSafety => l10n.categoryNullSafety,
    ContentCategory.dataClasses => l10n.categoryDataClasses,
    ContentCategory.lambdas => l10n.categoryLambdas,
    ContentCategory.extensions => l10n.categoryExtensions,
    ContentCategory.coroutines => l10n.categoryCoroutines,
    ContentCategory.djangoProject => l10n.categoryDjangoProject,
    ContentCategory.djangoModels => l10n.categoryDjangoModels,
    ContentCategory.djangoViews => l10n.categoryDjangoViews,
    ContentCategory.djangoTemplates => l10n.categoryDjangoTemplates,
    ContentCategory.djangoForms => l10n.categoryDjangoForms,
    ContentCategory.djangoAdmin => l10n.categoryDjangoAdmin,
    ContentCategory.djangoTesting => l10n.categoryDjangoTesting,
    ContentCategory.djangoRelationships => l10n.categoryDjangoRelationships,
    ContentCategory.djangoOrm => l10n.categoryDjangoOrm,
    ContentCategory.djangoMigrations => l10n.categoryDjangoMigrations,
    ContentCategory.djangoRestSetup => l10n.categoryDjangoRestSetup,
    ContentCategory.djangoSerializers => l10n.categoryDjangoSerializers,
    ContentCategory.djangoRestViews => l10n.categoryDjangoRestViews,
    ContentCategory.djangoRestAuth => l10n.categoryDjangoRestAuth,
    ContentCategory.djangoRestFiltering => l10n.categoryDjangoRestFiltering,
    ContentCategory.djangoRestTesting => l10n.categoryDjangoRestTesting,
    ContentCategory.recordsAndPatterns => l10n.categoryRecordsAndPatterns,
    ContentCategory.phpBasics => l10n.categoryPhpBasics,
    ContentCategory.phpStrings => l10n.categoryPhpStrings,
    ContentCategory.phpConditionals => l10n.categoryPhpConditionals,
    ContentCategory.phpLoops => l10n.categoryPhpLoops,
    ContentCategory.phpArrays => l10n.categoryPhpArrays,
    ContentCategory.phpFunctions => l10n.categoryPhpFunctions,
    ContentCategory.phpClasses => l10n.categoryPhpClasses,
    ContentCategory.phpEnums => l10n.categoryPhpEnums,
    ContentCategory.phpErrorHandling => l10n.categoryPhpErrorHandling,
    ContentCategory.phpNamespaces => l10n.categoryPhpNamespaces,
    ContentCategory.phpSuperglobals => l10n.categoryPhpSuperglobals,
    ContentCategory.phpForms => l10n.categoryPhpForms,
    ContentCategory.phpSessions => l10n.categoryPhpSessions,
    ContentCategory.phpDatabase => l10n.categoryPhpDatabase,
    ContentCategory.phpJson => l10n.categoryPhpJson,
    ContentCategory.phpFiles => l10n.categoryPhpFiles,
    ContentCategory.phpSearching => l10n.categoryPhpSearching,
    ContentCategory.phpSorting => l10n.categoryPhpSorting,
    ContentCategory.phpGraphs => l10n.categoryPhpGraphs,
    ContentCategory.gitBasics => l10n.categoryGitBasics,
    ContentCategory.gitCommits => l10n.categoryGitCommits,
    ContentCategory.gitBranching => l10n.categoryGitBranching,
    ContentCategory.gitRemotes => l10n.categoryGitRemotes,
    ContentCategory.gitHistory => l10n.categoryGitHistory,
    ContentCategory.gitUndo => l10n.categoryGitUndo,
    ContentCategory.gitCollaboration => l10n.categoryGitCollaboration,
    ContentCategory.gitObjects => l10n.categoryGitObjects,
    ContentCategory.gitRefs => l10n.categoryGitRefs,
    ContentCategory.gitMaintenance => l10n.categoryGitMaintenance,
    ContentCategory.linuxBasics => l10n.categoryLinuxBasics,
    ContentCategory.linuxFiles => l10n.categoryLinuxFiles,
    ContentCategory.permissions => l10n.categoryPermissions,
    ContentCategory.usersAndGroups => l10n.categoryUsersAndGroups,
    ContentCategory.processes => l10n.categoryProcesses,
    ContentCategory.packages => l10n.categoryPackages,
    ContentCategory.services => l10n.categoryServices,
    ContentCategory.logs => l10n.categoryLogs,
    ContentCategory.storage => l10n.categoryStorage,
    ContentCategory.networking => l10n.categoryNetworking,
    ContentCategory.scheduling => l10n.categoryScheduling,
    ContentCategory.backupAndArchives => l10n.categoryBackupAndArchives,
    ContentCategory.dockerBasics => l10n.categoryDockerBasics,
    ContentCategory.dockerImages => l10n.categoryDockerImages,
    ContentCategory.dockerFiles => l10n.categoryDockerFiles,
    ContentCategory.dockerContainers => l10n.categoryDockerContainers,
    ContentCategory.dockerVolumes => l10n.categoryDockerVolumes,
    ContentCategory.dockerNetworking => l10n.categoryDockerNetworking,
    ContentCategory.dockerRegistries => l10n.categoryDockerRegistries,
    ContentCategory.dockerCompose => l10n.categoryDockerCompose,
    ContentCategory.dockerMaintenance => l10n.categoryDockerMaintenance,
    ContentCategory.workflowBasics => l10n.categoryWorkflowBasics,
    ContentCategory.workflowTriggers => l10n.categoryWorkflowTriggers,
    ContentCategory.jobsAndSteps => l10n.categoryJobsAndSteps,
    ContentCategory.expressionsAndContexts =>
      l10n.categoryExpressionsAndContexts,
    ContentCategory.runnersAndMatrix => l10n.categoryRunnersAndMatrix,
    ContentCategory.secretsAndVariables => l10n.categorySecretsAndVariables,
    ContentCategory.cachingAndArtifacts => l10n.categoryCachingAndArtifacts,
    ContentCategory.reusableAndComposite => l10n.categoryReusableAndComposite,
    ContentCategory.containersAndDocker => l10n.categoryContainersAndDocker,
    ContentCategory.pipelinePatterns => l10n.categoryPipelinePatterns,
    ContentCategory.securityHardening => l10n.categorySecurityHardening,
    ContentCategory.deploymentsAndReleases =>
      l10n.categoryDeploymentsAndReleases,
    ContentCategory.ciOperations => l10n.categoryCiOperations,
    ContentCategory.languageEvolution => l10n.categoryLanguageEvolution,
    ContentCategory.modernIdioms => l10n.categoryModernIdioms,
    ContentCategory.genericMethods => l10n.categoryGenericMethods,
    ContentCategory.iterators => l10n.categoryIterators,
    ContentCategory.jsonV2 => l10n.categoryJsonV2,
    ContentCategory.modernStdlib => l10n.categoryModernStdlib,
    ContentCategory.apiDesign => l10n.categoryApiDesign,
    ContentCategory.errorPatterns => l10n.categoryErrorPatterns,
    ContentCategory.concurrencyPatterns => l10n.categoryConcurrencyPatterns,
    ContentCategory.goroutineLeaks => l10n.categoryGoroutineLeaks,
    ContentCategory.advancedTesting => l10n.categoryAdvancedTesting,
    ContentCategory.testing => l10n.categoryTesting,
    ContentCategory.performanceProfiling => l10n.categoryPerformanceProfiling,
    ContentCategory.observability => l10n.categoryObservability,
    ContentCategory.goTooling => l10n.categoryGoTooling,
    ContentCategory.cliArithmetic => l10n.categoryCliArithmetic,
    ContentCategory.cliTextTools => l10n.categoryCliTextTools,
    ContentCategory.cliMenus => l10n.categoryCliMenus,
    ContentCategory.cliChallenges => l10n.categoryCliChallenges,
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
