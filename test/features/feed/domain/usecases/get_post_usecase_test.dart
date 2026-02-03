import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/feed/domain/entities/post.dart';
import 'package:best_flutter/features/feed/domain/repositories/feed_repository.dart';
import 'package:best_flutter/features/feed/domain/usecases/get_post_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([FeedRepository])
import 'get_post_usecase_test.mocks.dart';

void main() {
  late MockFeedRepository mockRepository;
  late GetPostUseCase useCase;

  setUp(() {
    mockRepository = MockFeedRepository();
    useCase = GetPostUseCase(mockRepository);
    provideDummy<Result<Post>>(const Error(ServerFailure('', null)));
  });

  group('GetPostUseCase', () {
    test('Given valid post id, When called, Then returns Success with Post', () async {
      // Arrange
      when(mockRepository.getPost(any))
          .thenAnswer((_) async => const Success(TestData.testPost));

      // Act
      final result = await useCase(1);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.id, 1);
      verify(mockRepository.getPost(1)).called(1);
    });

    test('Given invalid post id, When called, Then returns Error with ServerFailure', () async {
      // Arrange
      when(mockRepository.getPost(any))
          .thenAnswer((_) async => const Error(ServerFailure('Not found', 404)));

      // Act
      final result = await useCase(999);

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
    });
  });
}
