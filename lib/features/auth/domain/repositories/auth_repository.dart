import '../../../../core/error/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  Future<Result<User>> register({
    required String email,
    required String password,
    required String username,
  });

  Future<Result<void>> logout();

  Future<Result<User>> getCurrentUser();

  Future<Result<User>> updateProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
  });

  Stream<User?> get userStream;
}