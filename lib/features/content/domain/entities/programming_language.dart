/// A programming language a Snippet is written in.
///
/// SPEC.md §18 originally scoped v1 to Go only; this enum was shaped from
/// the start so adding a language later is just a new case, never a
/// redesign — Bash (the `bash-foundations-v1` Learning Route) is the
/// first proof of that.
enum ProgrammingLanguage {
  /// The Go programming language.
  go,

  /// The Bash shell (POSIX-ish shell scripting on Linux), taught by the
  /// Arch-Linux-flavored `bash-foundations-v1` Learning Route.
  bash,

  /// SQL, taught against PostgreSQL by the library-themed
  /// `sql-foundations-v1` Learning Route — course-only, like Bash.
  sql,

  /// The Rust programming language, taught by the beginner-focused
  /// `rust-foundations-v1` Learning Route — course-only, like Bash/SQL.
  rust,

  /// The Python programming language, taught by `python-foundations-v1`
  /// (beginner) and `python-algorithms-v1` — course-only, like Bash/SQL/
  /// Rust.
  python,

  /// JavaScript, taught by `js-foundations-v1` (beginner) and
  /// `js-algorithms-v1` — course-only, like Bash/SQL/Rust/Python.
  javascript,

  /// TypeScript, taught by `typescript-foundations-v1` (beginner) and
  /// `typescript-algorithms-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions` categories for
  /// the typed core, plus two of its own (`classesAndObjects`, `modules`)
  /// for the class/module tour the JavaScript route doesn't cover.
  typescript,

  /// Haskell, taught by `haskell-foundations-v1` (beginner) and
  /// `haskell-algorithms-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`functions` categories (there is
  /// no `loops` block: recursion is introduced as the functional
  /// substitute for iteration).
  haskell,

  /// C, the language operating systems are built on — taught by
  /// `c-foundations-v1` (beginner), `c-algorithms-v1`, and
  /// `c-systems-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript/TypeScript/Haskell. Its routes reuse the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/`pointers`/
  /// `structs`/`errorHandling` categories plus four of its own
  /// (`arraysAndStrings`, `memoryManagement`, `preprocessor`, `fileIO`)
  /// for the concepts Go's categories don't represent.
  c,

  /// C++, taught by `cpp-foundations-v1` (beginner), `cpp-algorithms-v1`,
  /// and `cpp-advanced-v1` — course-only, like Bash/SQL/Rust/Python/
  /// JavaScript/TypeScript/Haskell/C. Its routes reuse the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/`pointers`/
  /// `structs`/`classesAndObjects`/`memoryManagement`/`errorHandling`/
  /// `concurrency` categories plus two of its own (`templates`,
  /// `stlContainers`) for the modern-C++ concepts Go's categories don't
  /// represent.
  cpp,

  /// Java, taught by `java-foundations-v1` (beginner) and
  /// `java-algorithms-v1` — course-only, like the languages above. Its
  /// foundations route reuses the generic `variablesAndTypes`/
  /// `conditionals`/`loops`/`functions` categories plus `modules`
  /// (Java's `package`/`import` structure), `classesAndObjects`,
  /// `interfaces`, and `errorHandling`; it adds no categories of its
  /// own.
  java,

  /// Crystal, a compiled, type-inferred language with Ruby-like syntax —
  /// taught by `crystal-foundations-v1` (a broad beginner tour) and
  /// `crystal-algorithms-v1` — course-only, like the languages above. Its
  /// foundations route reuses the generic `variablesAndTypes`/
  /// `conditionals`/`loops`/`functions`/`classesAndObjects`/`modules`/
  /// `errorHandling` categories plus three of its own (`blocksAndProcs`,
  /// `collections`, `nilSafety`) for the concepts Go's categories don't
  /// represent.
  crystal,

  /// Swift, taught by `swift-foundations-v1` (beginner),
  /// `swift-algorithms-v1`, and `swift-advanced-v1` — course-only, like
  /// the languages above. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/
  /// `classesAndObjects`/`interfaces`/`errorHandling` categories plus
  /// three of its own (`optionals`, `closures`,
  /// `enumsAndPatternMatching`); the advanced route reuses `optionals`/
  /// `enumsAndPatternMatching`/`closures`/`generics`/`interfaces`/
  /// `memoryManagement`/`errorHandling`/`concurrency` plus two of its own
  /// (`codable`, `propertyWrappers`).
  swift,

  /// CSS, the stylesheet language of the web — taught by
  /// `css-foundations-v1` (beginner), `css-layout-v1` (flexbox, grid,
  /// positioning, responsive), and `css-advanced-v1` (cascade layers,
  /// custom properties, transitions, animations) — course-only, like the
  /// languages above. None of Go's categories represent a CSS concept, so
  /// its routes use eight categories of their own (`cssSelectors`,
  /// `cssBoxModel`, `cssColorsAndTypography`, `cssLayout`,
  /// `cssPositioning`, `cssCustomProperties`, `cssResponsive`,
  /// `cssTransitionsAndAnimations`).
  css,

  /// C#, taught by `csharp-foundations-v1` (beginner),
  /// `csharp-algorithms-v1`, and `csharp-advanced-v1` — course-only, like
  /// the languages above. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/
  /// `classesAndObjects`/`interfaces`/`collections`/`errorHandling`/
  /// `modules` categories; the advanced route reuses `nilSafety`/
  /// `generics`/`functions`/`collections`/`errorHandling` plus four of its
  /// own (`patternMatching`, `delegatesAndEvents`, `linq`,
  /// `asyncProgramming`) for the modern-C# concepts Go's categories don't
  /// represent.
  csharp,

