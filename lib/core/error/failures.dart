import 'exceptions.dart';

/// Base failure class representing an operation that did not succeed.
///
/// Failures are used in the Result pattern to represent errors in a
/// type-safe way without throwing exceptions. All specific failure types
/// should extend this class.
sealed class Failure {
  /// Human-readable error message describing the failure.
  final String message;

  const Failure(this.message);
}

/// Failure representing a network-related error.
///
/// Used when network operations fail due to connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Failure representing a server error response.
///
/// Contains the HTTP status code for more specific error handling.
class ServerFailure extends Failure {
  /// HTTP status code returned by the server (e.g., 400, 500).
  final int? statusCode;

  const ServerFailure(super.message, this.statusCode);
}

/// Failure representing a cache operation error.
///
/// Used when local storage operations fail.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Failure representing an authentication error.
///
/// Used when authentication or authorization fails.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error']);
}

/// Failure representing a validation error.
///
/// Used when input validation fails.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

/// Failure representing an unknown or unexpected error.
///
/// Used as a fallback when the error type cannot be determined.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
}

/// Converts an [AppException] to its corresponding [Failure] type.
///
/// This utility function maps exception types to failure types,
/// preserving the error message and any additional data.
///
/// Example:
/// ```dart
/// try {
///   await apiCall();
/// } on AppException catch (e) {
///   return Error(mapExceptionToFailure(e));
/// }
/// ```
Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NetworkException() => NetworkFailure(exception.message),
    ServerException() => ServerFailure(exception.message, exception.statusCode),
    CacheException() => CacheFailure(exception.message),
    AuthException() => AuthFailure(exception.message),
    ValidationException() => ValidationFailure(exception.message),
    UnknownException() => UnknownFailure(exception.message),
  };
}
