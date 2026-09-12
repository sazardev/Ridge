/// The thematic construct a Snippet exercises (SPEC.md §3.1).
///
/// One concise line per value on purpose: `tool/check_architecture.dart`
/// hard-fails any hand-written file over 500 lines, and this enum is the
/// file that grows with every new language.
enum ContentCategory {
  /// Variable declarations, constants, and basic types.
  variablesAndTypes,

  /// `if`/`else`/`switch` branching.
  conditionals,

  /// `for` loops, including range-based iteration.
  loops,

  /// Function declarations, parameters, and return values.
  functions,

  /// Struct declarations and field tags.
  structs,

  /// Interface declarations and implementations.
  interfaces,

  /// Slices and maps: literals, indexing, iteration.
  slicesAndMaps,

  /// Idiomatic error handling and propagation.
  errorHandling,

  /// Pointers: address-of/dereference and pointer receivers.
  pointers,

  /// Goroutines and channels; Dart reuses it for isolates.
  concurrency,

  /// Generic type parameters and constraints.
  generics,

  /// Go 1.27 features: generic methods, promoted struct keys, new stdlib.
  modernGo,

  /// Idiomatic `gofmt` formatting conventions.
  idiomaticFormatting,

  /// Shell: commands, `echo`/`printf`, script arguments.
  shellCommands,

  /// Shell: pipes, redirection, heredocs, process substitution.
  pipesAndRedirection,

  /// Shell: filtering text with `grep`, `sort`, `cut`, `sed`.
  textProcessing,

  /// Arch: `pacman`, AUR helpers, systemd, journalctl.
  systemAdministration,

  /// `SELECT` over literals, aliases, arithmetic, `||`.
  sqlBasics,

  /// `psql` setup, `CREATE TABLE`/constraints, seed data.
  sqlSchema,

  /// `SELECT` from tables, projection, `DISTINCT`, `ORDER BY`.
  sqlQueries,

  /// `WHERE`, comparisons, `AND`/`OR`, `IN`, `LIKE`, `IS NULL`.
  sqlFiltering,

  /// `COUNT`/`SUM`/`AVG`/`MIN`/`MAX`, `GROUP BY`, `HAVING`.
  sqlAggregation,

  /// `INNER`/`LEFT JOIN`, aliases, multi-table joins.
  sqlJoins,

  /// `INSERT`, `UPDATE`, `DELETE`, `RETURNING`.
  sqlModifications,

  /// Subqueries, `EXISTS`, CTEs, `UNION`, `CASE`.
  sqlAdvancedQueries,

  /// Shell: `find`, `fd`, ripgrep, the `locate` index.
  searchAndIndexing,

  /// Shell: extended regex with `grep -E`, `sed -E`, `rg`.
  regularExpressions,

  /// Shell: file CRUD, metadata, `chmod`, `tar`.
  fileOperations,

  /// SSH client: connect, keys, `~/.ssh/config`, `scp`.
  sshClient,

  /// SSH server: permissions, `authorized_keys`, `sshd`.
  sshServer,

  /// Shell startup files: `~/.bashrc`, `PATH`, aliases.
  shellProfiles,

  /// DDD entities, value objects, domain errors.
  /// Architecture-layer category: held to a looser completeness bar.
  domainModeling,

  /// Application-core interfaces implemented by adapters.
  /// Architecture-layer category: held to a looser completeness bar.
  hexagonalPorts,

  /// Use cases orchestrating domain + ports, and their fake-port tests.
  /// Architecture-layer category: held to a looser completeness bar.
  applicationUseCases,

  /// Repository-port adapters (in-memory, file-backed).
  /// Architecture-layer category: held to a looser completeness bar.
  persistenceAdapters,

  /// REST/HTTP DTOs, handlers, routing, error-to-status mapping.
  /// Architecture-layer category: held to a looser completeness bar.
  restAdapters,

  /// Hand-written test doubles and the tests using them.
  /// Architecture-layer category: held to a looser completeness bar.
  testingWithFakes,

  /// Linear and binary search.
  /// Topic category: snippets carry a real difficulty.
  searchingAlgorithms,

  /// Bubble, selection, insertion, merge, quick, and heap sort.
  /// Topic category: snippets carry a real difficulty.
  sortingAlgorithms,

  /// Adjacency-list graphs, BFS, DFS, Dijkstra.
  /// Topic category: snippets carry a real difficulty.
  graphAlgorithms,

  /// Bubble Tea's `Model`/`Init`/`Update`/`View` loop.
  /// Architecture-layer category: held to a looser completeness bar.
  tuiArchitecture,

  /// Lip Gloss styles, colors, borders, padding.
  /// Architecture-layer category: held to a looser completeness bar.
  tuiStyling,

  /// Bubbles widgets inside a Bubble Tea model.
  /// Architecture-layer category: held to a looser completeness bar.
  tuiComponents,

  /// TUI commands calling use cases; the composition root.
  /// Architecture-layer category: held to a looser completeness bar.
  tuiAdapter,

  /// Go handlers, `ServeMux`, middleware, server lifecycle.
  /// Topic category: snippets carry a real difficulty.
  httpServers,

