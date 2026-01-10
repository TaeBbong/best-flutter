/// Base exception class for all application exceptions.
///
/// All custom exceptions should extend this class to ensure consistent
/// exception handling throughout the application.
sealed class AppException implements Exception {
  /// Human-readable error message describing the exception.
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when a network-related error occurs.
///
/// This includes connection timeouts, no internet connection,
/// and other network connectivity issues.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

/// Exception thrown when the server returns an error response.
///
/// Contains the HTTP status code for more specific error handling.
class ServerException extends AppException {
  /// HTTP status code returned by the server (e.g., 400, 500).
  final int? statusCode;

  const ServerException(super.message, this.statusCode);
}

/// Exception thrown when a cache operation fails.
///
/// This includes errors reading from or writing to local storage.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Exception thrown when authentication fails.
///
/// This includes invalid credentials, expired tokens,
/// and unauthorized access attempts.
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error']);
}

/// Exception thrown when input validation fails.
///
/// This includes invalid email formats, password requirements,
/// and other validation rule violations.
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

/// Exception thrown when an unknown or unexpected error occurs.
///
/// Used as a fallback when the error type cannot be determined.
class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error occurred']);
}
