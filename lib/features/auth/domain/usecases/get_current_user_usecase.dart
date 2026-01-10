import '../../../../core/error/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for retrieving the currently authenticated user.
///
/// Used to check authentication status and get current user data
/// on app startup or when needed.
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  /// Creates a [GetCurrentUserUseCase] with the given repository.
  GetCurrentUserUseCase(this._repository);

  /// Executes the get current user operation.
  ///
  /// Returns a [Result] containing the current [User] if authenticated,
  /// or a failure if no user is logged in or the session has expired.
  Future<Result<User>> call() {
    return _repository.getCurrentUser();
  }
}
