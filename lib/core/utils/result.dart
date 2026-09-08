/// A dependency-free `Either`-style result used at every port boundary so
/// that failures are values the caller must handle, never thrown exceptions.
sealed class Result<S, F> {
  const new();

  const factory ok(S value) = Ok<S, F>;
  const factory err(F failure) = Err<S, F>;

  bool get isOk => this is Ok<S, F>;
  bool get isErr => this is Err<S, F>;

  T fold<T>(T Function(S value) onOk, T Function(F failure) onErr) {
    return switch (this) {
      Ok<S, F>(:final value) => onOk(value),
      Err<S, F>(:final failure) => onErr(failure),
    };
  }

  S? get valueOrNull => switch (this) {
    Ok<S, F>(:final value) => value,
    Err<S, F>() => null,
  };

  F? get failureOrNull => switch (this) {
    Ok<S, F>() => null,
    Err<S, F>(:final failure) => failure,
  };

  Result<T, F> map<T>(T Function(S value) transform) => switch (this) {
    Ok<S, F>(:final value) => Result.ok(transform(value)),
    Err<S, F>(:final failure) => Result.err(failure),
  };
}

final class Ok<S, F> extends Result<S, F> {
  const new(this.value);
  final S value;
}

final class Err<S, F> extends Result<S, F> {
  const new(this.failure);
  final F failure;
}
