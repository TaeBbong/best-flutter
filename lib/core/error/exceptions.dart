sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String message = 'Network error occurred']) : super(message);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(String message, this.statusCode) : super(message);
}

class CacheException extends AppException {
  const CacheException([String message = 'Cache error occurred']) : super(message);
}

class AuthException extends AppException {
  const AuthException([String message = 'Authentication error']) : super(message);
}

class ValidationException extends AppException {
  const ValidationException([String message = 'Validation error']) : super(message);
}

class UnknownException extends AppException {
  const UnknownException([String message = 'Unknown error occurred']) : super(message);
}