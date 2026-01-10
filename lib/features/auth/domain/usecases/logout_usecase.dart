import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

/// Use case for logging out the current user.
///
/// Encapsulates the logout business logic including clearing
/// authentication tokens and user data.
class LogoutUseCase {
  final AuthRepository _repository;

  /// Creates a [LogoutUseCase] with the given repository.
  LogoutUseCase(this._repository);

  /// Executes the logout operation.
  ///
  /// Returns a [Result] indicating success or failure.
  /// On success, the user's session is terminated and tokens are cleared.
  Future<Result<void>> call() {
    return _repository.logout();
  }
}
