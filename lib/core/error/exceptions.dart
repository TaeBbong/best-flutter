sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, this.statusCode);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error occurred']);
}