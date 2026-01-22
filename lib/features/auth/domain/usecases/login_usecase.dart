import '../../../../core/error/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for authenticating a user with username and password.
///
/// Encapsulates the login business logic and delegates the actual
/// authentication to the [AuthRepository].
class LoginUseCase {
  final AuthRepository _repository;

  /// Creates a [LoginUseCase] with the given repository.
  LoginUseCase(this._repository);

  /// Executes the login operation.
  ///
  /// - [username]: The user's username (DummyJSON uses username, not email).
  /// - [password]: The user's password.
  ///
  /// Returns a [Result] containing the authenticated [User] on success,
  /// or a failure with error details.
  Future<Result<User>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}