  /// Kotlin, taught by `kotlin-foundations-v1` (beginner),
  /// `kotlin-algorithms-v1`, and `kotlin-advanced-v1` — course-only, like
  /// the languages above. Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/
  /// `classesAndObjects`/`errorHandling` categories plus five of its own
  /// (`nullSafety`, `dataClasses`, `lambdas`, `extensions`, `collections`)
  /// for the concepts Go's categories don't represent; the advanced route
  /// reuses `classesAndObjects`/`interfaces`/`generics`/`errorHandling`
  /// plus `coroutines`, its own category for suspend functions and flows.
  kotlin,

  /// Dart, the null-safe, async-first language behind Flutter — taught by
  /// `dart-foundations-v1` (a broad beginner tour), `dart-advanced-v1`,
  /// and `dart-algorithms-v1` — course-only, like the languages above.
  /// Its foundations route reuses the generic
  /// `variablesAndTypes`/`conditionals`/`loops`/`functions`/
  /// `classesAndObjects`/`modules`/`errorHandling` categories plus the
  /// shared `collections`, `nullSafety`, and `asyncProgramming` ones, and
  /// adds `recordsAndPatterns` of its own for Dart 3 records and pattern
  /// matching; the advanced route reuses `nullSafety`/`asyncProgramming`/
  /// `recordsAndPatterns`/`classesAndObjects`/`generics`/`errorHandling`
  /// plus `concurrency` for isolates.
  dart,

  /// PHP, the web's server-side workhorse — taught by
  /// `php-foundations-v1` (a broad beginner tour), `php-web-v1` (requests,
  /// forms, sessions, PDO, JSON, files), and `php-algorithms-v1` —
  /// course-only, like the languages above. Its routes use nineteen
  /// categories of their own (`phpBasics`, `phpStrings`,
  /// `phpConditionals`, `phpLoops`, `phpArrays`, `phpFunctions`,
  /// `phpClasses`, `phpEnums`, `phpErrorHandling`, `phpNamespaces`,
  /// `phpSuperglobals`, `phpForms`, `phpSessions`, `phpDatabase`,
  /// `phpJson`, `phpFiles`, `phpSearching`, `phpSorting`, `phpGraphs`),
  /// because PHP's idioms, web focus, and array/string handling don't map
  /// onto Go's categories.
  php,

  /// Git, the version-control system every project depends on — taught by
  /// `git-foundations-v1` (from `git init` to remotes),
  /// `git-workflows-v1` (history, undo, rebase, tags, hooks), and
  /// `git-internals-v1` (objects, refs, maintenance) — course-only, like
  /// the languages above. Its routes use ten categories of their own
  /// (`gitBasics`, `gitCommits`, `gitBranching`, `gitRemotes`,
  /// `gitHistory`, `gitUndo`, `gitCollaboration`, `gitObjects`,
  /// `gitRefs`, `gitMaintenance`), because version control has no
  /// concept that maps onto a programming-language category.
  git,

  /// Linux, the operating system itself — taught by
  /// `linux-foundations-v1` (files, permissions, users, processes,
  /// packages, services, logs), `linux-admin-v1` (system
  /// administration: accounts, ACLs, signals, storage, systemd,
  /// journald, pacman, timers, archives), and `linux-networking-v1`
  /// (interfaces, routes, DNS, sockets, HTTP, nftables,
  /// systemd-resolved) — course-only, like the languages above. Its
  /// routes use twelve categories of their own (`linuxBasics`,
  /// `linuxFiles`, `permissions`, `usersAndGroups`, `processes`,
  /// `packages`, `services`, `logs`, `storage`, `networking`,
  /// `scheduling`, `backupAndArchives`), because an operating system
  /// has no construct that maps onto a programming-language category.
  linux,

  /// Docker, the container platform backend code ships on — taught by
  /// `docker-foundations-v1` (your first `docker run`, Dockerfiles,
  /// images, container lifecycle, volumes, networks),
  /// `docker-compose-v1` (multi-container applications in one
  /// `compose.yaml`), and `docker-advanced-v1` (multi-stage builds,
  /// registries, resource limits, debugging) — course-only, like the
  /// languages above. Its routes use nine categories of their own
  /// (`dockerBasics`, `dockerImages`, `dockerFiles`,
  /// `dockerContainers`, `dockerVolumes`, `dockerNetworking`,
  /// `dockerRegistries`, `dockerCompose`, `dockerMaintenance`), because
  /// container concepts don't map onto a programming-language category.
  docker,

  /// GitHub Actions, GitHub's CI/CD platform — taught by
  /// `github-actions-foundations-v1` (workflow anatomy, triggers, jobs),
  /// `github-actions-pipelines-v1` (caching, artifacts, composite and
  /// reusable workflows, containers, pipeline patterns), and
  /// `github-actions-devops-v1` (environments, releases, OIDC, security
  /// hardening, `gh` operations) — course-only, like the languages
  /// above. Its routes use thirteen categories of their own
  /// (`workflowBasics`, `workflowTriggers`, `jobsAndSteps`,
  /// `expressionsAndContexts`, `runnersAndMatrix`, `secretsAndVariables`,
  /// `cachingAndArtifacts`, `reusableAndComposite`, `containersAndDocker`,
  /// `pipelinePatterns`, `securityHardening`, `deploymentsAndReleases`,
  /// `ciOperations`), because YAML CI/CD pipelines have no concept that
  /// maps onto a programming-language category.
  githubActions,
}