  /// HTTP requests with context/timeouts, transport, retries.
  /// Topic category: snippets carry a real difficulty.
  httpClients,

  /// Testing handlers and servers with `net/http/httptest`.
  /// Topic category: snippets carry a real difficulty.
  httpTesting,

  /// `database/sql` pools, DDL/DML, transactions, SQLite.
  /// Topic category: snippets carry a real difficulty.
  sqlPersistence,

  /// Classes: typed fields, constructors, access modifiers.
  classesAndObjects,

  /// Exports/imports, including type-only exports.
  modules,

  /// C arrays, NUL-terminated strings, `<string.h>`.
  arraysAndStrings,

  /// `malloc`/`calloc`/`realloc`/`free`, ownership, raw memory.
  memoryManagement,

  /// `#define` macros, `#include`, header guards, conditional builds.
  preprocessor,

  /// `fopen`/`fclose`, `fprintf`/`fputs`, `fgets` until EOF.
  fileIO,

  /// C++ function/class templates and concept constraints.
  templates,

  /// `std::vector`/`map`/`set`, iterators, `std::optional`.
  stlContainers,

  /// Crystal `yield`, block forms, `&` procs.
  blocksAndProcs,

  /// Crystal/C#/Kotlin arrays, maps, and iteration.
  collections,

  /// Crystal/C# nullable types, `try(&.x)`, `?.`, `??`.
  nilSafety,

  /// Selectors, combinators, specificity, `:is()`, `@layer`.
  cssSelectors,

  /// `display`, sizing, padding, margin, border, `box-sizing`.
  cssBoxModel,

  /// Colors, gradients, font stacks, text styles.
  cssColorsAndTypography,

  /// Flexbox and grid: alignment, placement, named areas.
  cssLayout,

  /// `position`, offsets, `inset`, `z-index`, `overflow`.
  cssPositioning,

  /// `--name` variables, `var()` fallbacks, overrides, `calc()`.
  cssCustomProperties,

  /// Units, media queries, breakpoints, `clamp()` fluid type.
  cssResponsive,

  /// Transitions, transforms, `@keyframes`, reduced motion.
  cssTransitionsAndAnimations,

  /// C# `is` patterns and `switch` expressions.
  patternMatching,

  /// C# delegates, lambdas, `event` subscription.
  delegatesAndEvents,

  /// LINQ `Where`/`Select`/`OrderBy` and query syntax.
  linq,

  /// `async`/`await`, `Task`, `Future`, `Stream`, `Task.WhenAll`.
  asyncProgramming,

  /// Swift optionals: `nil`, `if let`, `guard let`, `??`.
  optionals,

  /// Swift closures: trailing syntax, `$0`, capturing, `@escaping`.
  closures,

  /// Swift enums, associated values, `switch`, `indirect`.
  enumsAndPatternMatching,

  /// Swift `Codable`, `CodingKeys`, JSON round-trips.
  codable,

  /// Swift `@propertyWrapper` and `wrappedValue`.
  propertyWrappers,

  /// Kotlin/Dart `String?`, `?.`, `?:`, `!!`, `late`, flow promotion.
  nullSafety,

  /// Kotlin `data class` and destructuring declarations.
  dataClasses,

  /// Kotlin lambdas, `it`, higher-order functions, scope functions.
  lambdas,

  /// Kotlin extension functions and properties.
  extensions,

  /// Kotlin `suspend`, `launch`, `async`, `flow`, dispatchers.
  coroutines,

  /// Django scaffolding: `startproject`, `startapp`, `INSTALLED_APPS`.
  djangoProject,

  /// Django models: fields, `Meta`, model methods.
  djangoModels,

  /// Django views, `HttpResponse`, `path()` routing, `include()`.
  djangoViews,

  /// Django templates, `{% for %}`, `{% extends %}`, contexts.
  djangoTemplates,

  /// Django `Form`/`ModelForm`, validation, POST with CSRF.
  djangoForms,

  /// Django admin registration and `ModelAdmin` options.
  djangoAdmin,

  /// Django `TestCase`, `setUpTestData`, request assertions.
  djangoTesting,

  /// `ForeignKey`, reverse accessors, M2M, cascade behavior.
  djangoRelationships,

  /// QuerySets, lookups, `Q`/`F`, aggregation, custom managers.
  djangoOrm,

  /// Migration anatomy, `RunPython`, management commands.
  djangoMigrations,

  /// Installing DRF and the first `@api_view` endpoint.
  djangoRestSetup,

  /// DRF serializers, validation, nested fields.
  djangoSerializers,

  /// DRF views, viewsets, routers, custom actions.
  djangoRestViews,

  /// DRF token auth, permissions, per-user querysets.
  djangoRestAuth,

  /// DRF pagination, search, and ordering.
  djangoRestFiltering,

  /// `APITestCase`/`APIClient` end-to-end CRUD tests.
  djangoRestTesting,

  /// Dart records, destructuring, sealed-class pattern matching.
  recordsAndPatterns,

  /// PHP tags, `echo`, variables, scalar types, `??`.
  phpBasics,

  /// PHP string interpolation, heredoc/nowdoc, string functions.
  phpStrings,

