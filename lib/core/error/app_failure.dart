/// Shared vocabulary of failures returned across every hexagon's ports.
/// Features may add more specific subtypes, but funnel into this base so
/// presentation-layer error handling stays uniform across the app.
sealed class AppFailure {
  const new(this.message);

  final String message;
}

final class ValidationFailure extends AppFailure {
  const new(super.message);
}

final class NotFoundFailure extends AppFailure {
  const new(super.message);
}

final class StorageFailure extends AppFailure {
  const new(super.message, {this.cause});

  final Object? cause;
}

final class UnauthorizedFailure extends AppFailure {
  const new(super.message);
}

final class UnexpectedFailure extends AppFailure {
  const new(super.message, {this.cause});

  final Object? cause;
}
