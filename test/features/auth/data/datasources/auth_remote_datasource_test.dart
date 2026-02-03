import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:best_flutter/core/constants/app_constants.dart';
import 'package:best_flutter/core/error/exceptions.dart';
import 'package:best_flutter/core/network/api_client.dart';
import 'package:best_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([ApiClient, FlutterSecureStorage])
import 'auth_remote_datasource_test.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockFlutterSecureStorage mockStorage;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorage = MockFlutterSecureStorage();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient, mockStorage);
  });

  group('AuthRemoteDataSourceImpl - login', () {
    test('Given valid credentials, When login is called, Then returns UserModel and stores tokens', () async {
      // Arrange
      when(mockApiClient.login(any)).thenAnswer((_) async => TestData.testLoginResponse);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      // Act
      final result = await dataSource.login(username: 'emilys', password: 'emilyspass');

      // Assert
      expect(result.username, 'emilys');
      expect(result.email, 'emily.johnson@x.dummyjson.com');
      verify(mockStorage.write(key: AppConstants.accessTokenKey, value: 'test_access_token')).called(1);
      verify(mockStorage.write(key: AppConstants.refreshTokenKey, value: 'test_refresh_token')).called(1);
      verify(mockStorage.write(key: AppConstants.userIdKey, value: '1')).called(1);
    });

    test('Given API throws exception, When login is called, Then throws AuthException', () async {
      // Arrange
      when(mockApiClient.login(any)).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.login(username: 'emilys', password: 'wrong'),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('AuthRemoteDataSourceImpl - logout', () {
    test('Given valid session, When logout is called, Then clears all tokens', () async {
      // Arrange
      when(mockStorage.delete(key: anyNamed('key'))).thenAnswer((_) async {});

      // Act
      await dataSource.logout();

      // Assert
      verify(mockStorage.delete(key: AppConstants.accessTokenKey)).called(1);
      verify(mockStorage.delete(key: AppConstants.refreshTokenKey)).called(1);
      verify(mockStorage.delete(key: AppConstants.userIdKey)).called(1);
    });

    test('Given storage throws, When logout is called, Then throws AuthException', () async {
      // Arrange
      when(mockStorage.delete(key: anyNamed('key'))).thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(() => dataSource.logout(), throwsA(isA<AuthException>()));
    });
  });

  group('AuthRemoteDataSourceImpl - getCurrentUser', () {
    test('Given valid token exists, When getCurrentUser is called, Then returns UserModel', () async {
      // Arrange
      when(mockStorage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'valid_token');
      when(mockApiClient.getCurrentUser())
          .thenAnswer((_) async => TestData.testUserJson);

      // Act
      final result = await dataSource.getCurrentUser();

      // Assert
      expect(result.username, 'emilys');
      verify(mockApiClient.getCurrentUser()).called(1);
    });

    test('Given no token exists, When getCurrentUser is called, Then throws AuthException', () async {
      // Arrange
      when(mockStorage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => null);

      // Act & Assert
      expect(() => dataSource.getCurrentUser(), throwsA(isA<AuthException>()));
    });

    test('Given API throws, When getCurrentUser is called, Then throws AuthException', () async {
      // Arrange
      when(mockStorage.read(key: AppConstants.accessTokenKey))
          .thenAnswer((_) async => 'valid_token');
      when(mockApiClient.getCurrentUser()).thenThrow(Exception('Server error'));

      // Act & Assert
      expect(() => dataSource.getCurrentUser(), throwsA(isA<AuthException>()));
    });
  });
}
