/// The thematic construct a Snippet exercises (SPEC.md §3.1).
///
/// One concise line per value on purpose, written as plain `//` comments and
/// packed with no blank separators: `dart format`'s tall style forces a blank
/// line around every `///`-documented enum constant, and
/// `tool/check_architecture.dart` hard-fails this hand-written file over 500
/// lines as every new language grows it.
//
// The category docs below are plain `//` comments rather than `///` on
// purpose: the tall formatter forces a blank line around every documented
// enum constant, which pushed this file to 532 lines (over the 500-line hard
// limit). Keeping them as plain comments preserves every doc while letting
// the formatter keep the values packed.
// ignore_for_file: public_member_api_docs
enum ContentCategory {
  /// Variable declarations, constants, and basic types.
  variablesAndTypes,
  // `if`/`else`/`switch` branching.
  conditionals,
  // `for` loops, including range-based iteration.
  loops,
  // Function declarations, parameters, and return values.
  functions,
  // Struct declarations and field tags.
  structs,
  // Interface declarations and implementations.
  interfaces,
  // Slices and maps: literals, indexing, iteration.
  slicesAndMaps,
  // Idiomatic error handling and propagation.
  errorHandling,
  // Pointers: address-of/dereference and pointer receivers.
  pointers,
  // Goroutines and channels; Dart reuses it for isolates.
  concurrency,
  // Generic type parameters and constraints.
  generics,
  // Zig `comptime` evaluation, `inline` loops, `@compileError`.
  comptime,
  // Go 1.27 features: generic methods, promoted struct keys, new stdlib.
  modernGo,
  // Idiomatic `gofmt` formatting conventions.
  idiomaticFormatting,
  // Shell: commands, `echo`/`printf`, script arguments.
  shellCommands,
  // Shell: pipes, redirection, heredocs, process substitution.
  pipesAndRedirection,
  // Shell: filtering text with `grep`, `sort`, `cut`, `sed`.
  textProcessing,
  // Arch: `pacman`, AUR helpers, systemd, journalctl.
  systemAdministration,
  // `SELECT` over literals, aliases, arithmetic, `||`.
  sqlBasics,
  // `psql` setup, `CREATE TABLE`/constraints, seed data.
  sqlSchema,
  // `SELECT` from tables, projection, `DISTINCT`, `ORDER BY`.
  sqlQueries,
  // `WHERE`, comparisons, `AND`/`OR`, `IN`, `LIKE`, `IS NULL`.
  sqlFiltering,
  // `COUNT`/`SUM`/`AVG`/`MIN`/`MAX`, `GROUP BY`, `HAVING`.
  sqlAggregation,
  // `INNER`/`LEFT JOIN`, aliases, multi-table joins.
  sqlJoins,
  // `INSERT`, `UPDATE`, `DELETE`, `RETURNING`.
  sqlModifications,
  // Subqueries, `EXISTS`, CTEs, `UNION`, `CASE`.
  sqlAdvancedQueries,
  // Shell: `find`, `fd`, ripgrep, the `locate` index.
  searchAndIndexing,
  // Shell: extended regex with `grep -E`, `sed -E`, `rg`.
  regularExpressions,
  // Shell: file CRUD, metadata, `chmod`, `tar`.
  fileOperations,
  // SSH client: connect, keys, `~/.ssh/config`, `scp`.
  sshClient,
  // SSH server: permissions, `authorized_keys`, `sshd`.
  sshServer,
  // Shell startup files: `~/.bashrc`, `PATH`, aliases.
  shellProfiles,
  // DDD entities, value objects, domain errors. Architecture layer.
  domainModeling,
  // Application-core interfaces implemented by adapters. Architecture.
  hexagonalPorts,
  // Use cases and fake-port tests. Architecture layer.
  applicationUseCases,
  // Repository-port adapters (in-memory, file-backed). Architecture.
  persistenceAdapters,
  // REST/HTTP DTOs, handlers, routing, status mapping. Architecture.
  restAdapters,
  // Hand-written test doubles and their tests. Architecture layer.
  testingWithFakes,
  // Linear and binary search. Topic category: real difficulty.
  searchingAlgorithms,
  // Bubble, selection, insertion, merge, quick, heap sort. Topic.
  sortingAlgorithms,
  // Adjacency-list graphs, BFS, DFS, Dijkstra. Topic category.
  graphAlgorithms,
  // Wails' expression lexer, recursive-descent grammar and formatting.
  calculatorCore,
  // Wails' `wails.json` and `go.mod`: what the CLI reads to build.
  wailsProjectSetup,
  // Wails' `App` struct, `Bind` list, generated shims, Go->JS events.
  wailsBindings,
  // Wails' `frontend/`: `index.html`, the vanilla-TS module, the bindings.
  wailsFrontend,
  // Wails' `options.App`, `AssetServer`, lifecycle hooks, per-platform.
  wailsArchitecture,
  // Wails' embedded CSS: design tokens and the keypad grid.
  wailsStyling,
  // `wails build` flags and the `build/` per-platform metadata.
  wailsPackaging,
  // Testing the engine's table-driven cases and the bound methods.
  wailsTesting,
  // Bubble Tea's `Model`/`Init`/`Update`/`View` loop. Architecture.
  tuiArchitecture,
  // Lip Gloss styles, colors, borders, padding. Architecture.
  tuiStyling,
  // Bubbles widgets inside a Bubble Tea model. Architecture.
  tuiComponents,
  // TUI commands calling use cases; the root. Architecture.
  tuiAdapter,
  // Go handlers, `ServeMux`, middleware, lifecycle. Topic.
  httpServers,
  // HTTP with context/timeouts, transport, retries. Topic.
  httpClients,
  // Testing handlers and servers with `httptest`. Topic.
  httpTesting,
  // `database/sql` pools, DDL/DML, transactions. Topic.
  sqlPersistence,
  // Classes: typed fields, constructors, access modifiers.
  classesAndObjects,
  // Exports/imports, including type-only exports.
  modules,
  // C arrays, NUL-terminated strings, `<string.h>`.
  arraysAndStrings,
  // `malloc`/`calloc`/`realloc`/`free`, ownership, raw memory.
  memoryManagement,
  // `#define` macros, `#include`, header guards, conditional builds.
  preprocessor,
  // `fopen`/`fclose`, `fprintf`/`fputs`, `fgets` until EOF.
  fileIO,
  // C++ function/class templates and concept constraints.
  templates,
  // `std::vector`/`map`/`set`, iterators, `std::optional`.
  stlContainers,
  // Crystal `yield`, block forms, `&` procs.
  blocksAndProcs,
  // Crystal/C#/Kotlin arrays, maps, and iteration.
  collections,
  // Crystal/C# nullable types, `try(&.x)`, `?.`, `??`.
  nilSafety,
  // Selectors, combinators, specificity, `:is()`, `@layer`.
  cssSelectors,
  // `display`, sizing, padding, margin, border, `box-sizing`.
  cssBoxModel,
  // Colors, gradients, font stacks, text styles.
  cssColorsAndTypography,
  // Flexbox and grid: alignment, placement, named areas.
  cssLayout,
  // `position`, offsets, `inset`, `z-index`, `overflow`.
  cssPositioning,
  // `--name` variables, `var()` fallbacks, overrides, `calc()`.
  cssCustomProperties,
  // Units, media queries, breakpoints, `clamp()` fluid type.
  cssResponsive,
  // Transitions, transforms, `@keyframes`, reduced motion.
  cssTransitionsAndAnimations,
  // C# `is` patterns and `switch` expressions.
  patternMatching,
  // C# delegates, lambdas, `event` subscription.
  delegatesAndEvents,
  // LINQ `Where`/`Select`/`OrderBy` and query syntax.
  linq,
  // `async`/`await`, `Task`, `Future`, `Stream`, `Task.WhenAll`.
  asyncProgramming,
  // Swift optionals: `nil`, `if let`, `guard let`, `??`.
  optionals,
  // Swift closures: trailing syntax, `$0`, capturing, `@escaping`.
  closures,
  // Swift enums, associated values, `switch`, `indirect`.
  enumsAndPatternMatching,
  // Swift `Codable`, `CodingKeys`, JSON round-trips.
  codable,
  // Swift `@propertyWrapper` and `wrappedValue`.
  propertyWrappers,
  // Kotlin/Dart `String?`, `?.`, `?:`, `!!`, `late`, flow promotion.
  nullSafety,
  // Kotlin `data class` and destructuring declarations.
  dataClasses,
  // Kotlin lambdas, `it`, higher-order functions, scope functions.
  lambdas,
  // Kotlin extension functions and properties.
  extensions,
  // Kotlin `suspend`, `launch`, `async`, `flow`, dispatchers.
  coroutines,
  // Django scaffolding: `startproject`, `startapp`, `INSTALLED_APPS`.
  djangoProject,
  // Django models: fields, `Meta`, model methods.
  djangoModels,
  // Django views, `HttpResponse`, `path()` routing, `include()`.
  djangoViews,
  // Django templates, `{% for %}`, `{% extends %}`, contexts.
  djangoTemplates,
  // Django `Form`/`ModelForm`, validation, POST with CSRF.
  djangoForms,
  // Django admin registration and `ModelAdmin` options.
  djangoAdmin,
  // Django `TestCase`, `setUpTestData`, request assertions.
  djangoTesting,
  // `ForeignKey`, reverse accessors, M2M, cascade behavior.
  djangoRelationships,
  // QuerySets, lookups, `Q`/`F`, aggregation, custom managers.
  djangoOrm,
  // Migration anatomy, `RunPython`, management commands.
  djangoMigrations,
  // Installing DRF and the first `@api_view` endpoint.
  djangoRestSetup,
  // DRF serializers, validation, nested fields.
  djangoSerializers,
  // DRF views, viewsets, routers, custom actions.
  djangoRestViews,
  // DRF token auth, permissions, per-user querysets.
  djangoRestAuth,
  // DRF pagination, search, and ordering.
  djangoRestFiltering,
  // `APITestCase`/`APIClient` end-to-end CRUD tests.
  djangoRestTesting,
  // Dart records, destructuring, sealed-class pattern matching.
  recordsAndPatterns,
  // PHP tags, `echo`, variables, scalar types, `??`.
  phpBasics,
  // PHP string interpolation, heredoc/nowdoc, string functions.
  phpStrings,
  // PHP `if`/`elseif`/`else`, ternary, `match`.
  phpConditionals,
  // PHP `for`, `while`, `break`, `continue`.
  phpLoops,
  // PHP indexed/associative arrays, `array_*`, `foreach`.
  phpArrays,
  // PHP typed functions, arrow functions, closures with `use`.
  phpFunctions,
  // PHP classes, constructor promotion, interfaces, traits.
  phpClasses,
  // PHP enum cases and `from`/`tryFrom`.
  phpEnums,
  // PHP `throw`, `try`/`catch`/`finally`, custom exceptions.
  phpErrorHandling,
  // PHP namespaces, `use`, autoload boundaries.
  phpNamespaces,
  // PHP `$_GET`, `$_POST`, `$_SERVER` while handling a request.
  phpSuperglobals,
  // Form validation, escaping, `filter_var`, password hashing.
  phpForms,
  // `session_start`, `$_SESSION`, cookies.
  phpSessions,
  // PDO connections, prepared statements, transactions.
  phpDatabase,
  // `json_encode`/`json_decode` and JSON responses.
  phpJson,
  // Server-side file reads, writes, and `unlink`.
  phpFiles,
  // Linear and binary search in PHP.
  phpSearching,
  // PHP bubble, selection, insertion, merge, quick, and heap sort.
  phpSorting,
  // PHP weighted adjacency list, BFS, DFS, Dijkstra.
  phpGraphs,
  // Git repo setup, staging, `.gitignore`, diffs, file surgery.
  gitBasics,
  // Committing: messages, history reading, amending the last commit.
  gitCommits,
  // Branch create/switch/delete, fast-forward and merge commits,
  // conflict resolution. Introduced by `git-foundations-v1`.
  gitBranching,
  // Clone, remote setup, fetch, pull, push, tracking branches.
  gitRemotes,
  // Log formats, pickaxe, blame, and `git bisect`.
  gitHistory,
  // `restore`, the three `reset` modes, `revert`, `clean`, `stash`.
  gitUndo,
  // Rebase, force-with-lease, cherry-pick, autosquash, tags, hooks.
  gitCollaboration,
  // Blobs, trees, commits, and `cat-file`/`hash-object`/`ls-tree`.
  gitObjects,
  // `HEAD`, detached state, `show-ref`, `update-ref`, reflog.
  gitRefs,
  // Index internals, object counts, `git gc`, linked worktrees.
  gitMaintenance,
  // Distro identity, kernel, hostname, help, environment variables.
  linuxBasics,
  // Paths, navigation, file CRUD, symlinks, viewing files.
  linuxFiles,
  // Mode bits, `chmod`/`chown`/`umask`, sticky/setgid, ACLs.
  permissions,
  // Accounts, groups, `sudo`, password locks.
  usersAndGroups,
  // Listing, signals, and scheduling priority.
  processes,
  // `pacman` queries, installs, removals, file ownership.
  packages,
  // `systemctl` units: status, lifecycle, enablement.
  services,
  // `journalctl` filtering and disk usage.
  logs,
  // Block devices, disk space, directory usage.
  storage,
  // Interfaces, routes, DNS, sockets, HTTP, firewalls.
  networking,
  // `systemd-analyze calendar`, timers, transient units.
  scheduling,
  // `tar` create/list/extract and compression.
  backupAndArchives,
  // Docker CLI basics: images vs containers, run, ps, info.
  dockerBasics,
  // Building, tagging, pulling, and inspecting images.
  dockerImages,
  // Dockerfile instructions: FROM, RUN, COPY, CMD, ENV.
  dockerFiles,
  // Container lifecycle, logs, exec, inspect, and cleanup.
  dockerContainers,
  // Named volumes and bind mounts for persistent data.
  dockerVolumes,
  // Port publishing and user-defined networks with DNS.
  dockerNetworking,
  // Pushing and pulling registries, digests, and login.
  dockerRegistries,
  // compose.yaml: services, networks, volumes, healthchecks.
  dockerCompose,
  // Disk usage, stats, top, and diff for debugging.
  dockerMaintenance,
  // Workflow anatomy: `name`, `on`, `jobs`, `runs-on`, first steps.
  workflowBasics,
  // Events: `push`, `pull_request`, `schedule`, `workflow_dispatch`.
  workflowTriggers,
  // Jobs, `steps`, `needs`, `if`, timeouts, `GITHUB_OUTPUT`.
  jobsAndSteps,
  // `${{ }}` contexts, functions, status checks, operators.
  expressionsAndContexts,
  // `runs-on`, `strategy.matrix`, include/exclude, dynamic matrices.
  runnersAndMatrix,
  // `env`, `vars`, `secrets`, `GITHUB_TOKEN`, `permissions`.
  secretsAndVariables,
  // `actions/cache`, `upload-artifact`, `download-artifact`.
  cachingAndArtifacts,
  // Composite actions and `workflow_call` reusable workflows.
  reusableAndComposite,
  // `services`, container jobs, `docker/build-push-action`.
  containersAndDocker,
  // `concurrency`, path filters, step summaries, workflow chaining.
  pipelinePatterns,
  // Least privilege, SHA pinning, OIDC, CodeQL, Dependabot.
  securityHardening,
  // Environments, Pages, GitHub Releases, provenance, registries.
  deploymentsAndReleases,
  // Inspecting and driving runs with the `gh` CLI.
  ciOperations,
  // Go 1.26/1.27 language changes: `new(expr)`, promoted literal keys.
  languageEvolution,
  // Modern idioms: `min`/`max`, `SplitSeq`, `CutPrefix`, typed atomics.
  modernIdioms,
  // Go 1.27 methods with their own type parameters.
  genericMethods,
  // `iter.Seq`/`Seq2`, range-over-func, adapter composition.
  iterators,
  // `encoding/json/v2` and `jsontext` streaming, tags, options.
  jsonV2,
  // Recent stdlib: `uuid`, `url.Clone`, `rand/v2`, `mldsa`, `os.Root`.
  modernStdlib,
  // Constructors, functional options, consumer-side interfaces.
  apiDesign,
  // `errors.Join`/`AsType`, custom `Unwrap` and `Is`.
  errorPatterns,
  // `WaitGroup.Go`, context causes, worker pools, pipelines.
  concurrencyPatterns,
  // Leaked goroutines and the GA `goroutineleak` profile.
  goroutineLeaks,
  // Subtests, fuzzing, `synctest`, artifacts, golden files.
  advancedTesting,
  // Zig `test` blocks, `std.testing` helpers, and assertions.
  testing,
  // Benchmarks, allocation, pprof CPU, runtime metrics.
  performanceProfiling,
  // `log/slog` structured logging and multi-handler fan-out.
  observability,
  // `//go:embed`, build info, `//go:generate`, `go fix`.
  goTooling,
  // Complete, self-contained CLI programs: arithmetic and formatted output.
  cliArithmetic,
  // Complete CLI programs manipulating strings: case, runes, ciphers.
  cliTextTools,
  // Complete CLI programs driven by a `bufio.Scanner` menu loop.
  cliMenus,
  // Complete CLI programs combining state, maps, and randomness.
  cliChallenges,
}
