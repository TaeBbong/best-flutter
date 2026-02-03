import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/network/api_client.dart';

@GenerateMocks([Dio])
import 'api_client_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  group('ApiClient - Auth Endpoints', () {
    test('Given valid login data, When login is called, Then returns response data', () async {
      // Arrange
      final loginData = {'username': 'emilys', 'password': 'emilyspass'};
      final responseData = {
        'id': 1,
        'username': 'emilys',
        'accessToken': 'token123',
        'refreshToken': 'refresh123',
      };
      when(mockDio.post('/auth/login', data: loginData)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );

      // Act
      final result = await apiClient.login(loginData);

      // Assert
      expect(result, responseData);
      verify(mockDio.post('/auth/login', data: loginData)).called(1);
    });

    test('Given valid token, When getCurrentUser is called, Then returns user data', () async {
      // Arrange
      final userData = {'id': 1, 'username': 'emilys', 'email': 'emily@test.com'};
      when(mockDio.get('/auth/me')).thenAnswer(
        (_) async => Response(
          data: userData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/me'),
        ),
      );

      // Act
      final result = await apiClient.getCurrentUser();

      // Assert
      expect(result, userData);
      verify(mockDio.get('/auth/me')).called(1);
    });

    test('Given refresh data, When refreshToken is called, Then returns new tokens', () async {
      // Arrange
      final refreshData = {'refreshToken': 'old_refresh'};
      final responseData = {'accessToken': 'new_access', 'refreshToken': 'new_refresh'};
      when(mockDio.post('/auth/refresh', data: refreshData)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/refresh'),
        ),
      );

      // Act
      final result = await apiClient.refreshToken(refreshData);

      // Assert
      expect(result, responseData);
      verify(mockDio.post('/auth/refresh', data: refreshData)).called(1);
    });

    test('Given user id, When getUser is called, Then returns user data', () async {
      // Arrange
      final userData = {'id': 1, 'username': 'emilys'};
      when(mockDio.get('/users/1')).thenAnswer(
        (_) async => Response(
          data: userData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/1'),
        ),
      );

      // Act
      final result = await apiClient.getUser(1);

      // Assert
      expect(result, userData);
      verify(mockDio.get('/users/1')).called(1);
    });
  });

  group('ApiClient - Feed Endpoints', () {
    test('Given pagination params, When getPosts is called, Then returns posts data', () async {
      // Arrange
      final responseData = {
        'posts': [
          {'id': 1, 'title': 'Test Post'},
        ],
        'total': 1,
        'skip': 0,
        'limit': 20,
      };
      when(mockDio.get(
        '/posts',
        queryParameters: {'skip': 0, 'limit': 20},
      )).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        ),
      );

      // Act
      final result = await apiClient.getPosts(skip: 0, limit: 20);

      // Assert
      expect(result, responseData);
    });

    test('Given post data, When createPost is called, Then returns created post', () async {
      // Arrange
      final postData = {'title': 'New Post', 'body': 'Content', 'userId': 1};
      final responseData = {'id': 151, 'title': 'New Post', 'body': 'Content', 'userId': 1};
      when(mockDio.post('/posts/add', data: postData)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/add'),
        ),
      );

      // Act
      final result = await apiClient.createPost(postData);

      // Assert
      expect(result, responseData);
    });

    test('Given post id, When getPost is called, Then returns post data', () async {
      // Arrange
      final postData = {'id': 1, 'title': 'Test Post', 'body': 'Body'};
      when(mockDio.get('/posts/1')).thenAnswer(
        (_) async => Response(
          data: postData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/1'),
        ),
      );

      // Act
      final result = await apiClient.getPost(1);

      // Assert
      expect(result, postData);
    });

    test('Given update data, When updatePost is called, Then returns updated post', () async {
      // Arrange
      final updateData = {
        'reactions': {'likes': 10, 'dislikes': 0},
      };
      final responseData = {'id': 1, 'title': 'Test Post'};
      when(mockDio.patch('/posts/1', data: updateData)).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts/1'),
        ),
      );

      // Act
      final result = await apiClient.updatePost(1, updateData);

      // Assert
      expect(result, responseData);
    });
  });
}
