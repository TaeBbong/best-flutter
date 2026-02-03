import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/core/error/exceptions.dart';

void main() {
  group('AppException hierarchy', () {
    test('Given NetworkException, When created with default message, Then has correct message', () {
      const exception = NetworkException();
      expect(exception.message, 'Network error occurred');
      expect(exception.toString(), 'Network error occurred');
      expect(exception, isA<AppException>());
    });

    test('Given NetworkException, When created with custom message, Then has custom message', () {
      const exception = NetworkException('No internet connection');
      expect(exception.message, 'No internet connection');
    });

    test('Given ServerException, When created, Then has message and statusCode', () {
      const exception = ServerException('Internal Server Error', 500);
      expect(exception.message, 'Internal Server Error');
      expect(exception.statusCode, 500);
      expect(exception, isA<AppException>());
    });

    test('Given ServerException with null statusCode, When created, Then statusCode is null', () {
      const exception = ServerException('Server error', null);
      expect(exception.statusCode, isNull);
    });

    test('Given CacheException, When created with default message, Then has correct message', () {
      const exception = CacheException();
      expect(exception.message, 'Cache error occurred');
      expect(exception, isA<AppException>());
    });

    test('Given AuthException, When created with default message, Then has correct message', () {
      const exception = AuthException();
      expect(exception.message, 'Authentication error');
      expect(exception, isA<AppException>());
    });

    test('Given ValidationException, When created with default message, Then has correct message', () {
      const exception = ValidationException();
      expect(exception.message, 'Validation error');
      expect(exception, isA<AppException>());
    });

    test('Given UnknownException, When created with default message, Then has correct message', () {
      const exception = UnknownException();
      expect(exception.message, 'Unknown error occurred');
      expect(exception, isA<AppException>());
    });
  });
}
