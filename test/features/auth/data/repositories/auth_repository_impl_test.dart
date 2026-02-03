import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/exceptions.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:best_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([AuthRemoteDataSource])
import 'auth_repository_impl_test.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl - login', () {
    test('Given successful login, When called, Then returns Success with User', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => TestData.testUserModel);

      // Act
      final result = await repository.login(username: 'emilys', password: 'emilyspass');

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.username, 'emilys');
      verify(mockDataSource.login(username: 'emilys', password: 'emilyspass')).called(1);
    });

    test('Given login emits user on stream, When called, Then userStream emits user', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => TestData.testUserModel);

      // Act
      final future = repository.userStream.first;
      await repository.login(username: 'emilys', password: 'emilyspass');
      final streamUser = await future;

      // Assert
      expect(streamUser?.username, 'emilys');
    });

    test('Given AuthException thrown, When login is called, Then returns Error with AuthFailure', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenThrow(const AuthException('Invalid credentials'));

      // Act
      final result = await repository.login(username: 'emilys', password: 'wrong');

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });

    test('Given unknown exception thrown, When login is called, Then returns Error with UnknownFailure', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenThrow(Exception('Something unexpected'));

      // Act
      final result = await repository.login(username: 'emilys', password: 'pass');

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });

  group('AuthRepositoryImpl - register', () {
    test('Given successful register, When called, Then returns Success with User', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => TestData.testUserModel);

      // Act
      final result = await repository.register(
        email: 'test@test.com',
        password: 'password',
        username: 'testuser',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      // register uses default test user internally
      verify(mockDataSource.login(username: 'emilys', password: 'emilyspass')).called(1);
    });

    test('Given AuthException thrown, When register is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenThrow(const AuthException('Registration failed'));

      // Act
      final result = await repository.register(
        email: 'test@test.com',
        password: 'password',
        username: 'testuser',
      );

      // Assert
      expect(result.isError, isTrue);
    });
  });

  group('AuthRepositoryImpl - logout', () {
    test('Given successful logout, When called, Then returns Success and emits null on stream', () async {
      // Arrange
      when(mockDataSource.logout()).thenAnswer((_) async {});

      // Act
      final future = repository.userStream.first;
      final result = await repository.logout();
      final streamUser = await future;

      // Assert
      expect(result.isSuccess, isTrue);
      expect(streamUser, isNull);
      verify(mockDataSource.logout()).called(1);
    });

    test('Given AuthException thrown, When logout is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.logout()).thenThrow(const AuthException('Logout failed'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });

  group('AuthRepositoryImpl - getCurrentUser', () {
    test('Given user is authenticated, When getCurrentUser is called, Then returns Success', () async {
      // Arrange
      when(mockDataSource.getCurrentUser())
          .thenAnswer((_) async => TestData.testUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.username, 'emilys');
    });

    test('Given AuthException thrown, When getCurrentUser is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.getCurrentUser())
          .thenThrow(const AuthException('No token'));

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });

  group('AuthRepositoryImpl - dispose', () {
    test('Given repository, When dispose is called, Then stream is closed', () {
      repository.dispose();
      // No assertion needed - just ensure no exception is thrown
    });
  });
}
