import 'exceptions.dart';

sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(String message, this.statusCode) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication error']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error']) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Unknown error occurred']) : super(message);
}

// Exception을 Failure로 변환하는 유틸리티
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
