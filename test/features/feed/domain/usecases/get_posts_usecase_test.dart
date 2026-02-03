import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import 'package:best_flutter/features/feed/domain/repositories/feed_repository.dart';
import 'package:best_flutter/features/feed/domain/usecases/get_posts_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([FeedRepository])
import 'get_posts_usecase_test.mocks.dart';

void main() {
  late MockFeedRepository mockRepository;
  late GetPostsUseCase useCase;

  setUp(() {
    mockRepository = MockFeedRepository();
    useCase = GetPostsUseCase(mockRepository);
    provideDummy<Result<List<Post>>>(const Error(ServerFailure('', null)));
  });

  group('GetPostsUseCase', () {
    test('Given posts exist, When called, Then returns Success with posts list', () async {
      // Arrange
      when(mockRepository.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => Success(TestData.testPostList));

      // Act
      final result = await useCase(page: 1, limit: 20);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, hasLength(2));
      verify(mockRepository.getPosts(page: 1, limit: 20)).called(1);
    });

    test('Given server error, When called, Then returns Error with ServerFailure', () async {
      // Arrange
      when(mockRepository.getPosts(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) async => const Error(ServerFailure('Server error', 500)));

      // Act
      final result = await useCase(page: 1, limit: 20);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
