import 'exceptions.dart';

sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, this.statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
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
