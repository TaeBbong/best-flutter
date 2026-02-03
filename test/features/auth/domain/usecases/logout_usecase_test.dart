import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:best_flutter/features/auth/domain/usecases/logout_usecase.dart';

@GenerateMocks([AuthRepository])
import 'logout_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LogoutUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
    provideDummy<Result<void>>(const Error(AuthFailure()));
  });

  group('LogoutUseCase', () {
    test('Given user is logged in, When called, Then returns Success', () async {
      // Arrange
      when(mockRepository.logout())
          .thenAnswer((_) async => const Success(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isSuccess, isTrue);
      verify(mockRepository.logout()).called(1);
    });

    test('Given logout fails, When called, Then returns Error with AuthFailure', () async {
      // Arrange
      when(mockRepository.logout())
          .thenAnswer((_) async => const Error(AuthFailure('Logout failed')));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });
}
