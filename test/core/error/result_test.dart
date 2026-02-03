import 'package:flutter_test/flutter_test.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('Given Success with data, When accessed, Then returns data', () {
        const result = Success<int>(42);
        expect(result, isA<Result<int>>());
        expect(result.data, 42);
      });

      test('Given Success, When checking isSuccess, Then returns true', () {
        const Result<int> result = Success(42);
        expect(result.isSuccess, isTrue);
        expect(result.isError, isFalse);
      });

      test('Given Success, When accessing dataOrNull, Then returns data', () {
        const Result<String> result = Success('hello');
        expect(result.dataOrNull, 'hello');
      });

      test('Given Success, When accessing failureOrNull, Then returns null', () {
        const Result<int> result = Success(42);
        expect(result.failureOrNull, isNull);
      });
    });

    group('Error', () {
      test('Given Error with failure, When accessed, Then returns failure', () {
        const result = Error<int>(NetworkFailure('No connection'));
        expect(result, isA<Result<int>>());
        expect(result.failure, isA<NetworkFailure>());
        expect(result.failure.message, 'No connection');
      });

      test('Given Error, When checking isError, Then returns true', () {
        const Result<int> result = Error(NetworkFailure());
        expect(result.isError, isTrue);
        expect(result.isSuccess, isFalse);
      });

      test('Given Error, When accessing dataOrNull, Then returns null', () {
        const Result<int> result = Error(NetworkFailure());
        expect(result.dataOrNull, isNull);
      });

      test('Given Error, When accessing failureOrNull, Then returns failure', () {
        const Result<int> result = Error(AuthFailure('Unauthorized'));
        expect(result.failureOrNull, isA<AuthFailure>());
      });
    });

    group('fold', () {
      test('Given Success, When folded, Then calls onSuccess', () {
        const Result<int> result = Success(42);
        final message = result.fold(
          onSuccess: (data) => 'Value: $data',
          onError: (failure) => 'Error: ${failure.message}',
        );
        expect(message, 'Value: 42');
      });

      test('Given Error, When folded, Then calls onError', () {
        const Result<int> result = Error(ServerFailure('Not found', 404));
        final message = result.fold(
          onSuccess: (data) => 'Value: $data',
          onError: (failure) => 'Error: ${failure.message}',
        );
        expect(message, 'Error: Not found');
      });
    });
  });
}
