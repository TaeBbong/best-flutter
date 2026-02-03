import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import 'package:best_flutter/features/feed/domain/repositories/feed_repository.dart';
import 'package:best_flutter/features/feed/domain/usecases/create_post_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([FeedRepository])
import 'create_post_usecase_test.mocks.dart';

void main() {
  late MockFeedRepository mockRepository;
  late CreatePostUseCase useCase;

  setUp(() {
    mockRepository = MockFeedRepository();
    useCase = CreatePostUseCase(mockRepository);
    provideDummy<Result<Post>>(const Error(ServerFailure('', null)));
  });

  group('CreatePostUseCase', () {
    test('Given valid post data, When called, Then returns Success with Post', () async {
      // Arrange
      when(mockRepository.createPost(
        title: anyNamed('title'),
        body: anyNamed('body'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => const Success(TestData.testPost));

      // Act
      final result = await useCase(
        title: 'New Post',
        body: 'Post content',
        userId: 1,
      );

      // Assert
      expect(result.isSuccess, isTrue);
      verify(mockRepository.createPost(
        title: 'New Post',
        body: 'Post content',
        userId: 1,
      )).called(1);
    });

    test('Given server error, When called, Then returns Error with ServerFailure', () async {
      // Arrange
      when(mockRepository.createPost(
        title: anyNamed('title'),
        body: anyNamed('body'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => const Error(ServerFailure('Creation failed', 500)));

      // Act
      final result = await useCase(
        title: 'New Post',
        body: 'Post content',
        userId: 1,
      );

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
