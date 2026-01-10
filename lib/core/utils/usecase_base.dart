// Note: Consider using these abstract classes as the project grows
// and the number of UseCases increases. Currently, the project is small
// enough that individual UseCase classes are implemented directly.

import '../error/result.dart';

/// Abstract base class for use cases that require parameters.
///
/// Use cases encapsulate a single unit of business logic and provide
/// a consistent interface for the presentation layer to execute operations.
///
/// Type parameters:
/// - [T]: The type of data returned on success
/// - [Params]: The type of parameters required by the use case
///
/// Example:
/// ```dart
/// class LoginUseCase extends UseCase<User, LoginParams> {
///   final AuthRepository _repository;
///
///   LoginUseCase(this._repository);
///
///   @override
///   Future<Result<User>> call(LoginParams params) {
///     return _repository.login(
///       email: params.email,
///       password: params.password,
///     );
///   }
/// }
///
/// class LoginParams {
///   final String email;
///   final String password;
///
///   LoginParams({required this.email, required this.password});
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Executes the use case with the given parameters.
  ///
  /// Returns a [Result] containing either the success data or a failure.
  Future<Result<T>> call(Params params);
}

/// Abstract base class for use cases that don't require parameters.
///
/// Use this when the operation doesn't need any input parameters.
///
/// Example:
/// ```dart
/// class GetCurrentUserUseCase extends NoParamsUseCase<User> {
///   final AuthRepository _repository;
///
///   GetCurrentUserUseCase(this._repository);
///
///   @override
///   Future<Result<User>> call() {
///     return _repository.getCurrentUser();
///   }
/// }
/// ```
abstract class NoParamsUseCase<T> {
  /// Executes the use case without any parameters.
  ///
  /// Returns a [Result] containing either the success data or a failure.
  Future<Result<T>> call();
}

/// Abstract base class for use cases that return a stream of data.
///
/// Use this for operations that emit multiple values over time,
/// such as real-time updates or paginated data.
///
/// Example:
/// ```dart
/// class WatchUserUseCase extends StreamUseCase<User, String> {
///   final UserRepository _repository;
///
///   WatchUserUseCase(this._repository);
///
///   @override
///   Stream<User> call(String userId) {
///     return _repository.watchUser(userId);
///   }
/// }
/// ```
abstract class StreamUseCase<T, Params> {
  /// Executes the use case and returns a stream of data.
  Stream<T> call(Params params);
}
