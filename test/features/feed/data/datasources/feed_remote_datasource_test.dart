import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/exceptions.dart';
import 'package:best_flutter/core/network/api_client.dart';
import 'package:best_flutter/features/feed/data/datasources/feed_remote_datasource.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([ApiClient])
import 'feed_remote_datasource_test.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late FeedRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = FeedRemoteDataSourceImpl(mockApiClient);
  });

  group('FeedRemoteDataSourceImpl - getPosts', () {
    test('Given valid page and limit, When getPosts is called, Then returns list of PostModels', () async {
      // Arrange
      when(mockApiClient.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')))
          .thenAnswer((_) async => {
                'posts': [TestData.testPostJson],
                'total': 150,
                'skip': 0,
                'limit': 20,
              });

      // Act
      final result = await dataSource.getPosts(page: 1, limit: 20);

      // Assert
      expect(result, hasLength(1));
      expect(result.first.id, 1);
      expect(result.first.title, 'His mother had always taught him');
      verify(mockApiClient.getPosts(skip: 0, limit: 20)).called(1);
    });

    test('Given page 2, When getPosts is called, Then skip is calculated correctly', () async {
      // Arrange
      when(mockApiClient.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')))
          .thenAnswer((_) async => {
                'posts': [],
                'total': 150,
                'skip': 20,
                'limit': 20,
              });

      // Act
      await dataSource.getPosts(page: 2, limit: 20);

      // Assert
      verify(mockApiClient.getPosts(skip: 20, limit: 20)).called(1);
    });

    test('Given API throws, When getPosts is called, Then throws ServerException', () async {
      // Arrange
      when(mockApiClient.getPosts(skip: anyNamed('skip'), limit: anyNamed('limit')))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => dataSource.getPosts(page: 1, limit: 20),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('FeedRemoteDataSourceImpl - createPost', () {
    test('Given valid post data, When createPost is called, Then returns PostModel', () async {
      // Arrange
      when(mockApiClient.createPost(any)).thenAnswer((_) async => {
            'id': 151,
            'title': 'New Post',
            'body': 'Post body',
            'userId': 1,
            'tags': <String>[],
            'reactions': {'likes': 0, 'dislikes': 0},
            'views': 0,
          });

      // Act
      final result = await dataSource.createPost(
        title: 'New Post',
        body: 'Post body',
        userId: 1,
      );

      // Assert
      expect(result.id, 151);
      expect(result.title, 'New Post');
    });

    test('Given API throws, When createPost is called, Then throws ServerException', () async {
      // Arrange
      when(mockApiClient.createPost(any)).thenThrow(Exception('Server error'));

      // Act & Assert
      expect(
        () => dataSource.createPost(title: 'Test', body: 'Body', userId: 1),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('FeedRemoteDataSourceImpl - getPost', () {
    test('Given valid post id, When getPost is called, Then returns PostModel', () async {
      // Arrange
      when(mockApiClient.getPost(any)).thenAnswer((_) async => TestData.testPostJson);

      // Act
      final result = await dataSource.getPost(1);

      // Assert
      expect(result.id, 1);
      expect(result.title, 'His mother had always taught him');
      verify(mockApiClient.getPost(1)).called(1);
    });

    test('Given API throws, When getPost is called, Then throws ServerException', () async {
      // Arrange
      when(mockApiClient.getPost(any)).thenThrow(Exception('Not found'));

      // Act & Assert
      expect(
        () => dataSource.getPost(999),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('FeedRemoteDataSourceImpl - updatePostReactions', () {
    test('Given valid data, When updatePostReactions is called, Then returns updated PostModel', () async {
      // Arrange
      when(mockApiClient.updatePost(any, any)).thenAnswer((_) async => TestData.testPostJson);

      // Act
      final result = await dataSource.updatePostReactions(1, 193);

      // Assert
      expect(result.id, 1);
      verify(mockApiClient.updatePost(1, {
        'reactions': {'likes': 193, 'dislikes': 0},
      })).called(1);
    });

    test('Given API throws, When updatePostReactions is called, Then throws ServerException', () async {
      // Arrange
      when(mockApiClient.updatePost(any, any)).thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => dataSource.updatePostReactions(1, 10),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
