import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/auth/domain/entities/user.dart';
import 'package:best_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:best_flutter/features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([AuthRepository])
import 'get_current_user_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late GetCurrentUserUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
    provideDummy<Result<User>>(const Error(AuthFailure()));
  });

  group('GetCurrentUserUseCase', () {
    test('Given user is authenticated, When called, Then returns Success with User', () async {
      // Arrange
      when(mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Success(TestData.testUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.username, 'emilys');
      verify(mockRepository.getCurrentUser()).called(1);
    });

    test('Given no user authenticated, When called, Then returns Error with AuthFailure', () async {
      // Arrange
      when(mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Error(AuthFailure('No token found')));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });
}
