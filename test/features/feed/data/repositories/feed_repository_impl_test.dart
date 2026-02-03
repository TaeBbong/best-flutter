import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/exceptions.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/feed/data/datasources/feed_remote_datasource.dart';
import 'package:best_flutter/features/feed/data/repositories/feed_repository_impl.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([FeedRemoteDataSource])
import 'feed_repository_impl_test.mocks.dart';

void main() {
  late MockFeedRemoteDataSource mockDataSource;
  late FeedRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockFeedRemoteDataSource();
    repository = FeedRepositoryImpl(mockDataSource);
  });

  group('FeedRepositoryImpl - getPosts', () {
    test('Given successful response, When getPosts is called, Then returns Success with posts', () async {
      // Arrange
      when(mockDataSource.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => TestData.testPostModelList);

      // Act
      final result = await repository.getPosts(page: 1, limit: 20);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, hasLength(2));
      expect(result.dataOrNull?.first.id, 1);
    });

    test('Given ServerException thrown, When getPosts is called, Then returns Error with ServerFailure', () async {
      // Arrange
      when(mockDataSource.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(const ServerException('Server error', 500));

      // Act
      final result = await repository.getPosts(page: 1, limit: 20);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });

    test('Given unknown exception thrown, When getPosts is called, Then returns Error with UnknownFailure', () async {
      // Arrange
      when(mockDataSource.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenThrow(Exception('Unexpected'));

      // Act
      final result = await repository.getPosts(page: 1, limit: 20);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });

  group('FeedRepositoryImpl - createPost', () {
    test('Given successful creation, When createPost is called, Then returns Success with Post', () async {
      // Arrange
      when(mockDataSource.createPost(
        title: anyNamed('title'),
        body: anyNamed('body'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => TestData.testPostModel);

      // Act
      final result = await repository.createPost(
        title: 'New Post',
        body: 'Content',
        userId: 1,
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.title, 'His mother had always taught him');
    });

    test('Given ServerException thrown, When createPost is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.createPost(
        title: anyNamed('title'),
        body: anyNamed('body'),
        userId: anyNamed('userId'),
      )).thenThrow(const ServerException('Creation failed', 500));

      // Act
      final result = await repository.createPost(
        title: 'New Post',
        body: 'Content',
        userId: 1,
      );

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });

  group('FeedRepositoryImpl - getPost', () {
    test('Given valid post id, When getPost is called, Then returns Success with Post', () async {
      // Arrange
      when(mockDataSource.getPost(any))
          .thenAnswer((_) async => TestData.testPostModel);

      // Act
      final result = await repository.getPost(1);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.id, 1);
    });

    test('Given ServerException thrown, When getPost is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.getPost(any))
          .thenThrow(const ServerException('Not found', 404));

      // Act
      final result = await repository.getPost(999);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });

  group('FeedRepositoryImpl - updateLikes', () {
    test('Given valid data, When updateLikes is called, Then returns Success with updated Post', () async {
      // Arrange
      when(mockDataSource.updatePostReactions(any, any))
          .thenAnswer((_) async => TestData.testPostModel);

      // Act
      final result = await repository.updateLikes(id: 1, likes: 193);

      // Assert
      expect(result.isSuccess, isTrue);
      verify(mockDataSource.updatePostReactions(1, 193)).called(1);
    });

    test('Given ServerException thrown, When updateLikes is called, Then returns Error', () async {
      // Arrange
      when(mockDataSource.updatePostReactions(any, any))
          .thenThrow(const ServerException('Update failed', 500));

      // Act
      final result = await repository.updateLikes(id: 1, likes: 193);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
