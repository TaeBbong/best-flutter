import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import 'package:best_flutter/features/feed/domain/repositories/feed_repository.dart';
import 'package:best_flutter/features/feed/domain/usecases/like_post_usecase.dart';

@GenerateMocks([FeedRepository])
import 'like_post_usecase_test.mocks.dart';

void main() {
  late MockFeedRepository mockRepository;
  late LikePostUseCase useCase;

  setUp(() {
    mockRepository = MockFeedRepository();
    useCase = LikePostUseCase(mockRepository);
    provideDummy<Result<Post>>(const Error(ServerFailure('', null)));
  });

  group('LikePostUseCase', () {
    test(
      'Given like is true, When called, Then increments likes and calls updateLikes',
      () async {
        // Arrange
        const updatedPost = Post(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          likes: 11,
        );
        when(
          mockRepository.updateLikes(
            id: anyNamed('id'),
            likes: anyNamed('likes'),
          ),
        ).thenAnswer((_) async => const Success(updatedPost));

        // Act
        final result = await useCase(postId: 1, currentLikes: 10, like: true);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(mockRepository.updateLikes(id: 1, likes: 11)).called(1);
      },
    );

    test(
      'Given like is false and currentLikes > 0, When called, Then decrements likes',
      () async {
        // Arrange
        const updatedPost = Post(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          likes: 9,
        );
        when(
          mockRepository.updateLikes(
            id: anyNamed('id'),
            likes: anyNamed('likes'),
          ),
        ).thenAnswer((_) async => const Success(updatedPost));

        // Act
        final result = await useCase(postId: 1, currentLikes: 10, like: false);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(mockRepository.updateLikes(id: 1, likes: 9)).called(1);
      },
    );

    test(
      'Given like is false and currentLikes is 0, When called, Then likes stays at 0',
      () async {
        // Arrange
        const updatedPost = Post(
          id: 1,
          title: 'Test',
          body: 'Body',
          userId: 1,
          likes: 0,
        );
        when(
          mockRepository.updateLikes(
            id: anyNamed('id'),
            likes: anyNamed('likes'),
          ),
        ).thenAnswer((_) async => const Success(updatedPost));

        // Act
        final result = await useCase(postId: 1, currentLikes: 0, like: false);

        // Assert
        expect(result.isSuccess, isTrue);
        verify(mockRepository.updateLikes(id: 1, likes: 0)).called(1);
      },
    );

    test(
      'Given server error, When called, Then returns Error with ServerFailure',
      () async {
        // Arrange
        when(
          mockRepository.updateLikes(
            id: anyNamed('id'),
            likes: anyNamed('likes'),
          ),
        ).thenAnswer(
          (_) async => const Error(ServerFailure('Update failed', 500)),
        );

        // Act
        final result = await useCase(postId: 1, currentLikes: 10, like: true);

        // Assert
        expect(result.isError, isTrue);
        expect(result.failureOrNull, isA<ServerFailure>());
      },
    );
  });
}