  /// PHP `if`/`elseif`/`else`, ternary, `match`.
  phpConditionals,

  /// PHP `for`, `while`, `break`, `continue`.
  phpLoops,

  /// PHP indexed/associative arrays, `array_*`, `foreach`.
  phpArrays,

  /// PHP typed functions, arrow functions, closures with `use`.
  phpFunctions,

  /// PHP classes, constructor promotion, interfaces, traits.
  phpClasses,

  /// PHP enum cases and `from`/`tryFrom`.
  phpEnums,

  /// PHP `throw`, `try`/`catch`/`finally`, custom exceptions.
  phpErrorHandling,

  /// PHP namespaces, `use`, autoload boundaries.
  phpNamespaces,

  /// PHP `$_GET`, `$_POST`, `$_SERVER` while handling a request.
  phpSuperglobals,

  /// Form validation, escaping, `filter_var`, password hashing.
  phpForms,

  /// `session_start`, `$_SESSION`, cookies.
  phpSessions,

  /// PDO connections, prepared statements, transactions.
  phpDatabase,

  /// `json_encode`/`json_decode` and JSON responses.
  phpJson,

  /// Server-side file reads, writes, and `unlink`.
  phpFiles,

  /// Linear and binary search in PHP.
  phpSearching,

  /// PHP bubble, selection, insertion, merge, quick, and heap sort.
  phpSorting,

  /// PHP weighted adjacency list, BFS, DFS, Dijkstra.
  phpGraphs,

  /// Git repo setup, staging, `.gitignore`, diffs, file surgery.
  /// Introduced by the `git-foundations-v1` Learning Route.
  gitBasics,

  /// Committing: messages, history reading, amending the last commit.
  /// Introduced by the `git-foundations-v1` Learning Route.
  gitCommits,

  /// Branch create/switch/delete, fast-forward and merge commits,
  /// conflict resolution. Introduced by `git-foundations-v1`.
  gitBranching,

  /// Clone, remote setup, fetch, pull, push, tracking branches.
  /// Introduced by the `git-foundations-v1` Learning Route.
  gitRemotes,

  /// Log formats, pickaxe, blame, and `git bisect`.
  /// Introduced by the `git-workflows-v1` Learning Route.
  gitHistory,

  /// `restore`, the three `reset` modes, `revert`, `clean`, `stash`.
  /// Introduced by the `git-workflows-v1` Learning Route.
  gitUndo,

  /// Rebase, force-with-lease, cherry-pick, autosquash, tags, hooks.
  /// Introduced by the `git-workflows-v1` Learning Route.
  gitCollaboration,

  /// Blobs, trees, commits, and `cat-file`/`hash-object`/`ls-tree`.
  /// Introduced by the `git-internals-v1` Learning Route.
  gitObjects,

  /// `HEAD`, detached state, `show-ref`, `update-ref`, reflog.
  /// Introduced by the `git-internals-v1` Learning Route.
  gitRefs,

  /// Index internals, object counts, `git gc`, linked worktrees.
  /// Introduced by the `git-internals-v1` Learning Route.
  gitMaintenance,

  /// Distro identity, kernel, hostname, help, environment variables.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  linuxBasics,

  /// Paths, navigation, file CRUD, symlinks, viewing files.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  linuxFiles,

  /// Mode bits, `chmod`/`chown`/`umask`, sticky/setgid, ACLs.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  permissions,

  /// Accounts, groups, `sudo`, password locks.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  usersAndGroups,

  /// Listing, signals, and scheduling priority.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  processes,

  /// `pacman` queries, installs, removals, file ownership.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  packages,

  /// `systemctl` units: status, lifecycle, enablement.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  services,

  /// `journalctl` filtering and disk usage.
  /// Introduced by the `linux-foundations-v1` Learning Route.
  logs,

  /// Block devices, disk space, directory usage.
  /// Introduced by the `linux-admin-v1` Learning Route.
  storage,

  /// Interfaces, routes, DNS, sockets, HTTP, firewalls.
  /// Introduced by the `linux-networking-v1` Learning Route.
  networking,

  /// `systemd-analyze calendar`, timers, transient units.
  /// Introduced by the `linux-admin-v1` Learning Route.
  scheduling,

  /// `tar` create/list/extract and compression.
  /// Introduced by the `linux-admin-v1` Learning Route.
  backupAndArchives,

  /// Docker CLI basics: images vs containers, run, ps, info.
  dockerBasics,

  /// Building, tagging, pulling, and inspecting images.
  dockerImages,

  /// Dockerfile instructions: FROM, RUN, COPY, CMD, ENV.
  dockerFiles,

  /// Container lifecycle, logs, exec, inspect, and cleanup.
  dockerContainers,

  /// Named volumes and bind mounts for persistent data.
  dockerVolumes,

  /// Port publishing and user-defined networks with DNS.
  dockerNetworking,

  /// Pushing and pulling registries, digests, and login.
  dockerRegistries,

  /// compose.yaml: services, networks, volumes, healthchecks.
  dockerCompose,

  /// Disk usage, stats, top, and diff for debugging.
  dockerMaintenance,
}
