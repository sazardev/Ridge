/// The thematic construct a Snippet exercises (SPEC.md §3.1).
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

  /// Concurrency primitives: goroutines and channels.
  concurrency,

  /// Generic type parameters and constraints.
  generics,

  /// Idiomatic `gofmt` formatting conventions in general.
  idiomaticFormatting,

  /// Shell-specific: running commands, `echo`/`printf`, script
  /// arguments (`$1`, `$#`, `$@`), and command substitution. Introduced
  /// by the `bash-foundations-v1` Learning Route.
  shellCommands,

  /// Shell-specific: pipes (`|`), redirection (`>`, `>>`, `<`, `2>`,
  /// `&>`), heredocs, and process substitution. Bash Learning Route
  /// category.
  pipesAndRedirection,

  /// Shell-specific: filtering and transforming text with `grep`,
  /// `cut`, `sort`, `uniq`, `wc`, `tr`, `head`/`tail`, and a taste of
  /// `sed`/`awk`. Bash Learning Route category.
  textProcessing,

  /// Arch Linux system administration through the shell: `pacman`,
  /// AUR helpers (`paru`/`yay`), `systemctl`, and `journalctl`. Bash
  /// Learning Route category.
  systemAdministration,

  /// SQL basics: `SELECT` over literal expressions, aliases, arithmetic,
  /// string concatenation with `||`, and built-in values like
  /// `CURRENT_DATE`. Introduced by the PostgreSQL `sql-foundations-v1`
  /// Learning Route.
  sqlBasics,

  /// SQL schema definition and setup: `psql` meta-commands (`\l`, `\c`,
  /// `\dt`, `\d`), `CREATE TABLE`/`CREATE DATABASE`, column types and
  /// constraints (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `DEFAULT`,
  /// `REFERENCES`), and seeding the sample library database.
  sqlSchema,

  /// Reading data: `SELECT` from tables, column projection, `DISTINCT`,
  /// `ORDER BY`, and `LIMIT`/`OFFSET`. SQL Learning Route category.
  sqlQueries,

  /// Narrowing rows: `WHERE` with comparison operators, `AND`/`OR`/`NOT`,
  /// `IN`, `BETWEEN`, `LIKE`/`ILIKE`, and `IS NULL`. SQL Learning Route
  /// category.
  sqlFiltering,

  /// Summarizing rows: `COUNT`/`SUM`/`AVG`/`MIN`/`MAX`, `GROUP BY`,
  /// `HAVING`, and rounding. SQL Learning Route category.
  sqlAggregation,

  /// Combining tables: `INNER JOIN`, `LEFT JOIN`, table aliases, and
  /// multi-table joins. SQL Learning Route category.
  sqlJoins,

  /// Changing data: `INSERT`, `UPDATE`, `DELETE`, and `RETURNING`.
  /// SQL Learning Route category.
  sqlModifications,

  /// Advanced querying: subqueries, `EXISTS`, common table expressions
  /// (`WITH`), set operations (`UNION`), and `CASE` expressions. SQL
  /// Learning Route category.
  sqlAdvancedQueries,

  /// DDD domain modeling: entities, value objects, domain-level errors.
  /// Architecture-layer category (unlike the language-feature categories
  /// above) — see `snippet_catalog_completeness_test.dart`'s
  /// `_architectureLayerCategories` for why it's held to a different
  /// per-difficulty completeness bar.
  domainModeling,

  /// Hexagonal-architecture ports: interfaces owned by the application
  /// core, implemented by adapters. Architecture-layer category.
  hexagonalPorts,

  /// Application-layer use cases orchestrating domain + ports, and tests
  /// that exercise them via a fake port implementation. Architecture-layer
  /// category.
  applicationUseCases,

  /// Adapters implementing a repository port (e.g. in-memory, file-backed).
  /// Architecture-layer category.
  persistenceAdapters,

  /// The REST/HTTP adapter: request/response DTOs, handlers, routing,
  /// error-to-status-code mapping, and the composition-root wiring that
  /// starts the server. Architecture-layer category.
  restAdapters,

  /// Hand-written test doubles (fakes) and the tests that use them to
  /// exercise application-layer use cases in isolation from any real
  /// adapter. Kept separate from [applicationUseCases] rather than
  /// folded into it, since these lessons are sequenced at the very end
  /// of a Learning Route (after every adapter has been introduced) —
  /// a category must stay one contiguous block, so it can't share a tag
  /// with lessons earlier in the same route. Architecture-layer category.
  testingWithFakes,
}
