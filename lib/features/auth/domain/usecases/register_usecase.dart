import '../../../../core/error/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for registering a new user account.
///
/// Encapsulates the registration business logic and delegates the actual
/// account creation to the [AuthRepository].
class RegisterUseCase {
  final AuthRepository _repository;

  /// Creates a [RegisterUseCase] with the given repository.
  RegisterUseCase(this._repository);

  /// Executes the registration operation.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  /// - [username]: The user's display name.
  ///
  /// Returns a [Result] containing the newly created [User] on success,
  /// or a failure with error details.
  Future<Result<User>> call({
    required String email,
    required String password,
    required String username,
  }) {
    return _repository.register(
      email: email,
      password: password,
      username: username,
    );
  }
}
