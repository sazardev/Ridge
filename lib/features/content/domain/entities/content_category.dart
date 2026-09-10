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
