import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/auth/domain/entities/user.dart';
import 'package:best_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:best_flutter/features/auth/domain/usecases/register_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([AuthRepository])
import 'register_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
    provideDummy<Result<User>>(const Error(AuthFailure()));
  });

  group('RegisterUseCase', () {
    test('Given valid registration data, When called, Then returns Success with User', () async {
      // Arrange
      when(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        username: anyNamed('username'),
      )).thenAnswer((_) async => const Success(TestData.testUser));

      // Act
      final result = await useCase(
        email: 'test@test.com',
        password: 'password123',
        username: 'testuser',
      );

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.username, 'emilys');
      verify(mockRepository.register(
        email: 'test@test.com',
        password: 'password123',
        username: 'testuser',
      )).called(1);
    });

    test('Given registration fails, When called, Then returns Error', () async {
      // Arrange
      when(mockRepository.register(
        email: anyNamed('email'),
        password: anyNamed('password'),
        username: anyNamed('username'),
      )).thenAnswer((_) async => const Error(AuthFailure('Registration failed')));

      // Act
      final result = await useCase(
        email: 'test@test.com',
        password: 'password123',
        username: 'testuser',
      );

      // Assert
      expect(result.isError, isTrue);
    });
  });
}
