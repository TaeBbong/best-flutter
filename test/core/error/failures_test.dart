import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/core/error/exceptions.dart';
import 'package:best_flutter/core/error/failures.dart';

void main() {
  group('Failure hierarchy', () {
    test('Given NetworkFailure, When created with default message, Then has correct message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Network error occurred');
      expect(failure, isA<Failure>());
    });

    test('Given ServerFailure, When created, Then has message and statusCode', () {
      const failure = ServerFailure('Server error', 500);
      expect(failure.message, 'Server error');
      expect(failure.statusCode, 500);
    });

    test('Given CacheFailure, When created with default message, Then has correct message', () {
      const failure = CacheFailure();
      expect(failure.message, 'Cache error occurred');
    });

    test('Given AuthFailure, When created with default message, Then has correct message', () {
      const failure = AuthFailure();
      expect(failure.message, 'Authentication error');
    });

    test('Given ValidationFailure, When created with default message, Then has correct message', () {
      const failure = ValidationFailure();
      expect(failure.message, 'Validation error');
    });

    test('Given UnknownFailure, When created with default message, Then has correct message', () {
      const failure = UnknownFailure();
      expect(failure.message, 'Unknown error occurred');
    });
  });

  group('mapExceptionToFailure', () {
    test('Given NetworkException, When mapped, Then returns NetworkFailure', () {
      const exception = NetworkException('No internet');
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'No internet');
    });

    test('Given ServerException, When mapped, Then returns ServerFailure with statusCode', () {
      const exception = ServerException('Bad request', 400);
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Bad request');
      expect((failure as ServerFailure).statusCode, 400);
    });

    test('Given CacheException, When mapped, Then returns CacheFailure', () {
      const exception = CacheException('Disk full');
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'Disk full');
    });

    test('Given AuthException, When mapped, Then returns AuthFailure', () {
      const exception = AuthException('Token expired');
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Token expired');
    });

    test('Given ValidationException, When mapped, Then returns ValidationFailure', () {
      const exception = ValidationException('Invalid email');
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'Invalid email');
    });

    test('Given UnknownException, When mapped, Then returns UnknownFailure', () {
      const exception = UnknownException('Something went wrong');
      final failure = mapExceptionToFailure(exception);
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, 'Something went wrong');
    });
  });
}
