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
}
