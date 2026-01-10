import 'failures.dart';

/// A Result type representing either a success or an error.
///
/// This sealed class implements the Result pattern, providing a type-safe
/// way to handle operations that can fail without throwing exceptions.
///
/// Example:
/// ```dart
/// Future<Result<User>> getUser(String id) async {
///   try {
///     final user = await api.fetchUser(id);
///     return Success(user);
///   } on AppException catch (e) {
///     return Error(mapExceptionToFailure(e));
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation with the resulting data.
///
/// Contains the data of type [T] returned by the successful operation.
class Success<T> extends Result<T> {
  /// The data returned by the successful operation.
  final T data;

  const Success(this.data);
}

/// Represents a failed operation with failure information.
///
/// Contains a [Failure] object describing what went wrong.
class Error<T> extends Result<T> {
  /// The failure describing what went wrong.
  final Failure failure;

  const Error(this.failure);
}

/// Extension methods for [Result] to simplify common operations.
extension ResultExtension<T> on Result<T> {
  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this is an [Error].
  bool get isError => this is Error<T>;

  /// Returns the data if this is a [Success], otherwise `null`.
  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Error() => null,
  };

  /// Returns the failure if this is an [Error], otherwise `null`.
  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Error(failure: final failure) => failure,
  };

  /// Transforms the result using the provided callbacks.
  ///
  /// Calls [onSuccess] if this is a [Success], or [onError] if this is an [Error].
  ///
  /// Example:
  /// ```dart
  /// final message = result.fold(
  ///   onSuccess: (user) => 'Welcome, ${user.name}!',
  ///   onError: (failure) => 'Error: ${failure.message}',
  /// );
  /// ```
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Error(failure: final failure) => onError(failure),
    };
  }
}
