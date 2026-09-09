/// A dependency-free `Either`-style result used at every port boundary so
/// that failures are values the caller must handle, never thrown exceptions.
sealed class Result<S, F> {
  const new();

  const factory ok(S value) = Ok<S, F>;
  const factory err(F failure) = Err<S, F>;

  /// Whether this is an [Ok].
  bool get isOk => this is Ok<S, F>;

  /// Whether this is an [Err].
  bool get isErr => this is Err<S, F>;

  /// Collapses this result into a single value, calling [onOk] for an
  /// [Ok] or [onErr] for an [Err].
  T fold<T>(T Function(S value) onOk, T Function(F failure) onErr) {
    return switch (this) {
      Ok<S, F>(:final value) => onOk(value),
      Err<S, F>(:final failure) => onErr(failure),
    };
  }

  /// The success value, or `null` if this is an [Err].
  S? get valueOrNull => switch (this) {
    Ok<S, F>(:final value) => value,
    Err<S, F>() => null,
  };

  /// The failure value, or `null` if this is an [Ok].
  F? get failureOrNull => switch (this) {
    Ok<S, F>() => null,
    Err<S, F>(:final failure) => failure,
  };

  /// Applies [transform] to the success value, leaving an [Err] untouched.
  Result<T, F> map<T>(T Function(S value) transform) => switch (this) {
    Ok<S, F>(:final value) => Result.ok(transform(value)),
    Err<S, F>(:final failure) => Result.err(failure),
  };
}

/// A successful [Result], carrying the produced [value].
final class Ok<S, F> extends Result<S, F> {
  /// Creates a successful result wrapping [value].
  const new(this.value);

  /// The produced value.
  final S value;
}

/// A failed [Result], carrying the [failure] that occurred.
final class Err<S, F> extends Result<S, F> {
  /// Creates a failed result wrapping [failure].
  const new(this.failure);

  /// The failure that occurred.
  final F failure;
}
