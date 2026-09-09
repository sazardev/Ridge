/// Shared vocabulary of failures returned across every hexagon's ports.
/// Features may add more specific subtypes, but funnel into this base so
/// presentation-layer error handling stays uniform across the app.
sealed class AppFailure {
  /// Creates a failure carrying a human-readable [message].
  const new(this.message);

  /// Description of what went wrong, safe to show in the UI.
  final String message;
}

/// A business-rule input was invalid (e.g. an empty required title).
final class ValidationFailure extends AppFailure {
  /// Creates a [ValidationFailure] with a human-readable [message].
  const new(super.message);
}

/// The requested entity does not exist.
final class NotFoundFailure extends AppFailure {
  /// Creates a [NotFoundFailure] with a human-readable [message].
  const new(super.message);
}

/// A read/write against a storage adapter failed.
final class StorageFailure extends AppFailure {
  /// Creates a [StorageFailure], optionally wrapping the underlying
  /// exception as [cause] for logging/debugging.
  const new(super.message, {this.cause});

  /// The underlying exception that triggered this failure, if any.
  final Object? cause;
}

/// The caller isn't allowed to perform the requested action.
final class UnauthorizedFailure extends AppFailure {
  /// Creates an [UnauthorizedFailure] with a human-readable [message].
  const new(super.message);
}

/// A failure that doesn't fit any other [AppFailure] subtype.
final class UnexpectedFailure extends AppFailure {
  /// Creates an [UnexpectedFailure], optionally wrapping the underlying
  /// exception as [cause] for logging/debugging.
  const new(super.message, {this.cause});

  /// The underlying exception that triggered this failure, if any.
  final Object? cause;
}
