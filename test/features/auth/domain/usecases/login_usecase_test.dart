import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:best_flutter/core/error/failures.dart';
import 'package:best_flutter/core/error/result.dart';
import 'package:best_flutter/features/auth/domain/entities/user.dart';
import 'package:best_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:best_flutter/features/auth/domain/usecases/login_usecase.dart';
import '../../../../helpers/test_data.dart';

@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
    provideDummy<Result<User>>(const Error(AuthFailure()));
  });

  group('LoginUseCase', () {
    test('Given valid credentials, When called, Then returns Success with User', () async {
      // Arrange
      when(mockRepository.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Success(TestData.testUser));

      // Act
      final result = await useCase(username: 'emilys', password: 'emilyspass');

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.username, 'emilys');
      verify(mockRepository.login(username: 'emilys', password: 'emilyspass')).called(1);
    });

    test('Given invalid credentials, When called, Then returns Error with AuthFailure', () async {
      // Arrange
      when(mockRepository.login(
        username: anyNamed('username'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Error(AuthFailure('Invalid credentials')));

      // Act
      final result = await useCase(username: 'emilys', password: 'wrong');

      // Assert
      expect(result.isError, isTrue);
      expect(result.failureOrNull, isA<AuthFailure>());
    });
  });
}
